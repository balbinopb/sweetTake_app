import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/constants/api_endpoints.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/data/services/profile_service.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

import '../../../data/models/profile_model.dart';

class ProfileController extends GetxController {
  final _authC = Get.find<AuthController>();
  final _service=ProfileService();

  final profile = Rxn<ProfileModel>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  // for edit profile
  final editingField = ''.obs;
  final tempValue = ''.obs;
  final TextEditingController editController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // hit api or fetch api
  void fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // API fetch delay
      await Future.delayed(const Duration(seconds: 1));

      final response = await _service.fetchProfile();
      final Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> personalData = body['data'];

      profile.value = ProfileModel.fromJson(personalData);
    } catch (e) {
      errorMessage.value = "Failed to load profile.";
    } finally {
      isLoading.value = false;
    }
  }

  // refresh profile
  Future<void> refreshProfile() async {
    fetchProfile();
  }

  // start edit
  void startEdit(String field, String currentValue) {
    editingField.value = field;
    tempValue.value = currentValue;
  }

  // for cancel
  void cancelEdit() {
    editingField.value = '';
    tempValue.value = '';
  }

  // parse double value
  double? parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }

  // save edit
  Future<void> saveEdit(String fieldKey) async {
    final value = tempValue.value.trim();

    final body = <String, dynamic>{};

    switch (fieldKey) {
      case 'height':
        final parsed = double.tryParse(value);
        if (parsed != null) body['height'] = parsed;
        break;
      case 'weight':
        final parsed = double.tryParse(value);
        if (parsed != null) body['weight'] = parsed;
        break;
      case 'contact':
        body['contact_info'] = value;
        break;
      case 'goal':
        body['health_goal'] = value;
        break;
      case 'preference':
        body['preference'] = value;
        break;
      case 'gender':
        body['gender'] = value;
        break;
      case 'dob':
        try {
          final parsedDate = DateTime.parse(value);
          body['date_of_birth'] = parsedDate.toIso8601String();
        } catch (_) {
          Get.snackbar(
            "Error",
            "Invalid date format (YYYY-MM-DD)",
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
          return;
        }
        break;
    }

    if (body.isEmpty) return;

    try {
      final response = await http.patch(
        Uri.parse(ApiEndpoints.profile),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_authC.token.value}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // update local model
        profile.value = profile.value!.copyWith(
          height: fieldKey == 'height'
              ? double.tryParse(value)
              : profile.value!.height,
          weight: fieldKey == 'weight'
              ? double.tryParse(value)
              : profile.value!.weight,
          contactInfo: fieldKey == 'contact'
              ? value
              : profile.value!.contactInfo,
          healthGoal: fieldKey == 'goal' ? value : profile.value!.healthGoal,
          preference: fieldKey == 'preference'
              ? value
              : profile.value!.preference,
          gender: fieldKey == 'gender' ? value : profile.value!.gender,
          dateOfBirth: fieldKey == 'dob'
              ? body['date_of_birth']
              : profile.value!.dateOfBirth,
        );
        cancelEdit();
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          backgroundColor: AppColors.primary2.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        throw Exception("Failed to update profile: ${response.body}");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    // clear auth data
    _authC.logout();

    // clear profile state
    profile.value = null;
    editingField.value = '';
    tempValue.value = '';

    // print("==============${_authC.token.value}=============");

    // go to login
    Get.offAllNamed(Routes.LOGIN);
  }
}
