import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7EEC8); // krem
    const cardBrown = Color(0xFF4C462A); // coklat tua

    // fixed width for Y labels so we can mirror padding on the right side
    const double yLabelWidth = 30;

    return Scaffold(
      backgroundColor: backgroundColor,
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

              // ==========================
              // Weekly / Monthly segmented control
              // ==========================
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF4C462A)),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSegmentButton(
                        label: 'Weekly',
                        isActive: controller.selectedRange.value == 'Weekly',
                        onTap: () => controller.updateRange('Weekly'),
                      ),
                      _buildSegmentButton(
                        label: 'Monthly',
                        isActive: controller.selectedRange.value == 'Monthly',
                        onTap: () => controller.updateRange('Monthly'),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 18),

              // ==========================
              // Chart Section (reacts to Weekly/Monthly)
              // ==========================
              Obx(() {
                final isWeekly = controller.selectedRange.value == 'Weekly';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C462A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Y-axis labels
                            SizedBox(
                              width: yLabelWidth,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('40', style: _yLabelStyle()),
                                  Text('30', style: _yLabelStyle()),
                                  Text('20', style: _yLabelStyle()),
                                  Text('10', style: _yLabelStyle()),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Chart area: right padding mirrors label width
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: yLabelWidth,
                                ),
                                child: CustomPaint(
                                  painter: ChartLinePainter(isWeekly: isWeekly),
                                  size: Size.infinite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // X-axis labels (days)
                      const Row(
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
                      ),

                      const SizedBox(height: 24),

                      // Floating recommendation card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
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
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFF7EEC8),
                              size: 26,
                            ),
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
                                      color: Color(0xFFF7EEC8),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Avoid sugary drinks in the evening to reduce spikes.',
                                    style: TextStyle(
                                      color: Color(0xFFF7EEC8),
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Summary card (putih)
              Container(
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
                  children: const [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    _SummaryRow(label: 'Total', value: '168g'),
                    _SummaryRow(label: 'Average', value: '24g/day'),
                    _SummaryRow(label: 'Highest', value: '38g'),
                    _SummaryRow(label: 'Trend', value: 'UP +12%'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================
  // Helpers
  // ==========================

  TextStyle _yLabelStyle() {
    return const TextStyle(color: Color(0xFFE8DFC5), fontSize: 11);
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4C462A) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF4C462A),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
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

/// Icon di bottom nav (if needed)
// ignore: unused_element
class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _BottomIcon({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30,
      color: active ? const Color(0xFF8B6A3A) : Colors.black87,
    );
  }
}

/// Painter untuk chart – beda bentuk saat Weekly vs Monthly
class ChartLinePainter extends CustomPainter {
  final bool isWeekly;

  ChartLinePainter({required this.isWeekly});

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

    // Horizontal grid lines
    const gridCount = 4;
    final stepY = size.height / (gridCount + 1);
    for (int i = 1; i <= gridCount + 1; i++) {
      final y = stepY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Axes
    canvas.drawLine(
      Offset(0, stepY * 0.5),
      Offset(0, size.height - stepY * 0.3),
      axisPaint,
    );
    canvas.drawLine(
      Offset(0, size.height - stepY * 0.3),
      Offset(size.width, size.height - stepY * 0.3),
      axisPaint,
    );

    // Data points – change shape if Monthly
    final points = isWeekly
        ? <Offset>[
            Offset(size.width * 0.05, size.height * 0.6),
            Offset(size.width * 0.18, size.height * 0.25),
            Offset(size.width * 0.32, size.height * 0.35),
            Offset(size.width * 0.46, size.height * 0.65),
            Offset(size.width * 0.60, size.height * 0.45),
            Offset(size.width * 0.76, size.height * 0.40),
            Offset(size.width * 0.92, size.height * 0.48),
          ]
        : <Offset>[
            Offset(size.width * 0.05, size.height * 0.50),
            Offset(size.width * 0.20, size.height * 0.55),
            Offset(size.width * 0.35, size.height * 0.30),
            Offset(size.width * 0.50, size.height * 0.40),
            Offset(size.width * 0.65, size.height * 0.70),
            Offset(size.width * 0.80, size.height * 0.45),
            Offset(size.width * 0.95, size.height * 0.60),
          ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant ChartLinePainter oldDelegate) {
    return oldDelegate.isWeekly != isWeekly;
  }
}
