import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/reset_password_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  TextEditingController tokenC = TextEditingController();
  final isLoading = false.obs;

  final baseUrl = 'http://10.0.2.2:8080/v1/api';

  Future<void> resetPassword() async {
    // print("====resetPassword Get Called====");

    final password = passwordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();
    final token = tokenC.text.trim();

    if (token.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          ResetPasswordModel(newPassword: password, token: token).toJson()
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Succes', 'Succesfully reset password');
        Get.toNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error');
    } finally {
      isLoading.value = false;
    }
  }
}
