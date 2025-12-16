import 'package:get/get.dart';

class HomeController extends GetxController {
  var userName = 'Sweetie Telutizen'.obs;

  // Weekly or Monthly
  var selectedRange = 'Weekly'.obs;

  // Dummy consumption items
  var consumptionItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    consumptionItems.value = [
      {'name': 'Milk Tea', 'time': '8.00', 'sugar': '42gram'},
      {'name': 'Burger', 'time': '12.00', 'sugar': '25gram'},
    ];
  }

  void updateRange(String value) {
    selectedRange.value = value;
    // nanti bisa ganti data chart berdasarkan Weekly/Monthly
  }
}
