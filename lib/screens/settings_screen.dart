import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'edit_goals_screen.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Future<void> _editNumberDialog(
  //   BuildContext context, {
  //   required String title,
  //   required String initialValue,
  //   required String suffix,
  //   required ValueChanged<String> onSave,
  //   TextInputType keyboardType = const TextInputType.numberWithOptions(),
  // }) async {
  //   final controller = TextEditingController(text: initialValue);
  //   final result = await showDialog<String>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       backgroundColor: Theme.of(context).cardColor,
  //       title: Text(title),
  //       content: TextField(
  //         controller: controller,
  //         keyboardType: keyboardType,
  //         autofocus: true,
  //         decoration: InputDecoration(suffixText: suffix),
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, controller.text.trim()),
  //           child: const Text('Save', style: TextStyle(color: AppColors.green)),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (result != null && result.isNotEmpty) onSave(result);
  // }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    void editGoals() {
      Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const EditGoalsScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFF2A2A2A),
              child: Icon(Icons.person, size: 34, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            sectionTitle('Personal Information'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    label: 'Name',
                    value: '${app.profile.name}',
                    onTap: () => editNumberDialog(
                      context,
                      title: 'Name',
                      initialValue: '${app.profile.name}',
                      suffix: ' ',
                      onSave: (v) {
                        if (v.isNotEmpty) {
                          app.updateProfile(app.profile.copyWith(name: v));
                        }
                      },
                    ),
                  ),
                  _divider(),
                  _SettingsRow(
                    label: 'Age',
                    value: '${app.profile.age}',
                    onTap: () => editNumberDialog(
                      context,
                      title: 'Age',
                      initialValue: '${app.profile.age}',
                      suffix: 'yrs',
                      onSave: (v) {
                        final val = int.tryParse(v);
                        if (val != null && val > 0) {
                          app.updateProfile(app.profile.copyWith(age: val));
                        }
                      },
                    ),
                  ),
                  _divider(),
                  _SettingsRow(
                    label: 'Height',
                    value: app.profile.heightLabel,
                    onTap: () => _showHeightDialog(context, app),
                  ),
                  _divider(),
                  _SettingsRow(
                    label: 'Weight',
                    value: app.latestWeight == null
                        ? 'Not set'
                        : '${app.latestWeight!.weightKg.toStringAsFixed(1)} kg',
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
                  _divider(),
                  _SettingsRow(
                      label: 'Protein Goal',
                      value: '${app.goals.proteinGoalG.round()} g/day',
                      onTap: editGoals
                      //  () => Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //       builder: (_) => const EditGoalsScreen()),
                      // ),
                      ),
                  _divider(),
                  _SettingsRow(
                      label: 'Water Goal',
                      value: '${app.goals.waterGoalL.toStringAsFixed(1)} L/day',
                      onTap: editGoals),
                  _divider(),
                  _SettingsRow(
                      label: 'Fitness Goal',
                      value: app.goals.fitnessGoal,
                      onTap: editGoals),
                ],
              ),
            ),
            const SizedBox(height: 22),
            sectionTitle('App Settings'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    label: 'Theme',
                    value: app.themeMode == ThemeMode.dark ? 'Dark' : 'Light',
                    icon: Icons.dark_mode_rounded,
                    onTap: () => app.toggleTheme(),
                  ),
                  _divider(),
                  _SettingsRow(
                    label: "Reset Today's Data",
                    value: '',
                    icon: Icons.restore_rounded,
                    onTap: () async {
                      final ok = await showConfirmDialog(
                        context,
                        title: "Reset Today's Data",
                        message:
                            "This deletes only today's water, food and workout entries. Continue?",
                        confirmLabel: 'Reset',
                        danger: true,
                      );
                      if (ok) await app.resetTodayData();
                    },
                  ),
                  _divider(),
                  _SettingsRow(
                    label: 'Clear All Data',
                    value: '',
                    icon: Icons.delete_forever_rounded,
                    danger: true,
                    onTap: () async {
                      final ok = await showConfirmDialog(
                        context,
                        title: 'Clear All Data',
                        message:
                            'This permanently deletes ALL your data (water, food, workouts, weight, goals, profile). This cannot be undone.',
                        confirmLabel: 'Clear Everything',
                        danger: true,
                      );
                      if (ok) {
                        await app.clearAllData();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const SplashScreen()),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            sectionTitle('About'),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco_rounded, color: AppColors.green, size: 20),
                      SizedBox(width: 8),
                      Text('FitTrack Light',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('v1.0.0',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  SizedBox(height: 8),
                  Text(
                    'A simple, fully offline app for a healthier you. All your data stays on this device.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'made with love by Raju yadav',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
      color: AppColors.divider, height: 1, indent: 16, endIndent: 16);

  Future<void> _showHeightDialog(BuildContext context, AppProvider app) async {
    int feet = app.profile.heightFeet;
    int inches = app.profile.heightInches;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text('Height'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: feet,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  items: List.generate(4, (i) => i + 3)
                      .map((f) =>
                          DropdownMenuItem(value: f, child: Text("$f ft")))
                      .toList(),
                  onChanged: (v) => setLocal(() => feet = v ?? feet),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<int>(
                  value: inches,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  items: List.generate(12, (i) => i)
                      .map((i) =>
                          DropdownMenuItem(value: i, child: Text('$i in')))
                      .toList(),
                  onChanged: (v) => setLocal(() => inches = v ?? inches),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                app.updateProfile(app.profile
                    .copyWith(heightFeet: feet, heightInches: inches));
                Navigator.pop(ctx);
              },
              child:
                  const Text('Save', style: TextStyle(color: AppColors.green)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool danger;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 18,
                  color: danger ? AppColors.danger : AppColors.textMuted),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: danger ? AppColors.danger : AppColors.textLight)),
            ),
            Text(value,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
