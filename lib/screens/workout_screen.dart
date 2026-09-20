import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/shared_widgets.dart';
import 'workout_completed_screen.dart';

const Map<String, IconData> _muscleIcons = {
  'Chest': Icons.fitness_center_rounded,
  'Back': Icons.accessibility_new_rounded,
  'Legs': Icons.directions_walk_rounded,
  'Shoulders': Icons.sports_gymnastics_rounded,
  'Arms': Icons.sports_martial_arts_rounded,
  'Full Body': Icons.self_improvement_rounded,
  'Cardio': Icons.directions_run_rounded,
  'Rest Day': Icons.bedtime_rounded,
};

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String? _selectedGroup;
  int _duration = 60;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final app = context.read<AppProvider>();
    final existing = app.todayWorkout;
    if (existing != null) {
      _selectedGroup = existing.muscleGroup;
      _duration = existing.durationMinutes;
      _notesCtrl.text = existing.notes;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text('Move Today For A Stronger Tomorrow',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
              children: kMuscleGroups.map((group) {
                final selected = _selectedGroup == group;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _selectedGroup = group),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.green
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_muscleIcons[group],
                            color: selected ? Colors.black : AppColors.textLight,
                            size: 22),
                        const SizedBox(height: 6),
                        Text(group,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.black
                                    : AppColors.textLight)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            sectionTitle('Duration'),
            AppCard(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _duration,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  items: kWorkoutDurations
                      .map((d) => DropdownMenuItem(
                          value: d, child: Text('$d minutes')))
                      .toList(),
                  onChanged: (v) => setState(() => _duration = v ?? _duration),
                ),
              ),
            ),
            const SizedBox(height: 18),
            sectionTitle('Notes (optional)'),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'How was your workout?'),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: _selectedGroup == null
                  ? null
                  : () async {
                      await app.markWorkoutDone(
                        muscleGroup: _selectedGroup!,
                        durationMinutes: _duration,
                        notes: _notesCtrl.text.trim(),
                      );
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const WorkoutCompletedScreen()),
                        );
                      }
                    },
              icon: const Icon(Icons.check_rounded),
              label: const Text('Mark Workout Done'),
            ),
            if (app.isTodayWorkoutDone) ...[
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "You've already logged a workout today — saving again will update it.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
