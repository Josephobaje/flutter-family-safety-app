import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/family_state.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'child_view_screen.dart';

class ChildDetailScreen extends StatelessWidget {
  const ChildDetailScreen({super.key, required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<FamilyState>().child(childId);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(c.name),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.child_care),
              label: const Text('Child view'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChildViewScreen(childId: childId))),
            ),
          ],
          bottom: const TabBar(isScrollable: true, tabs: [
            Tab(text: 'Limits'),
            Tab(text: 'Apps'),
            Tab(text: 'Location'),
            Tab(text: 'Downtime'),
          ]),
        ),
        body: TabBarView(children: [
          _LimitsTab(child: c),
          _AppsTab(child: c),
          _LocationTab(child: c),
          _DowntimeTab(child: c),
        ]),
      ),
    );
  }
}

class _LimitsTab extends StatelessWidget {
  const _LimitsTab({required this.child});
  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    final s = context.read<FamilyState>();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UsageBar(used: child.minutesToday, limit: child.dailyLimitMinutes, label: 'Daily limit'),
            Slider(
              value: child.dailyLimitMinutes.toDouble(),
              min: 15,
              max: 360,
              divisions: 23,
              label: formatMinutes(child.dailyLimitMinutes),
              onChanged: (v) => s.setDailyLimit(child.id, v.round()),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      Text('Category limits', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      for (final cat in AppCategory.values)
        Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(cat.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                Switch(
                  value: child.categoryLimits.containsKey(cat),
                  onChanged: (on) => s.setCategoryLimit(child.id, cat, on ? 60 : null),
                ),
              ]),
              if (child.categoryLimits.containsKey(cat)) ...[
                UsageBar(used: child.minutesFor(cat), limit: child.categoryLimits[cat]!),
                Slider(
                  value: child.categoryLimits[cat]!.toDouble().clamp(0, 240),
                  max: 240,
                  divisions: 16,
                  label: formatMinutes(child.categoryLimits[cat]!),
                  onChanged: (v) => s.setCategoryLimit(child.id, cat, v.round()),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('No limit - ${formatMinutes(child.minutesFor(cat))} today'),
                ),
            ]),
          ),
        ),
    ]);
  }
}

class _AppsTab extends StatelessWidget {
  const _AppsTab({required this.child});
  final ChildProfile child;

  Future<void> _editLimit(BuildContext context, ChildApp app) async {
    final s = context.read<FamilyState>();
    final options = [null, 15, 30, 45, 60, 90, 120];
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text('Daily limit for ${app.name}')),
          for (final o in options)
            ListTile(
              title: Text(o == null ? 'No limit' : formatMinutes(o)),
              trailing: app.limitMinutes == o ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, o ?? -1),
            ),
        ]),
      ),
    );
    if (picked != null) s.setAppLimit(child.id, app.id, picked < 0 ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<FamilyState>();
    final scheme = Theme.of(context).colorScheme;
    return ListView(padding: const EdgeInsets.all(16), children: [
      for (final a in child.apps)
        Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: a.allowed ? scheme.primaryContainer : scheme.errorContainer,
              child: Icon(a.allowed ? Icons.apps : Icons.block),
            ),
            title: Text(a.name),
            subtitle: Text('${a.category.label} - ${formatMinutes(a.minutesToday)} today'
                '${a.limitMinutes != null ? ' - limit ${formatMinutes(a.limitMinutes!)}' : ''}'),
            onTap: () => _editLimit(context, a),
            trailing: Switch(
              value: a.allowed,
              onChanged: (v) => s.setAppAllowed(child.id, a.id, v),
            ),
          ),
        ),
      Text('Tap an app to set a daily time limit. Blocked apps show a friendly notice on the child\'s device.',
          style: TextStyle(color: scheme.onSurfaceVariant)),
    ]);
  }
}

class _LocationTab extends StatelessWidget {
  const _LocationTab({required this.child});
  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    final s = context.read<FamilyState>();
    final scheme = Theme.of(context).colorScheme;
    final loc = child.lastLocation;
    return ListView(padding: const EdgeInsets.all(16), children: [
      TransparencyBanner(
          text: '${child.name} agreed to share location. Sharing is shown on their device and they can see when it was last shared.'),
      const SizedBox(height: 14),
      if (child.locationSharing) ...[
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _MapPainter(scheme),
              child: Center(child: Icon(Icons.location_pin, size: 48, color: scheme.error)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(loc.place),
            subtitle: Text('Shared ${timeAgo(loc.time, s.now)} - '
                '${loc.lat.toStringAsFixed(4)}, ${loc.lng.toStringAsFixed(4)}'),
          ),
        ),
      ] else
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Location sharing is off. It can only be turned on with ${child.name}\'s consent.'),
          ),
        ),
      SwitchListTile(
        title: const Text('Location sharing (consented)'),
        value: child.locationSharing,
        onChanged: (v) => s.setLocationSharing(child.id, v),
      ),
    ]);
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.scheme);
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = scheme.surfaceContainerHighest);
    final road = Paint()
      ..color = scheme.outlineVariant
      ..strokeWidth = 10;
    for (var x = 30.0; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), road);
    }
    for (var y = 40.0; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 20), road);
    }
    canvas.drawCircle(size.center(Offset.zero), 40,
        Paint()..color = scheme.primary.withValues(alpha: 0.2));
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.scheme != scheme;
}

class _DowntimeTab extends StatelessWidget {
  const _DowntimeTab({required this.child});
  final ChildProfile child;

  Future<void> _pick(BuildContext context, bool start) async {
    final s = context.read<FamilyState>();
    final d = child.downtime;
    final m = start ? d.startMinutes : d.endMinutes;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: m ~/ 60, minute: m % 60));
    if (t == null) return;
    final v = t.hour * 60 + t.minute;
    s.setDowntime(child.id, start: start ? v : null, end: start ? null : v);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<FamilyState>();
    final d = child.downtime;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        child: Column(children: [
          SwitchListTile(
            secondary: const Icon(Icons.bedtime_outlined),
            title: const Text('Bedtime downtime'),
            subtitle: const Text('Only calls and approved apps work during downtime'),
            value: d.enabled,
            onChanged: (v) => s.setDowntime(child.id, enabled: v),
          ),
          ListTile(
            enabled: d.enabled,
            leading: const Icon(Icons.nightlight_round),
            title: const Text('Starts'),
            trailing: Text(formatClock(d.startMinutes)),
            onTap: () => _pick(context, true),
          ),
          ListTile(
            enabled: d.enabled,
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text('Ends'),
            trailing: Text(formatClock(d.endMinutes)),
            onTap: () => _pick(context, false),
          ),
        ]),
      ),
      const SizedBox(height: 10),
      TransparencyBanner(
          text: '${child.name} sees a countdown 10 minutes before downtime starts.'),
    ]);
  }
}
