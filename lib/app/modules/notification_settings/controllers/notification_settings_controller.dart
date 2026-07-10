import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsController extends GetxController {
  final isDailyReminderEnabled = true.obs;
  final isStreakAlertEnabled = true.obs;
  final isNewMaterialAlertEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotificationSettings();
  }

  Future<void> loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDailyReminderEnabled.value = prefs.getBool('daily_reminder') ?? true;
      isStreakAlertEnabled.value = prefs.getBool('streak_alert') ?? true;
      isNewMaterialAlertEnabled.value = prefs.getBool('new_material_alert') ?? true;
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    }
  }

  Future<void> toggleDailyReminder(bool value) async {
    isDailyReminderEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
  }

  Future<void> toggleStreakAlert(bool value) async {
    isStreakAlertEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streak_alert', value);
  }

  Future<void> toggleNewMaterialAlert(bool value) async {
    isNewMaterialAlertEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('new_material_alert', value);
  }
}
