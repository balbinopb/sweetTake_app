import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // colors
  static const Color primary = Color(0xFF4A3F24);
  static const Color softBg = Color(0xFFF7F3E8);
  static const Color inputBg = Color(0xFFFFFBF2);
  static const Color border = Color(0xFFE0D7C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primary));
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

        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // ===== Header =====
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, Color(0xFF776A4F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: primary.withValues(alpha: 0.2),
                        child: Text(
                          data.fullname.isNotEmpty ? data.fullname[0] : "-",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        data.fullname,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data.email,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 24),
            
                // ===== Info Section =====
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _infoTile("Gender", data.gender ?? "-"),
                      _infoTile("Date of Birth", _formatDate(data.dateOfBirth)),
                      _infoTile(
                        "Height",
                        data.height != null ? "${data.height} cm" : "-",
                      ),
                      _infoTile(
                        "Weight",
                        data.weight != null ? "${data.weight} kg" : "-",
                      ),
                      _infoTile("Contact", data.contactInfo ?? "-"),
                      _infoTile("Health Goal", data.healthGoal ?? "-"),
                      _infoTile("Preference", data.preference ?? "-"),
                    ],
                  ),
                ),
            
                SizedBox(height: 30),
            
                // ===== Buttons =====
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(48),
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
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

  // ===== Info Tile Widget =====
  Widget _infoTile(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    return iso.split("T").first;
  }
}
