import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: Color(0xFF4A3F24)),
              ),
            ),
            Text(
              'LOAD YOUR SWEETS INTAKE!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF4C462A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Blood Sugar Measurement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: Color(0xFF4C462A),
              ),
            ),
            SizedBox(height: 16),

            // DATE + TIME
            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                SizedBox(width: 10),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),
            SizedBox(height: 14),

            // BLOOD SUGAR FIELD
            _buildBloodSugarField(),
            SizedBox(height: 14),

            // CONTEXT DROPDOWN
            _buildContextDropdown(),
            SizedBox(height: 20),

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
                onPressed: controller.submitBloodSugarForm,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFFDF4C8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFA08C6A)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Color(0xFF4A3F24)),
          SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => Text(
                controller.dateString.value,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A3F24)),
        ],
      ),
    ),
  );

  Widget _buildTimePicker(BuildContext context) => GestureDetector(
    onTap: () async {
      final picked = await showTimePicker(
        context: context,
        initialTime: controller.selectedTime,
      );
      if (picked != null) controller.updateTime(picked);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFFDF4C8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFA08C6A)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Color(0xFF4A3F24)),
          SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => Text(
                controller.timeString.value,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A3F24)),
        ],
      ),
    ),
  );

  // 🔹 BLOOD SUGAR FIELD
  Widget _buildBloodSugarField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Sugar (mg/dL)',
          style: TextStyle(fontSize: 11, color: Color(0xFF4C462A)),
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFFFDF5DD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF4C462A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.bloodSugarC,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '117',
                    isCollapsed: true,
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
                ),
              ),
              Icon(Icons.edit, size: 18, color: Color(0xFF4C462A)),
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
        Text(
          'Context',
          style: TextStyle(fontSize: 11, color: Color(0xFF4C462A)),
        ),
        SizedBox(height: 4),
        Obx(
          () => DropdownButtonFormField<String>(
            initialValue: controller.selectedContext.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFFDF5DD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4C462A)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF4C462A)),
            items: controller.contextList
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      style: TextStyle(fontSize: 14, color: Color(0xFF4C462A)),
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
