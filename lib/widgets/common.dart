import 'package:flutter/material.dart';

import '../utils/format.dart';

class UsageBar extends StatelessWidget {
  const UsageBar({super.key, required this.used, required this.limit, this.label});
  final int used;
  final int limit;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = limit == 0 ? 1.0 : (used / limit).clamp(0.0, 1.0);
    final color = ratio >= 1
        ? scheme.error
        : ratio >= 0.8
            ? Colors.orange
            : scheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          if (label != null) Expanded(child: Text(label!, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text('${formatMinutes(used)} / ${formatMinutes(limit)}'),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            color: color,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class TransparencyBanner extends StatelessWidget {
  const TransparencyBanner({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Icon(Icons.visibility_outlined, color: scheme.onSecondaryContainer),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(color: scheme.onSecondaryContainer))),
      ]),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      'Limit reached' => scheme.error,
      'Near limit' => Colors.orange,
      _ => scheme.primary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
