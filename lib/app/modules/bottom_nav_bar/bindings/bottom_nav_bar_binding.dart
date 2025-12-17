import 'package:get/get.dart';
import 'package:sweettake_app/app/modules/blood_sugar/controllers/blood_sugar_controller.dart';
import 'package:sweettake_app/app/modules/consumption_form/controllers/consumption_form_controller.dart';
import 'package:sweettake_app/app/modules/graph/controllers/graph_controller.dart';
import 'package:sweettake_app/app/modules/history/controllers/history_controller.dart';
import 'package:sweettake_app/app/modules/home/controllers/home_controller.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<GraphController>(
      () => GraphController(),
    );
    Get.lazyPut<ConsumptionFormController>(
      () => ConsumptionFormController(),
    );
    Get.lazyPut<BloodSugarController>(
      () => BloodSugarController(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
  }
}
