import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../controllers/task_controller.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: Obx(() {
        final tasks = taskController.tasks;
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('No data available'),
              ],
            ),
          );
        }

        final completed = tasks.where((t) => t.isCompleted).length;
        final pending = tasks.length - completed;
        final highPriority = tasks.where((t) => t.priority == 2).length;
        final mediumPriority = tasks.where((t) => t.priority == 1).length;
        final lowPriority = tasks.where((t) => t.priority == 0).length;

        // Category distribution
        final Map<String, int> categories = {};
        for (var task in tasks) {
          categories[task.category] = (categories[task.category] ?? 0) + 1;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Overall Progress'),
              const SizedBox(height: 16),
              _buildProgressCard(context, completed, tasks.length),
              const SizedBox(height: 32),
              _buildSectionTitle('Priority Breakdown'),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPriorityStat(context, 'High', highPriority, Colors.red),
                  _buildPriorityStat(context, 'Medium', mediumPriority, Colors.orange),
                  _buildPriorityStat(context, 'Low', lowPriority, Colors.blue),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Categories'),
              const SizedBox(height: 16),
              ...categories.entries.map((entry) => _buildCategoryRow(context, entry.key, entry.value, tasks.length)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ).animate().fadeIn().slideX();
  }

  Widget _buildProgressCard(BuildContext context, int completed, int total) {
    final percent = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 12.0,
            percent: percent,
            center: Text(
              "${(percent * 100).toInt()}%",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$completed Tasks Done',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '$total Total Tasks',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale();
  }

  Widget _buildPriorityStat(BuildContext context, String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildCategoryRow(BuildContext context, String category, int count, int total) {
    final percent = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$count tasks', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percent,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            progressColor: Theme.of(context).colorScheme.primary,
            barRadius: const Radius.circular(10),
            animation: true,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}
