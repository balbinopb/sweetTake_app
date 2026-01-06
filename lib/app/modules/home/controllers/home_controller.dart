import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/data/models/profile_model.dart';

import '../../../constants/api_endpoints.dart';
import '../../../data/services/consumption_service.dart';
import '../../login/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final _service = ConsumptionService();
  final _authC = Get.find<AuthController>();

  final sugarHistory = <Map<String, dynamic>>[].obs;

  final profile = Rxn<ProfileModel>();

  final selectedRange = 'Weekly'.obs;

  final isLoading = false.obs;

  /// Chart points derived from sugarHistory
  final chartPoints = <double>[].obs;
  final chartLabels = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSugarHistory();
    fetchProfile();
  }

  Future<void> fetchSugarHistory() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchConsumptions();
      setSugarHistory(data);
    } finally {
      isLoading.value = false;
    }
  }

  void updateRange(String value) {
    selectedRange.value = value;
    _rebuildChart();
  }

  /// Call when API data arrives
  void setSugarHistory(List<dynamic> data) {
    final normalized = data.map<Map<String, dynamic>>((e) {
      final dateTime = DateTime.parse(e['date_time']).toLocal();

      return {
        'date': dateTime,
        'amount': (e['amount'] as num).toDouble(),
        'sugar': (e['sugar_data'] as num).toDouble(),
        'title': e['type'] ?? 'Unknown',
        'context': e['context'] ?? '',
        'time':'${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      };
    }).toList();

    sugarHistory.assignAll(normalized);
    _rebuildChart();
  }

  void _rebuildChart() {
    chartPoints.clear();
    chartLabels.clear();

    if (sugarHistory.isEmpty) return;

    if (selectedRange.value == 'Weekly') {
      _buildWeekly();
    } else {
      _buildMonthly();
    }
  }

  void _buildWeekly() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));

      final total = sugarHistory
          .where((e) {
            final d = e['date'] as DateTime;
            return d.year == day.year &&
                d.month == day.month &&
                d.day == day.day;
          })
          .fold<double>(0, (s, e) => s + (e['sugar'] as double));

      chartPoints.add(total);
      chartLabels.add(_dayLabel(day.weekday));
    }
  }

  void _buildMonthly() {
    final now = DateTime.now();
    final buckets = <int, double>{};

    for (final e in sugarHistory) {
      final d = e['date'] as DateTime;

      if (d.month == now.month && d.year == now.year) {
        final week = ((d.day - 1) / 7).floor() + 1;
        buckets[week] = (buckets[week] ?? 0) + (e['sugar'] as double);
      }
    }

    final sortedWeeks = buckets.keys.toList()..sort();
    for (final w in sortedWeeks) {
      chartPoints.add(buckets[w]!);
      chartLabels.add('W$w');
    }
  }

  String _dayLabel(int weekday) {
    const map = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    return map[weekday]!;
  }

  List<Map<String, dynamic>> get todayConsumptions {
    final now = DateTime.now();

    return sugarHistory.where((e) {
      final d = e['date'] as DateTime;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();
  }

  Future<void> refreshHome() async {
    fetchSugarHistory();
    update();
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

      profile.value = ProfileModel.fromJson(personalData);
    } catch (e) {
      Get.snackbar("Failed", "Failed to load profile.");
    } finally {
      isLoading.value = false;
    }
  }

  String get name {
    return profile.value?.fullname ?? "Sweetie Telutizen";
  }

  String get firstLetterOfName {
    return profile.value?.fullname[0] ?? "_";
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning ☀️";
    if (hour < 18) return "Good afternoon 🌤️";
    return "Good evening 🌙";
  }
}
