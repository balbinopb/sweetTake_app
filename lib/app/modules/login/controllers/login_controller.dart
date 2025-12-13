import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/login_model.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final isObscure = false.obs;

  final baseUrl = "http://10.0.2.2:8080/v1/api";

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar("Warning", "Valid email is required");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Warning", "Password is required");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(LoginModel(email: email, password: password).toJson()),
      );

      final decoded = jsonDecode(response.body);
      print("LOGIN RESPONSE = $decoded");

      if (response.statusCode == 200) {
        final token = decoded["token"]; 

        if (token == null || token.toString().isEmpty) {
          Get.snackbar("Error", "JWT not found");
          return;
        }

        final authC = Get.find<AuthController>();
        authC.setToken(token);

        print("TOKEN SAVED = ${authC.token.value}");

        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
        return;
      }

      Get.snackbar("Login Failed", decoded["error"] ?? "Invalid credentials");
    } catch (e) {
      Get.snackbar("Error", "Server error");
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
