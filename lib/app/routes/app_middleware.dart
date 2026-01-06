import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sweettake_app/app/constants/storage_keys.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

import '../modules/login/controllers/auth_controller.dart';

class AppMiddleware extends GetMiddleware {
  final auth = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    final hasSeenOnboarding =
        GetStorage().read(StorageKeys.hasSeenOnboarding) ?? false;

    // First time user -> onboarding
    if (!hasSeenOnboarding && route != Routes.ONBOARDING) {
      return const RouteSettings(name: Routes.ONBOARDING);
    }

    // Not logged in -> login
    if (!auth.isLoggedIn &&
        route != Routes.LOGIN &&
        route != Routes.ONBOARDING) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Logged in but trying to open login
    if (auth.isLoggedIn && route == Routes.LOGIN) {
      return const RouteSettings(name: Routes.BOTTOM_NAV_BAR);
    }

    return null;
  }
}
