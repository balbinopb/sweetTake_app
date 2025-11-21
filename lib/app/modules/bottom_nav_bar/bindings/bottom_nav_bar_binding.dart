import 'package:get/get.dart';
import 'package:sweettake_app/app/modules/blood/controllers/blood_controller.dart';
import 'package:sweettake_app/app/modules/graph/controllers/graph_controller.dart';
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
    Get.lazyPut<BloodController>(
      () => BloodController(),
    );
    Get.lazyPut<GraphController>(
      () => GraphController(),
    );
  }
}
