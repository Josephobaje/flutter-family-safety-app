/// Domain models for Family Safety. All data in this demo is simulated.
enum AppCategory { education, games, social, video, other }

extension AppCategoryX on AppCategory {
  String get label => switch (this) {
        AppCategory.education => 'Education',
        AppCategory.games => 'Games',
        AppCategory.social => 'Social',
        AppCategory.video => 'Video',
        AppCategory.other => 'Other',
      };
}

class ChildApp {
  ChildApp({
    required this.id,
    required this.name,
    required this.category,
    required this.minutesToday,
    this.allowed = true,
    this.limitMinutes,
  });

  final String id;
  final String name;
  final AppCategory category;
  final int minutesToday;
  bool allowed;

  /// Optional per-app daily limit in minutes. `null` means no app limit.
  int? limitMinutes;

  bool get overLimit => limitMinutes != null && minutesToday >= limitMinutes!;
}

class LocationPing {
  const LocationPing({
    required this.place,
    required this.lat,
    required this.lng,
    required this.time,
  });
  final String place;
  final double lat;
  final double lng;
  final DateTime time;
}

class DowntimeSchedule {
  DowntimeSchedule({
    this.enabled = true,
    this.startMinutes = 21 * 60,
    this.endMinutes = 6 * 60 + 30,
  });
  bool enabled;

  /// Minutes after midnight.
  int startMinutes;
  int endMinutes;

  /// True when [minuteOfDay] falls inside downtime (handles overnight ranges).
  bool isActiveAt(int minuteOfDay) {
    if (!enabled) return false;
    if (startMinutes == endMinutes) return false;
    if (startMinutes < endMinutes) {
      return minuteOfDay >= startMinutes && minuteOfDay < endMinutes;
    }
    return minuteOfDay >= startMinutes || minuteOfDay < endMinutes;
  }
}

class ChildProfile {
  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.device,
    required this.dailyLimitMinutes,
    required this.categoryLimits,
    required this.apps,
    required this.weeklyMinutes,
    required this.lastLocation,
    required this.downtime,
    this.locationSharing = true,
  });

  final String id;
  final String name;
  final int age;
  final String device;
  int dailyLimitMinutes;
  final Map<AppCategory, int> categoryLimits;
  final List<ChildApp> apps;

  /// Total minutes for the last 7 days, oldest first; the last entry is today.
  final List<int> weeklyMinutes;
  LocationPing lastLocation;
  final DowntimeSchedule downtime;

  /// Location sharing is only on when the child has consented.
  bool locationSharing;

  int get minutesToday => apps.fold(0, (sum, a) => sum + a.minutesToday);

  int minutesFor(AppCategory c) => apps
      .where((a) => a.category == c)
      .fold(0, (sum, a) => sum + a.minutesToday);

  double get usageRatio =>
      dailyLimitMinutes == 0 ? 1 : minutesToday / dailyLimitMinutes;

  List<ChildApp> get topApps =>
      (List<ChildApp>.of(apps)..sort((a, b) => b.minutesToday - a.minutesToday))
          .take(3)
          .toList();

  String get status {
    if (usageRatio >= 1) return 'Limit reached';
    if (usageRatio >= 0.8) return 'Near limit';
    return 'On track';
  }

  double get weeklyAverage =>
      weeklyMinutes.isEmpty ? 0 : weeklyMinutes.reduce((a, b) => a + b) / weeklyMinutes.length;
}
