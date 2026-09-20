import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../services/storage_service.dart';
import '../utils/date_utils.dart' as du;
import '../utils/constants.dart';

/// Single source of truth for the whole app. Every screen reads from this
/// provider via Provider/Consumer/context.watch, and every mutation goes
/// through a method here that immediately persists to SharedPreferences
/// AND calls notifyListeners() so the UI updates instantly with no manual
/// refresh anywhere.
class AppProvider extends ChangeNotifier {
  final _storage = StorageService.instance;
  final _uuid = const Uuid();

  bool _initialized = false;
  bool get initialized => _initialized;

  List<WaterEntry> waterEntries = [];
  List<FoodEntry> foodEntries = [];
  List<FoodItem> customFoods = [];
  List<WorkoutEntry> workoutEntries = [];
  List<WeightEntry> weightEntries = [];
  Goals goals = Goals();
  UserProfile profile = UserProfile();
  bool hasOnboarded = false;
  ThemeMode themeMode = ThemeMode.dark;

  int _bnbIndex = 0; // 0=Home, 1=Food, 2=Workout, 3=Progress
  int get bnbIndex => _bnbIndex;
  void setBnbIndex(int index) {
    _bnbIndex = index;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // INITIALISATION
  // ---------------------------------------------------------------------
  Future<void> init() async {
    debugPrint('AppProvider.init()');
    waterEntries =
        _storage.getList(StorageKeys.water).map(WaterEntry.fromJson).toList();
    foodEntries =
        _storage.getList(StorageKeys.food).map(FoodEntry.fromJson).toList();
    customFoods = _storage
        .getList(StorageKeys.customFoods)
        .map(FoodItem.fromJson)
        .toList();
    workoutEntries = _storage
        .getList(StorageKeys.workout)
        .map(WorkoutEntry.fromJson)
        .toList();
    weightEntries =
        _storage.getList(StorageKeys.weight).map(WeightEntry.fromJson).toList();

    final goalsJson = _storage.getMap(StorageKeys.goals);
    goals = goalsJson != null ? Goals.fromJson(goalsJson) : Goals();

    final profileJson = _storage.getMap(StorageKeys.profile);
    profile =
        profileJson != null ? UserProfile.fromJson(profileJson) : UserProfile();

    hasOnboarded = _storage.getBool(StorageKeys.hasOnboarded);

    debugPrint('hasOnboarded: $hasOnboarded');

    final theme = _storage.getString(StorageKeys.themeMode);
    themeMode = theme == 'light' ? ThemeMode.light : ThemeMode.dark;

    _initialized = true;
    notifyListeners();
  }

  List<FoodItem> get allFoods => [...kCommonFoods, ...customFoods];

  // ---------------------------------------------------------------------
  // ONBOARDING
  // ---------------------------------------------------------------------
  Future<void> completeOnboarding() async {
    hasOnboarded = true;
    await _storage.setBool(StorageKeys.hasOnboarded, true);
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // WATER
  // ---------------------------------------------------------------------
  List<WaterEntry> get todayWater => waterEntries
      .where((e) => du.isSameDay(e.timestamp, DateTime.now()))
      .toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  int get todayWaterMl => todayWater.fold(0, (sum, e) => sum + e.amountMl);

  double get todayWaterL => todayWaterMl / 1000.0;

  double get waterProgressPct =>
      goals.waterGoalL <= 0 ? 0 : (todayWaterL / goals.waterGoalL).clamp(0, 1);

  Future<void> addWater(int ml) async {
    waterEntries.add(WaterEntry(
      id: _uuid.v4(),
      amountMl: ml,
      timestamp: DateTime.now(),
    ));
    await _persistWater();
    notifyListeners();
  }

  Future<void> deleteWater(String id) async {
    waterEntries.removeWhere((e) => e.id == id);
    await _persistWater();
    notifyListeners();
  }

  Future<void> _persistWater() => _storage.setList(
      StorageKeys.water, waterEntries.map((e) => e.toJson()).toList());

  // ---------------------------------------------------------------------
  // FOOD
  // ---------------------------------------------------------------------
  List<FoodEntry> get todayFood => foodEntries
      .where((e) => du.isSameDay(e.timestamp, DateTime.now()))
      .toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  double get todayProtein => todayFood.fold(0.0, (s, e) => s + e.protein);
  double get todayCalories => todayFood.fold(0.0, (s, e) => s + e.calories);
  double get todayCarbs => todayFood.fold(0.0, (s, e) => s + e.carbs);
  double get todayFat => todayFood.fold(0.0, (s, e) => s + e.fat);

  double get proteinProgressPct => goals.proteinGoalG <= 0
      ? 0
      : (todayProtein / goals.proteinGoalG).clamp(0, 1);

  /// How much protein is still needed today (0 if goal already met).
  double get proteinRemaining => (goals.proteinGoalG - todayProtein) < 0
      ? 0
      : goals.proteinGoalG - todayProtein;

  Future<void> addFoodEntry(FoodItem item, double quantity) async {
    foodEntries.add(FoodEntry(
      id: _uuid.v4(),
      foodItemId: item.id,
      foodName: item.name,
      unitLabel: item.unitLabel,
      quantity: quantity,
      protein: item.proteinPerUnit * quantity,
      calories: item.caloriesPerUnit * quantity,
      carbs: item.carbsPerUnit * quantity,
      fat: item.fatPerUnit * quantity,
      timestamp: DateTime.now(),
    ));
    await _persistFood();
    notifyListeners();
  }

  Future<void> deleteFoodEntry(String id) async {
    foodEntries.removeWhere((e) => e.id == id);
    await _persistFood();
    notifyListeners();
  }

  Future<void> _persistFood() => _storage.setList(
      StorageKeys.food, foodEntries.map((e) => e.toJson()).toList());

  Future<void> addCustomFood(FoodItem item) async {
    customFoods.add(item);
    await _storage.setList(
        StorageKeys.customFoods, customFoods.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // WORKOUT
  // ---------------------------------------------------------------------
  WorkoutEntry? get todayWorkout {
    final matches =
        workoutEntries.where((e) => du.isSameDay(e.timestamp, DateTime.now()));
    return matches.isEmpty ? null : matches.first;
  }

  bool get isTodayWorkoutDone => todayWorkout != null;

  /// Marks (or overwrites) today's workout. If a workout already exists for
  /// today it is replaced rather than duplicated, so streak/consistency
  /// counters stay correct.
  Future<void> markWorkoutDone({
    required String muscleGroup,
    required int durationMinutes,
    required String notes,
  }) async {
    workoutEntries
        .removeWhere((e) => du.isSameDay(e.timestamp, DateTime.now()));
    workoutEntries.add(WorkoutEntry(
      id: _uuid.v4(),
      muscleGroup: muscleGroup,
      durationMinutes: durationMinutes,
      notes: notes,
      timestamp: DateTime.now(),
    ));
    await _persistWorkout();
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    workoutEntries.removeWhere((e) => e.id == id);
    await _persistWorkout();
    notifyListeners();
  }

  Future<void> _persistWorkout() => _storage.setList(
      StorageKeys.workout, workoutEntries.map((e) => e.toJson()).toList());

  /// Distinct days with a workout in the current (Mon-start) week.
  int get workoutConsistencyThisWeek {
    final start = du.startOfWeek(DateTime.now());
    final days = <String>{};
    for (final w in workoutEntries) {
      if (!w.timestamp.isBefore(start)) {
        days.add('${w.timestamp.year}-${w.timestamp.month}-${w.timestamp.day}');
      }
    }
    return days.length;
  }

  // ---------------------------------------------------------------------
  // WEIGHT
  // ---------------------------------------------------------------------
  WeightEntry? get latestWeight {
    if (weightEntries.isEmpty) return null;
    final sorted = [...weightEntries]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.first;
  }

  Future<void> logWeight(double kg) async {
    // Replace today's entry if one already exists.
    weightEntries.removeWhere((e) => du.isSameDay(e.timestamp, DateTime.now()));
    weightEntries.add(WeightEntry(
      id: _uuid.v4(),
      weightKg: kg,
      timestamp: DateTime.now(),
    ));
    await _storage.setList(
        StorageKeys.weight, weightEntries.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // GOALS & PROFILE
  // ---------------------------------------------------------------------
  Future<void> updateGoals(Goals newGoals) async {
    goals = newGoals;
    await _storage.setMap(StorageKeys.goals, goals.toJson());
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    profile = newProfile;
    await _storage.setMap(StorageKeys.profile, profile.toJson());
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // THEME
  // ---------------------------------------------------------------------
  Future<void> toggleTheme() async {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storage.setString(
        StorageKeys.themeMode, themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // HOME DASHBOARD OVERALL PROGRESS
  // ---------------------------------------------------------------------
  /// Average of water %, protein % and workout-done (0/100), matching the
  /// ring shown on the Home Dashboard.
  double get overallProgressPct {
    final waterPct = waterProgressPct * 100;
    final proteinPct = proteinProgressPct * 100;
    final workoutPct = isTodayWorkoutDone ? 100.0 : 0.0;
    return (waterPct + proteinPct + workoutPct) / 3;
  }

  // ---------------------------------------------------------------------
  // STREAK — consecutive days (ending today or yesterday) with at least
  // one logged activity (water, food or workout).
  // ---------------------------------------------------------------------
  int get dayStreak {
    bool hasActivityOn(DateTime day) {
      return waterEntries.any((e) => du.isSameDay(e.timestamp, day)) ||
          foodEntries.any((e) => du.isSameDay(e.timestamp, day)) ||
          workoutEntries.any((e) => du.isSameDay(e.timestamp, day));
    }

    final today = du.dateOnly(DateTime.now());
    int streak = 0;
    DateTime cursor = today;

    // If nothing logged today yet, the streak can still be "alive" as long
    // as yesterday had activity - start checking from today, but don't
    // break the streak just because today is still empty.
    if (!hasActivityOn(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    while (hasActivityOn(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // ---------------------------------------------------------------------
  // WEEKLY CHART DATA (last 7 days, Mon-Sun aligned to "This Week")
  // ---------------------------------------------------------------------
  List<double> weeklyWaterLiters({DateTime? end}) {
    final days = du.lastNDays(7, end: end);
    return days.map((d) {
      final ml = waterEntries
          .where((e) => du.isSameDay(e.timestamp, d))
          .fold(0, (s, e) => s + e.amountMl);
      return ml / 1000.0;
    }).toList();
  }

  List<double> weeklyProteinGrams({DateTime? end}) {
    final days = du.lastNDays(7, end: end);
    return days.map((d) {
      return foodEntries
          .where((e) => du.isSameDay(e.timestamp, d))
          .fold(0.0, (s, e) => s + e.protein);
    }).toList();
  }

  List<MapEntry<DateTime, double>> weightHistory() {
    final sorted = [...weightEntries]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted.map((e) => MapEntry(e.timestamp, e.weightKg)).toList();
  }

  // ---------------------------------------------------------------------
  // SETTINGS ACTIONS
  // ---------------------------------------------------------------------
  Future<void> resetTodayData() async {
    waterEntries.removeWhere((e) => du.isSameDay(e.timestamp, DateTime.now()));
    foodEntries.removeWhere((e) => du.isSameDay(e.timestamp, DateTime.now()));
    workoutEntries
        .removeWhere((e) => du.isSameDay(e.timestamp, DateTime.now()));
    await _persistWater();
    await _persistFood();
    await _persistWorkout();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _storage.clearAll();
    waterEntries = [];
    foodEntries = [];
    customFoods = [];
    workoutEntries = [];
    weightEntries = [];
    goals = Goals();
    profile = UserProfile();
    hasOnboarded = false;
    themeMode = ThemeMode.dark;
    notifyListeners();
  }
}
