import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/modules/history/component/consumption_list.dart';
import '../component/blood_sugar_list.dart';
import '../component/date_picker.dart';
import '../component/header.dart';
import '../component/soft_tab.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            const SizedBox(height: 12),
            DatePicker(),
            const SizedBox(height: 16),
            SoftTabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  CircularProgressIndicator();
                }
                return controller.selectedTab.value == 0
                    ? ConsumptionList(
                        items: controller.sugarItems,
                        controller: controller,
                      )
                    : BloodSugarList(items: controller.bloodItems);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
