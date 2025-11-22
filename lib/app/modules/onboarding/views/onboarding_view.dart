import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  // final List<Map<String, String>> onboardingData = [
  //   {
  //     "image": "assets/images/onboarding1.png",
  //     "title": "Welcome to sweetTake",
  //     "desc":
  //         "Track your blood sugar easily and stay healthy every day. SweetTake helps you understand and manage your sugar intake for a better lifestyle.",
  //   },
  //   {
  //     "image": "assets/images/onboarding2.png",
  //     "title": "Monitor, Learn, and Improve",
  //     "desc":
  //         "Record your daily sugar intake, view progress graphs, and read helpful articles to maintain balanced sugar levels.",
  //   },
  //   {
  //     "image": "assets/images/onboarding3.png",
  //     "title": "Ready to Begin Your Healthy Journey?",
  //     "desc":
  //         "Stay connected, stay informed, and make every choice count. Let SweetTake guide you toward a healthier sugar balance!",
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) {
                    final item = controller.onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Image.asset(item["image"]!, height: 250),
                          SizedBox(height: 20),
                          Text(
                            item["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'sansitaOne',
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            item["desc"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              //Indicator
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: controller.currentPage.value == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? AppColors.primary
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 30),

              // Buttons
              Obx(() {
                bool isLastPage = controller.currentPage.value == 2;
                bool isFirstPage = controller.currentPage.value == 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isFirstPage)
                        ElevatedButton(
                          onPressed: controller.previousPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Previous",
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 100),

                      ElevatedButton(
                        onPressed: isLastPage
                            ? () {
                                Get.offAllNamed(Routes.LOGIN);
                              }
                            : controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          isLastPage ? "Done" : "Next",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
