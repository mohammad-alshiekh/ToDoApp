import 'package:get/get.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository;

  TaskController(this._repository);

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    isLoading.value = true;
    try {
      tasks.assignAll(_repository.getTasks());
      // Sort tasks: Incomplete first, then by priority (High to Low), then by date
      _sortTasks();
    } finally {
      isLoading.value = false;
    }
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

  Future<void> addTask(String title, String description, int priority) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      priority: priority,
    );
    await _repository.addTask(newTask);
    tasks.insert(0, newTask);
    _sortTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _repository.updateTask(task);
    tasks.refresh();
    _sortTasks();
  }

  Future<void> deleteTask(Task task) async {
    await _repository.deleteTask(task);
    tasks.remove(task);
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    tasks.refresh();
    _sortTasks();
  }
}
