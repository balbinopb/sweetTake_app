import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/consumption_graph_model.dart';
import '../../../constants/api_endpoints.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/consumption_service.dart';
import '../../login/controllers/auth_controller.dart';

// ================= ENUMS =================
enum GraphPeriod { weekly, monthly }

enum RiskLevel { low, moderate, high }

// ================= CONTROLLER =================
class GraphController extends GetxController {
  final period = GraphPeriod.weekly.obs;
  final selectedRange = 'Weekly'.obs;
  final isLoading = true.obs;

  final riskLevel = RiskLevel.low.obs;
  final recommendationText = ''.obs;

  final _service = ConsumptionService();
  final _authC = Get.find<AuthController>();
  final userProfile = Rxn<ProfileModel>();

  final RxList<ConsumptionGraphModel> consumptions =
      <ConsumptionGraphModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    everAll([consumptions, userProfile], (_) {
      final profile = userProfile.value;
      if (profile == null || consumptions.isEmpty) return;

      evaluateRiskAndRecommendationUnified(
        todaySugar: todayTotalSugar,
        periodAverage: periodDailyAverage,
        dietPreference: profile.preference ?? "Balanced Diet",
        healthGoal: profile.healthGoal ?? "Reduce Daily Sugar Intake",
      );
    });

    fetchProfile();
    fetchData();
  }

  // ================= RAW → DAILY AGGREGATION =================

  /// Key = date (yyyy-mm-dd), Value = total sugar that day
  Map<DateTime, double> get dailyTotals {
    final Map<DateTime, double> map = {};

    for (final c in consumptions) {
      final day = DateTime(c.dateTime.year, c.dateTime.month, c.dateTime.day);

      map[day] = (map[day] ?? 0) + c.sugar;
    }

    return map;
  }

  // ================= SUMMARY METRICS =================

  double get todayTotalSugar {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return dailyTotals[today] ?? 0.0;
  }

  double get periodDailyAverage {
    final now = DateTime.now();
    final days = period.value == GraphPeriod.weekly
        ? 7
        : DateUtils.getDaysInMonth(now.year, now.month);

    return periodTotalSugar / days;
  }

  double get highestDailySugar {
    final entries = _currentPeriodEntries();
    if (entries.isEmpty) return 0.0;
    return entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  // ================= TREND =================

  double get previousPeriodAverage {
    final now = DateTime.now();

    final entries = dailyTotals.entries.where((e) {
      if (period.value == GraphPeriod.weekly) {
        return e.key.isAfter(now.subtract(const Duration(days: 14))) &&
            e.key.isBefore(now.subtract(const Duration(days: 7)));
      } else {
        final prevMonth = DateTime(now.year, now.month - 1);
        return e.key.year == prevMonth.year && e.key.month == prevMonth.month;
      }
    });

    if (entries.isEmpty) return 0.0;

    final total = entries.fold(0.0, (s, e) => s + e.value);
    return total / entries.length;
  }

  double get trendPercentage {
    if (previousPeriodAverage == 0) return 0.0;
    return ((periodDailyAverage - previousPeriodAverage) /
            previousPeriodAverage) *
        100;
  }

  String get trendText {
    final value = trendPercentage;
    final arrow = value >= 0 ? '▲' : '▼';
    return '$arrow ${value.abs().toStringAsFixed(1)}%';
  }

  Color get trendColor {
    if (trendPercentage > 0) return Colors.green;
    if (trendPercentage < 0) return Colors.red;
    return Colors.grey;
  }

  void fetchProfile() async {
    try {
      isLoading.value = true;

      // API fetch delay
      await Future.delayed(const Duration(seconds: 1));

      final response = await http.get(
        Uri.parse(ApiEndpoints.profile),
        headers: {
          'Authorization': "Bearer ${_authC.token.value}",
          'Content-Type': 'application/json',
        },
      );
      final Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> personalData = body['data'];

      userProfile.value = ProfileModel.fromJson(personalData);
    } catch (e) {
      Get.snackbar('error', "Failed to load profile.");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= RISK & RECOMMENDATION =================
  void evaluateRiskAndRecommendationUnified({
    required double todaySugar,
    required double periodAverage,
    required String dietPreference,
    required String healthGoal,
  }) {
    double recommended;
    double upperLimit;
    // node 1

    if (dietPreference == "Diabetic-Friendly Diet") {
      //node 2
      recommended = 20.0; //node 3
      upperLimit = 30.0; //node 4
    } else if (dietPreference == "Low Sugar Diet") {
      //node 5
      recommended = 25.0; //node 6
      upperLimit = 40.0; //node 7
    } else {
      recommended = 30.0; //node 8
      upperLimit = 50.0; //node 9
    }

    if (healthGoal == "Maintain Stable Blood Sugar") {
      //node 10
      upperLimit -= 5; //node 11
    } else if (healthGoal == "Weight Loss") {
      //node 12
      recommended -= 5; //node 13
    }
    //       node 14                         nod15
    if (todaySugar > upperLimit && periodAverage > recommended) {
      riskLevel.value = RiskLevel.high; //node 16
      recommendationText.value =
          "Your sugar intake is too high for your health plan. Reduce sugary foods and drinks."; //node 17

      //                 node 18                        node 19
    } else if (todaySugar > recommended || periodAverage > recommended) {
      riskLevel.value = RiskLevel.moderate; //node 20
      recommendationText.value =
          "Your sugar intake is slightly above your target. Try balancing your meals."; //node 21
    } else {
      riskLevel.value = RiskLevel.low; //node 22
      recommendationText.value =
          "Great job! Your sugar intake matches your health goals."; //node 23
    }

    //node 24
  }

  // ================= RANGE =================

  void updateRange(String value) {
    if (selectedRange.value == value) return;

    selectedRange.value = value;
    period.value = value == 'Weekly' ? GraphPeriod.weekly : GraphPeriod.monthly;
  }

  // ================= API =================

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchConsumptions();
      consumptions.value = data
          .map((e) => ConsumptionGraphModel.fromJson(e))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= GRAPH DATA =================

  List<FlSpot> get weeklySpots {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday % 7));

    final Map<int, List<double>> map = {};

    for (final c in consumptions) {
      if (c.dateTime.isBefore(start)) continue;
      final day = c.dateTime.weekday % 7;
      map.putIfAbsent(day, () => []);
      map[day]!.add(c.sugar);
    }

    return List.generate(7, (i) {
      final list = map[i] ?? [];
      final avg = list.isEmpty
          ? 0.0
          : list.reduce((a, b) => a + b) / list.length;
      return FlSpot(i.toDouble(), avg);
    });
  }

  List<FlSpot> get monthlySpots {
    final now = DateTime.now();
    final Map<int, List<double>> weeks = {};

    for (final c in consumptions) {
      if (c.dateTime.year != now.year || c.dateTime.month != now.month) {
        continue;
      }

      final week = (c.dateTime.day - 1) ~/ 7;
      weeks.putIfAbsent(week, () => []);
      weeks[week]!.add(c.sugar);
    }

    return weeks.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return FlSpot(e.key.toDouble(), avg);
    }).toList();
  }

  List<FlSpot> get activeSpots =>
      period.value == GraphPeriod.weekly ? weeklySpots : monthlySpots;

  Iterable<MapEntry<DateTime, double>> _currentPeriodEntries() {
    final now = DateTime.now();

    if (period.value == GraphPeriod.weekly) {
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));

      return dailyTotals.entries.where((e) => !e.key.isBefore(start));
    } else {
      return dailyTotals.entries.where(
        (e) => e.key.year == now.year && e.key.month == now.month,
      );
    }
  }

  double get periodTotalSugar {
    final entries = _currentPeriodEntries();
    return entries.fold(0.0, (s, e) => s + e.value);
  }
}
