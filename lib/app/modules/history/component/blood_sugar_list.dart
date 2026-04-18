import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/modules/history/component/show_blood_sugar_dialog.dart';

import '../../../constants/app_colors.dart';
import '../../../data/models/history_bloodsugar_model.dart';
import '../controllers/history_controller.dart';
import 'empty_state.dart';
import 'history_card.dart';
import 'total_card.dart';

class BloodSugarList extends StatelessWidget {
  final List<HistoryBloodsugarModel> items;

  const BloodSugarList({super.key, required this.items});

  String _time(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  // Widget _deleteBg() {
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     padding: const EdgeInsets.only(right: 20),
  //     color: Colors.red.shade400,
  //     child: const Icon(Icons.delete, color: Colors.white),
  //   );
  // }

  Future<bool?> _confirmDelete(String text) {
    return Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.inputBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          text,
          style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7)),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary2),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary2,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(text: "No blood sugar data");
    }

    final total = items.fold(0.0, (s, e) => s + e.bloodSugarData);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...items.map((e) {
          return Dismissible(
            key: ValueKey(e.metricId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red.shade400,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              return await _confirmDelete("Delete this blood sugar record?");
            },
            onDismissed: (_) {
              Get.find<HistoryController>().deleteBloodSugar(e);
            },
            child: HistoryCard(
              icon: Icons.bloodtype_rounded,
              title: e.context,
              subtitle: _time(e.dateTime),
              value: "${e.bloodSugarData} mg/dL",
              onEdit: () => Get.dialog(
                ShowBloodSugarDialog(
                  controller: Get.find<HistoryController>(),
                  item: e,
                ),
              ),
            ),
          );
        }),
        TotalCard(value: "$total mg/dL"),
      ],
    );
  }
}
