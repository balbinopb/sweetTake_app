import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/consumption_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class ConsumptionFormController extends GetxController {
  // Input fields
  final TextEditingController typeC = TextEditingController();
  final TextEditingController sugarC = TextEditingController();

  // Context dropdown (reactive)
  final Rx<String> selectedContext = "Snack".obs;
  final List<String> contextList = ["Snack", "Breakfast", "Lunch", "Dinner"];

  // Loading state
  final isLoading = false.obs;

  // Amount for counter (reactive int)
  final RxInt amount = 1.obs;
  void incrementAmount() => amount.value++;
  void decrementAmount() {
    if (amount.value > 1) amount.value--;
  }

  // Date & Time fields + reactive formatted strings
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final RxString dateString = "".obs;
  final RxString timeString = "".obs;

  // Base URL (adjust if using real device)
  final baseUrl = "http://10.0.2.2:8080/v1/api";

  @override
  void onInit() {
    super.onInit();
    _updateDateString();
    _updateTimeString();
  }

  void updateDate(DateTime newDate) {
    selectedDate = newDate;
    _updateDateString();
  }

  void updateTime(TimeOfDay newTime) {
    selectedTime = newTime;
    _updateTimeString();
  }

  void _updateDateString() {
    dateString.value =
        "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
  }

  void _updateTimeString() {
    final h = selectedTime.hour.toString().padLeft(2, '0');
    final m = selectedTime.minute.toString().padLeft(2, '0');
    timeString.value = "$h:$m";
  }

  // Submit consumption
  Future<void> submitConsumption() async {
    final type = typeC.text.trim();
    final sugar = double.tryParse(sugarC.text.trim()) ?? 0.0;
    final amt = amount.value.toDouble();
    final context = contextList.contains(selectedContext.value)
        ? selectedContext.value
        : contextList.first;

    // Validations
    if (type.length > 255) {
      Get.snackbar("Error", "Type text is too long (max 255 characters)");
      return;
    }

    if (sugar <= 0) {
      Get.snackbar("Error", "Sugar (grams) must be greater than 0");
      return;
    }

    if (amt <= 0) {
      Get.snackbar("Error", "Amount must be greater than 0");
      return;
    }

    try {
      isLoading.value = true;

      final consumption = ConsumptionModel(
        userId: 1, // replace with actual user ID
        type: type,
        amount: amt,
        sugarGrams: sugar,
        context: context,
      );

      final response = await http.post(
        Uri.parse("$baseUrl/consumption"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(consumption.toJson()),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Sugar consumption recorded!");
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Error", "Failed to record consumption.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    typeC.dispose();
    sugarC.dispose();
    super.onClose();
  }
}
