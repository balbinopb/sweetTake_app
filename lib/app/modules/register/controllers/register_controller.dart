import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/register_model.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final TextEditingController fullnameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final isObscure = false.obs;
  final isLoading = false.obs;

  // PAGE 2 — Dropdown values (reactive)
  RxString gender = ''.obs;
  RxString preference = ''.obs;
  RxString healthGoal = ''.obs;

  // pick date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}T00:00:00Z";
    }
  }

  // List options
  final genders = ["Male", "Female"];

  final preferences = [
    "Low Sugar Diet",
    "Diabetic-Friendly Diet",
    "Balanced Diet",
  ];

  final healthGoals = [
    "Reduce Daily Sugar Intake",
    "Maintain Stable Blood Sugar",
    "Weight Loss",
  ];

  final baseUrl = "http://10.0.2.2:8080/v1/api";

  Future<void> register() async {
    final fullname = fullnameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final phoneNumber = numberController.text.trim();
    final dob = DateTime.parse(
      dobController.text.trim(),
    ).toUtc().toIso8601String();
    final genderValue = gender.value;
    final weight = weightController.text.trim();
    final height = heightController.text.trim();
    final preferenceValue = preference.value;
    final healthGoalValue = healthGoal.value;

    // ---------- VALIDATION ----------
    if (fullname.isEmpty) {
      Get.snackbar("Warning", "Name is required");
      return;
    }

    if (phoneNumber.isEmpty) {
      Get.snackbar("Warning", "Phone number is required");
      return;
    }

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar("Warning", "Valid email is required");
      return;
    }

    if (password.isEmpty || password.length < 6) {
      Get.snackbar("Warning", "Password must be at least 6 characters");
      return;
    }

    if (dob.isEmpty) {
      Get.snackbar("Warning", "Date of birth is required");
      return;
    }

    if (genderValue.isEmpty) {
      Get.snackbar("Warning", "Gender is required");
      return;
    }

    if (weight.isEmpty) {
      Get.snackbar("Warning", "Weight is required");
      return;
    }

    if (height.isEmpty) {
      Get.snackbar("Warning", "Height is required");
      return;
    }

    if (preferenceValue.isEmpty) {
      Get.snackbar("Warning", "Diet preference is required");
      return;
    }

    if (healthGoalValue.isEmpty) {
      Get.snackbar("Warning", "Health goal is required");
      return;
    }

    // ---------- CREATE MODEL ----------
    final data = RegisterModel(
      fullname: fullname,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      dateOfBirth: dob,
      gender: genderValue,
      weight: double.parse(weight),
      height: double.parse(height),
      preference: preferenceValue,
      healthGoal: healthGoalValue,
    );

    // ---------- API CALL ----------
    try {
      isLoading.value = true;
      // final payload = data.toJson();
      // print("===== PAYLOAD SENT =====");
      // print(payload);
      // print("========================");

      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      // ---------- SUCCESS ----------
      if (response.statusCode == 201) {
        Get.snackbar("Success", "Account created successfully");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // ---------- ERROR HANDLING ----------
      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      if (response.statusCode == 400) {
        if (decoded?["errors"] != null) {
          Get.snackbar(
            "Validation Error",
            (decoded["errors"] as List).join("\n"),
          );
        } else {
          Get.snackbar(
            "Validation Errorr",
            decoded?["error"] ?? "Invalid input",
          );
          // print("======${decoded?["error"]}===========");
        }
        return;
      }

      if (response.statusCode == 409) {
        Get.snackbar("Error", decoded?["error"] ?? "Account already exists");
        return;
      }

      Get.snackbar("Error", "Unexpected error occurred");
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to server");
    } finally {
      isLoading.value = false;
    }
  }
}
