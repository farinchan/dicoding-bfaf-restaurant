import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDatasource {
  String _keyTheme = 'isDark';

  Future<void> saveTheme(bool isDark) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(_keyTheme, isDark);
  }

  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_keyTheme) ?? false;
  }
}
