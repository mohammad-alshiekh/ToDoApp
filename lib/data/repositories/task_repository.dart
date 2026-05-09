import '../models/task_model.dart';
import '../providers/hive_service.dart';

class TaskRepository {
  final HiveService _hiveService;

  TaskRepository(this._hiveService);

  List<Task> getTasks() {
    return _hiveService.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    await _hiveService.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _hiveService.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await _hiveService.deleteTask(task);
  }
}
