import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/data/models/history_bloodsugar_model.dart';
import 'package:sweettake_app/app/data/services/history_service.dart';
import '../../../data/models/history_consumption_model.dart';
import '../../login/controllers/auth_controller.dart';

class HistoryController extends GetxController {
  final selectedTab = 0.obs;
  final selectedDate = DateTime.now().obs;
  final dateText = ''.obs;

  final isLoading = false.obs;

  final _authC = Get.find<AuthController>();
  final _service = HistoryService();

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
    final list = await _service.sugarConsumption();
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
    final list = await _service.bloodSugar();
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

  Future<void> deleteSugar(HistoryConsumptionModel item) async {
    final backup = List.of(sugarItems);
    sugarItems.remove(item);

    try {
      await _service.deleteSugar(item.consumptionId);
    } catch (e) {
      sugarItems.value = backup;
      Get.snackbar("Error", "Failed to delete");
    }
  }

  void deleteBloodSugar(HistoryBloodsugarModel e) async {
    bloodItems.removeWhere((x) => x.metricId == e.metricId);

    try {
      await _service.deleteBloodSugar(e.metricId);
    } catch (err) {
      bloodItems.insert(0, e);

      Get.snackbar(
        "Error",
        "Failed to delete blood sugar record",
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }
}
