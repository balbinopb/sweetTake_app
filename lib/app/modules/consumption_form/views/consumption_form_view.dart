import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/consumption_form_controller.dart';

class ConsumptionFormView extends GetView<ConsumptionFormController> {
  const ConsumptionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sugar Consumption",
          style: TextStyle(
            color: Color(0xFF4A3F24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 25),

            //-----------------------
            // DATE & TIME ROW
            //-----------------------
            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                const SizedBox(width: 14),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),

            const SizedBox(height: 20),
            _buildLabel("Food Type"),
            _buildTextField(controller.typeC, "e.g., Milk Tea"),
            const SizedBox(height: 20),

            _buildLabel("Amount"),
            _buildAmountControl(),
            const SizedBox(height: 20),

            _buildLabel("Sugar (g)"),
            _buildTextField(controller.sugarC, "e.g., 42"),
            const SizedBox(height: 20),

            _buildLabel("Context"),
            _buildContextDropdown(),
            const SizedBox(height: 35),

            //-----------------------
            // SUBMIT BUTTON
            //-----------------------
            Obx(() {
              return Center(
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitConsumption(),
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

  //===========================
  // UI COMPONENTS
  //===========================

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
          "Sugar Consumption",
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF4A3F24),
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  BoxDecoration _inputBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFDF4C8),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFA08C6A)),
    );
  }

  //------------------------------------
  // TEXT FIELD
  //------------------------------------
  Widget _buildTextField(TextEditingController c, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _inputBoxDecoration(),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: const Icon(Icons.edit, color: Color(0xFF4A3F24)),
        ),
      ),
    );
  }

  //------------------------------------
  // DATE PICKER
  //------------------------------------
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
            Obx(
              () => Text(
                controller.dateString.value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  //------------------------------------
  // TIME PICKER
  //------------------------------------
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
            Obx(
              () => Text(
                controller.timeString.value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  //------------------------------------
  // AMOUNT COUNTER
  //------------------------------------
  Widget _buildAmountControl() {
    return Obx(
      () => Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF4A3F24),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: controller.incrementAmount,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  controller.amount.value.toString(),
                  style: const TextStyle(
                    color: Color(0xFF4A3F24),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: controller.decrementAmount,
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------------
  // CONTEXT DROPDOWN
  //------------------------------------
  Widget _buildContextDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _inputBoxDecoration(),
        child: DropdownButton<String>(
          value:
              controller.contextList.contains(controller.selectedContext.value)
              ? controller.selectedContext.value
              : controller.contextList.first,
          isExpanded: true,
          underline: const SizedBox(),
          items: controller.contextList
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => controller.selectedContext.value = value ?? "",
        ),
      ),
    );
  }
}
