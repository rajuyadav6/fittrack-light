import 'package:fittrack_light/screens/edit_goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'root_shell.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _getStarted(BuildContext context) async {
    final onboarded = context.read<AppProvider>().hasOnboarded;

    if (onboarded) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const EditGoalsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_rounded,
                    color: AppColors.green, size: 46),
              ),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight),
                  children: [
                    TextSpan(text: 'FitTrack '),
                    TextSpan(
                        text: 'Light',
                        style: TextStyle(color: AppColors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Track Today\nBuild A Better You',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 15),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _getStarted(context),

                  // onPressed: () async {
                  //   await context.read<AppProvider>().completeOnboarding();
                  //   if (context.mounted) {
                  //     print('context.mounted splash ${context.mounted}');
                  //     Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(builder: (_) => const RootShell()),
                  //     );
                  //   }
                  // },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Simple Tracking. Real Progress.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
