import 'package:fittrack_light/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';
import 'food_screen.dart';
import 'workout_screen.dart';
import 'progress_screen.dart';

/// Hosts the 4 main tabs behind the persistent bottom nav bar, preserving
/// each tab's scroll/state via IndexedStack.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  // int _index = 0;

  final _screens = const [
    HomeScreen(),
    FoodScreen(),
    WorkoutScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      body: IndexedStack(index: app.bnbIndex, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: app.bnbIndex,
        onTap: (i) => app.setBnbIndex(i),
      ),
    );
  }
}
