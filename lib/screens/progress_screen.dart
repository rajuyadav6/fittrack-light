import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/shared_widgets.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _range = 0; // 0 = Week, 1 = Month, 2 = All

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    // Water/Protein bar charts always show last 7 days (matches design);
    // "Month"/"All" widen the weight trend line instead.
    final waterData = app.weeklyWaterLiters();
    final proteinData = app.weeklyProteinGrams();
    final days = lastNDays(7);

    var weightHistory = app.weightHistory();
    if (_range == 0) {
      final start = DateTime.now().subtract(const Duration(days: 7));
      weightHistory = weightHistory.where((e) => e.key.isAfter(start)).toList();
    } else if (_range == 1) {
      final start = DateTime.now().subtract(const Duration(days: 30));
      weightHistory = weightHistory.where((e) => e.key.isAfter(start)).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text('Small Steps. Big Results.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                _RangeBtn(
                    label: 'Week',
                    selected: _range == 0,
                    onTap: () => setState(() => _range = 0)),
                const SizedBox(width: 8),
                _RangeBtn(
                    label: 'Month',
                    selected: _range == 1,
                    onTap: () => setState(() => _range = 1)),
                const SizedBox(width: 8),
                _RangeBtn(
                    label: 'All',
                    selected: _range == 2,
                    onTap: () => setState(() => _range = 2)),
              ],
            ),
            const SizedBox(height: 22),
            sectionTitle('Water Intake (L)'),
            AppCard(
              child: SizedBox(
                height: 160,
                child: BarChart(BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                              v.toInt() < days.length
                                  ? weekdayShort(days[v.toInt()])
                                  : '',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted)),
                        ),
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    waterData.length,
                    (i) => BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: waterData[i],
                        color: AppColors.blue,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ]),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 20),
            sectionTitle('Protein Intake (g)'),
            AppCard(
              child: SizedBox(
                height: 160,
                child: BarChart(BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                              v.toInt() < days.length
                                  ? weekdayShort(days[v.toInt()])
                                  : '',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted)),
                        ),
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    proteinData.length,
                    (i) => BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: proteinData[i],
                        color: AppColors.green,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ]),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 20),
            sectionTitle('Weight (kg)'),
            AppCard(
              child: SizedBox(
                height: 160,
                child: weightHistory.isEmpty
                    ? const Center(
                        child: Text('No weight logged yet',
                            style: TextStyle(color: AppColors.textMuted)))
                    : LineChart(LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: AppColors.green,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            spots: List.generate(
                              weightHistory.length,
                              (i) => FlSpot(
                                  i.toDouble(), weightHistory[i].value),
                            ),
                          ),
                        ],
                      )),
              ),
            ),
            if (weightHistory.isNotEmpty) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Latest: ${weightHistory.last.value.toStringAsFixed(1)} kg on ${DateFormat('d MMM').format(weightHistory.last.key)}',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        Text('${app.workoutConsistencyThisWeek} / 7',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        const Text('This Week',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_fire_department_rounded,
                                color: AppColors.orange, size: 20),
                            const SizedBox(width: 4),
                            Text('${app.dayStreak}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textLight)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Day Streak',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RangeBtn(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              style: TextStyle(
                  color: selected ? Colors.black : AppColors.textMuted,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
