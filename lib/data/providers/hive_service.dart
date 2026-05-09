import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class HiveService {
  static const String taskBoxName = 'tasks';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(taskBoxName);
  }

  Box<Task> getTaskBox() {
    return Hive.box<Task>(taskBoxName);
  }

  Future<void> addTask(Task task) async {
    final box = getTaskBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  List<Task> getAllTasks() {
    return getTaskBox().values.toList();
  }
}
