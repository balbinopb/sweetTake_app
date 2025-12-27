import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';

import '../modules/profile/controllers/profile_controller.dart';

class ProfileField extends GetView<ProfileController> {
  final String label;
  final String value;
  final String fieldKey;
  final TextInputType keyboard;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.fieldKey,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEditing = controller.editingField.value == fieldKey;

      return Container(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: isEditing
                      ? TextField(
                          autofocus: true,
                          keyboardType: keyboard,
                          controller: controller.editController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check_circle : Icons.edit,
                    color: AppColors.primary2,
                  ),
                  onPressed: () => isEditing
                      ? controller.saveEdit(fieldKey)
                      : controller.startEdit(fieldKey, value),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
