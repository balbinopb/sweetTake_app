import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';

import '../../../widgets/input_decorations.dart' show appInputDecoration;
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
              padding: EdgeInsets.symmetric(
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
                    SizedBox(height: 50),

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
                    SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create a new secure password',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => TextField(
                        controller: controller.tokenC,
                        onChanged: controller.onTokenChanged,
                        decoration: appInputDecoration(
                          label: "Token",
                          errorText: controller.tokenError.value,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Obx(
                      () => TextField(
                        controller: controller.passwordC,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        onChanged: controller.onPasswordChanged,
                        decoration: appInputDecoration(
                          label: 'New Password',
                          errorText: controller.passwordError.value,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Obx(
                      () => TextField(
                        controller: controller.confirmPasswordC,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        onChanged: controller.onConfirmPasswordChanged,
                        decoration: appInputDecoration(
                          label: "Confirm Password",
                          errorText: controller.confirmPasswordError.value,
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isAllRulesCompleted
                              ? controller.resetPassword
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Reset Password",
                                  style: TextStyle(color: Colors.white),
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
