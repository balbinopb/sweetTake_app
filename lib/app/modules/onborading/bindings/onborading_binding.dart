import 'package:get/get.dart';

import '../controllers/onborading_controller.dart';

class OnboradingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboradingController>(
      () => OnboradingController(),
    );
  }
}
