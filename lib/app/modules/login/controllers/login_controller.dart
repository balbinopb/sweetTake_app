import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/data/models/login_model.dart';
import 'package:sweettake_app/app/data/services/auth_service.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final isObscure = false.obs;
  final isLoading = false.obs;


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
      isLoading.value = true;

      final data=LoginModel(email: email, password: password);

      print("========test login=====");

      final response = await AuthService.login(data);

      // print("==============login.....${response.body}.........==================");
      final decoded = jsonDecode(response.body);
      // print("LOGIN RESPONSE = $decoded");

      await Future.delayed(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final token = decoded["token"];

        if (token == null || token.toString().isEmpty) {
          Get.snackbar("Error", "JWT not found");
          return;
        }

        final authC = Get.find<AuthController>();
        authC.setToken(token);

        // print("TOKEN SAVED = ${authC.token.value}");

        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
        return;
      }

      Get.snackbar("Login Failed", decoded["error"] ?? "Invalid credentials");
    } catch (e) {
      Get.snackbar("Error", "Server error");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
