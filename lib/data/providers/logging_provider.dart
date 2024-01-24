import 'package:logger/logger.dart';

class Logging {
  static final Logger _log = Logger();

  static void info(String msg) {
    _log.i("INFO: $msg");
  }

  static void error(String msg, {bool fatal = false}) {
    if (!fatal) {
      _log.e("ERROR: $msg");
    } else {
      _log.f("FATAL ERROR: $msg");
    }
  }

  static void debug(String msg) {
    _log.d("DEBUG: $msg");
  }

  static void warning(String msg) {
    _log.w("WARNING: $msg");
  }
}
