import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

class ProgressCard extends StatelessWidget {
  final double tasksProgress;
  final int completedTasks;
  final int totalTasks;
  final String focusTime;

  const ProgressCard({
    super.key,
    required this.tasksProgress,
    required this.completedTasks,
    required this.totalTasks,
    required this.focusTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Daily Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Progress stats
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressItem(
                        context,
                        Icons.task_alt,
                        'Tasks Done',
                        '$completedTasks of $totalTasks',
                        tasksProgress,
                      ),
                      const SizedBox(height: 16),
                      _buildProgressItem(
                        context,
                        Icons.timer,
                        'Focus Time',
                        focusTime,
                        0.7,
                      ),
                      const SizedBox(height: 16),
                      _buildProgressItem(
                        context,
                        Icons.psychology,
                        'Productivity Score',
                        '87%',
                        0.87,
                      ),
                    ],
                  ),
                ),
                
                // Chart
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 120,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 1,
                        maxX: 7,
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(1, 3),
                              FlSpot(2, 2),
                              FlSpot(3, 5),
                              FlSpot(4, 3.1),
                              FlSpot(5, 4),
                              FlSpot(6, 3),
                              FlSpot(7, 4),
                            ],
                            isCurved: true,
                            color: AppColors.lightBlue,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.lightBlue.withOpacity(0.2),
                            ),
                          )
                        ],
                      ),
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

  Widget _buildProgressItem(
    BuildContext context,
    IconData icon, 
    String label, 
    String value, 
    double progress,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 