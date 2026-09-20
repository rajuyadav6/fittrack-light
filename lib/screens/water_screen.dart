import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  Future<void> _showCustomAmountDialog(BuildContext context) async {
    final controller = TextEditingController();
    final app = context.read<AppProvider>();
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Custom Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Amount in ml',
            suffixText: 'ml',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              Navigator.pop(ctx, val);
            },
            child: const Text('Add', style: TextStyle(color: AppColors.green)),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      await app.addWater(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text('Stay Hydrated, Stay Healthy',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            Center(
              child: ProgressRing(
                percent: app.waterProgressPct,
                size: 190,
                strokeWidth: 16,
                color: AppColors.blue,
                centerChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop_rounded,
                            color: AppColors.blue, size: 20),
                        const SizedBox(width: 6),
                        Text('${app.todayWaterL.toStringAsFixed(1)} L',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight)),
                      ],
                    ),
                    Text('of ${app.goals.waterGoalL.toStringAsFixed(1)} L',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('${(app.waterProgressPct * 100).round()}%',
                        style: const TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            sectionTitle('Quick Add'),
            Row(
              children: [
                QuickAddChip(label: '+250 ml', onTap: () => app.addWater(250)),
                const SizedBox(width: 10),
                QuickAddChip(label: '+500 ml', onTap: () => app.addWater(500)),
                const SizedBox(width: 10),
                QuickAddChip(label: '+1 L', onTap: () => app.addWater(1000)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCustomAmountDialog(context),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('Custom Amount'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            sectionTitle("Today's Water History"),
            if (app.todayWater.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No entries yet today',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else
              ...app.todayWater.reversed.map((entry) => AppCard(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop_rounded,
                            color: AppColors.blue, size: 18),
                        const SizedBox(width: 10),
                        Text(DateFormat('hh:mm a').format(entry.timestamp),
                            style:
                                const TextStyle(color: AppColors.textMuted)),
                        const Spacer(),
                        Text('${entry.amountMl} ml',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: AppColors.danger, size: 20),
                          onPressed: () => app.deleteWater(entry.id),
                        ),
                      ],
                    ),
                  )),
          ]
              .map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 8), child: w))
              .toList(),
        ),
      ),
    );
  }
}
