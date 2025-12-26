

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

InputDecoration appInputDecoration({
  required String label,
  String? errorText,
}) {
  return InputDecoration(
    labelText: label,
    errorText: errorText,
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

    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
