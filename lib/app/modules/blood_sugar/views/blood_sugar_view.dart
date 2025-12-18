import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({super.key});

  static const Color primary = Color(0xFF4A3F24);
  static const Color softBg = Color(0xFFF7F3E8);
  static const Color inputBg = Color(0xFFFFFBF2);
  static const Color border = Color(0xFFE0D7C3);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: softBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),
            const SizedBox(height: 22),

            _label("Blood Sugar (mg/dL)"),
            _buildBloodSugarField(),
            const SizedBox(height: 22),

            _label("Context"),
            _buildContextDropdown(),
            const SizedBox(height: 32),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Add Blood Sugar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Record your measurement",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
      IconButton(onPressed: Get.back, icon: const Icon(Icons.close)),
    ],
  );

  // ================= LABEL =================

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),
  );

  // ================= DATE PICKER =================

  Widget _buildDatePicker(BuildContext context) => GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        initialDate: controller.selectedDate,
      );
      if (picked != null) controller.updateDate(picked);
    },
    child: _pickerBox(
      Obx(
        () => Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(controller.dateString.value)),
          ],
        ),
      ),
    ),
  );

  // ================= TIME PICKER =================

  Widget _buildTimePicker(BuildContext context) => GestureDetector(
    onTap: () async {
      final picked = await showTimePicker(
        context: context,
        initialTime: controller.selectedTime,
      );
      if (picked != null) controller.updateTime(picked);
    },
    child: _pickerBox(
      Obx(
        () => Row(
          children: [
            const Icon(Icons.access_time_outlined, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(controller.timeString.value)),
          ],
        ),
      ),
    ),
  );

  Widget _pickerBox(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border),
    ),
    child: child,
  );

  // ================= BLOOD SUGAR FIELD =================

  Widget _buildBloodSugarField() => Container(
    decoration: BoxDecoration(
      color: inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: TextField(
      controller: controller.bloodSugarC,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: "117",
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none,
      ),
    ),
  );

  // ================= DROPDOWN =================

  Widget _buildContextDropdown() => Obx(
    () => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedContext.value,
          isExpanded: true,
          items: controller.contextList
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => controller.selectedContext.value = v!,
        ),
      ),
    ),
  );

  // ================= BUTTON =================

  Widget _submitButton() => SizedBox(
    width: double.infinity,
    child: Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : controller.submitBloodSugarForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          controller.isLoading.value ? "Submitting..." : "Save Measurement",
          style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
