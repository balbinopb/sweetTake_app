import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/history_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4C462A),
      body: SafeArea(
        child: Column(
          children: [

            // =========header====================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Consumption History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SansitaOne',
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),


                  SizedBox(height: 16),

                  // DATE PICKER PILL
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          controller.setDate(picked);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF7D6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: Colors.brown,
                            ),
                            SizedBox(width: 10),
                            Obx(
                              () => Text(
                                controller.dateText.value,
                                style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, color: Colors.brown),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // =========body====================
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFF7D6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      SizedBox(height: 12),

                      /// Tabs
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4C462A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // Sugar Consumption tab
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.selectTab(0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: controller.selectedTab.value == 0
                                          ? Colors.white
                                          : Color(0xFF4C462A),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sugar Consumption',
                                      style: TextStyle(
                                        color: controller.selectedTab.value == 0
                                            ? Color(0xFF4C462A)
                                            : Colors.white,
                                        fontWeight:
                                            controller.selectedTab.value == 0
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Blood Sugar tab
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.selectTab(1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: controller.selectedTab.value == 1
                                          ? Colors.white
                                          : Color(0xFF4C462A),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Blood Sugar',
                                      style: TextStyle(
                                        color: controller.selectedTab.value == 1
                                            ? Color(0xFF4C462A)
                                            : Colors.white,
                                        fontWeight:
                                            controller.selectedTab.value == 1
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      Divider(
                        height: 1,
                        thickness: 0.7,
                        color: Color(0xFFE0C69B),
                      ),

                      // switch tab
                      Expanded(
                        child: controller.selectedTab.value == 0
                            ? _SugarList(items: controller.sugarItems)
                            : _BloodSugarList(), // <- switch here
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sugar Consumption list
class _SugarList extends StatelessWidget {
  final List<HistoryModel> items;

  const _SugarList({required this.items});

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double total = items.fold(0, (sum, item) => sum + item.sugarData);

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No sugar consumption data',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: [
        ...items.map(
          (item) => _SugarItem(
            time: _formatTime(item.dateTime),
            title: item.type,
            amount: '${item.sugarData.toStringAsFixed(1)}g',
          ),
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 0.7, color: Color(0xFFE0C69B)),
        const SizedBox(height: 8),
        _TotalRow(totalText: '${total.toStringAsFixed(1)}g'),
      ],
    );
  }
}

/// Blood Sugar list
class _BloodSugarList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      children: [
        _BloodItem(time: '14:35', label: 'Post-Meal', value: '118 mg/dL'),
        SizedBox(height: 12),
        Divider(thickness: 0.7, color: Color(0xFFE0C69B)),
        SizedBox(height: 8),
        _TotalRow(totalText: '118 mg/dL'),
      ],
    );
  }
}

class _SugarItem extends StatelessWidget {
  final String time;
  final String title;
  final String amount;

  const _SugarItem({
    required this.time,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF4E3A26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fastfood_rounded, size: 20, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.brown,
                    ),
                    SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Icon(Icons.edit, size: 16, color: Colors.brown),
            ],
          ),
        ],
      ),
    );
  }
}

/// Blood Item (for Blood Sugar tab)
class _BloodItem extends StatelessWidget {
  final String time;
  final String label;
  final String value;

  const _BloodItem({
    required this.time,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Blood drop icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF4E3A26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bloodtype_rounded, size: 20, color: Colors.white),
          ),
          SizedBox(width: 10),

          // Time + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.brown,
                    ),
                    SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Value + edit icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Icon(Icons.edit, size: 16, color: Colors.brown),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String totalText;

  const _TotalRow({required this.totalText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.brown,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: 'Total:   '),
            TextSpan(
              text: totalText,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
