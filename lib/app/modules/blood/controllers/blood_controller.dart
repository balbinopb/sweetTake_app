import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/routes/app_pages.dart';

class BloodController extends GetxController {
  final TextEditingController sugarC = TextEditingController();

  final RxString selectedContext = "Post-meal".obs;
  final List<String> contextList = [
    "Post-meal",
    "Pre-meal",
    "Fasting",
    "Random",
  ];

  final RxBool isLoading = false.obs;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final RxString dateString = "".obs;
  final RxString timeString = "".obs;

  final String baseUrl = "http://10.0.2.2:8080/v1/api";

  @override
  void onInit() {
    super.onInit();
    _updateDateString();
    _updateTimeString();
  }

  void updateDate(DateTime value) {
    selectedDate = value;
    _updateDateString();
  }

  void updateTime(TimeOfDay value) {
    selectedTime = value;
    _updateTimeString();
  }

  void _updateDateString() {
    dateString.value =
        "${selectedDate.day.toString().padLeft(2, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.year}";
  }

  void _updateTimeString() {
    final h = selectedTime.hour.toString().padLeft(2, '0');
    final m = selectedTime.minute.toString().padLeft(2, '0');
    timeString.value = "$h:$m";
  }

  // Submit blood sugar
  Future<void> submitBloodSugar() async {
    final sugarValue = double.tryParse(sugarC.text.trim()) ?? 0.0;

    if (sugarValue <= 0) {
      Get.snackbar("Error", "Blood sugar must be greater than 0");
      return;
    }

    try {
      isLoading.value = true;

      final payload = {
        "userId": 1,
        "date": selectedDate.toIso8601String(),
        "time": timeString.value,
        "bloodSugarMgDl": sugarValue,
        "context": selectedContext.value,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/blood-sugar"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Blood sugar saved!");
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Error", "Failed to save blood sugar.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    sugarC.dispose();
    super.onClose();
  }
}
