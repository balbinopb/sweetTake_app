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

    try {

      final data = RegisterModel(
        username: username,
        email: email,
        password: password,
      );

      // print("===========DATA: ${data.toJson()}=======================");

      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      // print("===========RESPONSE: ${response.statusCode}=======================");
      // print("===========RESPONSE: ${response.body}=======================");

      if (response.statusCode == 201) {
        Get.snackbar("SUCCES", "SUCCES TO REGISTER");

        Get.toNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.snackbar("Error", "something wrong");
    }
  }
}
