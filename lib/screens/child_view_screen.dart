import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/family_state.dart';
import '../utils/format.dart';
import '../widgets/common.dart';

/// What the child sees on their own device: monitoring is never hidden.
class ChildViewScreen extends StatelessWidget {
  const ChildViewScreen({super.key, required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<FamilyState>();
    final c = s.child(childId);
    final left = (c.dailyLimitMinutes - c.minutesToday).clamp(0, 9999);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('${c.name}\'s device')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          color: scheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Icon(Icons.shield_outlined, size: 40),
              const SizedBox(height: 8),
              const Text('Family Safety is active',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Your parent can see your screen time, app limits'
                  '${c.locationSharing ? ' and your shared location' : ''}.',
                  textAlign: TextAlign.center),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${formatMinutes(left)} left today',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              UsageBar(used: c.minutesToday, limit: c.dailyLimitMinutes),
            ]),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bedtime_outlined),
            title: const Text('Bedtime'),
            subtitle: Text(c.downtime.enabled
                ? '${formatClock(c.downtime.startMinutes)} - ${formatClock(c.downtime.endMinutes)}'
                : 'Off'),
          ),
        ),
        const SizedBox(height: 8),
        const TransparencyBanner(
            text: 'Want more time? Ask your parent - requests show up on their dashboard.'),
      ]),
    );
  }
}
