import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/zondicons.dart';
import 'package:sweettake_app/app/modules/graph/views/graph_view.dart';
import 'package:sweettake_app/app/modules/history/views/history_view.dart';
import 'package:sweettake_app/app/modules/home/views/home_view.dart';

import '../../profile/views/profile_view.dart';

class BottomNavBarController extends GetxController {
  final selectedIndex = 0.obs;

  late final List screens;

  @override
  void onInit() {
    super.onInit();
    screens = [
      HomeView(), 
      GraphView(),
      HistoryView(),
      ProfileView()
      ];
  }

  final icons = [
    MaterialSymbols.home_rounded,
    Zondicons.chart,
    Mdi.history,
    MaterialSymbols.person_filled,
  ];
}