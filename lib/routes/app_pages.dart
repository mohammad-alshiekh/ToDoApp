import 'package:get/get.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/add_task_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ADD_TASK,
      page: () => const AddTaskScreen(),
      transition: Transition.cupertino,
    ),
  ];
}
