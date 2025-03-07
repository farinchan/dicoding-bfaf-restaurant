import 'package:shared_preferences/shared_preferences.dart';

class ReminderLocalDataSource {
  String _reminderKey = 'isAlarmOn';

  Future<bool> getReminderPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reminderKey) ?? false;
  }

  Future<void> setReminderPreference(bool isOn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, isOn);
  }
}
