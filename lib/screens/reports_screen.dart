import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/family_state.dart';
import '../utils/format.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? childId;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<FamilyState>();
    final c = s.child(childId ?? s.children.first.id);
    final scheme = Theme.of(context).colorScheme;
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'];
    final cats = AppCategory.values.where((k) => c.minutesFor(k) > 0).toList();
    final colors = [scheme.primary, Colors.orange, Colors.purple, Colors.blue, Colors.teal];
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SegmentedButton<String>(
          segments: [for (final k in s.children) ButtonSegment(value: k.id, label: Text(k.name))],
          selected: {c.id},
          onSelectionChanged: (v) => setState(() => childId = v.first),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Weekly screen time', style: Theme.of(context).textTheme.titleMedium),
              Text('Average ${formatMinutes(c.weeklyAverage.round())} / day - limit ${formatMinutes(c.dailyLimitMinutes)}',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(BarChartData(
                  maxY: (c.weeklyMinutes.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(y: c.dailyLimitMinutes.toDouble(), color: scheme.error, dashArray: [6, 4]),
                  ]),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(days[v.toInt()], style: const TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < c.weeklyMinutes.length; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: c.weeklyMinutes[i].toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: c.weeklyMinutes[i] > c.dailyLimitMinutes ? Colors.orange : scheme.primary,
                        ),
                      ]),
                  ],
                )),
              ),
            ]),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Today by category', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: PieChart(PieChartData(
                    centerSpaceRadius: 34,
                    sectionsSpace: 2,
                    sections: [
                      for (var i = 0; i < cats.length; i++)
                        PieChartSectionData(
                          value: c.minutesFor(cats[i]).toDouble(),
                          color: colors[i % colors.length],
                          title: '',
                          radius: 30,
                        ),
                    ],
                  )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (var i = 0; i < cats.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(children: [
                          Container(width: 12, height: 12, color: colors[i % colors.length]),
                          const SizedBox(width: 8),
                          Expanded(child: Text(cats[i].label)),
                          Text(formatMinutes(c.minutesFor(cats[i]))),
                        ]),
                      ),
                  ]),
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
