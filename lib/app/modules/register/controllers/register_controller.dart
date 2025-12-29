import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/data/models/register_model.dart';
import 'package:sweettake_app/app/data/services/auth_service.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // ---------- TEXT CONTROLLERS ----------
  final fullnameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final numberController = TextEditingController();

  // ---------- STATE ----------
  final isLoading = false.obs;

  // ----------REACTIVE DROPDOWN----------
  final RxString gender = ''.obs;
  final RxString preference = ''.obs;
  final RxString healthGoal = ''.obs;

  // ---------- DATE ----------
  DateTime? selectedDob;

  // ---------- OPTIONS ----------
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

  // ---------- DATE PICKER ----------
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDob = picked;
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // ---------- REGISTER ----------
  Future<void> register() async {
    // ---------- GET VALUES ----------
    final fullname = fullnameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final phoneNumber = numberController.text.trim();
    final weightText = weightController.text.trim();
    final heightText = heightController.text.trim();

    // ---------- VALIDATION ----------
    if (fullname.isEmpty) {
      Get.snackbar("Warning", "Full name is required");
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

    if (password.length < 6) {
      Get.snackbar("Warning", "Password must be at least 6 characters");
      return;
    }

    if (selectedDob == null) {
      Get.snackbar("Warning", "Date of birth is required");
      return;
    }

    if (gender.value.isEmpty) {
      Get.snackbar("Warning", "Gender is required");
      return;
    }

    final weight = double.tryParse(weightText);
    if (weight == null) {
      Get.snackbar("Warning", "Weight must be a valid number");
      return;
    }

    final height = double.tryParse(heightText);
    if (height == null) {
      Get.snackbar("Warning", "Height must be a valid number");
      return;
    }

    if (preference.value.isEmpty) {
      Get.snackbar("Warning", "Diet preference is required");
      return;
    }

    if (healthGoal.value.isEmpty) {
      Get.snackbar("Warning", "Health goal is required");
      return;
    }

    // ---------- FORMAT DOB FOR BACKEND ----------
    final dobIso = selectedDob!.toUtc().toIso8601String();

    // ---------- CREATE MODEL ----------
    final data = RegisterModel(
      fullname: fullname,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      dateOfBirth: dobIso,
      gender: gender.value,
      weight: weight,
      height: height,
      preference: preference.value,
      healthGoal: healthGoal.value,
    );

    // ---------- API CALL ----------
    try {
      isLoading.value = true;

      final response = await AuthService.register(data);

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      // ---------- SUCCESS ----------
      if (response.statusCode == 201) {
        Get.snackbar("Success", "Account created successfully");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // ---------- ERRORS ----------
      if (response.statusCode == 400) {
        Get.snackbar("Validation Error", decoded?["error"] ?? "Invalid input");
        return;
      }

      if (response.statusCode == 409) {
        Get.snackbar("Error", decoded?["error"] ?? "Account already exists");
        return;
      }

      Get.snackbar("Error", "Unexpected error occurred");
    } catch (_) {
      Get.snackbar("Error", "Failed to connect to server");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- CLEANUP ----------
  @override
  void onClose() {
    fullnameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    numberController.dispose();
    super.onClose();
  }
}
