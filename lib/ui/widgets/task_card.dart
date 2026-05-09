import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../routes/app_routes.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getPriorityColor() {
    switch (task.priority) {
      case 2:
        return Colors.red;
      case 1:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => controller.deleteTask(task),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.TASK_DETAILS, arguments: task),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 6,
                    color: _getPriorityColor(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.toggleTaskStatus(task),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task.isCompleted ? Colors.green : Colors.transparent,
                                    border: Border.all(
                                      color: task.isCompleted ? Colors.green : Colors.grey.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: task.isCompleted
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted ? Colors.grey : null,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  task.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 36),
                              child: Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: task.isCompleted ? Colors.grey : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 36),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  task.dueDate != null 
                                    ? DateFormat('MMM d, yyyy').format(task.dueDate!)
                                    : DateFormat('MMM d').format(task.createdAt),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                                if (task.reminderEnabled) ...[
                                  const SizedBox(width: 12),
                                  Icon(Icons.notifications_active_outlined, size: 14, color: Colors.grey[500]),
                                ],
                                const Spacer(),
                                Text(
                                  _getPriorityText(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _getPriorityColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  String _getPriorityText() {
    switch (task.priority) {
      case 2:
        return 'HIGH';
      case 1:
        return 'MEDIUM';
      default:
        return 'LOW';
    }
  }
}
