import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/widgets/custom_textfield.dart';
import '../controllers/register_controller.dart';

class RegisterView2 extends GetView<RegisterController> {
  RegisterView2({super.key});

  //list items for dropdowns
  final List<String> preferences = [
    "Low Sugar Diet",
    "Diabetic-Friendly Diet",
    "Balanced Diet",
  ];

  final List<String> healthGoals = [
    "Reduce Daily Sugar Intake",
    "Maintain Stable Blood Sugar",
    "Weight Loss",
  ];

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


              CustomTextfield(
                textController: controller.dobController,
                labelText: "Date of birth",
              ),
              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.genderController,
                labelText: "Gender",
              ),
              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.weightController,
                labelText: "Weight",
                keyboardType:TextInputType.number,

              ),

              SizedBox(height: 16),
              // Preference dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  dropdownColor: AppColors.background2,
                  initialValue: controller.preference.value.isEmpty
                      ? null
                      : controller.preference.value,
                  decoration: const InputDecoration(
                    labelText: "My Preference",
                    border: OutlineInputBorder(),
                  ),
                  items: preferences
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
                    labelText: "My Preference",
                    border: OutlineInputBorder(),
                    // filled: true,
                    // fillColor: AppColors.background2,
                  ),
                  items: healthGoals
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
                    // Get.toNamed(Routes.);
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
