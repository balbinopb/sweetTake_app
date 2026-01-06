import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';

import '../../../data/models/history_bloodsugar_model.dart';
import '../../../data/models/history_consumption_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  // static const Color primary = Color(0xFF4A3F24);
  // static const Color softBg = Color(0xFFF7F3E8);
  // static const Color inputBg = Color(0xFFFFFBF2);
  // static const Color border = Color(0xFFE0D7C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            const SizedBox(height: 12),
            _DatePicker(),
            const SizedBox(height: 16),
            _SoftTabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  CircularProgressIndicator();
                }
                return controller.selectedTab.value == 0
                    ? _SugarList(items: controller.sugarItems)
                    : _BloodSugarList(items: controller.bloodItems);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
                        HEADER
========================================================= */
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Spacer(),
          const Text(
            "History",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

/* =========================================================
                    DATE PICKER (SOFT)
========================================================= */
class _DatePicker extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: controller.selectedDate.value,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (picked != null) controller.setDate(picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Color(0xFFE0D7C3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  controller.dateText.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================================================
                    SOFT TAB BAR
========================================================= */
class _SoftTabBar extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _TabItem(
                label: "Sugar",
                isActive: controller.selectedTab.value == 0,
                onTap: () => controller.selectTab(0),
              ),
              _TabItem(
                label: "Blood Sugar",
                isActive: controller.selectedTab.value == 1,
                onTap: () => controller.selectTab(1),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.white : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================================================
                    SUGAR LIST
========================================================= */
class _SugarList extends StatelessWidget {
  final List<HistoryConsumptionModel> items;

  const _SugarList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyState(text: "No sugar consumption yet");
    }

    final total = items.fold(0.0, (s, e) => s + e.sugarData);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...items.map((e) {
          return Dismissible(
            key: ValueKey(e.consumptionId),
            direction: DismissDirection.endToStart,
            background: _deleteBg(),
            confirmDismiss: (_) => _confirmDelete("Delete sugar record?"),
            onDismissed: (_) {
              Get.find<HistoryController>().deleteSugar(e);
            },
            child: _HistoryCard(
              icon: Icons.fastfood_rounded,
              title: e.type,
              subtitle: _time(e.dateTime),
              value: "${e.sugarData.toStringAsFixed(1)} g",
            ),
          );
        }),
        _TotalCard(value: "${total.toStringAsFixed(1)} g"),
      ],
    );
  }
}

/* =========================================================
                BLOOD SUGAR LIST
========================================================= */
class _BloodSugarList extends StatelessWidget {
  final List<HistoryBloodsugarModel> items;

  const _BloodSugarList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyState(text: "No blood sugar data");
    }

    final total = items.fold(0.0, (s, e) => s + e.bloodSugarData);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...items.map((e) {
          return Dismissible(
            key: ValueKey(e.metricId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red.shade400,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              return await _confirmDelete("Delete this blood sugar record?");
            },
            onDismissed: (_) {
              Get.find<HistoryController>().deleteBloodSugar(e);
            },
            child: _HistoryCard(
              icon: Icons.bloodtype_rounded,
              title: e.context,
              subtitle: _time(e.dateTime),
              value: "${e.bloodSugarData} mg/dL",
            ),
          );
        }),
        _TotalCard(value: "$total mg/dL"),
      ],
    );
  }
}

/* =========================================================
                SHARED COMPONENTS
========================================================= */
class _HistoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  const _HistoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final String value;

  const _TotalCard({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "Total: $value",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(color: AppColors.primary.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

String _time(DateTime d) =>
    "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

Widget _deleteBg() {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: Colors.red.shade400,
    child: const Icon(Icons.delete, color: Colors.white),
  );
}

Future<bool?> _confirmDelete(String text) {
  return Get.dialog<bool>(
    AlertDialog(
      backgroundColor: AppColors.inputBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Delete",
        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
      content: Text(
        text,
        style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7)),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary2),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary2,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Delete", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
