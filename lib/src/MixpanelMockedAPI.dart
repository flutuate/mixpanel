import 'MixpanelAPI.dart';

class MixpanelMockedAPI extends MixpanelAPI {
  @override
  void flush() {
    // Do nothing.
  }

  @override
  void track(String eventName, [Map<String, dynamic> properties]) {
    print('$runtimeType.track: {$eventName=$properties}');
  }

  @override
  Future<Map<String, String>> getDeviceInfo() {
    return Future<Map<String, String>>.value(<String, String>{
      '\$android_os': 'Android',
      '\$android_os_version': '5.0.2',
      '\$android_brand': 'generic_x86_64',
      '\$android_model': 'Android SDK built for x86_64',
      '\$android_app_version': '1.0',
      '\$android_app_version_code': '1',
      '\$android_lib_version': '5.6.1',
      '\$android_manufacturer': 'unknown'
    });
  }

  @override
  Future<String> getDistinctId() {
    return Future<String>.value('2345d678-fb90-12b3-4567-8a90e1cdc234');
  }

  @override
  void optInTracking() {
    // Do nothing.
  }

  @override
  void optOutTracking() {
    // Do nothing.
  }

  @override
  void reset() {
    // Do nothing.
  }
}
