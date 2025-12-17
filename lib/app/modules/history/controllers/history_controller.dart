import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/history_model.dart';
import '../../login/controllers/auth_controller.dart';

class HistoryController extends GetxController {
  final baseUrl = "http://10.0.2.2:8080/v1/api/auth";

  final selectedTab = 0.obs;
  final selectedDate = DateTime.now().obs;
  final dateText = ''.obs;

  final _authC = Get.find<AuthController>();

  final sugarItems = <HistoryModel>[].obs;
  final bloodItems = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateText();
    loadConsumptions();
  }

  void selectTab(int index) => selectedTab.value = index;

  void setDate(DateTime newDate) {
    selectedDate.value = newDate;
    _updateDateText();
    loadConsumptions();
  }

  void _updateDateText() {
    final d = selectedDate.value;
    dateText.value =
        '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${(d.year % 100).toString().padLeft(2, '0')}';
  }

  Future<List<HistoryModel>> fetchConsumptions() async {
    final response = await http.get(
      Uri.parse("$baseUrl/consumptions"),
      headers: {
        'Authorization': 'Bearer ${_authC.token.value}',
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    final List list = body['data'];
    return list.map((e) => HistoryModel.fromJson(e)).toList();
  }

  Future<void> loadConsumptions() async {
    final all = await fetchConsumptions();

    // print('ALL DATA COUNT: ${all.length}');
    // for (final e in all) {
    //   print(
    //     'RAW -> type: ${e.type}, '
    //     'amount: ${e.amount}, '
    //     'sugarData: ${e.sugarData}, '
    //     'date: ${e.dateTime}',
    //   );
    // }

    sugarItems.value = filterConsumptions(
      all: all,
      selectedDate: selectedDate.value,
    );

    bloodItems.value = filterConsumptions(
      all: all,
      selectedDate: selectedDate.value,
    );

    // print('SUGAR ITEMS COUNT: ${sugarItems.length}');
    // print('BLOOD ITEMS COUNT: ${bloodItems.length}');
  }

  List<HistoryModel> filterConsumptions({
    required List<HistoryModel> all,
    required DateTime selectedDate,
  }) {
    return all.where((c) {
      final localTime = c.dateTime.toLocal();

      final sameDate =
          localTime.year == selectedDate.year &&
          localTime.month == selectedDate.month &&
          localTime.day == selectedDate.day;

      return sameDate;
    }).toList();
  }
}
