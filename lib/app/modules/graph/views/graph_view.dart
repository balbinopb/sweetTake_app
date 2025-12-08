// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controllers/graph_controller.dart';

// class GraphView extends GetView<GraphController> {
//   const GraphView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const backgroundColor = Color(0xFFF7EEC8); // krem
//     const cardBrown = Color(0xFF4C462A); // coklat tua
//     const pillBrown = Color(0xFF4C462A);
//     const pillBorder = Color(0xFF4C462A);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 23),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 4),
//               // Title
//               const Text(
//                 'Sugar Trends',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'SansitaOne',
//                   letterSpacing: 0.5,
//                   color: Color(0xFF4C462A),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Weekly / Monthly toggle
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Weekly (active)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 28,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: pillBrown,
//                       borderRadius: BorderRadius.circular(999),
//                       boxShadow: const [
//                         BoxShadow(
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                           color: Colors.black26,
//                         ),
//                       ],
//                     ),
//                     child: const Text(
//                       'Weekly',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 16),

//                   // Monthly (inactive)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 28,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(999),
//                       border: Border.all(color: pillBorder, width: 2),
//                       boxShadow: const [
//                         BoxShadow(
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                           color: Colors.black12,
//                         ),
//                       ],
//                     ),
//                     child: const Text(
//                       'Monthly',
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               // Card chart
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: cardBrown,
//                   borderRadius: BorderRadius.circular(26),
//                   boxShadow: const [
//                     BoxShadow(
//                       blurRadius: 14,
//                       offset: Offset(0, 8),
//                       color: Colors.black26,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // === CHART + LABELS ===
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 170,
//                           width: double.infinity,
//                           child: CustomPaint(painter: _SugarChartPainter()),
//                         ),
//                         const SizedBox(height: 8),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _ChartLabel('Sun'),
//                             _ChartLabel('Mon'),
//                             _ChartLabel('Tue'),
//                             _ChartLabel('Wed'),
//                             _ChartLabel('Thu'),
//                             _ChartLabel('Fri'),
//                             _ChartLabel('Sat'),
//                           ],
//                         ),

//                         // memberi ruang untuk recommendation card
//                         const SizedBox(height: 100),
//                       ],
//                     ),

//                     // === RECOMMENDATION CARD (floating) ===
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(26),
//                           boxShadow: const [
//                             BoxShadow(
//                               blurRadius: 14,
//                               offset: Offset(0, 8),
//                               color: Colors.black38,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.warning_amber_rounded,
//                               color: Color(0xFFF7EEC8),
//                               size: 26,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: const [
//                                   Text(
//                                     'Recommendation',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       decoration: TextDecoration.underline,
//                                       decorationColor: Colors.yellow,
//                                       color: Color(0xFFF7EEC8),
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     'Avoid sugary drinks in the evening to reduce spikes.',
//                                     style: TextStyle(
//                                       color: Color(0xFFF7EEC8),
//                                       fontSize: 13,
//                                       height: 1.3,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 18),

//               const SizedBox(height: 32),

//               // Summary card (putih)
//               Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 18,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(26),
//                   boxShadow: const [
//                     BoxShadow(
//                       blurRadius: 10,
//                       offset: Offset(0, 6),
//                       color: cardBrown,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Summary',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         decoration: TextDecoration.underline,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     _SummaryRow(label: 'Total', value: '168g'),
//                     _SummaryRow(label: 'Average', value: '24g/day'),
//                     _SummaryRow(label: 'Highest', value: '38g'),
//                     _SummaryRow(label: 'Trend', value: 'UP +12%'),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),

//       // Bottom navigation (custom)
//     );
//   }
// }

// /// Label kecil di bawah chart
// class _ChartLabel extends StatelessWidget {
//   final String text;
//   const _ChartLabel(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: const TextStyle(color: Color(0xFFE8DFC5), fontSize: 11),
//     );
//   }
// }

// /// Row untuk item summary
// class _SummaryRow extends StatelessWidget {
//   final String label;
//   final String value;

