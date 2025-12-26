import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/reset_password_model.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final tokenC = TextEditingController();

  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final tokenError = RxnString();

  final isLoading = false.obs;
  final isOkay=false.obs;

  final String baseUrl = 'http://10.0.2.2:8080/v1/api';

bool get isAllRulesCompleted {
  return passwordError.value == null &&
      confirmPasswordError.value == null &&
      tokenError.value == null &&
      !isLoading.value &&
      passwordC.text.isNotEmpty &&
      confirmPasswordC.text.isNotEmpty ;
      // tokenC.text.isNotEmpty;
}



  bool _isStrongPassword(String password) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecial =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return password.length >= 8 &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecial;
  }

  void onPasswordChanged(String value) {
    passwordError.value = null;

    if (!_isStrongPassword(value)) {
      passwordError.value =
          'Min 8 chars, uppercase, lowercase, number & symbol';
    }

    // Recheck confirm password
    if (confirmPasswordC.text.isNotEmpty &&
        value != confirmPasswordC.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = null;
    }
  }

  void onConfirmPasswordChanged(String value) {
    confirmPasswordError.value = null;

    if (value != passwordC.text) {
      confirmPasswordError.value = 'Passwords do not match';
    }
  }

  void onTokenChanged(String value) {
    tokenError.value = value.isEmpty ? 'Token is required' : null;
  }

  bool _validateForm() {
    onPasswordChanged(passwordC.text);
    onConfirmPasswordChanged(confirmPasswordC.text);
    onTokenChanged(tokenC.text);

    return passwordError.value == null &&
        confirmPasswordError.value == null &&
        tokenError.value == null;
  }

  // api call
  Future<void> resetPassword() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          ResetPasswordModel(
            newPassword: passwordC.text.trim(),
            token: tokenC.text.trim(),
          ).toJson(),
        ),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        final body = jsonDecode(response.body);
        tokenError.value = body['error'] ?? 'Invalid or expired token';
      }
    } catch (_) {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
      );
    } finally {
      isLoading.value = false;
    }
  }

// CLEAN UP
  @override
  void onClose() {
    passwordC.dispose();
    confirmPasswordC.dispose();
    tokenC.dispose();
    super.onClose();
  }
}
