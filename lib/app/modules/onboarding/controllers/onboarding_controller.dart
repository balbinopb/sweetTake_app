import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/storage_keys.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  PageController pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Welcome to sweetTake",
      "desc":
          "Track your blood sugar easily and stay healthy every day. SweetTake helps you understand and manage your sugar intake for a better lifestyle.",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Monitor, Learn, and Improve",
      "desc":
          "Record your daily sugar intake, view progress graphs, and read helpful articles to maintain balanced sugar levels.",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Ready to Begin Your Healthy Journey?",
      "desc":
          "Stay connected, stay informed, and make every choice count. Let SweetTake guide you toward a healthier sugar balance!",
    },
  ];

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void finishOnboarding() {
    final box = GetStorage();
    box.write(StorageKeys.hasSeenOnboarding, true);
    Get.offAllNamed(Routes.LOGIN);
  }
}
