import 'package:get/get.dart';

/// Periode grafik: mingguan / bulanan
enum GraphPeriod { weekly, monthly }

class GraphController extends GetxController {
  /// Periode yang dipilih (default: weekly)
  final period = GraphPeriod.weekly.obs;

  /// String untuk binding di UI segmented button ("Weekly"/"Monthly")
  final selectedRange = 'Weekly'.obs;

  /// Label untuk chart mingguan (Sun..Sat)
  final weeklyLabels = <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ].obs;

  /// Data gula mingguan (dummy, dalam gram)
  final weeklySugar = <double>[22, 30, 26, 35, 18, 20, 17].obs;

  /// Label untuk chart bulanan (misal 4 minggu)
  final monthlyLabels = <String>['W1', 'W2', 'W3', 'W4'].obs;

  /// Data gula bulanan (dummy, total per minggu)
  final monthlySugar = <double>[160, 175, 168, 180].obs;

  /// Summary (bisa nanti dihitung dari data kalau mau)
  final total = 168.0.obs; // Total gula (gram)
  final averagePerDay = 24.0.obs; // Rata-rata per hari (gram/hari)
  final highest = 38.0.obs; // Nilai tertinggi (gram)
  final trendText = 'UP +12%'.obs; // Tren (teks)

  /// Recommendation text
  final recommendation =
      'Avoid sugary drinks in the evening to reduce spikes.'.obs;

  /// Getter untuk data yang sedang aktif dipakai chart
  List<String> get currentLabels =>
      period.value == GraphPeriod.weekly ? weeklyLabels : monthlyLabels;

  List<double> get currentSugar =>
      period.value == GraphPeriod.weekly ? weeklySugar : monthlySugar;

  /// Ganti periode grafik pakai enum (kalau dipanggil dari logic lain)
  void setPeriod(GraphPeriod value) {
    if (period.value == value) return;

    period.value = value;
    selectedRange.value = value == GraphPeriod.weekly ? 'Weekly' : 'Monthly';

    // TODO: kalau mau, hitung ulang total/average/highest/trend di sini
  }

  /// Dipakai oleh UI segmented button: "Weekly" / "Monthly"
  void updateRange(String value) {
    if (selectedRange.value == value) return;

    selectedRange.value = value;
    period.value = value == 'Weekly' ? GraphPeriod.weekly : GraphPeriod.monthly;

    // TODO: sama seperti setPeriod, bisa trigger perhitungan summary di sini
  }
}
