import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedRange = 'Weekly'.obs;

  final sugarHistory = <Map<String, dynamic>>[].obs;

  /// Chart points derived from sugarHistory
  final chartPoints = <double>[].obs;
  final chartLabels = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _rebuildChart();
  }

  void updateRange(String value) {
    selectedRange.value = value;
    _rebuildChart();
  }

  /// Call this when API data arrives
  void setSugarHistory(List<Map<String, dynamic>> data) {
    sugarHistory.assignAll(data);
    _rebuildChart();
  }

  void _rebuildChart() {
    chartPoints.clear();
    chartLabels.clear();

    if (sugarHistory.isEmpty) return;

    if (selectedRange.value == 'Weekly') {
      _buildWeekly();
    } else {
      _buildMonthly();
    }
  }

  void _buildWeekly() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));

      final total = sugarHistory
          .where((e) {
            final d = e['date'] as DateTime;
            return d.year == day.year &&
                d.month == day.month &&
                d.day == day.day;
          })
          .fold<double>(0, (s, e) => s + (e['sugar'] as double));

      chartPoints.add(total);
      chartLabels.add(_dayLabel(day.weekday));
    }
  }

  void _buildMonthly() {
    final now = DateTime.now();

    final weeklyBuckets = <double>[10, 0, 100, 0];

    for (final e in sugarHistory) {
      final d = e['date'] as DateTime;
      if (d.month == now.month && d.year == now.year) {
        final weekIndex = ((d.day - 1) / 7).floor().clamp(0, 3);
        weeklyBuckets[weekIndex] += e['sugar'] as double;
      }
    }

    for (int i = 0; i < weeklyBuckets.length; i++) {
      chartPoints.add(weeklyBuckets[i]);
      chartLabels.add('W${i + 1}');
    }
  }

  String _dayLabel(int weekday) {
    const map = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    return map[weekday]!;
  }
}
