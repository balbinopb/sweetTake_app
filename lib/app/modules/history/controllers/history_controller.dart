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

  Future<void> updateConsumption(
    HistoryConsumptionModel item,
    String amount,
    String type,
    DateTime dateTime,
  ) async {
    final backup = List.of(sugarItems);
    final index = sugarItems.indexWhere((x) => x.consumptionId == item.consumptionId);

    try {
      final double parsedAmount = double.parse(amount);
      
      await _service.updateSugarConsumption(item.consumptionId, {
        'sugar_data': parsedAmount,
        'type': type,
        'date_time': _formatDateTime(dateTime),
      });

      if (index != -1) {
        sugarItems[index] = item.copyWith(
          sugarData: parsedAmount,
          type: type,
          dateTime: dateTime,
        );
        sugarItems.refresh();
      }

      Get.snackbar("Success", "Sugar record updated");
    } catch (e) {
      sugarItems.value = backup;
      Get.snackbar("Error", "Failed to update sugar record");
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

  Future<void> updateBloodSugar(
    HistoryBloodsugarModel item,
    String sugarValue,
    String context,
    DateTime dateTime,
  ) async {
    final backup = List.of(bloodItems);
    final index = bloodItems.indexWhere((x) => x.metricId == item.metricId);

    try {
      final int parsedSugar = int.parse(sugarValue);
      
      await _service.updateBloodSugar(item.metricId, {
        'blood_sugar': parsedSugar,
        'context': context,
        'date_time': _formatDateTime(dateTime),
      });

      if (index != -1) {
        bloodItems[index] = item.copyWith(
          bloodSugarData: parsedSugar.toDouble(),
          context: context,
          dateTime: dateTime,
        );
        bloodItems.refresh();
      }

      Get.snackbar("Success", "Blood sugar record updated");
    } catch (e) {
      bloodItems.value = backup;
      Get.snackbar("Error", "Failed to update blood sugar record");
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes =
        (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final datePart =
        '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
    final timePart =
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}:'
        '${local.second.toString().padLeft(2, '0')}';

    return '$datePart''T''$timePart$sign$hours:$minutes';
  }
}
