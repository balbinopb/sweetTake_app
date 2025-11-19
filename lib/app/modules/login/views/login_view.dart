import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sweettake_app/app/widgets/custom_textfield.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 60),
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
                  'Welcome back !',
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
                'Log in to continue tracking your balanced and healthy sugar levels',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),

              CustomTextfield(
                textController: controller.emailC,
                labelText: "Email",
              ),
              SizedBox(height: 16),
              CustomTextfield(
                textController: controller.passwordC,
                labelText: "Password",
                isObscure: true,
              ),
              SizedBox(height: 40),

                  // content
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome back !',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'sansitaOne',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to continue tracking your balanced and healthy sugar levels',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  CustomTextfield(
                    textController: controller.emailC,
                    labelText: "Email",
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    textController: controller.passwordC,
                    labelText: "Password",
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have account? ",
                        style: TextStyle(color: AppColors.primary),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.REGISTER),
                        child: Text(
                          "Register",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
