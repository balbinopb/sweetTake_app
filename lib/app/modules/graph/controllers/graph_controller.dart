import 'package:get/get.dart';
import '../services/charts_api.dart';

enum ChartGranularity { daily, weekly, monthly }

enum WeeklySeries { totalSugar, avgPerDay }

enum MonthlySeries { totalSugar, avgPerDay }

class GraphController extends GetxController {
  GraphController({
    required this.dailyUrl,
    required this.weeklyUrl,
    required this.monthlyUrl,
  });

  final String dailyUrl;
  final String weeklyUrl;
  final String monthlyUrl;

  final granularity = ChartGranularity.daily.obs;
  final weeklySeries = WeeklySeries.avgPerDay.obs;
  final monthlySeries = MonthlySeries.avgPerDay.obs;

  final dailyJson = <dynamic>[].obs;
  final weeklyJson = <dynamic>[].obs;
  final monthlyJson = <dynamic>[].obs;

  final loading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    loading.value = true;
    error.value = null;
    try {
      final daily = await fetchDataPointsArray(dailyUrl);
      final weekly = await fetchDataPointsArray(weeklyUrl);
      final monthly = await fetchDataPointsArray(monthlyUrl);
      dailyJson.assignAll(daily);
      weeklyJson.assignAll(weekly);
      monthlyJson.assignAll(monthly);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}

// // import 'package:get/get.dart';

// // class GraphController extends GetxController {

// // }

// //graph/controllers/graph_controller.dart
// // import 'package:get/get.dart';

// // enum ChartGranularity { daily, weekly, monthly }

// // enum WeeklySeries { totalSugar, avgPerDay }

// // enum MonthlySeries { totalSugar, avgPerDay }

// // class GraphController extends GetxController {
// //   // URLs can be injected via binding or config
// //   GraphController({
// //     required this.dailyUrl,
// //     required this.weeklyUrl,
// //     required this.monthlyUrl,
// //   });

// //   final String dailyUrl;
// //   final String weeklyUrl;
// //   final String monthlyUrl;

// //   // UI state
// //   final granularity = ChartGranularity.daily.obs;
// //   final weeklySeries = WeeklySeries.avgPerDay.obs;
// //   final monthlySeries = MonthlySeries.avgPerDay.obs;

// //   // Data arrays (decoded JSON arrays)
// //   final dailyJson = <dynamic>[].obs;
// //   final weeklyJson = <dynamic>[].obs;
// //   final monthlyJson = <dynamic>[].obs;

// //   final loading = false.obs;
// //   final error = RxnString();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     loadAll();
// //   }

// //   Future<void> loadAll() async {
// //     loading.value = true;
// //     error.value = null;
// //     try {
// //       final daily = await fetchDataPointsArray(dailyUrl);
// //       final weekly = await fetchDataPointsArray(weeklyUrl);
// //       final monthly = await fetchDataPointsArray(monthlyUrl);
// //       dailyJson.assignAll(daily);
// //       weeklyJson.assignAll(weekly);
// //       monthlyJson.assignAll(monthly);
// //     } catch (e) {
// //       error.value = e.toString();
// //     } finally {
// //       loading.value = false;
// //     }
// //   }
// // }

// import 'package:get/get.dart';
// import '../services/charts_api.dart'; // <-- add this import

// enum ChartGranularity { daily, weekly, monthly }

// enum WeeklySeries { totalSugar, avgPerDay }

// enum MonthlySeries { totalSugar, avgPerDay }

// class GraphController extends GetxController {
//   GraphController({
//     required this.dailyUrl,
//     required this.weeklyUrl,
//     required this.monthlyUrl,
//   });

//   final String dailyUrl;
//   final String weeklyUrl;
//   final String monthlyUrl;

//   // UI state
//   final granularity = ChartGranularity.daily.obs;
//   final weeklySeries = WeeklySeries.avgPerDay.obs;
//   final monthlySeries = MonthlySeries.avgPerDay.obs;

//   // Data arrays (decoded JSON arrays)
//   final dailyJson = <dynamic>[].obs;
//   final weeklyJson = <dynamic>[].obs;
//   final monthlyJson = <dynamic>[].obs;

//   final loading = false.obs;
//   final error = RxnString();

//   @override
//   void onInit() {
//     super.onInit();
//     loadAll();
//   }

//   Future<void> loadAll() async {
//     loading.value = true;
//     error.value = null;
//     try {
//       final daily = await fetchDataPointsArray(dailyUrl);
//       final weekly = await fetchDataPointsArray(weeklyUrl);
//       final monthly = await fetchDataPointsArray(monthlyUrl);
//       dailyJson.assignAll(daily);
//       weeklyJson.assignAll(weekly);
//       monthlyJson.assignAll(monthly);
//     } catch (e) {
//       error.value = e.toString();
//     } finally {
//       loading.value = false;
//     }
//   }
// }
