import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C462A), // dark brown background
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7D6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Obx(() {
                  return _ContentCard(
                    selectedTab: controller.selectedTab.value,
                    onTabSelected: controller.selectTab,
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

/// HEADER (back button + title + date selector)
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(), // use GetX navigation
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Center(
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
          const SizedBox(height: 16),

          // DATE PICKER PILL
          Center(
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: historyController.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  historyController.setDate(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7D6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: Colors.brown,
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Text(
                        historyController.dateText.value,
                        style: const TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.brown),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// MAIN CARD AREA (tabs + list + total)
class _ContentCard extends StatelessWidget {
  final int selectedTab; // 0 = sugar, 1 = blood
  final void Function(int) onTabSelected;

  const _ContentCard({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        /// Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4C462A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Sugar Consumption tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTab == 0
                            ? Colors.white
                            : const Color(0xFF4C462A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sugar Consumption',
                        style: TextStyle(
                          color: selectedTab == 0
                              ? const Color(0xFF4C462A)
                              : Colors.white,
                          fontWeight: selectedTab == 0
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
                    onTap: () => onTabSelected(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTab == 1
                            ? Colors.white
                            : const Color(0xFF4C462A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Blood Sugar',
                        style: TextStyle(
                          color: selectedTab == 1
                              ? const Color(0xFF4C462A)
                              : Colors.white,
                          fontWeight: selectedTab == 1
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

        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 0.7, color: Color(0xFFE0C69B)),

        /// Body content (switch based on tab)
        Expanded(
          child: selectedTab == 0
              ? _SugarList()
              : _BloodSugarList(), // <- switch here
        ),
      ],
    );
  }
}

/// Sugar Consumption list
class _SugarList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      children: const [
        _SugarItem(time: '08:30', title: 'Oatmeal with honey', amount: '12.5g'),
        _SugarItem(time: '12:00', title: 'Iced coffee', amount: '18g'),
        SizedBox(height: 12),
        Divider(thickness: 0.7, color: Color(0xFFE0C69B)),
        SizedBox(height: 8),
        _TotalRow(totalText: '30.5g'),
      ],
    );
  }
}

/// Blood Sugar list
class _BloodSugarList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      children: const [
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4E3A26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fastfood_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.brown,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.edit, size: 16, color: Colors.brown),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Blood drop icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4E3A26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bloodtype_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),

          // Time + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.brown,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
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
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.edit, size: 16, color: Colors.brown),
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
          style: const TextStyle(
            color: Colors.brown,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: [
            const TextSpan(text: 'Total:   '),
            TextSpan(
              text: totalText,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
