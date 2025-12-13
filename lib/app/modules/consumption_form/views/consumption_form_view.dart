import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/consumption_form_controller.dart';

class ConsumptionFormView extends GetView<ConsumptionFormController> {
  const ConsumptionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Color(0xFF4A3F24)),
              ),
            ),

            _buildTitle(),
            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(child: _buildDatePicker(context)),
                const SizedBox(width: 14),
                Expanded(child: _buildTimePicker(context)),
              ],
            ),

            const SizedBox(height: 20),
            _buildLabel("Food Type"),
            _buildTextField(controller.typeC, "Milk Tea"),
            const SizedBox(height: 20),

            _buildLabel("Amount"),
            _buildAmountControl(),
            const SizedBox(height: 20),

            _buildLabel("Sugar (g)"),
            _buildTextField(controller.sugarC, "42"),
            const SizedBox(height: 20),

            _buildLabel("Context"),
            _buildContextDropdown(),
            const SizedBox(height: 35),

            Obx(
              () => Center(
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          // print("===========inisialized 1============");

                          await controller.submitConsumption();
                        },

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
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------ SAME WIDGET COMPONENTS BELOW ------
  Widget _buildTitle() => const Column(
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF4A3F24),
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
  );

  BoxDecoration _inputBoxDecoration() => BoxDecoration(
    color: const Color(0xFFFDF4C8),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Color(0xFFA08C6A)),
  );

  Widget _buildTextField(TextEditingController c, String hint) => Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: _inputBoxDecoration(),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Color(0xFF4A3F24)),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => Text(
                controller.dateString.value,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A3F24)),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: _inputBoxDecoration(),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFF4A3F24)),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => Text(
                controller.timeString.value,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A3F24)),
        ],
      ),
    ),
  );

  Widget _buildAmountControl() => Obx(
    () => Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF4A3F24),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.decrementAmount,
            icon: const Icon(Icons.remove, color: Colors.white),
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
            onPressed: controller.incrementAmount,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    ),
  );

  Widget _buildContextDropdown() => Obx(
    () => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _inputBoxDecoration(),
      child: DropdownButton<String>(
        value: controller.contextList.contains(controller.selectedContext.value)
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
