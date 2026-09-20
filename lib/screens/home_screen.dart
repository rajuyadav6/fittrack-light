import 'package:fittrack_light/screens/food_screen.dart';
import 'package:fittrack_light/screens/water_screen.dart';
import 'package:fittrack_light/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';
import '../widgets/shared_widgets.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final dateStr = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greetingForNow(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Let\'s stay consistent.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF2A2A2A),
                child: Icon(Icons.person, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: ListView(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Text(dateStr,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            Center(
              child: ProgressRing(
                percent: app.overallProgressPct / 100,
                size: 190,
                strokeWidth: 16,
                centerChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${app.overallProgressPct.round()}%',
                        style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight)),
                    const Text("Today's Progress",
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.blue,
                      label: 'Water',
                      value:
                          '${app.todayWaterL.toStringAsFixed(1)} L / ${app.goals.waterGoalL.toStringAsFixed(1)} L',
                      progress: app.waterProgressPct,
                      progressLabel: '${(app.waterProgressPct * 100).round()}%',
                      progressColor: AppColors.blue,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const WaterScreen()))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                      icon: Icons.restaurant_rounded,
                      iconColor: AppColors.green,
                      label: 'Protein',
                      value:
                          '${app.todayProtein.round()} g / ${app.goals.proteinGoalG.round()} g',
                      progress: app.proteinProgressPct,
                      progressLabel:
                          '${(app.proteinProgressPct * 100).round()}%',
                      progressColor: AppColors.orange,
                      onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const FoodScreen())),
                          }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                      icon: Icons.fitness_center_rounded,
                      iconColor: AppColors.orange,
                      label: 'Workout',
                      value: app.isTodayWorkoutDone ? 'Done' : 'Not Done',
                      progress: app.isTodayWorkoutDone ? 1 : 0,
                      progressLabel: app.isTodayWorkoutDone ? '100%' : '0%',
                      progressColor: AppColors.green,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const WorkoutScreen()))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.monitor_weight_rounded,
                    iconColor: AppColors.textMuted,
                    label: 'Weight',
                    value: app.latestWeight == null
                        ? '--'
                        : '${app.latestWeight!.weightKg.toStringAsFixed(1)} kg',
                    progressLabel: app.latestWeight == null
                        ? 'No entry yet'
                        : (isSameDay(
                                app.latestWeight!.timestamp, DateTime.now())
                            ? 'Today'
                            : DateFormat('d MMM')
                                .format(app.latestWeight!.timestamp)),
                    progressColor: AppColors.textMuted,
                    onTap: () => editNumberDialog(
                      context,
                      title: 'Log Weight',
                      initialValue:
                          app.latestWeight?.weightKg.toStringAsFixed(1) ?? '',
                      suffix: 'kg',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSave: (v) {
                        final val = double.tryParse(v);
                        if (val != null && val > 0) app.logWeight(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            sectionTitle('Quick Add'),
            Row(
              children: [
                _QuickAddIconChip(
                  icon: Icons.water_drop_rounded,
                  label: 'Water\n+250ml',
                  onTap: () => app.addWater(250),
                ),
                const SizedBox(width: 10),
                _QuickAddIconChip(
                  icon: Icons.egg_rounded,
                  label: 'Egg\n1 piece',
                  onTap: () => app.addFoodEntry(
                      kCommonFoods.firstWhere((f) => f.id == 'common_egg'), 1),
                ),
                const SizedBox(width: 10),
                _QuickAddIconChip(
                  icon: Icons.icecream_rounded,
                  label: 'Paneer\n50g',
                  onTap: () => app.addFoodEntry(
                      kCommonFoods.firstWhere((f) => f.id == 'common_paneer'),
                      1),
                ),
                const SizedBox(width: 10),
                _QuickAddIconChip(
                  icon: Icons.local_drink_rounded,
                  label: 'Protein\nShake',
                  onTap: () => app.addFoodEntry(
                      kCommonFoods
                          .firstWhere((f) => f.id == 'common_protein_shake'),
                      1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddIconChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAddIconChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          onTap();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added: ${label.replaceAll('\n', ' ')}'),
              duration: const Duration(milliseconds: 900),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.green, size: 22),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight)),
            ],
          ),
        ),
      ),
    );
  }
}
