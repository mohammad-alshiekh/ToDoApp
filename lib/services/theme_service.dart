import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService extends GetxService {
  static const String _boxName = 'settings';
  static const String _key = 'isDarkMode';
  late Box _box;

  Future<ThemeService> init() async {
    _box = await Hive.openBox(_boxName);
    return this;
  }

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.get(_key, defaultValue: false);

  _saveThemeToBox(bool isDarkMode) => _box.put(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
