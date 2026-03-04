import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../controllers/history_controller.dart';
import 'tab_item.dart';

class SoftTabBar extends GetView<HistoryController> {
  const SoftTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              TabItem(
                label: "Sugar",
                isActive: controller.selectedTab.value == 0,
                onTap: () => controller.selectTab(0),
              ),
              TabItem(
                label: "Blood Sugar",
                isActive: controller.selectedTab.value == 1,
                onTap: () => controller.selectTab(1),
              ),
            ],
          ),
        );
      }),
    );
  }
}
