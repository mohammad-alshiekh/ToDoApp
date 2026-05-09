import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/task_controller.dart';
import '../../data/models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task task;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late int _selectedPriority;
  late String _selectedCategory;
  DateTime? _selectedDate;
  late bool _reminderEnabled;
  bool _isEditing = false;

  final List<String> _categories = ['General', 'Work', 'Personal', 'Shopping', 'Health'];

  @override
  void initState() {
    super.initState();
    task = Get.arguments as Task;
    _titleController.text = task.title;
    _descController.text = task.description;
    _selectedPriority = task.priority;
    _selectedCategory = task.category;
    _selectedDate = task.dueDate;
    _reminderEnabled = task.reminderEnabled;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTask() {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final controller = Get.find<TaskController>();
    final updatedTask = task.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _selectedPriority,
      category: _selectedCategory,
      dueDate: _selectedDate,
      reminderEnabled: _reminderEnabled,
    );

    controller.updateTask(updatedTask);
    setState(() {
      task = updatedTask;
      _isEditing = false;
    });
    Get.snackbar('Success', 'Task updated successfully',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _deleteTask() {
    Get.defaultDialog(
      title: 'Delete Task',
      middleText: 'Are you sure you want to delete this task?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.find<TaskController>().deleteTask(task);
        Get.back(); // Close dialog
        Get.back(); // Go back to home
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEditing) ...[
              _buildReadOnlyField('Title', task.title, Icons.title, isBold: true, fontSize: 24),
              const SizedBox(height: 24),
              _buildReadOnlyField('Description', task.description.isEmpty ? 'No description' : task.description, Icons.description_outlined),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildReadOnlyField('Priority', _getPriorityLabel(_selectedPriority), Icons.priority_high, color: _getPriorityColor(_selectedPriority))),
                  Expanded(child: _buildReadOnlyField('Category', _selectedCategory, Icons.category_outlined)),
                ],
              ),
              const SizedBox(height: 24),
              _buildReadOnlyField('Due Date', _selectedDate == null ? 'No due date' : DateFormat('MMM d, yyyy').format(_selectedDate!), Icons.calendar_today),
              const SizedBox(height: 24),
              _buildReadOnlyField('Reminder', _reminderEnabled ? 'Enabled' : 'Disabled', Icons.notifications_outlined),
            ] else ...[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: const Icon(Icons.edit_note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 20),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 32),
              const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPriorityOption(0, 'Low', Colors.blue),
                  const SizedBox(width: 12),
                  _buildPriorityOption(1, 'Medium', Colors.orange),
                  const SizedBox(width: 12),
                  _buildPriorityOption(2, 'High', Colors.red),
                ],
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => _selectedCategory = cat),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    );
                  },
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: Text(_selectedDate == null ? 'Not set' : DateFormat('MMM d, yyyy').format(_selectedDate!)),
                trailing: TextButton(onPressed: () => _selectDate(context), child: const Text('Change')),
              ).animate().fadeIn(delay: 400.ms),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Reminder'),
                value: _reminderEnabled,
                onChanged: (val) => setState(() => _reminderEnabled = val),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _updateTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ).animate().fadeIn(delay: 600.ms).scale(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon, {bool isBold = false, double fontSize = 16, Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildPriorityOption(int value, String label, Color color) {
    final isSelected = _selectedPriority == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPriority = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? color : Colors.grey.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? color : Colors.grey, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: isSelected ? color : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(int priority) {
    if (priority == 2) return 'High';
    if (priority == 1) return 'Medium';
    return 'Low';
  }

  Color _getPriorityColor(int priority) {
    if (priority == 2) return Colors.red;
    if (priority == 1) return Colors.orange;
    return Colors.blue;
  }
}
