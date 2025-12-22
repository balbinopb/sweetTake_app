import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';

/// Model that reflects backend /v1/api/auth/profile response:
/// {
///   "message": "success",
///   "user": {
///     "fullname": "...",
///     "email": "...",
///     "gender": "...",
///     "date_of_birth": "...",
///     "height": ...,
///     "weight": ...,
///     "contact_info": "..."
///   }
/// }
class ProfileModel {
  final String email;
  final String? fullname;
  final String? gender;
  final String? dateOfBirth; // RFC3339 or date string from backend
  final num? height;
  final num? weight;
  final String? contactInfo;

  ProfileModel({
    required this.email,
    this.fullname,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.contactInfo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: (json['email'] as String?) ?? '',
      fullname: json['fullname'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth']?.toString(),
      height: json['height'] as num?,
      weight: json['weight'] as num?,
      contactInfo: json['contact_info'] as String?,
    );
  }
}

class ProfileController extends GetxController {
  /// Loading & state observables
  final isLoading = false.obs;
  final profile = Rxn<ProfileModel>(); // nullable reactive model
  final errorMessage = RxnString();

  /// Optional controllers if you plan to edit/display in text fields
  final fullnameC = TextEditingController();
  final emailC = TextEditingController();
  final genderC = TextEditingController();
  final dateOfBirthC = TextEditingController();
  final heightC = TextEditingController();
  final weightC = TextEditingController();
  final contactInfoC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetches the authenticated profile via GET /v1/api/auth/profile
  Future<void> fetchProfile() async {
    final baseUrl = dotenv.get('BASE_URL', fallback: '');
    if (baseUrl.isEmpty) {
      Get.snackbar("Error", "BASE_URL not configured");
      return;
    }

    final authC = Get.find<AuthController>();
    final token = authC.token.value;

    if (token.isEmpty) {
      Get.snackbar("Error", "JWT not found. Please login again.");
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final uri = Uri.parse(
        "$baseUrl/auth/profile",
      ); // since your router groups under /v1/api/auth, ensure BASE_URL includes /v1/api
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final decoded = jsonDecode(response.body);
      // print("PROFILE RESPONSE = $decoded");

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // small UX delay to show loader

      if (response.statusCode == 200) {
        final userJson = decoded["user"] as Map<String, dynamic>?;

        if (userJson == null) {
          Get.snackbar("Error", "User payload not found");
          errorMessage.value = "Invalid response";
          return;
        }

        final model = ProfileModel.fromJson(userJson);
        profile.value = model;

        // Populate controllers (optional - useful if you have an Edit Profile form)
        emailC.text = model.email;
        fullnameC.text = model.fullname ?? '';
        genderC.text = model.gender ?? '';
        dateOfBirthC.text = model.dateOfBirth ?? '';
        heightC.text = model.height?.toString() ?? '';
        weightC.text = model.weight?.toString() ?? '';
        contactInfoC.text = model.contactInfo ?? '';

        return;
      }

      // Non-200: show message
      final msg = decoded["error"] ?? "Failed to load profile";
      errorMessage.value = msg;
      Get.snackbar("Error", msg);
    } catch (e) {
      errorMessage.value = "Server error";
      Get.snackbar("Error", "Server error");
    } finally {
      isLoading.value = false;
    }
  }

  /// Example: manual refresh trigger (pull-to-refresh, button, etc.)
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  @override
  void onClose() {
    fullnameC.dispose();
    emailC.dispose();
    genderC.dispose();
    dateOfBirthC.dispose();
    heightC.dispose();
    weightC.dispose();
    contactInfoC.dispose();
    super.onClose();
  }
}
