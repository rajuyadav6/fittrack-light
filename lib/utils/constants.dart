import '../models/models.dart';

/// Built-in common foods available in "Quick Add" and the "Common Food"
/// tab of Add Food Item. Nutrition values are per the given unit.
final List<FoodItem> kCommonFoods = [
  FoodItem(
    id: 'common_egg',
    name: 'Egg',
    unitLabel: '1 large egg (approx 50g)',
    proteinPerUnit: 6,
    caloriesPerUnit: 70,
    carbsPerUnit: 0.6,
    fatPerUnit: 5,
    emoji: '🥚',
  ),
  FoodItem(
    id: 'common_milk',
    name: 'Milk',
    unitLabel: '250 ml',
    proteinPerUnit: 8,
    caloriesPerUnit: 150,
    carbsPerUnit: 12,
    fatPerUnit: 8,
    emoji: '🥛',
  ),
  FoodItem(
    id: 'common_paneer',
    name: 'Paneer',
    unitLabel: '50 g',
    proteinPerUnit: 9,
    caloriesPerUnit: 130,
    carbsPerUnit: 2,
    fatPerUnit: 10,
    emoji: '🧀',
  ),
  FoodItem(
    id: 'common_curd',
    name: 'Curd',
    unitLabel: '100 g',
    proteinPerUnit: 4,
    caloriesPerUnit: 60,
    carbsPerUnit: 4,
    fatPerUnit: 3,
    emoji: '🥣',
  ),
  FoodItem(
    id: 'common_dal',
    name: 'Dal',
    unitLabel: '1 cup',
    proteinPerUnit: 9,
    caloriesPerUnit: 200,
    carbsPerUnit: 30,
    fatPerUnit: 4,
    emoji: '🍛',
  ),
  FoodItem(
    id: 'common_chana',
    name: 'Chana',
    unitLabel: '1 cup',
    proteinPerUnit: 8,
    caloriesPerUnit: 210,
    carbsPerUnit: 35,
    fatPerUnit: 3,
    emoji: '🌰',
  ),
  FoodItem(
    id: 'common_protein_shake',
    name: 'Protein Shake',
    unitLabel: '1 scoop (30g)',
    proteinPerUnit: 24,
    caloriesPerUnit: 120,
    carbsPerUnit: 3,
    fatPerUnit: 2,
    emoji: '🥤',
  ),
  FoodItem(
    id: 'common_rice',
    name: 'Rice',
    unitLabel: '1 cup cooked',
    proteinPerUnit: 4,
    caloriesPerUnit: 205,
    carbsPerUnit: 45,
    fatPerUnit: 0.4,
    emoji: '🍚',
  ),
  FoodItem(
    id: 'common_chicken_breast',
    name: 'Chicken Breast',
    unitLabel: '100 g',
    proteinPerUnit: 31,
    caloriesPerUnit: 165,
    carbsPerUnit: 0,
    fatPerUnit: 3.6,
    emoji: '🍗',
  ),
  FoodItem(
    id: 'common_banana',
    name: 'Banana',
    unitLabel: '1 medium',
    proteinPerUnit: 1.3,
    caloriesPerUnit: 105,
    carbsPerUnit: 27,
    fatPerUnit: 0.4,
    emoji: '🍌',
  ),
];

const List<String> kMuscleGroups = [
  'Chest',
  'Back',
  'Legs',
  'Shoulders',
  'Arms',
  'Full Body',
  'Cardio',
  'Rest Day',
];

const List<int> kWorkoutDurations = [15, 30, 45, 60, 90, 120];

const List<String> kFitnessGoals = [
  'Stay Fit & Healthy',
  'Weight Loss',
  'Muscle Gain',
  'Maintain Weight',
];

const List<String> kMotivationalQuotes = [
  'Consistency today, results tomorrow.',
  'Small steps. Big results.',
  'Discipline beats motivation.',
  'Every rep counts.',
  'Progress, not perfection.',
];
