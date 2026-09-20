import 'package:fittrack_light/screens/root_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/shared_widgets.dart';

class EditGoalsScreen extends StatefulWidget {
  const EditGoalsScreen({super.key});

  @override
  State<EditGoalsScreen> createState() => _EditGoalsScreenState();
}

class _EditGoalsScreenState extends State<EditGoalsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _heightFeetCtrl;
  late TextEditingController _heightInchCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _proteinCtrl;
  late TextEditingController _waterCtrl;

  late String _fitnessGoal;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppProvider>().profile;
    final goals = context.read<AppProvider>().goals;

    if (!mounted) return;

    _nameCtrl = TextEditingController(text: profile.name.toString());
    _ageCtrl = TextEditingController(text: profile.age.toString());
    _heightFeetCtrl =
        TextEditingController(text: profile.heightFeet.toString());
    _heightInchCtrl =
        TextEditingController(text: profile.heightInches.toString());
    _weightCtrl = TextEditingController(text: profile.weightKg.toString());
    _proteinCtrl =
        TextEditingController(text: goals.proteinGoalG.round().toString());
    _waterCtrl =
        TextEditingController(text: goals.waterGoalL.toStringAsFixed(1));
    _fitnessGoal = goals.fitnessGoal;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightFeetCtrl.dispose();
    _heightInchCtrl.dispose();
    _weightCtrl.dispose();
    _proteinCtrl.dispose();
    _waterCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final app = context.read<AppProvider>();

    final name = _nameCtrl.text;

    final age = int.tryParse(_ageCtrl.text) ?? app.profile.age;

    final heightFeet =
        int.tryParse(_heightFeetCtrl.text) ?? app.profile.heightFeet;

    final heightInches =
        int.tryParse(_heightInchCtrl.text) ?? app.profile.heightInches;

    final weightKg = double.tryParse(_weightCtrl.text) ?? app.profile.weightKg;

    final protein =
        double.tryParse(_proteinCtrl.text) ?? app.goals.proteinGoalG;

    final water = double.tryParse(_waterCtrl.text) ?? app.goals.waterGoalL;

    await app.updateGoals(app.goals.copyWith(
      proteinGoalG: protein,
      waterGoalL: water,
      fitnessGoal: _fitnessGoal,
    ));
    await app.updateProfile(app.profile.copyWith(
      name: name,
      age: age,
      heightFeet: heightFeet,
      heightInches: heightInches,
      weightKg: weightKg,
    ));

    //need to check this
    await app.completeOnboarding();

    if (!mounted) return;

    if (app.hasOnboarded) {
      debugPrint(
          'Onboarding complete, navigating to RootShell -- ${app.hasOnboarded}');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootShell()),
        (route) => false,
      );
    } else {
      debugPrint('Goals updated, popping back to previous screen');
      Navigator.of(context).pop(true);
    }
    // if (context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Goals updated')),
    //   );
    //   Navigator.pop(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Goals')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            sectionTitle('Protein Goal (g/day)'),
            TextField(
              controller: _proteinCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '90'),
            ),
            const SizedBox(height: 18),
            sectionTitle('Water Goal (L/day)'),
            TextField(
              controller: _waterCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: '2.5'),
            ),
            const SizedBox(height: 18),
            sectionTitle('Fitness Goal'),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _fitnessGoal,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  items: kFitnessGoals
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _fitnessGoal = v ?? _fitnessGoal),
                ),
              ),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: _save,
              // onPressed: () async {
              //   final protein = double.tryParse(_proteinCtrl.text) ??
              //       app.goals.proteinGoalG;
              //   final water =
              //       double.tryParse(_waterCtrl.text) ?? app.goals.waterGoalL;
              //   await app.updateGoals(app.goals.copyWith(
              //     proteinGoalG: protein,
              //     waterGoalL: water,
              //     fitnessGoal: _fitnessGoal,
              //   ));
              //   if (context.mounted) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Goals updated')),
              //     );
              //     Navigator.pop(context);
              //   }
              // },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
