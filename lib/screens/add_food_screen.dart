import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? initialFood;
  const AddFoodScreen({super.key, this.initialFood});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  late int _tab; // 0 = Common Food, 1 = Custom Food
  FoodItem? _selected;
  double _quantity = 1;

  // custom food form controllers
  final _nameCtrl = TextEditingController();
  final _unitCtrl = TextEditingController(text: '1 serving');
  final _proteinCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialFood;
    _tab = widget.initialFood == null ? 0 : 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
    _proteinCtrl.dispose();
    _caloriesCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Food Item')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                      child: _TabBtn(
                          label: 'Common Food',
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _TabBtn(
                          label: 'Custom Food',
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1))),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _tab == 0
                    ? _buildCommonFoodTab(app)
                    : _buildCustomFoodTab(app),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommonFoodTab(AppProvider app) {
    return ListView(
      children: [
        if (_selected == null) ...[
          sectionTitle('Choose a food'),
          ...app.allFoods.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  onTap: () => setState(() {
                    _selected = f;
                    _quantity = 1;
                  }),
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
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
              )),
        ] else
          _buildSelectedFoodDetail(app, _selected!),
      ],
    );
  }

  Widget _buildSelectedFoodDetail(AppProvider app, FoodItem food) {
    final protein = food.proteinPerUnit * _quantity;
    final calories = food.caloriesPerUnit * _quantity;
    final carbs = food.carbsPerUnit * _quantity;
    final fat = food.fatPerUnit * _quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(food.emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textLight)),
                    Text(food.unitLabel,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selected = null),
                child: const Text('Change'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionTitle('Quantity'),
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey(_quantity),
                  initialValue:
                      _quantity.toStringAsFixed(_quantity % 1 == 0 ? 0 : 1),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null && parsed > 0) {
                      setState(() => _quantity = parsed);
                    }
                  },
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.remove_circle, color: AppColors.textMuted),
                onPressed: () => setState(() {
                  if (_quantity > 0.5) _quantity -= 0.5;
                }),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.green),
                onPressed: () => setState(() => _quantity += 0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionTitle(
            'Nutrition (for ${_quantity.toStringAsFixed(_quantity % 1 == 0 ? 0 : 1)} × ${food.unitLabel})'),
        AppCard(
          child: Column(
            children: [
              _nutritionRow('Protein', '${protein.toStringAsFixed(1)} g'),
              const Divider(color: AppColors.divider, height: 20),
              _nutritionRow('Calories', '${calories.toStringAsFixed(0)} kcal'),
              const Divider(color: AppColors.divider, height: 20),
              _nutritionRow('Carbs', '${carbs.toStringAsFixed(1)} g'),
              const Divider(color: AppColors.divider, height: 20),
              _nutritionRow('Fat', '${fat.toStringAsFixed(1)} g'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await app.addFoodEntry(food, _quantity);
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Add to Today'),
        ),
        const SizedBox(height: 10),
        const Text(
          'Note: Nutrition values are estimates and may vary based on brand and preparation.',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _nutritionRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textLight)),
        ],
      );

  Widget _buildCustomFoodTab(AppProvider app) {
    return ListView(
      children: [
        sectionTitle('Food Name'),
        TextField(
            controller: _nameCtrl,
            decoration:
                const InputDecoration(hintText: 'e.g. Homemade Sandwich')),
        const SizedBox(height: 14),
        sectionTitle('Serving Unit'),
        TextField(
            controller: _unitCtrl,
            decoration: const InputDecoration(hintText: 'e.g. 1 plate, 100 g')),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Protein (g)'),
                  TextField(
                      controller: _proteinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '0')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Calories'),
                  TextField(
                      controller: _caloriesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '0')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Carbs (g)'),
                  TextField(
                      controller: _carbsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '0')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Fat (g)'),
                  TextField(
                      controller: _fatCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '0')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: () async {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a food name')),
              );
              return;
            }
            final item = FoodItem(
              id: const Uuid().v4(),
              name: name,
              unitLabel: _unitCtrl.text.trim().isEmpty
                  ? '1 serving'
                  : _unitCtrl.text.trim(),
              proteinPerUnit: double.tryParse(_proteinCtrl.text) ?? 0,
              caloriesPerUnit: double.tryParse(_caloriesCtrl.text) ?? 0,
              carbsPerUnit: double.tryParse(_carbsCtrl.text) ?? 0,
              fatPerUnit: double.tryParse(_fatCtrl.text) ?? 0,
              isCustom: true,
              emoji: '🍴',
            );
            await app.addCustomFood(item);
            await app.addFoodEntry(item, 1);
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Save & Add to Today'),
        ),
      ],
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn(
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
