import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Bottom navigation bar used on Home / Food / Workout / Progress screens.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_rounded), label: 'Food'),
        BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded), label: 'Workout'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
      ],
    );
  }
}

/// Circular progress ring with a percentage/value in the center.
class ProgressRing extends StatelessWidget {
  final double percent; // 0..1
  final double size;
  final double strokeWidth;
  final Widget? centerChild;
  final Color color;

  const ProgressRing({
    super.key,
    required this.percent,
    this.size = 180,
    this.strokeWidth = 14,
    this.centerChild,
    this.color = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              percent: percent.clamp(0, 1),
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final double strokeWidth;
  final Color color;

  _RingPainter({
    required this.percent,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * percent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}

/// A rounded dark card, the base building block of most screens.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: card,
    );
  }
}

/// Small stat card used on Home dashboard (icon + label + value + bar).
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double? progress; // 0..1, optional linear bar
  final String? progressLabel;
  final Color? progressColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.progress,
    this.progressLabel,
    this.progressColor = AppColors.green,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight)),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress!.clamp(0, 1),
                minHeight: 6,
                backgroundColor: const Color(0xFF2A2A2A),
                valueColor: const AlwaysStoppedAnimation(AppColors.green),
              ),
            ),
            if (progressLabel != null) ...[
              const SizedBox(height: 4),
              Text(progressLabel!,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
            ]
          ] else ...[
            const SizedBox(height: 14),
          ]
        ],
      ),
    );
  }
}

/// A green pill quick-add chip used in several screens.
class QuickAddChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const QuickAddChip({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.green,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ),
    );
  }
}

Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight)),
    );

/// Generic confirmation dialog helper.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool danger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel,
              style: TextStyle(
                  color: danger ? AppColors.danger : AppColors.green)),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> editNumberDialog(
  BuildContext context, {
  required String title,
  required String initialValue,
  required String suffix,
  required ValueChanged<String> onSave,
  TextInputType keyboardType = const TextInputType.numberWithOptions(),
}) async {
  final controller = TextEditingController(text: initialValue);
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: true,
        decoration: InputDecoration(suffixText: suffix),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: const Text('Save', style: TextStyle(color: AppColors.green)),
        ),
      ],
    ),
  );
  if (result != null && result.isNotEmpty) onSave(result);
}
