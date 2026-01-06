import 'package:get/get.dart';

import '../../../constants/storage_keys.dart';
import '../../../routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import '../../login/controllers/auth_controller.dart';

class InitialController extends GetxController {
  final box = GetStorage();
  final auth = Get.find<AuthController>();

  @override
  void onReady() {
    super.onReady();
    // print('===============InitialController ready============');
    _decideStartPage();
  }

  void _decideStartPage() {
    final hasSeenOnboarding =
        box.read(StorageKeys.hasSeenOnboarding) ?? false;

    if (!hasSeenOnboarding) {
      box.write(StorageKeys.hasSeenOnboarding, true);
      Get.offAllNamed(Routes.ONBOARDING);
      return;
    }

    if (!auth.isLoggedIn) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
  }
}

