import 'package:get/get.dart';

import '../controllers/bloodhistory_controller.dart';

class BloodhistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BloodhistoryController>(
      () => BloodhistoryController(),
    );
  }
}
