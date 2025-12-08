import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chart_points.dart';
import '../models/granularity.dart';
import '../widgets/daily_intake_line_chart.dart';
import '../widgets/weekly_line_chart.dart';
import '../widgets/monthly_line_chart.dart';

class ConsumptionChartsToggleScreen extends StatefulWidget {
  final List<dynamic> dailyJson;
  final List<dynamic> weeklyJson;
  final List<dynamic> monthlyJson;

  const ConsumptionChartsToggleScreen({
    super.key,
    required this.dailyJson,
    required this.weeklyJson,
    required this.monthlyJson,
  });

  @override
  State<ConsumptionChartsToggleScreen> createState() =>
      _ConsumptionChartsToggleScreenState();
}

class _ConsumptionChartsToggleScreenState
    extends State<ConsumptionChartsToggleScreen> {
  ChartGranularity _granularity = ChartGranularity.daily;
  WeeklySeries _weeklySeries = WeeklySeries.avgPerDay;
  MonthlySeries _monthlySeries = MonthlySeries.avgPerDay;

  @override
  Widget build(BuildContext context) {
    final dailyPoints = parseDaily(widget.dailyJson);
    final weeklyPoints = parseWeekly(widget.weeklyJson);
    final monthlyPoints = parseMonthly(widget.monthlyJson);

    Widget chart;
    switch (_granularity) {
      case ChartGranularity.daily:
        chart = DailyIntakeLineChart(points: dailyPoints);
        break;
      case ChartGranularity.weekly:
        chart = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoSlidingSegmentedControl<WeeklySeries>(
              groupValue: _weeklySeries,
              thumbColor: CupertinoColors.systemBlue,
              children: const {
                WeeklySeries.totalSugar: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Total (g/week)'),
                ),
                WeeklySeries.avgPerDay: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Avg (g/day)'),
                ),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _weeklySeries = val);
              },
            ),
            const SizedBox(height: 12),
            WeeklyLineChart(points: weeklyPoints, series: _weeklySeries),
          ],
        );
        break;
      case ChartGranularity.monthly:
        chart = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoSlidingSegmentedControl<MonthlySeries>(
              groupValue: _monthlySeries,
              thumbColor: CupertinoColors.systemGreen,
              children: const {
                MonthlySeries.totalSugar: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Total (g/month)'),
                ),
                MonthlySeries.avgPerDay: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Avg (g/day)'),
                ),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _monthlySeries = val);
              },
            ),
            const SizedBox(height: 12),
            MonthlyLineChart(points: monthlyPoints, series: _monthlySeries),
          ],
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Consumption Charts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CupertinoSlidingSegmentedControl<ChartGranularity>(
              groupValue: _granularity,
              thumbColor: CupertinoColors.systemOrange,
              children: const {
                ChartGranularity.daily: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Daily'),
                ),
                ChartGranularity.weekly: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Weekly'),
                ),
                ChartGranularity.monthly: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Monthly'),
                ),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _granularity = val);
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: chart)),
          ],
        ),
      ),
    );
  }
}
