import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/family_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<FamilyState>();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          color: scheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.visibility, color: scheme.onTertiaryContainer),
                const SizedBox(width: 8),
                Text('Transparency',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: scheme.onTertiaryContainer)),
              ]),
              const SizedBox(height: 10),
              for (final line in const [
                'Children always see that Family Safety is active on their device.',
                'There is no hidden or stealth mode - by design.',
                'Location is shared only with the child\'s consent and they can see when it was shared.',
                'Messages, photos and browsing content are never read.',
                'Older children can review every rule set for them.',
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.check_circle, size: 18, color: scheme.onTertiaryContainer),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line, style: TextStyle(color: scheme.onTertiaryContainer))),
                  ]),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text('"Monitoring active" notice on child device'),
              subtitle: const Text('Always on - cannot be disabled'),
              value: s.childNoticeAlwaysOn,
              onChanged: null,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.email_outlined),
              title: const Text('Weekly report email'),
              value: s.weeklyEmailReport,
              onChanged: s.setWeeklyEmailReport,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark mode'),
              value: s.themeMode == ThemeMode.dark,
              onChanged: (_) => s.toggleTheme(),
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Language & region'),
              subtitle: Text('English (Nigeria) - Africa/Lagos'),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Text('Family Safety demo by Joseph Obaje. All monitoring data is simulated.',
            textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurfaceVariant)),
      ]),
    );
  }
}
