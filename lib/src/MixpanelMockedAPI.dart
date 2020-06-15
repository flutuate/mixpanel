import 'MixpanelAPI.dart';

///
/// Core class to emulate the functionalities of the Mixpanel Analytics.
///
/// See [Mixpanel] wrapper and [native MixpanelAPI](https://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html)
/// for more information.
class MixpanelMockedAPI extends MixpanelAPI {
  MixpanelMockedAPI() : super(null);

  /// Do nothing.
  @override
  void flush() {}

  /// Prints to console the [eventName] and [properties].
  @override
  void track(String eventName, [Map<String, dynamic> properties]) {
    print('$runtimeType.track: {$eventName=$properties}');
  }

  /// Returns a mocked [Map] with information about a fictitious device.
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

  /// Returns a fictitious id.
  @override
  Future<String> getDistinctId() {
    return Future<String>.value('2345d678-fb90-12b3-4567-8a90e1cdc234');
  }

  /// Do nothing.
  @override
  void identify(String distinctId) {}

  /// Do nothing.
  @override
  void optInTracking() {}

  /// Do nothing.
  @override
  void optOutTracking() {}

  /// Do nothing.
  @override
  void reset() {}
}
