import 'package:flutter/services.dart';

void defaultAppSettings() {
  // OS Navigation
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Prevent turning phone
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
