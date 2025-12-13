import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView2 extends GetView<RegisterController> {
  const RegisterView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'sweetTake',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'sansitaOne',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Create Your Account',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'sansitaOne',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Start your journey toward balanced and healthy sugar levels',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 16),

              // Preference dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  dropdownColor: AppColors.background2,
                  initialValue: controller.preference.value.isEmpty
                      ? null
                      : controller.preference.value,
                  decoration: InputDecoration(
                    labelText: "My Preference",
                    labelStyle: TextStyle(color: AppColors.primary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: controller.preferences
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.preference.value = value!;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Health goal dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  dropdownColor: AppColors.background2,
                  initialValue: controller.healthGoal.value.isEmpty
                      ? null
                      : controller.healthGoal.value,
                  decoration: InputDecoration(
                    labelText: "My Health Goal",
                    labelStyle: TextStyle(color: AppColors.primary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: controller.healthGoals
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.healthGoal.value = value!;
                  },
                ),
              ),
              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    controller.register();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
