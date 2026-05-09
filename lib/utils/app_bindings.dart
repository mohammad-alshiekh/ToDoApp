import 'package:get/get.dart';
import '../data/providers/hive_service.dart';
import '../data/repositories/task_repository.dart';
import '../controllers/task_controller.dart';
import '../services/theme_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => HiveService());
    Get.lazyPut(() => ThemeService());

    // Repositories
    Get.lazyPut(() => TaskRepository(Get.find<HiveService>()));

    // Controllers
    Get.lazyPut(() => TaskController(Get.find<TaskRepository>()));
  }
}
//my do
