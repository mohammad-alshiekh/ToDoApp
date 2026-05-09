import 'package:get/get.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/add_task_screen.dart';
import '../ui/screens/statistics_screen.dart';
import '../ui/screens/task_details_screen.dart';
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
    GetPage(
      name: AppRoutes.STATISTICS,
      page: () => const StatisticsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.TASK_DETAILS,
      page: () => const TaskDetailsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
