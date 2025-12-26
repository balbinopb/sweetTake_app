import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/forgot_password_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();

  final isLoading = false.obs;

  final baseUrl = 'http://10.0.2.2:8080/v1/api';

  Future<void> sendResetEmail() async {
    // print("====sendResetEmail Get Called====");
    final email = emailC.text.trim();

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ForgotPasswordModel(email: email).toJson()),
      );

      if (response.statusCode == 200) {
        Get.toNamed(Routes.RESET_PASSWORD);
      }
    } catch (e) {
      Get.snackbar('error', 'server error');
    } finally {
      isLoading.value = false;
    }
  }
}
