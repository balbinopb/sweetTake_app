import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/modules/blood_sugar/views/blood_sugar_view.dart';
import 'package:sweettake_app/app/modules/consumption_form/views/consumption_form_view.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedIndex.value],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          width: double.infinity,
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
            children: List.generate(controller.icons.length, (index) {
              bool isSelected = controller.selectedIndex.value == index;

              return GestureDetector(
                onTap: () {
                  if (index == 2) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const ConsumptionFormView(),
                    );
                  } else if (index == 3) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const BloodSugarView(),
                    );
                  } else {
                    // convert icon index → screen index
                    int screenIndex = index > 3 ? index - 2 : index;
                    controller.selectedIndex.value = screenIndex;
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Iconify(
                      controller.icons[index],
                      size: 28,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),

                    const SizedBox(height: 6),

                    if (isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
