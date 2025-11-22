import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bloodhistory_controller.dart';

class BloodhistoryView extends GetView<BloodhistoryController> {
  const BloodhistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x4C462A), // dark brown background
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF5E7), // light paper color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: const _ContentCard(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

/// HEADER (back button + title + date selector)
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE9CF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: Colors.brown,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '17-11-20',
                    style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.brown),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// MAIN CARD AREA (tabs + single blood-sugar row + total)
class _ContentCard extends StatelessWidget {
  const _ContentCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        // Tabs – styled like the blood sugar page
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFBE0B2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Left tab (highlighted)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCCB7E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Sugar Consumption',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Right tab (unselected)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Blood Sugar',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 0.7, color: Color(0xFFE0C69B)),

        // Content list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 8.0,
            ),
            children: const [
              _BloodItem(time: '14:35', label: 'Post-Meal', value: '118 mg/dL'),
              SizedBox(height: 12),
              Divider(thickness: 0.7, color: Color(0xFFE0C69B)),
              SizedBox(height: 8),
              _TotalRow(totalText: '118 mg/dL'),
            ],
          ),
        ),
      ],
    );
  }
}

/// ONE blood-sugar row
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
          // Blood-drop icon
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

/// BOTTOM NAVIGATION BAR
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF5E7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, -2),
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _NavIcon(icon: Icons.home_filled),
          _NavIcon(icon: Icons.show_chart_rounded),
          _NavIcon(icon: Icons.restaurant_rounded),
          _NavIcon(icon: Icons.water_drop_rounded),
          _NavIcon(icon: Icons.add_box_rounded),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;

  const _NavIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.brown),
    );
  }
}
