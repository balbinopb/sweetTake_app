import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({super.key});

  String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
         "${date.month.toString().padLeft(2, '0')}/"
         "${date.year}";
}

String _formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Color(0xFF4A3F24)),
              ),
            ),
            const Text(
              'LOAD YOUR SWEETS INTAKE!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF4C462A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Blood Sugar Measurement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: Color(0xFF4C462A),
              ),
            ),
            const SizedBox(height: 16),

            // DATE + TIME
            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                const SizedBox(width: 10),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),
            const SizedBox(height: 14),

            // BLOOD SUGAR FIELD
            _buildBloodSugarField(),
            const SizedBox(height: 14),

            // CONTEXT DROPDOWN
            _buildContextDropdown(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: controller.submit,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 DATE PICKER
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date', style: TextStyle(fontSize: 11, color: Color(0xFF4C462A))),
        const SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.pickDate(context),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5DD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4C462A)),
            ),
            child: Obx(
              () => Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Color(0xFF4C462A)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatDate(controller.selectedDate.value),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 TIME PICKER
  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time', style: TextStyle(fontSize: 11, color: Color(0xFF4C462A))),
        const SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.pickTime(context),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5DD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4C462A)),
            ),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatTime(controller.selectedTime.value),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
                    ),
                  ),
                  const Icon(Icons.access_time, size: 18, color: Color(0xFF4C462A)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 BLOOD SUGAR FIELD
  Widget _buildBloodSugarField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blood Sugar (mg/dL)', style: TextStyle(fontSize: 11, color: Color(0xFF4C462A))),
        const SizedBox(height: 4),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF5DD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4C462A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.bloodSugarController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '117',
                    isCollapsed: true,
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
                ),
              ),
              const Icon(Icons.edit, size: 18, color: Color(0xFF4C462A)),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 CONTEXT DROPDOWN
  Widget _buildContextDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Context', style: TextStyle(fontSize: 11, color: Color(0xFF4C462A))),
        const SizedBox(height: 4),
        Obx(
          () => DropdownButtonFormField<String>(
            initialValue: controller.selectedContext.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFDF5DD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4C462A)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4C462A)),
            items: controller.contextList
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => controller.selectedContext.value = val!,
          ),
        ),
      ],
    );
  }
}
