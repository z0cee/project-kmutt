import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveDailyTask(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("daily_task", jsonEncode(task));
  }

  static Future<Map<String, dynamic>?> loadDailyTask() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("daily_task");
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  static Future<void> saveIntervalTask(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("interval_task", jsonEncode(task));
  }

  static Future<Map<String, dynamic>?> loadIntervalTask() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("interval_task");
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}
