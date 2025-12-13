import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                textController: controller.fullnameC,
                labelText: "Full name",
              ),

              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.numberController,
                labelText: "Phone number",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                textController: controller.emailC,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.passwordC,
                labelText: "Password",
                isObscure: true,
              ),

              SizedBox(height: 16),

              TextField(
                controller: controller.dobController,
                readOnly: true,
                onTap: () {
                  controller.selectDate(context);
                },
                decoration: InputDecoration(
                  labelText: "Date of birth",
                  labelStyle: TextStyle(color: AppColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // drop down for gender
              Obx(
                () => DropdownButtonFormField<String>(
                  dropdownColor: AppColors.background2,
                  initialValue: controller.gender.value.isEmpty
                      ? null
                      : controller.gender.value,
                  decoration: InputDecoration(
                    labelText: "Gender",
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
                  items: controller.genders
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.gender.value = value!;
                  },
                ),
              ),

              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.weightController,
                labelText: "Weight",
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.heightController,
                labelText: "Height",
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER2);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),

              SizedBox(height: 13),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
