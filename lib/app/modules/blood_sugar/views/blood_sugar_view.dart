import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.softBg,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 26),

            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                SizedBox(width: 12),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),
            SizedBox(height: 22),

            _label("Blood Sugar (mg/dL)"),
            _buildBloodSugarField(),
            SizedBox(height: 22),

            _label("Context"),
            _buildContextDropdown(),
            SizedBox(height: 32),

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
        children: [
          Text(
            "Add Blood Sugar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Record your measurement",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
      IconButton(onPressed: Get.back, icon: Icon(Icons.close)),
    ],
  );

  // ================= LABEL =================
  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
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
            Icon(Icons.calendar_today_outlined, size: 18),
            SizedBox(width: 10),
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
            Icon(Icons.access_time_outlined, size: 18),
            SizedBox(width: 10),
            Expanded(child: Text(controller.timeString.value)),
          ],
        ),
      ),
    ),
  );

  Widget _pickerBox(Widget child) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );

  // ================= BLOOD SUGAR FIELD =================
  Widget _buildBloodSugarField() => Container(
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    padding: EdgeInsets.symmetric(horizontal: 14),
    child: TextField(
      controller: controller.bloodSugarC,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14),
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
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
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
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          controller.isLoading.value ? "Submitting..." : "Save Measurement",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
