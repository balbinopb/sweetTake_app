import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/modules/blood_sugar/views/blood_sugar_view.dart';
import 'package:sweettake_app/app/modules/consumption_form/views/consumption_form_view.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({super.key});

  void _showAddEntryBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Entry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildBottomSheetItem(
              icon: Icons.fastfood,
              title: 'Sugar Consumption',
              onTap: () {
                Get.dialog(ConsumptionFormView(), barrierDismissible: true);
              },
            ),
            _buildBottomSheetItem(
              icon: Icons.bloodtype,
              title: 'Blood Sugar',
              onTap: () {
                Get.dialog(BloodSugarView(), barrierDismissible: true);
              },
            ),
          ],
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedIndex.value],
        floatingActionButton: _buildFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _showAddEntryBottomSheet,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primary, Color.fromARGB(255, 190, 200, 202)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(child: Icon(Icons.add, color: Colors.white, size: 32)),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final middleIndex = (controller.icons.length / 2).floor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xffFFFEF9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(controller.icons.length + 1, (index) {
          if (index == middleIndex) {
            return SizedBox(width: 60);
          }

          int iconIndex = index > middleIndex ? index - 1 : index;
          final isSelected = controller.selectedIndex.value == iconIndex;
          return _buildNavItem(iconIndex, isSelected);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index > 3 ? index - 2 : index;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(
            controller.icons[index],
            size: 28,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          SizedBox(height: 6),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
