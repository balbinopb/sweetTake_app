import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // static const Color primary = Color(0xFF4C462A);
  // static const Color bg = Color(0xFFF7F3E8);
  // static const Color card = Color(0xFFFFFDF8);
  // static const Color accent = Color(0xFF4C462A);
  // static const Color chartBg = Color(0xFF4C462A);

  @override
  Widget build(BuildContext context) {
    const double bottomNavHeight = 90;

    final media = MediaQuery.of(context);
    final minHeight = media.size.height - media.padding.top - bottomNavHeight;

    return Scaffold(
      backgroundColor: AppColors.softBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: RefreshIndicator(
            onRefresh: controller.refreshHome,
            color: AppColors.primary2,
            backgroundColor:AppColors.softBg,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomNavHeight / 2),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24),

                      // ================= HEADER =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // avatar
                              Container(
                                padding: EdgeInsets.all(4),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.primary2
                                      .withValues(alpha: 0.8),
                                  child: Obx(
                                    () => Text(
                                      controller.firstLetterOfName,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.greeting,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 28),

                      // ================= TITLE =================
                      Text(
                        "Sugar Consumption History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 12),

                      // ================= SEGMENT =================
                      Obx(
                        () => Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.card,
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

                      SizedBox(height: 20),

                      // ================= CHART =================
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Obx(() {
                              final points = controller.chartPoints;

                              if (points.isEmpty) {
                                return SizedBox(
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
                                        color: AppColors.softBg,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: AppColors.softBg.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                        spots: List.generate(
                                          points.length,
                                          (i) =>
                                              FlSpot(i.toDouble(), points[i]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: 12),

                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: controller.chartLabels
                                    .map((e) => Text(e, style: _axisText))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // ================= TODAY SUMMARY =================
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Today's Sugar Intake",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // ================= CONSUMPTION LIST =================
                      Obx(() {
                        final today = controller.todayConsumptions;

                        if (today.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "No sugar intake recorded today",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.primary),
                            ),
                          );
                        }

                        return Column(
                          children: today.map((e) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 14),
                              child: _consumptionCard(
                                time: e['time'],
                                title: e['title'],
                                sugar: "${e['sugar']*e['amount']}g",
                              ),
                            );
                          }).toList(),
                        );
                      }),

                      SizedBox(height: bottomNavHeight / 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  static const TextStyle _axisText = TextStyle(
    color: AppColors.softBg,
    fontSize: 12,
  );

  Widget _segment({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.primary,
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
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
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
                  Icon(Icons.access_time, size: 14, color: AppColors.card),
                  SizedBox(width: 6),
                  Text(
                    time,
                    style: TextStyle(fontSize: 14, color: AppColors.card),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.card,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.opacity, color: AppColors.card),
              SizedBox(width: 6),
              Text(
                sugar,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.card,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
