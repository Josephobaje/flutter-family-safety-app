import '../models/models.dart';

/// Simulated family data. No real device is monitored by this demo.
List<ChildProfile> mockChildren(DateTime now) => [
      ChildProfile(
        id: 'amara',
        name: 'Amara',
        age: 12,
        device: 'Tecno Spark 20',
        dailyLimitMinutes: 180,
        categoryLimits: {
          AppCategory.games: 60,
          AppCategory.social: 45,
          AppCategory.video: 60,
        },
        apps: [
          ChildApp(id: 'yt', name: 'YouTube Kids', category: AppCategory.video, minutesToday: 52, limitMinutes: 60),
          ChildApp(id: 'duo', name: 'Duolingo', category: AppCategory.education, minutesToday: 25),
          ChildApp(id: 'ulesson', name: 'uLesson', category: AppCategory.education, minutesToday: 40),
          ChildApp(id: 'roblox', name: 'Roblox', category: AppCategory.games, minutesToday: 35, limitMinutes: 45),
          ChildApp(id: 'wa', name: 'WhatsApp', category: AppCategory.social, minutesToday: 18),
          ChildApp(id: 'tiktok', name: 'TikTok', category: AppCategory.social, minutesToday: 0, allowed: false),
          ChildApp(id: 'cam', name: 'Camera', category: AppCategory.other, minutesToday: 6),
        ],
        weeklyMinutes: [150, 170, 140, 195, 160, 210, 176],
        lastLocation: LocationPing(place: 'Home, Wuse 2, Abuja', lat: 9.0765, lng: 7.4704, time: now.subtract(const Duration(minutes: 8))),
        downtime: DowntimeSchedule(startMinutes: 21 * 60, endMinutes: 6 * 60 + 30),
      ),
      ChildProfile(
        id: 'tobi',
        name: 'Tobi',
        age: 9,
        device: 'Samsung Galaxy Tab A8',
        dailyLimitMinutes: 120,
        categoryLimits: {
          AppCategory.games: 45,
          AppCategory.video: 45,
        },
        apps: [
          ChildApp(id: 'mc', name: 'Minecraft', category: AppCategory.games, minutesToday: 45, limitMinutes: 45),
          ChildApp(id: 'ytk', name: 'YouTube Kids', category: AppCategory.video, minutesToday: 40),
          ChildApp(id: 'khan', name: 'Khan Academy Kids', category: AppCategory.education, minutesToday: 22),
          ChildApp(id: 'draw', name: 'Sketchbook', category: AppCategory.other, minutesToday: 9),
          ChildApp(id: 'ff', name: 'Free Fire', category: AppCategory.games, minutesToday: 0, allowed: false),
        ],
        weeklyMinutes: [95, 110, 120, 88, 130, 125, 116],
        lastLocation: LocationPing(place: 'Greenfield School, Garki', lat: 9.0333, lng: 7.4890, time: now.subtract(const Duration(hours: 2))),
        downtime: DowntimeSchedule(startMinutes: 20 * 60, endMinutes: 7 * 60),
      ),
    ];
