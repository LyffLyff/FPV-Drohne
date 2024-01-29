import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  loadSavedText(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key) ?? "";
    } catch (e) {
      Logging.error(e);
    }
    return "";
  }

  saveText(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setString(key, value);
    Logging.info("Shared Prefs: $success, $key : $value");
  }
}
