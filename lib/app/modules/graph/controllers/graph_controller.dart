import 'package:get/get.dart';

/// Periode grafik: mingguan / bulanan
enum GraphPeriod { weekly, monthly }

class GraphController extends GetxController {
  /// Periode yang dipilih (default: weekly)
  final period = GraphPeriod.weekly.obs;

  /// Label untuk chart mingguan (Sun..Sat)
  final weeklyLabels = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].obs;

  /// Data gula mingguan (dummy, dalam gram)
  final weeklySugar = <double>[22, 30, 26, 35, 18, 20, 17].obs;

  /// Label untuk chart bulanan (misal 4 minggu)
  final monthlyLabels = <String>['W1', 'W2', 'W3', 'W4'].obs;

  /// Data gula bulanan (dummy, total per minggu)
  final monthlySugar = <double>[160, 175, 168, 180].obs;

  /// Summary (default: weekly, biar cocok sama teks awal)
  final total = 168.0.obs;          // Total gula (gram)
  final averagePerDay = 24.0.obs;   // Rata-rata per hari (gram/hari)
  final highest = 38.0.obs;         // Nilai tertinggi (gram)
  final trendText = 'UP +12%'.obs;  // Tren (teks)

  /// Recommendation text
  final recommendation = 'Avoid sugary drinks in the evening to reduce spikes.'
      .obs;

  /// Getter untuk data yang sedang aktif dipakai chart
  List<String> get currentLabels =>
      period.value == GraphPeriod.weekly ? weeklyLabels : monthlyLabels;

  List<double> get currentSugar =>
      period.value == GraphPeriod.weekly ? weeklySugar : monthlySugar;

  /// Ganti periode grafik
  void setPeriod(GraphPeriod value) {
    if (period.value == value) return;
    period.value = value;

    // Contoh: update summary kalau pindah periode
    if (period.value == GraphPeriod.weekly) {
      total.value = 168;
      averagePerDay.value = 24;
      highest.value = 38;
      trendText.value = 'UP +12%';
      recommendation.value =
          'Avoid sugary drinks in the evening to reduce spikes.';
    } else {
      // contoh summary bulanan (dummy)
      total.value = 683; // 160+175+168+180
      averagePerDay.value = 22; // misal rata-rata
      highest.value = 180;
      trendText.value = 'STABLE +3%';
      recommendation.value =
          'Maintain your current routine and monitor weekly spikes.';
    }
  }
}
