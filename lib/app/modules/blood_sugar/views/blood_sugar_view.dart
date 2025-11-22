import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({super.key});

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString().substring(2);
    return '$d-$m-$y'; // 17-11-20 style
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m'; // 14:07
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFFFFFF);
    const cardColor = Color(0xFFFFFFFF);
    const accentColor = Color(0xFF4C462A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('Blood Sugar'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,


              children: [
                const Text(
                  'LOAD YOUR SWEETS INTAKE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Blood Sugar Measurement',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                ),
                const SizedBox(height: 16),

              Row(
              crossAxisAlignment: CrossAxisAlignment.start, // ⬅️ penting biar sejajar atas
              children: [
                // ============ DATE ============
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4C462A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 144,
                      height: 48,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => controller.pickDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF5DD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4C462A)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Obx(
                            () => Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Color(0xFF4C462A)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatDate(controller.selectedDate.value),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4C462A),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    size: 22, color: Color(0xFF4C462A)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // ============ TIME ============
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4C462A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 120,
                      height: 48,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => controller.pickTime(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF5DD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4C462A)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Obx(
                            () => Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatTime(controller.selectedTime.value),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4C462A),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.access_time,
                                    size: 18, color: Color(0xFF4C462A)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
                const SizedBox(height: 8),
                // Blood sugar
                                // BLOOD SUGAR
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Blood Sugar (mg/dL)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4C462A),
                      ),
                    ),
                    const SizedBox(height: 4),

                    SizedBox(
                      width: 144,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFDF5DD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF4C462A),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [

                            // --- REMOVE ICON LEFT ---

                            // TEXTFIELD ONLY
                            Expanded(
                              child: TextField(
                                controller: controller.bloodSugarController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintText: 'e.g., 117',
                                ),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4C462A),
                                ),
                              ),
                            ),

                            // ICON RIGHT ONLY
                            const Icon(
                              Icons.edit,
                              size: 18,
                              color: Color(0xFF4C462A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),




                // Context
         // CONTEXT / POST-MEAL
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Context',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4C462A),
                  ),
                ),
                const SizedBox(height: 4),

                SizedBox(
                  width: 168,
                  height: 48,
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedContext.value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFDF5DD),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4C462A),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF4C462A),
                      ),
                      items: controller.contextList
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4C462A),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) controller.selectedContext.value = val;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


                // Submit
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: controller.submit,
                    child: const Text(
                      'Submit',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFFFDF5DD);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}



