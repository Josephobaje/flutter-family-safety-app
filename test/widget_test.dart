import 'package:family_safety/app.dart';
import 'package:family_safety/state/family_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard lists children and opens detail + child view', (tester) async {
    final state = FamilyState(now: DateTime(2026, 10, 14, 18));
    await tester.pumpWidget(FamilySafetyApp(state: state));
    expect(find.text('Amara'), findsOneWidget);
    expect(find.text('Tobi'), findsOneWidget);

    await tester.tap(find.text('Amara'));
    await tester.pumpAndSettle();
    expect(find.text('Daily limit'), findsOneWidget);

    await tester.tap(find.text('Apps'));
    await tester.pumpAndSettle();
    expect(find.text('TikTok'), findsOneWidget);

    await tester.tap(find.text('Child view'));
    await tester.pumpAndSettle();
    expect(find.text('Family Safety is active'), findsOneWidget);
  });

  testWidgets('settings shows transparency and toggles dark mode', (tester) async {
    final state = FamilyState(now: DateTime(2026, 10, 14, 18));
    await tester.pumpWidget(FamilySafetyApp(state: state));
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Transparency'), findsOneWidget);
    expect(find.textContaining('no hidden or stealth mode'), findsOneWidget);
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(state.themeMode, ThemeMode.dark);
  });

  testWidgets('reports renders charts', (tester) async {
    await tester.pumpWidget(FamilySafetyApp(state: FamilyState(now: DateTime(2026, 10, 14, 18))));
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Weekly screen time'), findsOneWidget);
  });
}
