import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/consumption_model.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

import '../../history/controllers/history_controller.dart';

class ConsumptionFormController extends GetxController {
  final typeC = TextEditingController();
  final sugarC = TextEditingController();

  final selectedContext = "Snack".obs;
  final contextList = ["Snack", "Breakfast", "Lunch", "Dinner"];

  final amount = 1.obs;
  final isLoading = false.obs;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final dateString = "".obs;
  final timeString = "".obs;

  @override
  void onInit() {
    super.onInit();
    _updateDate();
    _updateTime();
  }

  void incrementAmount() {
    amount.value++;
  }

  void decrementAmount() {
    if (amount.value > 1) {
      amount.value--;
    }
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

  Future<void> submitConsumption() async {
    // print("===========inisialized============");
    final sugar = double.tryParse(sugarC.text.trim());
    if (typeC.text.trim().isEmpty || sugar == null || sugar <= 0) {
      Get.snackbar("Error", "Invalid input");
      return;
    }

    try {
      isLoading.value = true;

      final consumedAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // print("AuthController registered: ${Get.isRegistered<AuthController>()}");
      final authC = Get.find<AuthController>();

      // print("=========TOKEN = ${authC.token.value}============");

      final response = await http.post(
        Uri.parse("${dotenv.get('BASE_URL_AUTH')}/consumption"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${authC.token.value}",
        },
        body: jsonEncode(
          ConsumptionModel(
            type: typeC.text.trim(),
            amount: amount.value.toDouble(),
            sugarData: sugar,
            context: selectedContext.value,
            dateTime: consumedAt.toUtc().toIso8601String(),
          ).toJson(),
        ),
      );

      if (response.statusCode == 201) {
        clearForm();
        Get.find<HistoryController>().loadConsumptions();
        Get.back();
        Get.snackbar("Success", "Consumption saved");
      } else if (response.statusCode == 401) {
        authC.logout();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        // print("=====${response.body}==============");
        Get.snackbar("Error", "Failed to save");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    typeC.clear();
    sugarC.clear();
    amount.value = 1;
    selectedContext.value = "Snack";
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    _updateDate();
    _updateTime();
  }

  @override
  void onClose() {
    typeC.dispose();
    sugarC.dispose();
    super.onClose();
  }
}
