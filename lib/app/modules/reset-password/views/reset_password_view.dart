import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/widgets/custom_textfield.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 60,
              ),
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
                    const SizedBox(height: 50),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Reset Password',
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create a new secure password',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextfield(
                      textController: controller.tokenC,
                      labelText: "Reset Code",
                    ),
                    const SizedBox(height: 16),

                    CustomTextfield(
                      textController: controller.passwordC,
                      labelText: "New Password",
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),

                    CustomTextfield(
                      textController: controller.confirmPasswordC,
                      labelText: "Confirm Password",
                      isObscure: true,
                    ),
                    const SizedBox(height: 40),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            controller.isLoading.value
                                ? "Resetting..."
                                : "Reset Password",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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
