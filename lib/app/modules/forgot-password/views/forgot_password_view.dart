import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/widgets/custom_textfield.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: keyboardOpen
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'sansitaOne',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter your email and we’ll send you a reset link',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 24),

                    CustomTextfield(
                      textController: controller.emailC,
                      labelText: "Email",
                    ),
                    SizedBox(height: 40),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.sendResetEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            controller.isLoading.value
                                ? "Sending..."
                                : "Send Reset Link",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Back to Login",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
