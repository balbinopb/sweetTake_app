import 'package:get/get.dart';

import '../controllers/blood_sugar_controller.dart';

class BloodSugarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BloodSugarController>(
      () => BloodSugarController(),
    );
  }
}

