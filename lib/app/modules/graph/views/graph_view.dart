import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/graph_controller.dart';

class GraphView extends GetView<GraphController> {
  const GraphView({super.key});

  static const Color bg = Color(0xFFF7EEC8);
  static const Color primary = Color(0xFF4C462A);
  static const Color softWhite = Color(0xFFFFFDF8);
  static const Color lineColor = Color(0xFFF6F0DC);
  static const Color muted = Color(0xFFE8DFC5);

  static const double yLabelWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              _title(),
              const SizedBox(height: 22),

              _rangeSelector(),
              const SizedBox(height: 20),

              _chartCard(),
              const SizedBox(height: 28),

              _summaryCard(),
              const SizedBox(height: 32),
            ],
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


  // ===========RANGE SELECTOR==============

  Widget _rangeSelector() => Obx(
        () => Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: softWhite,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: primary.withValues(alpha: .6)),
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : primary,
            ),
          ),
        ),
      ),
    );
  }


  // ===========CHART CARD==============

  Widget _chartCard() => Obx(() {
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
              _xLabels(),
              const SizedBox(height: 22),
              _recommendationCard(),
            ],
          ),
        );
      });

  Widget _chartArea(bool isWeekly) => SizedBox(
        height: 190,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: yLabelWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  _YLabel('40'),
                  _YLabel('30'),
                  _YLabel('20'),
                  _YLabel('10'),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: yLabelWidth),
                child: CustomPaint(
                  painter: ChartLinePainter(isWeekly: isWeekly),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _xLabels() => const Row(
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


  // ==========RECOMMENDATION===============

  Widget _recommendationCard() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.warning_amber_rounded,
                color: bg, size: 24),
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
                    'Avoid sugary drinks in the evening to reduce spikes.',
                    style: TextStyle(
                      color: bg,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );


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
          children: const [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 12),
            _SummaryRow(label: 'Total', value: '168g'),
            _SummaryRow(label: 'Average', value: '24g/day'),
            _SummaryRow(label: 'Highest', value: '38g'),
            _SummaryRow(label: 'Trend', value: 'UP +12%'),
          ],
        ),
      );
}


/// ==========SMALL WIDGETS===============

class _YLabel extends StatelessWidget {
  final String text;
  const _YLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: GraphView.muted, fontSize: 11),
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '• $label: ',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


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
