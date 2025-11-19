import 'package:get/get.dart';

import '../modules/consumption_form/bindings/consumption_form_binding.dart';
import '../modules/consumption_form/views/consumption_form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onborading/bindings/onborading_binding.dart';
import '../modules/onborading/views/onborading_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/test/bindings/test_binding.dart';
import '../modules/test/views/test_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBORADING;

  static final routes = [
    GetPage(
      name: _Paths.ONBORADING,
      page: () => OnboradingView(),
      binding: OnboradingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => const TestView(),
      binding: TestBinding(),
    ),
    GetPage(
      name: _Paths.CONSUMPTION_FORM,
      page: () => const ConsumptionFormView(),
      binding: ConsumptionFormBinding(),
    ),
  ];
}
