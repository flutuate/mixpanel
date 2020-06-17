import 'package:flutter_driver/driver_extension.dart';
import 'package:flutuate_mixpanel_example/main.dart' as app;

/// Set your Mixpanel token here before run the flutter driver tests.
const YOUR_MIXPANEL_TOKEN = null;

void main() {
  enableFlutterDriverExtension();

  app.main([YOUR_MIXPANEL_TOKEN]);
}
