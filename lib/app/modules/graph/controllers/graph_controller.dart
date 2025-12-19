import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/data/models/consumption_graph_model.dart';
import '../../../data/services/consumption_service.dart';

enum GraphPeriod { weekly, monthly }

class GraphController extends GetxController {
  final period = GraphPeriod.weekly.obs;
  final selectedRange = 'Weekly'.obs;
  final isLoading = true.obs;

  final _service = ConsumptionService();
  final RxList<ConsumptionGraphModel> consumptions =
      <ConsumptionGraphModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
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
  } finally {
    isLoading.value = false;
  }
}


  // ================= WEEKLY =================
  /// Daily total (Sun–Sat)
  List<FlSpot> get weeklySpots {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final Map<int, double> daily = {};

    for (var item in consumptions) {
      if (item.dateTime.isBefore(startOfWeek) ||
          item.dateTime.isAfter(endOfWeek)) {
        continue;
      }

      final dayIndex = item.dateTime.weekday % 7;
      daily[dayIndex] = (daily[dayIndex] ?? 0) + item.sugar;
    }

    return List.generate(7, (i) => FlSpot(i.toDouble(), daily[i] ?? 0));
  }

  // ================= MONTHLY =================
  /// Weekly average (Week 1–4/5)
  List<FlSpot> get monthlySpots {
    final now = DateTime.now();

    final Map<int, List<double>> weeks = {};

    for (var item in consumptions) {
      if (item.dateTime.year != now.year || item.dateTime.month != now.month){
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
