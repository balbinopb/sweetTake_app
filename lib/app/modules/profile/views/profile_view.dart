import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary2),
          );
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(
              controller.errorMessage.value!,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final data = controller.profile.value;
        if (data == null) {
          return Center(child: Text('No profile data'));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          color: AppColors.primary2,
          backgroundColor:AppColors.softBg,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ===== Header =====y
                _buildHeader(data),

                SizedBox(height: 24),

                // ===== Info Section =====
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _editableInfoTile(
                        fieldKey: 'gender',
                        title: "Gender",
                        value: data.gender ?? "-",
                      ),
                      _editableInfoTile(
                        fieldKey: 'dob',
                        title: "Date of Birth",
                        value: _formatDate(data.dateOfBirth),
                        keyboard: TextInputType.datetime,
                      ),
                      _editableInfoTile(
                        fieldKey: 'height',
                        title: "Height (cm)",
                        value: data.height != null ? "${data.height}" : "-",
                        keyboard: TextInputType.number,
                      ),
                      _editableInfoTile(
                        fieldKey: 'weight',
                        title: "Weight (kg)",
                        value: data.weight != null ? "${data.weight}" : "-",
                        keyboard: TextInputType.number,
                      ),
                      _editableInfoTile(
                        fieldKey: 'contact',
                        title: "Contact",
                        value: data.contactInfo ?? "-",
                        keyboard: TextInputType.phone,
                      ),
                      _editableInfoTile(
                        fieldKey: 'goal',
                        title: "Health Goal",
                        value: data.healthGoal ?? "-",
                      ),
                      _editableInfoTile(
                        fieldKey: 'preference',
                        title: "Preference",
                        value: data.preference ?? "-",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: OutlinedButton(
                    onPressed: _showLogoutDialog,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      side: BorderSide(color: AppColors.primary2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: AppColors.primary2,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(dynamic data) {
    final topInset = MediaQuery.of(Get.context!).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topInset + 32, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary2, Color(0xFF776A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with soft glow
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary2.withValues(alpha: 0.25),
              child: Text(
                data.fullname.isNotEmpty ? data.fullname[0] : "-",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Name
          Text(
            data.fullname,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),

          SizedBox(height: 6),

          // Email
          Text(
            data.email,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _editableInfoTile({
    required String fieldKey,
    required String title,
    required String value,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Obx(() {
      final isEditing = controller.editingField.value == fieldKey;

      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: isEditing
                  ? TextField(
                      autofocus: true,
                      keyboardType: keyboard,
                      controller: TextEditingController(text: value),
                      onChanged: (v) => controller.tempValue.value = v,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    )
                  : Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
            ),

            SizedBox(width: 12),

            if (!isEditing)
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(width: 10),

            GestureDetector(
              onTap: () => isEditing
                  ? controller.saveEdit(fieldKey)
                  : controller.startEdit(fieldKey, value),
              child: Icon(
                isEditing ? Icons.check : Icons.edit,
                color: AppColors.primary2,
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    return iso.split("T").first;
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.inputBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout", style: TextStyle(fontWeight: FontWeight.w600)),
        content: Text("Are you sure you want to logout from your account?"),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text("Cancel", style: TextStyle(color: AppColors.primary2)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary2,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
