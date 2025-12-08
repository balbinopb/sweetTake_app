// lib/screens/consumption_charts_loader_screen.dart
import 'package:flutter/material.dart';
import '../services/charts_api.dart';
import 'consumption_charts_toggle_screen.dart';

class ConsumptionChartsLoaderScreen extends StatelessWidget {
  final String dailyUrl;
  final String weeklyUrl;
  final String monthlyUrl;

  const ConsumptionChartsLoaderScreen({
    super.key,
    required this.dailyUrl,
    required this.weeklyUrl,
    required this.monthlyUrl,
  });

  Future<(List<dynamic>, List<dynamic>, List<dynamic>)> _loadAll() async {
    final daily = await fetchDataPointsArray(dailyUrl);
    final weekly = await fetchDataPointsArray(weeklyUrl);
    final monthly = await fetchDataPointsArray(monthlyUrl);
    return (daily, weekly, monthly);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(List<dynamic>, List<dynamic>, List<dynamic>)>(
      future: _loadAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final (daily, weekly, monthly) = snapshot.requireData;
        return ConsumptionChartsToggleScreen(
          dailyJson: daily,
          weeklyJson: weekly,
          monthlyJson: monthly,
        );
      },
    );
  }
}
