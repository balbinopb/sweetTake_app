import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';

import '../../../data/models/history_consumption_model.dart';
import '../controllers/history_controller.dart';

class ShowSugarEdit extends StatelessWidget {
  final HistoryController controller;
  final HistoryConsumptionModel item;
  const ShowSugarEdit({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final typeController = TextEditingController(text: item.type);
    final sugarController = TextEditingController(
      text: item.sugarData.toString(),
    );
    final selectedDateTime = ValueNotifier<DateTime>(item.dateTime);

    return Dialog(
      backgroundColor: AppColors.softBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Sugar Intake",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Update what you consumed",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(context, selectedDateTime),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimePicker(context, selectedDateTime),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _label("Food Type"),
            _buildTextField(typeController, "Milk Tea"),
            const SizedBox(height: 22),
            _label("Sugar (g)"),
            _buildTextField(sugarController, "42", isNumeric: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateConsumption(
                    item,
                    sugarController.text,
                    typeController.text,
                    selectedDateTime.value,
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Update Intake",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
  }) => Container(
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: TextField(
      controller: controller,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none,
      ),
    ),
  );

  Widget _buildDatePicker(
    BuildContext context,
    ValueNotifier<DateTime> selectedDateTime,
  ) => GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        initialDate: selectedDateTime.value,
      );

      if (picked != null) {
        final current = selectedDateTime.value;
        selectedDateTime.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          current.hour,
          current.minute,
          current.second,
        );
      }
    },
    child: _pickerBox(
      ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateTime,
        builder: (_, value, __) {
          return Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${value.day.toString().padLeft(2, '0')}/'
                  '${value.month.toString().padLeft(2, '0')}/'
                  '${value.year}',
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _buildTimePicker(
    BuildContext context,
    ValueNotifier<DateTime> selectedDateTime,
  ) => GestureDetector(
    onTap: () async {
      final current = selectedDateTime.value;
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
      );

      if (picked != null) {
        selectedDateTime.value = DateTime(
          current.year,
          current.month,
          current.day,
          picked.hour,
          picked.minute,
          current.second,
        );
      }
    },
    child: _pickerBox(
      ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateTime,
        builder: (_, value, __) {
          return Row(
            children: [
              const Icon(Icons.access_time_outlined, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${value.hour.toString().padLeft(2, '0')}:'
                  '${value.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _pickerBox(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}
