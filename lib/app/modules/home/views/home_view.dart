import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const double bottomNavHeight = 90;
    const int topSpacerFlex = 2;

    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final topPadding = media.padding.top;
    final minHeight = screenHeight - topPadding - bottomNavHeight;

    // Measure Y-label width dynamically
    final labelStrings = ['40', '30', '20', '10'];
    final TextStyle yLabelStyle = HomeView._yLabelStyle();
    double maxLabelWidth = 0;
    for (final s in labelStrings) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: yLabelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > maxLabelWidth) maxLabelWidth = tp.width;
    }
    final double yLabelWidth = (maxLabelWidth + 8).ceilToDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
      body: SafeArea(
        child: SingleChildScrollView(
          // beri padding bottom agar konten tidak tertutup bottom nav saat discroll
          padding: EdgeInsets.only(bottom: bottomNavHeight / 2),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Spacer di awal: ini yang mendorong seluruh isi ke bawah.
                    Spacer(flex: topSpacerFlex),

                    const SizedBox(height: 16),
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User Avatar and Greeting
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF4C462A),
                                  width: 2,
                                ),
                                color: const Color(0xFFFFFDF8),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF4C462A),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF4C462A),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Sweetie Telutizen',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF4C462A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Menu Icon
                        GestureDetector(
                          onTap: () {
                            // Menu action
                          },
                          child: Icon(
                            Icons.menu,
                            color: const Color(0xFF4C462A),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Title above chart
                    Text(
                      'Sugar Consumption History',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SansitaOne',
                        letterSpacing: 0.5,
                        color: Color(0xFF4C462A),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Segmented control (Weekly / Monthly)
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
                              isActive:
                                  controller.selectedRange.value == 'Weekly',
                              onTap: () => controller.updateRange('Weekly'),
                            ),
                            _buildSegmentButton(
                              label: 'Monthly',
                              isActive:
                                  controller.selectedRange.value == 'Monthly',
                              onTap: () => controller.updateRange('Monthly'),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 18),

                    // Chart Section
                    Container(
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
                                // Y-axis labels with fixed (measured) width so chart can mirror it on the right
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
                                // Chart area: give right padding equal to label width to make left/right symmetric
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: yLabelWidth,
                                    ),
                                    child: CustomPaint(
                                      painter: ChartLinePainter(),
                                      size: Size.infinite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // X-axis labels (Days of week)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sun', style: _xLabelStyle()),
                              Text('Mon', style: _xLabelStyle()),
                              Text('Tue', style: _xLabelStyle()),
                              Text('Wed', style: _xLabelStyle()),
                              Text('Thu', style: _xLabelStyle()),
                              Text('Fri', style: _xLabelStyle()),
                              Text('Sat', style: _xLabelStyle()),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Today's Sugar Intake Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDF8),
                        border: Border.all(
                          color: const Color(0xFF4C462A),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "Today's Sugar Intake",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF4C462A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Consumption Items
                    Column(
                      children: [
                        // Milk Tea Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCF71),
                            border: Border.all(
                              color: const Color(0xFF4C462A),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: const Color(0xFF4C462A),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '8.00',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF4C462A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Milk Tea',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: const Color(0xFF4C462A),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.opacity,
                                    color: const Color(0xFF4C462A),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '42gram',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: const Color(0xFF4C462A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Burger Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCF71),
                            border: Border.all(
                              color: const Color(0xFF4C462A),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: const Color(0xFF4C462A),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '12.00',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF4C462A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Burger',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: const Color(0xFF4C462A),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.opacity,
                                    color: const Color(0xFF4C462A),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '25gram',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: const Color(0xFF4C462A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Jika ingin ada ruang bawah ekstra sebelum bottom nav:
                    SizedBox(height: bottomNavHeight / 2),

                    // Kalau perlu, spacer akhir agar IntrinsicHeight terpenuhi —
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Styles helper
  static TextStyle _yLabelStyle() {
    return const TextStyle(
      fontSize: 12,
      color: Color(0xFFFFF7D6),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle _xLabelStyle() {
    return const TextStyle(
      fontSize: 12,
      color: Color(0xFFFFF7D6),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
    const int gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final double y = (h / gridCount) * i;
      const double dashWidth = 6;
      const double dashSpace = 6;
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
