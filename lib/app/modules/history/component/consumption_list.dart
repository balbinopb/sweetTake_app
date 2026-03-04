import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/modules/history/component/show_sugar_edit.dart';

import '../../../constants/app_colors.dart';
import '../../../data/models/history_consumption_model.dart';
import '../controllers/history_controller.dart';
import 'empty_state.dart';
import 'history_card.dart';
import 'total_card.dart';

class ConsumptionList extends StatelessWidget {
  final List<HistoryConsumptionModel> items;
  final HistoryController controller;

  const ConsumptionList({
    super.key,
    required this.items,
    required this.controller,
  });

  String _time(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  Widget _deleteBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red.shade400,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

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
      return const EmptyState(text: "No sugar consumption yet");
    }

    final total = items.fold(0.0, (s, e) => s + e.sugarData);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...items.map((e) {
          return Dismissible(
            key: ValueKey(e.consumptionId),
            direction: DismissDirection.endToStart,
            background: _deleteBg(),
            confirmDismiss: (_) => _confirmDelete("Delete sugar record?"),
            onDismissed: (_) {
              controller.deleteSugar(e);
            },
            child: HistoryCard(
              icon: Icons.fastfood_rounded,
              title: e.type,
              subtitle: _time(e.dateTime),
              value: "${e.sugarData.toStringAsFixed(1)} g",
              onEdit: () => Get.dialog(
                ShowSugarEdit(controller: controller, item: e),
              ),
            ),
          );
        }),
        TotalCard(value: "${total.toStringAsFixed(1)} g"),
      ],
    );
  }
}

