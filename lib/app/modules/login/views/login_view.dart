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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important for scrollable Column
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Title
              Text(
                'sweetTake',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'sansitaOne',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 50),

              // Welcome Text
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'sansitaOne',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Log in to continue tracking your balanced and healthy sugar levels',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Email & Password Fields
              CustomTextfield(
                textController: controller.emailC,
                labelText: "Email",
              ),
              const SizedBox(height: 16),
              CustomTextfield(
                textController: controller.passwordC,
                labelText: "Password",
                isObscure: true,
              ),
              const SizedBox(height: 40),

              // Login Button
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

              // Forgot Password
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
