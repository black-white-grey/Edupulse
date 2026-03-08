import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/paper.dart';

class TrendDashboard extends StatelessWidget {
  final List<Paper> papers;

  const TrendDashboard({super.key, required this.papers});

  Map<String, int> get _categoryDistribution {
    final Map<String, int> dist = {};
    for (var paper in papers) {
      dist[paper.primaryCategory] = (dist[paper.primaryCategory] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distribution = _categoryDistribution;

    if (papers.isEmpty) {
      return const Center(child: Text('No data available for trends.'));
    }

    return Column(
      children: [
        Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: PieChart(
            PieChartData(
              sections: distribution.entries.map((entry) {
                final color = _getColorForCategory(entry.key);
                return PieChartSectionData(
                  color: color,
                  value: entry.value.toDouble(),
                  title: '${entry.value}',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: distribution.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final entry = distribution.entries.elementAt(index);
              final color = _getColorForCategory(entry.key);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      entry.key,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.value} papers',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getColorForCategory(String category) {
    // Generate distinct colors based on the category string
    final hash = category.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.6, 0.5).toColor();
  }
}
