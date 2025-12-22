import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
                    // ===== App Title (match LoginView style) =====
                    Text(
                      'sweetTake',
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'sansitaOne',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // ===== Page Header =====
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Profile',
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
                        'View and manage your personal details',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ===== Content =====
                    Obx(() {
                      // Loading
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Error
                      final err = controller.errorMessage.value;
                      if (err != null) {
                        return Center(
                          child: Text(
                            err,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      // Data
                      final data = controller.profile.value;
                      if (data == null) {
                        return const Center(child: Text('No data'));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _infoTile("Full Name", data.fullname ?? "-"),
                          _infoTile("Email", data.email),
                          _infoTile("Gender", data.gender ?? "-"),
                          _infoTile(
                            "Date of Birth",
                            _formatDate(data.dateOfBirth),
                          ),
                          _infoTile(
                            "Height",
                            data.height != null ? "${data.height} cm" : "-",
                          ),
                          _infoTile(
                            "Weight",
                            data.weight != null ? "${data.weight} kg" : "-",
                          ),
                          _infoTile("Contact Info", data.contactInfo ?? "-"),

                          const SizedBox(height: 40),

                          // ===== Edit Button (match Login button style) =====
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to Edit Profile page, e.g.:
                                // Get.toNamed(Routes.EDIT_PROFILE);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ===== Refresh Button (optional) =====
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: controller.refreshProfile,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Refresh",
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== Helpers =====

  Widget _infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    // If backend returns RFC3339 like "2006-01-02T15:04:05Z07:00",
    // you can keep it as-is or format it to YYYY-MM-DD using intl.
    // For now, keep it raw:
    return iso;
  }
}
