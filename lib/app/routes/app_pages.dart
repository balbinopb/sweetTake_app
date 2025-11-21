import 'package:get/get.dart';

import '../modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import '../modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
import '../modules/consumption_form/bindings/consumption_form_binding.dart';
import '../modules/consumption_form/views/consumption_form_view.dart';
import '../modules/graph/bindings/graph_binding.dart';
import '../modules/graph/views/graph_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onborading/bindings/onborading_binding.dart';
import '../modules/onborading/views/onborading_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register/views/register_view2.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
      name: _Paths.REGISTER2,
      page: () => RegisterView2(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GRAPH,
      page: () => const GraphView(),
      binding: GraphBinding(),
    ),
    GetPage(
      name: _Paths.CONSUMPTION_FORM,
      page: () => const ConsumptionFormView(),
      binding: ConsumptionFormBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV_BAR,
      page: () => const BottomNavBarView(),
      binding: BottomNavBarBinding(),
    ),
  ];
}