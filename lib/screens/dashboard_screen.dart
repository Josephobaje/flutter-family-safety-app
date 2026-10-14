import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/family_state.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'child_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<FamilyState>();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Safety', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: s.themeMode == ThemeMode.dark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(s.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: s.toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Good evening, Parent', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Family screen time today: ${formatMinutes(s.familyMinutesToday)}',
              style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          const TransparencyBanner(
              text: 'Monitoring is visible on each child\'s device. Demo data is simulated.'),
          const SizedBox(height: 16),
          for (final c in s.children) _ChildCard(child: c),
        ],
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.child});
  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ChildDetailScreen(childId: child.id))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(child.name[0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(child.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${child.age} yrs - ${child.device}', style: TextStyle(color: scheme.onSurfaceVariant)),
                  ]),
                ),
                StatusChip(child.status),
              ]),
              const SizedBox(height: 14),
              UsageBar(used: child.minutesToday, limit: child.dailyLimitMinutes, label: 'Screen time today'),
              const SizedBox(height: 12),
              Text('Top apps', style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Wrap(spacing: 8, runSpacing: 6, children: [
                for (final a in child.topApps)
                  Chip(label: Text('${a.name} ${formatMinutes(a.minutesToday)}'), visualDensity: VisualDensity.compact),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
