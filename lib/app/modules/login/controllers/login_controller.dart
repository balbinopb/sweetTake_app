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
    try {
      final loginData = LoginModel(email: email, password: password);

      // print("===============Body: ${loginData.toJson()}========================");
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData.toJson()),
      );
      // print("===============STATUS CODE: ${response.statusCode}========================");
      // print("===============STATUS BODY: ${response.body}========================");

      if (response.statusCode == 200) {
        Get.snackbar("SUCCES", "SUCCES TO LOGIN");

        Get.offAllNamed(Routes.CONSUMPTION_FORM);
      }
    } catch (e) {
      // print("===============ERROR: ${e}========================");
      Get.snackbar("Error", "something wrong");
    }
  }
}
