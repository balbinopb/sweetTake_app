import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color primary = Color(0xFF4C462A);
  static const Color bg = Color(0xFFFFF7D6);
  static const Color card = Color(0xFFFFFDF8);
  static const Color accent = Color(0xFFFFCF71);
  static const Color chartBg = Color(0xFF4C462A);

  @override
  Widget build(BuildContext context) {
    const double bottomNavHeight = 90;

    final media = MediaQuery.of(context);
    final minHeight =
        media.size.height - media.padding.top - bottomNavHeight;

    // Measure Y-axis label width
    final yLabels = ['40', '30', '20', '10'];
    double yLabelWidth = _measureMaxLabelWidth(yLabels) + 8;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
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
                              Text("Hello,",
                                  style: TextStyle(
                                      fontSize: 14, color: primary)),
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
                      const Icon(Icons.menu, color: primary),
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
                  Obx(() => Container(
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
                              onTap: () =>
                                  controller.updateRange("Weekly"),
                            ),
                            _segment(
                              label: "Monthly",
                              active:
                                  controller.selectedRange.value == "Monthly",
                              onTap: () =>
                                  controller.updateRange("Monthly"),
                            ),
                          ],
                        ),
                      )),

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
                        SizedBox(
                          height: 180,
                          child: Row(
                            children: [
                              SizedBox(
                                width: yLabelWidth,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: yLabels
                                      .map((e) => Text(e,
                                          style: _axisStyle()))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: yLabelWidth),
                                  child: CustomPaint(
                                    painter: ChartLinePainter(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Sun", style: _axisText),
                            Text("Mon", style: _axisText),
                            Text("Tue", style: _axisText),
                            Text("Wed", style: _axisText),
                            Text("Thu", style: _axisText),
                            Text("Fri", style: _axisText),
                            Text("Sat", style: _axisText),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= TODAY SUMMARY =================
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
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
                  _consumptionCard(
                    time: "08:00",
                    title: "Milk Tea",
                    sugar: "42g",
                  ),
                  const SizedBox(height: 14),
                  _consumptionCard(
                    time: "12:00",
                    title: "Burger",
                    sugar: "25g",
                  ),

                  const SizedBox(height: bottomNavHeight / 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  static double _measureMaxLabelWidth(List<String> labels) {
    double max = 0;
    for (final s in labels) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: _axisStyle()),
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > max) max = tp.width;
    }
    return max;
  }

  static TextStyle _axisStyle() =>
      const TextStyle(color: bg, fontSize: 12);

  static const TextStyle _axisText =
      TextStyle(color: bg, fontSize: 12);

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
                  const Icon(Icons.access_time, size: 14, color: primary),
                  const SizedBox(width: 6),
                  Text(time,
                      style:
                          const TextStyle(fontSize: 14, color: primary)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.opacity, color: primary),
              const SizedBox(width: 6),
              Text(
                sugar,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// CustomPainter untuk menggambar line chart dengan dukungan customization
class ChartLinePainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxValue;
  final Color lineColor;
  final double strokeWidth;

  ChartLinePainter({
    List<double>? data,
    this.maxValue = 40.0,
    this.lineColor = Colors.white,
    this.strokeWidth = 2.2,
  }) : dataPoints = data ?? [28, 30, 20, 12, 18, 25, 22];

  @override
  void paint(Canvas canvas, Size size) {
    final double paddingLeft =
        0; // paddingLeft is 0 because we already reserved Y-label width outside
    final double w = size.width - paddingLeft;
    final double h = size.height;

    // Grid (dotted) paint
    final Paint gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Line paint (only stroke, no fill)
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round;

    // Dot paint
    final Paint dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw dotted horizontal grid
    int gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final double y = (h / gridCount) * i;
      double dashWidth = 6;
      double dashSpace = 6;
      double x = 0;
      while (x < w) {
        final double xEnd = (x + dashWidth).clamp(0, w);
        canvas.drawLine(
          Offset(paddingLeft + x, y),
          Offset(paddingLeft + xEnd, y),
          gridPaint,
        );
        x += dashWidth + dashSpace;
      }
    }

    // Map data to canvas points
    final int n = dataPoints.length;
    if (n < 2) return;
    final double spacingX = w / (n - 1);
    final List<Offset> pts = List.generate(n, (i) {
      final double x = paddingLeft + i * spacingX;
      final double y = h - (dataPoints[i] / maxValue) * h;
      return Offset(x, y);
    });

    // Build smooth path using Catmull-Rom to cubic Bezier conversion
    final Path path = Path();
    path.moveTo(pts[0].dx, pts[0].dy);

    for (int i = 0; i < pts.length - 1; i++) {
      final Offset p0 = i == 0 ? pts[i] : pts[i - 1];
      final Offset p1 = pts[i];
      final Offset p2 = pts[i + 1];
      final Offset p3 = (i + 2 < pts.length) ? pts[i + 2] : pts[i + 1];

      // Catmull–Rom to Bezier control points (practical approximation)
      final Offset c1 = p1 + (p2 - p0) * (1 / 6);
      final Offset c2 = p2 - (p3 - p1) * (1 / 6);

      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }

    // Draw the line only
    canvas.drawPath(path, linePaint);

    // Draw small dots at each point (improves readability)
    for (final p in pts) {
      canvas.drawCircle(p, 2.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ChartLinePainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
