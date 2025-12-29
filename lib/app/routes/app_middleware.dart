import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sweettake_app/app/constants/storage_keys.dart';
import 'package:sweettake_app/app/routes/app_pages.dart';

class AppMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final hasSeenOnboarding = box.read(StorageKeys.hasSeenOnboarding) ?? false;
    final token = box.read(StorageKeys.token);

    //first time user will direct to onboarding
    if (!hasSeenOnboarding) {
      return const RouteSettings(name: Routes.ONBOARDING);
    }

    //not logged in direct to login
    if (token == null || token.isEmpty) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    //Logged in direct to home
    return const RouteSettings(name: Routes.BOTTOM_NAV_BAR);
  }
}
