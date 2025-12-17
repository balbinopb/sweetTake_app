import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/blood_sugar_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

import '../../login/controllers/auth_controller.dart';

class BloodSugarController extends GetxController {
  final bloodSugarC = TextEditingController();
  // final typeC = TextEditingController();

  final contextList = [
    'Fasting',
    'Post-meal',
    'Before Sleep',
    'After Exercise',
  ];

  final selectedContext = 'Post-meal'.obs;

  final isLoading = false.obs;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final dateString = "".obs;
  final timeString = "".obs;

  final baseUrl = "http://10.0.2.2:8080/v1/api/auth";

  @override
  void onClose() {
    bloodSugarC.dispose();
    super.onClose();
  }

  void updateDate(DateTime d) {
    selectedDate = d;
    _updateDate();
  }

  void updateTime(TimeOfDay t) {
    selectedTime = t;
    _updateTime();
  }

  void _updateDate() {
    dateString.value =
        "${selectedDate.day.toString().padLeft(2, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.year}";
  }

  void _updateTime() {
    timeString.value =
        "${selectedTime.hour.toString().padLeft(2, '0')}:"
        "${selectedTime.minute.toString().padLeft(2, '0')}";
  }

  void _handleResponse(http.Response response, AuthController authC) {
    switch (response.statusCode) {
      case 201:
        clearForm();
        Get.back();
        _showSuccess("Blood sugar saved successfully");
        break;

      case 401:
        authC.logout();
        Get.offAllNamed(Routes.LOGIN);
        break;

      default:
        _showError("Failed to save blood sugar data");
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
  }

  void _showSuccess(String message) {
    Get.snackbar("Success", message, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> submitBloodSugarForm() async {
    final sugar = double.tryParse(bloodSugarC.text.trim());

    if (sugar == null || sugar <= 0) {
      _showError("Please enter a valid blood sugar value");
      return;
    }

    isLoading.value = true;

    try {
      final authC = Get.find<AuthController>();

      final consumedAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final body = BloodSugarModel(
        bloodSugarData: sugar,
        context: selectedContext.value,
        dateTime: consumedAt.toUtc().toIso8601String(),
      ).toJson();

      final response = await http.post(
        Uri.parse("$baseUrl/bloodsugar"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${authC.token.value}",
        },
        body: jsonEncode(body),
      );

      _handleResponse(response, authC);
    } catch (e) {
      _showError("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    bloodSugarC.clear();
    selectedContext.value = 'Post-meal';

    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    _updateDate();
    _updateTime();
  }
}
