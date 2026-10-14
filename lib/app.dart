import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_shell.dart';
import 'state/family_state.dart';
import 'theme/app_theme.dart';

class FamilySafetyApp extends StatelessWidget {
  const FamilySafetyApp({super.key, this.state});
  final FamilyState? state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FamilyState>(
      create: (_) => state ?? FamilyState(),
      child: Consumer<FamilyState>(
        builder: (context, s, _) => MaterialApp(
          title: 'Family Safety',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: s.themeMode,
          home: const HomeShell(),
        ),
      ),
    );
  }
}
