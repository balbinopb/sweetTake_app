import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color primary = Color(0xFF4C462A);
  static const Color bg = Color(0xFFF7F3E8);
  static const Color card = Color(0xFFFFFDF8);
  // static const Color accent = Color(0xFFFFCF71);
  static const Color accent = Color(0xFF4C462A);
  static const Color chartBg = Color(0xFF4C462A);

  @override
  Widget build(BuildContext context) {
    const double bottomNavHeight = 90;

    final media = MediaQuery.of(context);
    final minHeight = media.size.height - media.padding.top - bottomNavHeight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: bottomNavHeight / 2),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // ================= HEADER =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: card,
                                border: Border.all(color: primary),
                              ),
                              child: const Icon(Icons.person, color: primary),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: primary,
                                  ),
                                ),
                                Text(
                                  "Sweetie Telutizen",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ================= TITLE =================
                    const Text(
                      "Sugar Consumption History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SEGMENT =================
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            _segment(
                              label: "Weekly",
                              active:
                                  controller.selectedRange.value == "Weekly",
                              onTap: () => controller.updateRange("Weekly"),
                            ),
                            _segment(
                              label: "Monthly",
                              active:
                                  controller.selectedRange.value == "Monthly",
                              onTap: () => controller.updateRange("Monthly"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= CHART =================
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: chartBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            final points = controller.chartPoints;

                            if (points.isEmpty) {
                              return const SizedBox(
                                height: 180,
                                child: Center(
                                  child: Text(
                                    "No data yet",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 180,
                              child: LineChart(
                                LineChartData(
                                  minY: 0,
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(show: false),

                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      barWidth: 3,
                                      color: bg,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: bg.withValues(alpha: 0.15),
                                      ),
                                      spots: List.generate(
                                        points.length,
                                        (i) => FlSpot(i.toDouble(), points[i]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 12),

                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: controller.chartLabels
                                  .map((e) => Text(e, style: _axisText))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= TODAY SUMMARY =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Today's Sugar Intake",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= CONSUMPTION LIST =================
                    Obx(() {
                      final today = controller.todayConsumptions;

                      if (today.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "No sugar intake recorded today",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primary),
                          ),
                        );
                      }

                      return Column(
                        children: today.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _consumptionCard(
                              time: e['time'], // "08:00"
                              title: e['title'], // "Milk Tea"
                              sugar: "${e['sugar']}g",
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: bottomNavHeight / 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  static const TextStyle _axisText = TextStyle(color: bg, fontSize: 12);

  Widget _segment({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _consumptionCard({
    required String time,
    required String title,
    required String sugar,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: card),
                  const SizedBox(width: 6),
                  Text(time, style: const TextStyle(fontSize: 14, color: card)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: card,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.opacity, color: card),
              const SizedBox(width: 6),
              Text(
                sugar,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: card,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
