import 'dart:async';
import 'package:flutter/services.dart';

import 'MixpanelMockedAPI.dart';

///
/// Core class for interacting with Mixpanel Analytics.
///
/// See native [MixpanelAPI](https://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html)
/// for more information.
///
class MixpanelAPI {
  static const String _pluginName = 'flutuate.io/plugins/mixpanel';

  static const MethodChannel _channel = const MethodChannel(_pluginName);

  ///
  /// Get the instance of native MixpanelAPI associated with your Mixpanel project
  /// [token].
  ///
  /// Use [getInstance] to get a reference to a shared instance of MixpanelAPI
  /// you can use to send events to Mixpanel.
  ///
  /// The [optOutTrackingDefault] parameters, determines whether or not Mixpanel
  /// can start tracking by default. See [optOutTracking].
  ///
  /// If you need test your application, set [mocked] as ```true```. See [MixpanelMockedAPI].
  ///
  static Future<MixpanelAPI> getInstance(String token,
      {bool optOutTrackingDefault, mocked = false}) async {
    if (mocked) {
      return new MixpanelMockedAPI();
    }

    Map<String, dynamic> properties = <String, dynamic>{'token': token};

    if (optOutTrackingDefault != null)
      properties['optOutTrackingDefault'] = optOutTrackingDefault;

    await _channel.invokeMethod<int>('getInstance', properties);

    return new MixpanelAPI();
  }

  void flush() {
    _channel.invokeMethod<void>('flush');
  }

  void track(String eventName, Map<String, dynamic> properties) {
    _channel.invokeMethod<void>('track',
        <String, dynamic>{'eventName': eventName, 'properties': properties});
  }

  Future<Map<String, String>> getDeviceInfo() async {
    Map result = await _channel.invokeMethod<Map>('getDeviceInfo');
    Map<String, String> devInfo = {};
    for (dynamic key in result.keys) {
      devInfo[key as String] = result[key] as String;
    }
    return devInfo;
  }

  Future<String> getDistinctId() async {
    return await _channel.invokeMethod<String>('getDistinctId');
  }

  void optInTracking() {
    _channel.invokeMethod<void>('optInTracking');
  }

  void optOutTracking() {
    _channel.invokeMethod<void>('optOutTracking');
  }

  void reset() {
    _channel.invokeMethod<void>('reset');
  }
}
