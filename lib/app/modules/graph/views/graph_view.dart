import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7EEC8); // krem
    const cardBrown = Color(0xFF4C462A); // coklat tua
    const pillBrown = Color(0xFF4C462A);
    const pillBorder = Color(0xFF4C462A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const SizedBox(), // title kosong, judul di body
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              // Title
              const Text(
                'Sugar Trends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SansitaOne',
                  letterSpacing: 0.5,
                  color: Color(0xFF4C462A),
                ),
              ),
              const SizedBox(height: 24),

              // Weekly / Monthly toggle (reactive)
              Obx(() {
                final isWeekly =
                    controller.period.value == GraphPeriod.weekly;
                final isMonthly =
                    controller.period.value == GraphPeriod.monthly;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Weekly
                    GestureDetector(
                      onTap: () => controller.setPeriod(GraphPeriod.weekly),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isWeekly ? pillBrown : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: isWeekly
                              ? null
                              : Border.all(color: pillBorder, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        child: Text(
                          'Weekly',
                          style: TextStyle(
                            color: isWeekly ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Monthly
                    GestureDetector(
                      onTap: () => controller.setPeriod(GraphPeriod.monthly),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMonthly ? pillBrown : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: isMonthly
                              ? null
                              : Border.all(color: pillBorder, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            color: isMonthly ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // Card chart (reactive)
              Obx(() {
                final labels = controller.currentLabels;
                final values = controller.currentSugar;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: cardBrown,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 14,
                        offset: Offset(0, 8),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // === CHART + LABELS ===
                      Column(
                        children: [
                          SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: _SugarChartPainter(values: values),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: labels
                                .map((text) => _ChartLabel(text))
                                .toList(),
                          ),

                          // memberi ruang untuk recommendation card
                          const SizedBox(height: 100),
                        ],
                      ),

                      // === RECOMMENDATION CARD (floating, reactive text) ===
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 14,
                                offset: Offset(0, 8),
                                color: Colors.black38,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFF7EEC8),
                                size: 26,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Recommendation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.yellow,
                                        color: Color(0xFFF7EEC8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Obx(() {
                                      return Text(
                                        controller.recommendation.value,
                                        style: const TextStyle(
                                          color: Color(0xFFF7EEC8),
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 18),

              const SizedBox(height: 32),

              // Summary card (putih, reactive)
              Obx(() {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 6),
                        color: cardBrown,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SummaryRow(
                        label: 'Total',
                        value: '${controller.total.value.toStringAsFixed(0)}g',
                      ),
                      _SummaryRow(
                        label: 'Average',
                        value:
                            '${controller.averagePerDay.value.toStringAsFixed(0)}g/day',
                      ),
                      _SummaryRow(
                        label: 'Highest',
                        value:
                            '${controller.highest.value.toStringAsFixed(0)}g',
                      ),
                      _SummaryRow(
                        label: 'Trend',
                        value: controller.trendText.value,
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // Bottom navigation (custom) — kalau mau ditambah nanti
    );
  }
}

/// Label kecil di bawah chart
class _ChartLabel extends StatelessWidget {
  final String text;
  const _ChartLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFFE8DFC5), fontSize: 11),
    );
  }
}

/// Row untuk item summary
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isBold =
        label == 'Total' ||
        label == 'Average' ||
        label == 'Highest' ||
        label == 'Trend';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('• $label: ', style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon di bottom nav
class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _BottomIcon({required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30,
      color: active ? const Color(0xFF8B6A3A) : Colors.black87,
    );
  }
}

/// Painter untuk chart: pakai data dari controller
class _SugarChartPainter extends CustomPainter {
  final List<double> values;

  _SugarChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE8DFC5)
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = const Color(0xFFF6F0DC)
      ..strokeWidth = 2;

    final linePaint = Paint()
      ..color = const Color(0xFFF6F0DC)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // draw horizontal grid lines
    const gridCount = 4;
    final stepY = size.height / (gridCount + 1);
    for (int i = 1; i <= gridCount + 1; i++) {
      final y = stepY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // axes
    final topAxisY = stepY * 0.5;
    final bottomAxisY = size.height - stepY * 0.3;

    canvas.drawLine(
      Offset(0, topAxisY),
      Offset(0, bottomAxisY),
      axisPaint,
    );
    canvas.drawLine(
      Offset(0, bottomAxisY),
      Offset(size.width, bottomAxisY),
      axisPaint,
    );

    if (values.length < 2) return;

    // hitung min & max untuk scale
    double minVal = values.first;
    double maxVal = values.first;
    for (final v in values) {
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
    }
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);

    final usableHeight = bottomAxisY - topAxisY;

    // generate points dari data
    final points = <Offset>[];
    final n = values.length;
    for (int i = 0; i < n; i++) {
      final tX = n == 1 ? 0.5 : i / (n - 1); // 0..1
      final x = size.width * (0.05 + 0.90 * tX); // beri margin kiri/kanan

      final normalized = (values[i] - minVal) / range; // 0..1
      final y = bottomAxisY - normalized * usableHeight;

      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SugarChartPainter oldDelegate) {
    // repaint kalau data berubah
    if (oldDelegate.values.length != values.length) return true;
    for (int i = 0; i < values.length; i++) {
      if (oldDelegate.values[i] != values[i]) return true;
    }
    return false;
  }
}
