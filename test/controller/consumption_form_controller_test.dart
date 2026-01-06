import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/modules/consumption_form/controllers/consumption_form_controller.dart';

void main() {
  late ConsumptionFormController controller;

  setUp(() {
    Get.testMode = true;
    controller = ConsumptionFormController();
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
  });

  test('incrementAmount should increase amount by 1', () {
    controller.amount.value = 1;
    controller.incrementAmount();
    expect(controller.amount.value, 2);
  });

  test('decrementAmount should not go below 1', () {
    controller.amount.value = 1;
    controller.decrementAmount();
    expect(controller.amount.value, 1);
  });

  test('updateDate should update formatted dateString', () {
    controller.updateDate(DateTime(2026, 1, 5));
    expect(controller.dateString.value, '05-01-2026');
  });

  test('updateTime should update formatted timeString', () {
    controller.updateTime(const TimeOfDay(hour: 8, minute: 30));
    expect(controller.timeString.value, '08:30');
  });

  test('clearForm should reset all values', () {
    controller.typeC.text = 'Cake';
    controller.sugarC.text = '20';
    controller.amount.value = 3;

    controller.clearForm();

    expect(controller.typeC.text, '');
    expect(controller.sugarC.text, '');
    expect(controller.amount.value, 1);
    expect(controller.selectedContext.value, 'Snack');
  });
}
