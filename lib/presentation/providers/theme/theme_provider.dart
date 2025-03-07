import 'package:dicoding_submission_restaurant/data/datasources/local/theme_local_datasource.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeLocalDatasource _themeLocalDatasource = ThemeLocalDatasource();
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    _getTheme();
  }

  Future<void> _getTheme() async {
    _isDark = await _themeLocalDatasource.getTheme();
    notifyListeners();
  }

  Future<void> setTheme() async {
    _isDark = !_isDark;
    await _themeLocalDatasource.saveTheme(_isDark);
    notifyListeners();
  }
}
