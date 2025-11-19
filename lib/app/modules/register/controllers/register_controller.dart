import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/register_model.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final isObscure = false.obs;

  final baseUrl = "http://10.0.2.2:8080/v1/api";

  Future<void> register() async {
    final username = usernameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    // ---------- VALIDATION ----------
    if (username.isEmpty) {
      Get.snackbar("Warning", "Username is required");
      return;
    }
    if (email.isEmpty) {
      Get.snackbar("Warning", "Email is required");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Warning", "Invalid email format");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Warning", "Password is required");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Warning", "Password must be at least 6 characters");
      return;
    }

    // ---------- API CALL ----------
    try {
      final data = RegisterModel(
        username: username,
        email: email,
        password: password,
      );

      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      // ----------- SUCCESS 201 -----------
      if (response.statusCode == 201) {
        Get.snackbar("Success", "Successfully registered");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // ---------- BACKEND ERRORS ----------
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 400) {
        // backend returns { "errors": [] } or { "error": "" }
        if (decoded["errors"] != null) {
          String allErrors = (decoded["errors"] as List).join("\n");
          Get.snackbar("Validation Error", allErrors);
        } else {
          Get.snackbar("Validation Error", decoded["error"]);
        }
        return;
      }

      if (response.statusCode == 409) {
        // duplicate username/email
        Get.snackbar("Error", decoded["error"]);
        return;
      }

      // fallback unexpected
      Get.snackbar("Error", "Unexpected error: ${response.body}");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
