import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/providers/hive_service.dart';
import 'services/theme_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'ui/themes/app_theme.dart';
import 'utils/app_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();
  Get.put(hiveService);

  // Initialize Theme Service
  final themeService = await ThemeService().init();
  Get.put(themeService);

  runApp(const ToDoAlp());
}

class ToDoAlp extends StatelessWidget {
  const ToDoAlp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return GetMaterialApp(
      title: 'ToDoAlp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.theme,
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
    );
  }
}