//   const _SummaryRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     final isBold =
//         label == 'Total' ||
//         label == 'Average' ||
//         label == 'Highest' ||
//         label == 'Trend';

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           Text('• $label: ', style: const TextStyle(fontSize: 14)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Icon di bottom nav
// // ignore: unused_element
// class _BottomIcon extends StatelessWidget {
//   final IconData icon;
//   final bool active;
//   const _BottomIcon({required this.icon, required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return Icon(
//       icon,
//       size: 30,
//       color: active ? const Color(0xFF8B6A3A) : Colors.black87,
//     );
//   }
// }

// /// Painter sederhana untuk chart (garis grid + 1 garis tren)
// class _SugarChartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final gridPaint = Paint()
//       ..color = const Color(0xFFE8DFC5)
//       ..strokeWidth = 1;

//     final axisPaint = Paint()
//       ..color = const Color(0xFFF6F0DC)
//       ..strokeWidth = 2;

//     final linePaint = Paint()
//       ..color = const Color(0xFFF6F0DC)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     // draw horizontal grid lines
//     const gridCount = 4;
//     final stepY = size.height / (gridCount + 1);
//     for (int i = 1; i <= gridCount + 1; i++) {
//       final y = stepY * i;
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
//     }

//     // axes
//     canvas.drawLine(
//       Offset(0, stepY * 0.5),
//       Offset(0, size.height - stepY * 0.3),
//       axisPaint,
//     );
//     canvas.drawLine(
//       Offset(0, size.height - stepY * 0.3),
//       Offset(size.width, size.height - stepY * 0.3),
//       axisPaint,
//     );

//     // simple hard-coded trend line (dummy)
//     final points = <Offset>[
//       Offset(size.width * 0.05, size.height * 0.6),
//       Offset(size.width * 0.18, size.height * 0.25),
//       Offset(size.width * 0.32, size.height * 0.35),
//       Offset(size.width * 0.46, size.height * 0.65),
//       Offset(size.width * 0.60, size.height * 0.45),
//       Offset(size.width * 0.76, size.height * 0.40),
//       Offset(size.width * 0.92, size.height * 0.48),
//     ];

//     final path = Path()..moveTo(points.first.dx, points.first.dy);
//     for (int i = 1; i < points.length; i++) {
//       path.lineTo(points[i].dx, points[i].dy);
//     }
//     canvas.drawPath(path, linePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }



// // updated
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controllers/graph_controller.dart';
// import '../models/chart_points.dart';
// import '../widgets/daily_intake_line_chart.dart';
// import '../widgets/weekly_line_chart.dart';
// import '../widgets/monthly_line_chart.dart';

// class GraphView extends GetView<GraphController> {
//   const GraphView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Consumption Charts')),
//       body: Obx(() {
//         if (controller.loading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.error.value != null) {
//           return Center(child: Text('Error: ${controller.error.value}'));
//         }

//         // Parse based on current state
//         final dailyPoints = parseDaily(controller.dailyJson);
//         final weeklyPoints = parseWeekly(controller.weeklyJson);
//         final monthlyPoints = parseMonthly(controller.monthlyJson);

//         Widget chart;
//         switch (controller.granularity.value) {
//           case ChartGranularity.daily:
//             chart = DailyIntakeLineChart(points: dailyPoints);
//             break;
//           case ChartGranularity.weekly:
//             chart = Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CupertinoSlidingSegmentedControl<WeeklySeries>(
//                   groupValue: controller.weeklySeries.value,
//                   thumbColor: CupertinoColors.systemBlue,
//                   children: const {
//                     WeeklySeries.totalSugar: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Total (g/week)'),
//                     ),
//                     WeeklySeries.avgPerDay: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Avg (g/day)'),
//                     ),
//                   },
//                   onValueChanged: (val) {
//                     if (val != null) controller.weeklySeries.value = val;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 WeeklyLineChart(
//                   points: weeklyPoints,
//                   series: controller.weeklySeries.value,
//                 ),
//               ],
//             );
//             break;
//           case ChartGranularity.monthly:
//             chart = Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CupertinoSlidingSegmentedControl<MonthlySeries>(
//                   groupValue: controller.monthlySeries.value,
//                   thumbColor: CupertinoColors.systemGreen,
//                   children: const {
//                     MonthlySeries.totalSugar: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Total (g/month)'),
//                     ),
//                     MonthlySeries.avgPerDay: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Avg (g/day)'),
//                     ),
//                   },
//                   onValueChanged: (val) {
//                     if (val != null) controller.monthlySeries.value = val;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 MonthlyLineChart(
//                   points: monthlyPoints,
//                   series: controller.monthlySeries.value,
//                 ),
//               ],
//             );
//             break;
//         }

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               CupertinoSlidingSegmentedControl<ChartGranularity>(
//                 groupValue: controller.granularity.value,
//                 thumbColor: CupertinoColors.systemOrange,
//                 children: const {
//                   ChartGranularity.daily: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('Daily'),
//                   ),
//                   ChartGranularity.weekly: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('Weekly'),
//                   ),
//                   ChartGranularity.monthly: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('Monthly'),
//                   ),
//                 },
//                 onValueChanged: (val) {
//                   if (val != null) controller.granularity.value = val;
//                 },
//               ),
//               const SizedBox(height: 16),
//               Expanded(child: SingleChildScrollView(child: chart)),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
