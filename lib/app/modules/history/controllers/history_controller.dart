import 'package:get/get.dart';

class HistoryController extends GetxController {
  /// 0 = Sugar Consumption, 1 = Blood Sugar
  final selectedTab = 0.obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  // ==========================
  // DATE STATE (for header)
  // ==========================
  /// Tanggal yang dipilih
  final selectedDate = DateTime.now().obs;

  /// Teks yang ditampilkan di header (misal: 17-11-20)
  final dateText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateText();
  }

  /// Dipanggil ketika user pilih tanggal dari date picker
  void setDate(DateTime newDate) {
    selectedDate.value = newDate;
    _updateDateText();

    // TODO: di sini nanti bisa panggil API / filter history by date
    // loadHistoryForDate(newDate);
  }

  void _updateDateText() {
    final d = selectedDate.value;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year2 = (d.year % 100).toString().padLeft(2, '0'); // 2-digit year
    dateText.value = '$day-$month-$year2'; // contoh: 17-11-20
  }

  // ==========================
  // DUMMY DATA – bisa diganti model asli nanti
  // ==========================
  final sugarItems = <Map<String, String>>[
    {'time': '08:30', 'title': 'Oatmeal with honey', 'amount': '12.5g'},
    {'time': '12:00', 'title': 'Iced coffee', 'amount': '18g'},
  ].obs;

  final bloodItems = <Map<String, String>>[
    {'time': '14:35', 'label': 'Post-Meal', 'value': '118 mg/dL'},
  ].obs;
}
