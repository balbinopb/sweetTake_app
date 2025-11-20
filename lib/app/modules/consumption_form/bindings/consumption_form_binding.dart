import 'package:get/get.dart';

import '../controllers/consumption_form_controller.dart';

class ConsumptionFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsumptionFormController>(() => ConsumptionFormController());
  }
}
