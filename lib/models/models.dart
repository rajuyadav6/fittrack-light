// All app data models. Every model is a plain Dart class with toJson/fromJson
// so it can be persisted as a JSON string inside SharedPreferences.

class WaterEntry {
  final String id;
  final int amountMl;
  final DateTime timestamp;

  WaterEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        id: json['id'] as String,
        amountMl: json['amountMl'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// A food item definition (either a built-in common food or a user-created
/// custom food). Stores nutrition PER UNIT so it can be scaled by quantity.
class FoodItem {
  final String id;
  final String name;
  final String unitLabel; // e.g. "1 egg", "100 g", "1 cup"
  final double proteinPerUnit;
  final double caloriesPerUnit;
  final double carbsPerUnit;
  final double fatPerUnit;
  final bool isCustom;
  final String emoji;

  FoodItem({
    required this.id,
    required this.name,
    required this.unitLabel,
    required this.proteinPerUnit,
    required this.caloriesPerUnit,
    required this.carbsPerUnit,
    required this.fatPerUnit,
    this.isCustom = false,
    this.emoji = '🍽️',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unitLabel': unitLabel,
        'proteinPerUnit': proteinPerUnit,
        'caloriesPerUnit': caloriesPerUnit,
        'carbsPerUnit': carbsPerUnit,
        'fatPerUnit': fatPerUnit,
        'isCustom': isCustom,
        'emoji': emoji,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'] as String,
        name: json['name'] as String,
        unitLabel: json['unitLabel'] as String,
        proteinPerUnit: (json['proteinPerUnit'] as num).toDouble(),
        caloriesPerUnit: (json['caloriesPerUnit'] as num).toDouble(),
        carbsPerUnit: (json['carbsPerUnit'] as num).toDouble(),
        fatPerUnit: (json['fatPerUnit'] as num).toDouble(),
        isCustom: json['isCustom'] as bool? ?? false,
        emoji: json['emoji'] as String? ?? '🍽️',
      );
}

/// A logged food entry. Stores a SNAPSHOT of the nutrition (already scaled
/// by quantity) so that editing/deleting a FoodItem later never corrupts
/// historical entries.
class FoodEntry {
  final String id;
  final String foodItemId;
  final String foodName;
  final String unitLabel;
  final double quantity;
  final double protein;
  final double calories;
  final double carbs;
  final double fat;
  final DateTime timestamp;

  FoodEntry({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.unitLabel,
    required this.quantity,
    required this.protein,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodItemId': foodItemId,
        'foodName': foodName,
        'unitLabel': unitLabel,
        'quantity': quantity,
        'protein': protein,
        'calories': calories,
        'carbs': carbs,
        'fat': fat,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        id: json['id'] as String,
        foodItemId: json['foodItemId'] as String,
        foodName: json['foodName'] as String,
        unitLabel: json['unitLabel'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        calories: (json['calories'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class WorkoutEntry {
  final String id;
  final String muscleGroup;
  final int durationMinutes;
  final String notes;
  final DateTime timestamp;

  WorkoutEntry({
    required this.id,
    required this.muscleGroup,
    required this.durationMinutes,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'muscleGroup': muscleGroup,
        'durationMinutes': durationMinutes,
        'notes': notes,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) => WorkoutEntry(
        id: json['id'] as String,
        muscleGroup: json['muscleGroup'] as String,
        durationMinutes: json['durationMinutes'] as int,
        notes: json['notes'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class WeightEntry {
  final String id;
  final double weightKg;
  final DateTime timestamp;

  WeightEntry({
    required this.id,
    required this.weightKg,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'weightKg': weightKg,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'] as String,
        weightKg: (json['weightKg'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class Goals {
  final double proteinGoalG;
  final double waterGoalL;
  final String fitnessGoal;

  Goals({
    this.proteinGoalG = 90,
    this.waterGoalL = 2.5,
    this.fitnessGoal = 'Stay Fit & Healthy',
  });

  Goals copyWith({
    double? proteinGoalG,
    double? waterGoalL,
    String? fitnessGoal,
  }) =>
      Goals(
        proteinGoalG: proteinGoalG ?? this.proteinGoalG,
        waterGoalL: waterGoalL ?? this.waterGoalL,
        fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      );

  Map<String, dynamic> toJson() => {
        'proteinGoalG': proteinGoalG,
        'waterGoalL': waterGoalL,
        'fitnessGoal': fitnessGoal,
      };

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        proteinGoalG: (json['proteinGoalG'] as num?)?.toDouble() ?? 90,
        waterGoalL: (json['waterGoalL'] as num?)?.toDouble() ?? 2.5,
        fitnessGoal: json['fitnessGoal'] as String? ?? 'Stay Fit & Healthy',
      );
}

class UserProfile {
  final String? name;
  final int age;
  final int heightFeet;
  final int heightInches;
  final double? weightKg;

  UserProfile({
    this.name = 'user',
    this.age = 26,
    this.heightFeet = 5,
    this.heightInches = 5,
    this.weightKg = 62.0,
  });

  double get heightCm => ((heightFeet * 12) + heightInches) * 2.54;

  String get heightLabel =>
      "$heightFeet'$heightInches\" (${heightCm.round()} cm)";

  UserProfile copyWith(
          {String? name,
          int? age,
          int? heightFeet,
          int? heightInches,
          double? weightKg}) =>
      UserProfile(
        name: name ?? this.name,
        age: age ?? this.age,
        heightFeet: heightFeet ?? this.heightFeet,
        heightInches: heightInches ?? this.heightInches,
        weightKg: weightKg ?? this.weightKg,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'heightFeet': heightFeet,
        'heightInches': heightInches,
        'weightKg': weightKg,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'raju y',
        age: json['age'] as int? ?? 26,
        heightFeet: json['heightFeet'] as int? ?? 5,
        heightInches: json['heightInches'] as int? ?? 5,
        weightKg: json['weightKg'] as double? ?? 70.0,
      );
}
