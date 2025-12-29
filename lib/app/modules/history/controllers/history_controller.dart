import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/constants/api_endpoints.dart';
import 'package:sweettake_app/app/data/models/history_bloodsugar_model.dart';
import '../../../data/models/history_consumption_model.dart';
import '../../login/controllers/auth_controller.dart';

class HistoryController extends GetxController {

  final selectedTab = 0.obs;
  final selectedDate = DateTime.now().obs;
  final dateText = ''.obs;

  final isLoading = false.obs;

  final _authC = Get.find<AuthController>();

  final sugarItems = <HistoryConsumptionModel>[].obs;
  final bloodItems = <HistoryBloodsugarModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateText();
    // loadConsumptions();
    // loadBloodSugar();

    ever(_authC.token, (token) {
      if (token.toString().isNotEmpty) {
        loadConsumptions();
        loadBloodSugar();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadConsumptions();
    loadBloodSugar();
  }

  // Tab selection
  void selectTab(int index) {
    selectedTab.value = index;

    // Load blood sugar only if tab 1 selected and data not loaded
    if (index == 1 && bloodItems.isEmpty) {
      loadBloodSugar();
    }
  }

  // Change date
  void setDate(DateTime newDate) {
    selectedDate.value = newDate;
    _updateDateText();
    loadConsumptions();
    loadBloodSugar();
  }

  // Format date for UI
  void _updateDateText() {
    final d = selectedDate.value;
    dateText.value =
        '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${(d.year % 100).toString().padLeft(2, '0')}';
  }

  // ================= Sugar Consumption =================
  Future<List<HistoryConsumptionModel>> fetchConsumptions() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllConsumptions),
      headers: {
        'Authorization': 'Bearer ${_authC.token.value}',
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    final List list = body['data'];
    return list.map((e) => HistoryConsumptionModel.fromJson(e)).toList();
  }

  List<HistoryConsumptionModel> filterConsumptions({
    required List<HistoryConsumptionModel> all,
    required DateTime selectedDate,
  }) {
    return all.where((c) {
      final localTime = c.dateTime.toLocal();
      return localTime.year == selectedDate.year &&
          localTime.month == selectedDate.month &&
          localTime.day == selectedDate.day;
    }).toList();
  }

Future<void> loadConsumptions() async {
  isLoading.value = true;

  final all = await fetchConsumptions();
  sugarItems.value = filterConsumptions(
    all: all,
    selectedDate: selectedDate.value,
  );

  isLoading.value = false;
}


  // ================= Blood Sugar =================
  Future<List<HistoryBloodsugarModel>> fetchBloodSugar() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllBloodSugars),
      headers: {'Authorization': 'Bearer ${_authC.token.value}'},
    );

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List list = body['data'];
    return list.map((e) => HistoryBloodsugarModel.fromJson(e)).toList();
  }

  List<HistoryBloodsugarModel> filterBloodSugar({
    required List<HistoryBloodsugarModel> all,
    required DateTime selectedDate,
  }) {
    return all.where((c) {
      final localTime = c.dateTime.toLocal();
      return localTime.year == selectedDate.year &&
          localTime.month == selectedDate.month &&
          localTime.day == selectedDate.day;
    }).toList();
  }

  Future<void> loadBloodSugar() async {
    isLoading.value = true;
    final all = await fetchBloodSugar();

    bloodItems.value = filterBloodSugar(
      all: all,
      selectedDate: selectedDate.value,
    );

    isLoading.value = false;
  }
}
