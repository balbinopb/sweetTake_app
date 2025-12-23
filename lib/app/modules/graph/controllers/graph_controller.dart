import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/data/models/consumption_graph_model.dart';
import '../../../data/services/consumption_service.dart';

// enum for graph
enum GraphPeriod { weekly, monthly }

// enum for risk level in recomendation
enum RiskLevel { low, moderate, high }

class GraphController extends GetxController {
  final period = GraphPeriod.weekly.obs;
  final selectedRange = 'Weekly'.obs;
  final isLoading = true.obs;

  final riskLevel = RiskLevel.low.obs;
  final recommendationText = ''.obs;

  final _service = ConsumptionService();
  final RxList<ConsumptionGraphModel> consumptions =
      <ConsumptionGraphModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  double get todayTotalSugar {
    final now = DateTime.now();
    return consumptions
        .where(
          (c) =>
              c.dateTime.year == now.year &&
              c.dateTime.month == now.month &&
              c.dateTime.day == now.day,
        )
        .fold(0.0, (sum, c) => sum + c.sugar);
  }

  double get weeklyAverageSugar {
    final spots = weeklySpots;
    if (spots.isEmpty) return 0.0;

    final total = spots.fold(0.0, (sum, s) => sum + s.y);
    return total / spots.length;
  }

  void evaluateRisk() {
    const dailyGoal = 25.0;
    const upperLimit = 50.0;

    final daily = todayTotalSugar;
    final weeklyAvg = weeklyAverageSugar;

    if (daily > upperLimit) {
      riskLevel.value = RiskLevel.high;
      recommendationText.value =
          'Your sugar intake today is very high. Reduce sugary foods and drinks.';
    } else if (daily > dailyGoal || weeklyAvg > dailyGoal) {
      riskLevel.value = RiskLevel.moderate;
      recommendationText.value =
          'Try to lower sugar intake in your next meals, especially snacks and drinks.';
    } else {
      riskLevel.value = RiskLevel.low;
      recommendationText.value =
          'Great job! You are managing your sugar intake well today.';
    }
  }

  // ================= RANGE HANDLING =================
  void updateRange(String value) {
    if (selectedRange.value == value) return;

    selectedRange.value = value;
    period.value = value == 'Weekly' ? GraphPeriod.weekly : GraphPeriod.monthly;
  }

  // ================= API =================
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchConsumptions();

      // print('==============RAW API DATA: $data =================');

      consumptions.value = data
          .map((e) => ConsumptionGraphModel.fromJson(e))
          .toList();

      // print('===============PARSED MODEL COUNT: ${consumptions.length}===============');
      evaluateRisk();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= WEEKLY =================
  List<FlSpot> get weeklySpots {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final Map<int, double> total = {};
    final Map<int, int> count = {};

    for (var item in consumptions) {
      if (item.dateTime.isBefore(startOfWeek) ||
          item.dateTime.isAfter(endOfWeek)) {
        continue;
      }

      final dayIndex = item.dateTime.weekday % 7;

      total[dayIndex] = (total[dayIndex] ?? 0) + item.sugar;
      count[dayIndex] = (count[dayIndex] ?? 0) + 1;
    }

    return List.generate(7, (i) {
      final c = count[i] ?? 0;
      final avg = c == 0 ? 0.0 : total[i]! / c.toDouble();
      return FlSpot(i.toDouble(), avg);
    });
  }

  // ================= MONTHLY =================
  /// Weekly average (Week 1–4/5)
  List<FlSpot> get monthlySpots {
    final now = DateTime.now();

    final Map<int, List<double>> weeks = {};

    for (var item in consumptions) {
      if (item.dateTime.year != now.year || item.dateTime.month != now.month) {
        continue;
      }

      final weekIndex = ((item.dateTime.day - 1) ~/ 7);
      weeks.putIfAbsent(weekIndex, () => []);
      weeks[weekIndex]!.add(item.sugar);
    }

    if (weeks.isEmpty) {
      return [const FlSpot(0, 0)];
    }

    final keys = weeks.keys.toList()..sort();

    return keys.map((k) {
      final avg = weeks[k]!.reduce((a, b) => a + b) / weeks[k]!.length;
      return FlSpot(k.toDouble(), avg);
    }).toList();
  }

  // ================= ACTIVE DATA =================

  List<FlSpot> get activeSpots =>
      period.value == GraphPeriod.weekly ? weeklySpots : monthlySpots;
}
