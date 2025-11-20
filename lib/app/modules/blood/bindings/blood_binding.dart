import 'package:get/get.dart';

import '../controllers/blood_controller.dart';

class BloodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BloodController>(
      () => BloodController(),
    );
  }
}
