import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  // static const Color bg = Color(0xFFF7EEC8);
  static const Color bg = Color(0xFFF7F3E8);
  static const Color primary = Color(0xFF4A3F24);
  static const Color softWhite = Color(0xFFFFFDF8);
  static const Color lineColor = Color(0xFFF6F0DC);
  static const Color muted = Color(0xFFE8DFC5);

  static const double yLabelWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                const SizedBox(height: 22),
                _rangeSelector(),
                const SizedBox(height: 20),
                _chartCard(),
                const SizedBox(height: 16),
                _recommendationCard(),
                const SizedBox(height: 28),
                _summaryCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============TITLE=============

  Widget _title() => const Center(
    child: Text(
      'Sugar Trends',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: 'SansitaOne',
        letterSpacing: 0.6,
        color: primary,
      ),
    ),
  );

  // ================= RANGE SELECTOR =================

  Widget _rangeSelector() => Obx(
    () => Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: softWhite,
        borderRadius: BorderRadius.circular(32),
        // border: Border.all(color: primary.withValues(alpha:0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _segment(
            'Weekly',
            controller.selectedRange.value == 'Weekly',
            () => controller.updateRange('Weekly'),
          ),
          _segment(
            'Monthly',
            controller.selectedRange.value == 'Monthly',
            () => controller.updateRange('Monthly'),
          ),
        ],
      ),
    ),
  );

  Widget _segment(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: active ? primary : softWhite,
            borderRadius: BorderRadius.circular(28),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : primary,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  // ===========CHART CARD==============

  Widget _chartCard() => Obx(() {
    if (controller.isLoading.value) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final isWeekly = controller.selectedRange.value == 'Weekly';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: .25),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chartArea(isWeekly),
          const SizedBox(height: 14),
          _xLabels(isWeekly),
        ],
      ),
    );
  });

  Widget _chartArea(bool isWeekly) => SizedBox(
    height: 190,
    child: LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: lineColor.withValues(alpha: 0.4), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            barWidth: 3,
            color: lineColor,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withValues(alpha: 0.15),
            ),
            spots: controller.activeSpots,
          ),
        ],
      ),
    ),
  );

  Widget _xLabels(bool isWeekly) {
    if (isWeekly) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ChartLabel('Sun'),
          _ChartLabel('Mon'),
          _ChartLabel('Tue'),
          _ChartLabel('Wed'),
          _ChartLabel('Thu'),
          _ChartLabel('Fri'),
          _ChartLabel('Sat'),
        ],
      );
    }

    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ChartLabel('W1'),
        _ChartLabel('W2'),
        _ChartLabel('W3'),
        _ChartLabel('W4'),
        _ChartLabel('W5'),
      ],
    );
  }

  // ==========RECOMMENDATION===============
  Widget _recommendationCard() {
    final controller = Get.find<GraphController>();

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: bg, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendation',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.yellow,
                      color: bg,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    controller.recommendationText.value,
                    style: TextStyle(color: bg, fontSize: 13, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========SUMMARY==============
  Widget _summaryCard() => Container(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          blurRadius: 16,
          offset: const Offset(0, 10),
          color: primary.withValues(alpha: .25),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _MetricTile('Total', '168 g'),
            _MetricTile('Average', '24 g/day'),
            _MetricTile('Highest', '38 g'),
            _MetricTile('Trend', '▲ 12%'),
          ],
        ),
      ],
    ),
  );
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4A3F24)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ChartLabel extends StatelessWidget {
  final String text;
  const _ChartLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: GraphView.muted, fontSize: 11),
    );
  }
}
