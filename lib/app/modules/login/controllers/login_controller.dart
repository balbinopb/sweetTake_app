import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/login_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final isObscure = false.obs;

  final baseUrl = "http://10.0.2.2:8080/v1/api";

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    // ---------- LOCAL VALIDATION ----------
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

    // ---------- API CALL ----------
    try {
      final loginData = LoginModel(email: email, password: password);

      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData.toJson()),
      );

      // ---------- SUCCESS ----------
      if (response.statusCode == 200) {
        Get.snackbar("SUCCES", "SUCCES TO LOGIN");

        Get.offAllNamed(Routes.CONSUMPTION_FORM);
      }

      // ---------- BACKEND ERRORS ----------
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 400) {
        //{ "error": "invalid credentials" } or validation error
        Get.snackbar("Login Failed", decoded["error"] ?? "Invalid request");
        return;
      }

      if (response.statusCode == 401) {
        // unauthorized / wrong email or password
        Get.snackbar(
          "Login Failed",
          decoded["error"] ?? "Incorrect email or password",
        );
        return;
      }

      Get.snackbar("Error", "Unexpected error: ${response.body}");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
