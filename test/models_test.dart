import 'package:family_safety/data/mock_data.dart';
import 'package:family_safety/models/models.dart';
import 'package:family_safety/state/family_state.dart';
import 'package:family_safety/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 14, 18);

  test('formatMinutes', () {
    expect(formatMinutes(45), '45m');
    expect(formatMinutes(120), '2h');
    expect(formatMinutes(176), '2h 56m');
  });

  test('formatClock', () {
    expect(formatClock(21 * 60), '9:00 PM');
    expect(formatClock(6 * 60 + 30), '6:30 AM');
    expect(formatClock(0), '12:00 AM');
  });

  test('overnight downtime range', () {
    final d = DowntimeSchedule(startMinutes: 21 * 60, endMinutes: 6 * 60 + 30);
    expect(d.isActiveAt(22 * 60), isTrue);
    expect(d.isActiveAt(3 * 60), isTrue);
    expect(d.isActiveAt(12 * 60), isFalse);
    d.enabled = false;
    expect(d.isActiveAt(22 * 60), isFalse);
  });

  test('child totals, top apps and status', () {
    final amara = mockChildren(now).first;
    expect(amara.minutesToday, 176);
    expect(amara.topApps.first.name, 'YouTube Kids');
    expect(amara.minutesFor(AppCategory.education), 65);
    expect(amara.status, 'Near limit');
  });

  test('state updates limits, apps and consent', () {
    final s = FamilyState(now: now);
    var notified = 0;
    s.addListener(() => notified++);
    s.setDailyLimit('tobi', 5);
    expect(s.child('tobi').dailyLimitMinutes, 15); // clamped
    s.setAppAllowed('amara', 'tiktok', true);
    expect(s.child('amara').apps.firstWhere((a) => a.id == 'tiktok').allowed, isTrue);
    s.setCategoryLimit('amara', AppCategory.games, null);
    expect(s.child('amara').categoryLimits.containsKey(AppCategory.games), isFalse);
    s.setLocationSharing('amara', false);
    expect(s.child('amara').locationSharing, isFalse);
    expect(s.childNoticeAlwaysOn, isTrue);
    expect(notified, 4);
  });
}
