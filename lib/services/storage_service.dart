import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences that stores everything as JSON
/// strings. This is the ONLY place in the app that talks to local storage.
/// No network, no cloud, no external services are used anywhere.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late SharedPreferences _prefs;
  bool _ready = false;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  void _assertReady() {
    assert(_ready, 'StorageService.init() must be awaited before use');
  }

  List<Map<String, dynamic>> getList(String key) {
    _assertReady();
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> setList(String key, List<Map<String, dynamic>> list) async {
    _assertReady();
    await _prefs.setString(key, jsonEncode(list));
  }

  Map<String, dynamic>? getMap(String key) {
    _assertReady();
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setMap(String key, Map<String, dynamic> map) async {
    _assertReady();
    await _prefs.setString(key, jsonEncode(map));
  }

  bool getBool(String key, {bool defaultValue = false}) {
    _assertReady();
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    _assertReady();
    await _prefs.setBool(key, value);
  }

  String? getString(String key) {
    _assertReady();
    return _prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    _assertReady();
    await _prefs.setString(key, value);
  }

  /// Wipes every key this app has ever written. Used by "Clear All Data".
  Future<void> clearAll() async {
    _assertReady();
    await _prefs.clear();
  }
}

/// All SharedPreferences keys used by the app, kept in one place so nothing
/// is ever mistyped.
class StorageKeys {
  static const water = 'fittrack_water_entries';
  static const food = 'fittrack_food_entries';
  static const customFoods = 'fittrack_custom_foods';
  static const workout = 'fittrack_workout_entries';
  static const weight = 'fittrack_weight_entries';
  static const goals = 'fittrack_goals';
  static const profile = 'fittrack_user_profile';
  static const hasOnboarded = 'fittrack_has_onboarded';
  static const themeMode = 'fittrack_theme_mode'; // 'dark' | 'light'
}
