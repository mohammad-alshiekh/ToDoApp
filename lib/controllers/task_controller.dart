import 'package:get/get.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../services/notification_service.dart';

class TaskController extends GetxController {
  final TaskRepository _repository;
 // final NotificationService _notificationService = Get.find<NotificationService>();

  TaskController(this._repository);

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;
  
  // Search and Filter
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxInt selectedPriority = (-1).obs; // -1 for All

  final RxList<Task> filteredTasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    
    // Setup listeners for filtering
    everAll([tasks, searchQuery, selectedCategory, selectedPriority], (_) => _applyFilters());
  }

  void loadTasks() {
    isLoading.value = true;
    try {
      tasks.assignAll(_repository.getTasks());
      _sortTasks();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var filtered = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'All' || task.category == selectedCategory.value;
      
      final matchesPriority = selectedPriority.value == -1 || task.priority == selectedPriority.value;

      return matchesSearch && matchesCategory && matchesPriority;
    }).toList();
    
    filteredTasks.assignAll(filtered);
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  Future<void> addTask({
    required String title,
    String description = '',
    int priority = 1,
    String category = 'General',
    DateTime? dueDate,
    bool reminderEnabled = false,
  }) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      priority: priority,
      category: category,
      dueDate: dueDate,
      reminderEnabled: reminderEnabled,
    );
    await _repository.addTask(newTask);
    tasks.insert(0, newTask);
    
    if (newTask.reminderEnabled) {
    ///  await _notificationService.scheduleNotification(newTask);
    }
    
    _sortTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _repository.updateTask(task);
    
    if (task.isCompleted) {
   //   await _notificationService.cancelNotification(task);
    } else if (task.reminderEnabled) {
    //  await _notificationService.scheduleNotification(task);
    }
    
    tasks.refresh();
    _sortTasks();
  }

  Future<void> deleteTask(Task task) async {
    await _repository.deleteTask(task);
   // await _notificationService.cancelNotification(task);
    tasks.remove(task);
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    
    if (task.reminderEnabled && !task.isCompleted) {
     // await _notificationService.scheduleNotification(task);
    } else {
    //  await _notificationService.cancelNotification(task);
    }
    
    tasks.refresh();
    _sortTasks();
  }
}
