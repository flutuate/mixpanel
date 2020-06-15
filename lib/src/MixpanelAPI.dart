import 'dart:async';
import 'package:flutter/services.dart';

///
/// Core class for interacting with Mixpanel Analytics.
///
/// See native [MixpanelAPI](https://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html)
/// for more information.
class MixpanelAPI {
  
  static const String _pluginName = 'flutuate_mixpanel';

  static const MethodChannel _channel = const MethodChannel(_pluginName);

  final String instanceId;

  MixpanelAPI(this.instanceId);

  ///
  /// Get the instance of native MixpanelAPI associated with your Mixpanel project
  /// [token].
  ///
  /// If you need test your application, set [mocked] as ```true```. See [MixpanelMockedAPI].
  ///
  /// See native [Mixpanel.getInstance](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#getInstance-android.content.Context-java.lang.String-boolean-)
  /// for more information.
  static Future<MixpanelAPI> getInstance(String token,
      {bool optOutTrackingDefault}) async {

    Map<String, dynamic> properties = <String, dynamic>{'token': token};

    if (optOutTrackingDefault != null)
      properties['optOutTrackingDefault'] = optOutTrackingDefault;

    String name =
        await _channel.invokeMethod<String>('getInstance', properties);

    return new MixpanelAPI(name);
  }

  ///
  /// Push all queued Mixpanel events to Mixpanel servers.
  ///
  /// See native [Mixpanel.flush](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#flush--)
  /// for more information.
  void flush() {
    _channel.invokeMethod<void>('flush');
  }

  ///
  /// Track an event.
  ///
  /// See native [Mixpanel.track](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#track-java.lang.String-org.json.JSONObject-)
  /// and [Mixpanel.trackMap](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#trackMap-java.lang.String-java.util.Map-)
  /// for more information.
  void track(String eventName, [Map<String, dynamic> properties]) {
    _channel.invokeMethod<void>('track',
        <String, dynamic>{'eventName': eventName, 'properties': properties});
  }

  ///
  /// Returns an unmodifiable map that contains the device description properties that will be sent to Mixpanel.
  ///
  /// See native [Mixpanel.getDeviceInfo](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#getDeviceInfo--)
  /// for more information.
  Future<Map<String, String>> getDeviceInfo() async {
    Map result = await _channel.invokeMethod<Map>('getDeviceInfo');
    Map<String, String> devInfo = {};
    for (dynamic key in result.keys) {
      devInfo[key as String] = result[key] as String;
    }
    return devInfo;
  }

  ///
  /// Returns the string id currently being used to uniquely identify the user
  /// associated with events sent using [track].
  ///
  /// See native [Mixpanel.getDistinctId](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#getDistinctId--)
  /// for more information.
  Future<String> getDistinctId() async {
    return await _channel.invokeMethod<String>('getDistinctId');
  }

  ///
  /// Associate all future calls to [track] with the user identified by the
  /// given distinct id.
  ///
  /// See native [Mixpanel.identify](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#identify-java.lang.String-)
  /// for more information.
  void identify(String distinctId) {
    _channel.invokeMethod<void>('identify');
  }

  ///
  /// Use this method to opt-in an already opted-out user from tracking.
  ///
  /// See native [Mixpanel.optInTracking](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#optInTracking--)
  /// for more information.
  void optInTracking() {
    _channel.invokeMethod<void>('optInTracking');
  }

  ///
  /// Use this method to opt-out a user from tracking.
  ///
  /// See native [Mixpanel.optOutTracking](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#optOutTracking--)
  /// for more information.
  void optOutTracking() {
    _channel.invokeMethod<void>('optOutTracking');
  }

  ///
  /// Clears tweaks and all distinct_ids, superProperties, and push registrations
  /// from persistent storage.
  ///
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void reset() {
    _channel.invokeMethod<void>('reset');
  }
}
