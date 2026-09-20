import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/shared_widgets.dart';
import 'add_food_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  int _tab = 0; // 0 = Today, 1 = Food List
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                  text: 'Food & Nutrition\n',
                  style: TextStyle(color: AppColors.textLight, fontSize: 23)),
              TextSpan(
                  text: 'Track Your Food, Fuel Your Goals',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Expanded(
                      child: _TabButton(
                          label: 'Today',
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _TabButton(
                          label: 'Food List',
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1))),
                ],
              ),
            ),
            Expanded(
              child: _tab == 0
                  ? _TodayTab(app: app)
                  : _FoodListTab(
                      app: app,
                      search: _search,
                      onSearchChanged: (v) => setState(() => _search = v),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.black : AppColors.textMuted,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _TodayTab extends StatelessWidget {
  final AppProvider app;
  const _TodayTab({required this.app});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.restaurant_rounded,
                iconColor: AppColors.green,
                label: 'Protein',
                value:
                    '${app.todayProtein.round()} / ${app.goals.proteinGoalG.round()} g',
                progress: app.proteinProgressPct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.orange,
                label: 'Calories',
                value: '${app.todayCalories.round()} kcal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.grain_rounded,
                iconColor: AppColors.blue,
                label: 'Carbs',
                value: '${app.todayCarbs.round()} g',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.opacity_rounded,
                iconColor: AppColors.orange,
                label: 'Fat',
                value: '${app.todayFat.round()} g',
              ),
            ),
          ],
        ),
        if (app.proteinRemaining > 0) ...[
          const SizedBox(height: 14),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.lightbulb_rounded,
                    color: AppColors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You need about ${app.proteinRemaining.round()} g more protein today.',
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        sectionTitle('Quick Add Common Foods'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: kCommonFoods.take(6).map((food) {
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                await app.addFoodEntry(food, 1);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${food.name}'),
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(food.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(food.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight)),
                    Text('${food.proteinPerUnit.round()} g',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddFoodScreen()),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Custom Food'),
          ),
        ),
        const SizedBox(height: 20),
        sectionTitle("Today's Log"),
        if (app.todayFood.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
                child: Text('No food logged yet today',
                    style: TextStyle(color: AppColors.textMuted))),
          )
        else
          ...app.todayFood.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.foodName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textLight)),
                            Text(
                                '${e.quantity.toStringAsFixed(e.quantity % 1 == 0 ? 0 : 1)} × ${e.unitLabel} • ${DateFormat('hh:mm a').format(e.timestamp)}',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Text('${e.protein.round()} g P',
                          style: const TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.danger, size: 20),
                        onPressed: () => app.deleteFoodEntry(e.id),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}

class _FoodListTab extends StatelessWidget {
  final AppProvider app;
  final String search;
  final ValueChanged<String> onSearchChanged;

  const _FoodListTab(
      {required this.app, required this.search, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final all = app.allFoods
        .where((f) => f.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search foods...',
              prefixIcon:
                  Icon(Icons.search_rounded, color: AppColors.textMuted),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: all.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final f = all[i];
              return AppCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => AddFoodScreen(initialFood: f)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Text(f.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight)),
                          Text(f.unitLabel,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Text('${f.proteinPerUnit.round()} g protein',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.green)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
