import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodSugarController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;

  final bloodSugarController = TextEditingController();
  final contextList = ['Fasting', 'Post-meal', 'Before Sleep', 'After Exercise'];
  final selectedContext = 'Post-meal'.obs;

  @override
  void onClose() {
    bloodSugarController.dispose();
    super.onClose();
  }

  

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void submit() {
    final text = bloodSugarController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter your blood sugar value');
      return;
    }

    final value = int.tryParse(text);
    if (value == null) {
      Get.snackbar('Error', 'Blood sugar must be a number');
      return;
    }

    // final data = {
    //   'date': selectedDate.value,
    //   'time': selectedTime.value,
    //   'bloodSugar': value,
    //   'context': selectedContext.value,
    // };

    Get.snackbar('Saved', 'Blood sugar measurement recorded');
  }
}
