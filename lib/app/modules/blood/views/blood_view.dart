import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blood_controller.dart';

class BloodView extends GetView<BloodController> {
  const BloodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7D6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Blood Sugar",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'SansitaOne',
            letterSpacing: 0.5,
            color: Color(0xFF4A3F24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(),
            const SizedBox(height: 25),

            // DATE + TIME
            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                const SizedBox(width: 14),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),

            const SizedBox(height: 20),

            _buildLabel("Blood Sugar (mg/dL)"),
            _buildTextField(controller.sugarC, "e.g., 117"),
            const SizedBox(height: 20),

            _buildLabel("Context"),
            _buildContextDropdown(),
            const SizedBox(height: 35),

            // SUBMIT BUTTON
            Obx(() {
              return Center(
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitBloodSugar(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3F24),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // TITLE SECTION
  Widget _buildTitle() {
    return const Column(
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
          "Blood Sugar Measurement",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF4A3F24),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // LABEL
  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF4A3F24),
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  // SHARED BOX DECORATION
  BoxDecoration _inputBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFDF4C8),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFA08C6A)),
    );
  }

  // TEXT FIELD
  Widget _buildTextField(TextEditingController c, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _inputBoxDecoration(),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: const Icon(Icons.edit, color: Color(0xFF4A3F24)),
        ),
      ),
    );
  }

  // DATE PICKER
  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: _inputBoxDecoration(),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF4A3F24)),
            const SizedBox(width: 10),
            Obx(() => Text(controller.dateString.value)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  // TIME PICKER
  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: controller.selectedTime,
        );
        if (picked != null) controller.updateTime(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: _inputBoxDecoration(),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF4A3F24)),
            const SizedBox(width: 10),
            Obx(() => Text(controller.timeString.value)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  // CONTEXT DROPDOWN
  Widget _buildContextDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _inputBoxDecoration(),
        child: DropdownButton<String>(
          value: controller.selectedContext.value,
          isExpanded: true,
          underline: const SizedBox(),
          items: controller.contextList
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => controller.selectedContext.value = value!,
        ),
      ),
    );
  }
}
