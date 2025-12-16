import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/consumption_form_controller.dart';

class ConsumptionFormView extends GetView<ConsumptionFormController> {
  const ConsumptionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: Color(0xFF4A3F24)),
              ),
            ),

            Column(
              children: [
                Text(
                  "LOAD YOUR SWEETS INTAKE!",
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.8,
                    color: Color(0xFF4A3F24),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "Sugar Consumption",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF4A3F24),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 25),

            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                SizedBox(width: 14),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),

            SizedBox(height: 20),

            // food type
            Text(
              "Food Type",
              style: TextStyle(
                color: Color(0xFF4A3F24),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            _buildTextField(controller.typeC, "Milk Tea"),
            SizedBox(height: 20),

            // amount
            Text(
              "Amount",
              style: TextStyle(
                color: Color(0xFF4A3F24),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Obx(
              () => Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFF4A3F24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: controller.decrementAmount,
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          controller.amount.value.toString(),
                          style: TextStyle(
                            color: Color(0xFF4A3F24),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.incrementAmount,
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // sugar input
            Text(
              "Sugar (g)",
              style: TextStyle(
                color: Color(0xFF4A3F24),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            _buildTextField(controller.sugarC, "42"),
            SizedBox(height: 20),

            // choose context
            Text(
              "Context",
              style: TextStyle(
                color: Color(0xFF4A3F24),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            _buildContextDropdown(),

            SizedBox(height: 35),

            // submit button
            Obx(
              () => Center(
                child: ElevatedButton(
                  onPressed: () async {
                    controller.isLoading.value
                        ? null
                        : await controller.submitConsumption();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A3F24),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    controller.isLoading.value ? "Submitting..." : "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String hint) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Color(0xFFFDF4C8),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFA08C6A)),
    ),
    child: TextField(
      controller: c,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        suffixIcon: Icon(Icons.edit, color: Color(0xFF4A3F24)),
      ),
    ),
  );

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

  Widget _buildContextDropdown() => Obx(
    () => Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFDF4C8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFA08C6A)),
      ),
      child: DropdownButton<String>(
        value: controller.contextList.contains(controller.selectedContext.value)
            ? controller.selectedContext.value
            : controller.contextList.first,
        isExpanded: true,
        underline: SizedBox(),
        items: controller.contextList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) => controller.selectedContext.value = value ?? "",
      ),
    ),
  );
}