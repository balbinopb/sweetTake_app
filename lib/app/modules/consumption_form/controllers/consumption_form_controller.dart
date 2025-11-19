import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/consumption_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class ConsumptionController extends GetxController {
  // Input fields
  final TextEditingController typeC =
      TextEditingController(); // Optional free-text
  final TextEditingController descriptionC = TextEditingController();
  final TextEditingController sugarC = TextEditingController();
  final TextEditingController amountC = TextEditingController();

  // Only context is dropdown
  final RxString selectedContext = "".obs;

  final isLoading = false.obs;

  final baseUrl = "http://10.0.2.2:8080/v1/api";

  Future<void> submitConsumption() async {
    final type = typeC.text.trim();
    final sugar = double.tryParse(sugarC.text.trim()) ?? 0.0;
    final amount = double.tryParse(amountC.text.trim()) ?? 0.0;
    final context = selectedContext.value;

    // Validations matching current backend rules
    if (type.length > 255) {
      Get.snackbar("Error", "Type text is too long (max 255 characters)");
      return;
    }

    if (sugar <= 0) {
      Get.snackbar("Error", "Sugar (grams) must be greater than 0");
      return;
    }

    if (amount <= 0) {
      Get.snackbar("Error", "Amount must be greater than 0");
      return;
    }

    if (context.isEmpty) {
      Get.snackbar("Error", "Please select a context");
      return;
    }

    try {
      isLoading.value = true;

      final consumption = ConsumptionModel(
        userId: 1, // replace with actual user ID
        type: type, // free text or empty allowed
        amount: amount,
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
}
