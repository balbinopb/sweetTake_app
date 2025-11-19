import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/consumption_form_controller.dart';

class ConsumptionFormView extends GetView<ConsumptionFormController> {
  const ConsumptionFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConsumptionFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConsumptionFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
