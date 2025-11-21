import 'package:flutter/material.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController textController;
  final bool isObscure;
  final TextInputType keyboardType;

  const CustomTextfield({
    super.key,
    required this.labelText,
    required this.textController,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
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
    );
  }
}
