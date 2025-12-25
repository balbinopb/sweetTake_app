import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/profile/controllers/profile_controller.dart';
import '../modules/profile/views/profile_view.dart';

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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ProfileView.inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ProfileView.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: isEditing
                      ? TextField(
                          autofocus: true,
                          keyboardType: keyboard,
                          controller: controller.editController,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          value,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check_circle : Icons.edit,
                    color: ProfileView.primary,
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
