import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';

class FamilyState extends ChangeNotifier {
  FamilyState({DateTime? now, List<ChildProfile>? children})
      : now = now ?? DateTime.now(),
        children = children ?? mockChildren(now ?? DateTime.now());

  final DateTime now;
  final List<ChildProfile> children;
  ThemeMode themeMode = ThemeMode.light;

  /// Shows a persistent "monitoring is active" notice on the child's device.
  /// Locked on in this app by design; exposed for display only.
  final bool childNoticeAlwaysOn = true;
  bool weeklyEmailReport = true;

  ChildProfile child(String id) => children.firstWhere((c) => c.id == id);

  int get familyMinutesToday =>
      children.fold(0, (sum, c) => sum + c.minutesToday);

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setDailyLimit(String childId, int minutes) {
    child(childId).dailyLimitMinutes = minutes.clamp(15, 600);
    notifyListeners();
  }

  void setCategoryLimit(String childId, AppCategory c, int? minutes) {
    final limits = child(childId).categoryLimits;
    if (minutes == null) {
      limits.remove(c);
    } else {
      limits[c] = minutes.clamp(0, 600);
    }
    notifyListeners();
  }

  void setAppAllowed(String childId, String appId, bool allowed) {
    child(childId).apps.firstWhere((a) => a.id == appId).allowed = allowed;
    notifyListeners();
  }

  void setAppLimit(String childId, String appId, int? minutes) {
    child(childId).apps.firstWhere((a) => a.id == appId).limitMinutes = minutes;
    notifyListeners();
  }

  void setLocationSharing(String childId, bool on) {
    child(childId).locationSharing = on;
    notifyListeners();
  }

  void setDowntime(String childId, {bool? enabled, int? start, int? end}) {
    final d = child(childId).downtime;
    if (enabled != null) d.enabled = enabled;
    if (start != null) d.startMinutes = start;
    if (end != null) d.endMinutes = end;
    notifyListeners();
  }

  void setWeeklyEmailReport(bool on) {
    weeklyEmailReport = on;
    notifyListeners();
  }
}
