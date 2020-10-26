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
  final People _people = People._(_channel);

  ///Accessor to the Mixpanel People API object
  People get people => _people;

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
  /// Register Super Properties.
  ///
  /// See native [Mixpanel.registerSuperProperties](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#registerSuperProperties-org.json.JSONObject-)
  /// for more information.
  void registerSuperProperties([Map<String, dynamic> properties]) {
    _channel.invokeMethod<void>(
        'registerSuperProperties', <String, dynamic>{'properties': properties});
  }

  ///
  /// Register Super Properties Once.
  ///
  /// See native [Mixpanel.registerSuperPropertiesOnce](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#registerSuperPropertiesOnce-org.json.JSONObject-)
  /// for more information.
  void registerSuperPropertiesOnce([Map<String, dynamic> properties]) {
    _channel.invokeMethod<void>('registerSuperPropertiesOnce',
        <String, dynamic>{'properties': properties});
  }

  ///
  /// Erase all currently registered superProperties.
  ///
  /// See native [Mixpanel.clearSuperProperties](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#clearSuperProperties--)
  /// for more information.
  void clearSuperProperties([Map<String, dynamic> properties]) {
    _channel.invokeMethod<void>('clearSuperProperties');
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
    _channel.invokeMethod<void>('identify', {'distinctId': distinctId});
  }

  ///
  /// The alias method creates an alias which Mixpanel will use to remap one id to another.
  /// Multiple aliases can point to the same identifier.
  ///
  /// See native [Mixpanel.alias](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#alias-java.lang.String-java.lang.String-)
  /// for more information.
  void alias(String alias, String distinctId) {
    _channel.invokeMethod<void>(
        'alias', {'alias': alias, 'distinctId': distinctId});
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

class People {
  final MethodChannel _channel;

  People._(this._channel);

  /// Register the given device to receive push notifications.
  ///
  /// This will associate the device token with the current user in Mixpanel People,
  /// which will allow you to send push notifications to the user from the Mixpanel
  /// People web interface.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void addPushDeviceToken(String token) {
    _channel.invokeMapMethod("people", {
      "method": "addPushDeviceToken",
      "params": {"token": token}
    });
  }

  ///Unregister the given device to receive push notifications.
  ///
  /// This will unset all of the push tokens saved to this people profile. This is useful
  /// in conjunction with a call to `reset`, or when a user is logging out.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  ///
  void removeAllPushDeviceTokens() {
    _channel.invokeMapMethod("people", {
      "method": "removeAllPushDeviceTokens",
    });
  }

  ///Unregister a specific device token from the ability to receive push notifications.
  ///
  /// This will remove the provided push token saved to this people profile. This is useful
  /// in conjunction with a call to `reset`, or when a user is logging out.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void removePushDeviceToken(String token) {
    _channel.invokeMapMethod("people", {
      "method": "removePushDeviceToken",
      "params": {"token": token}
    });
  }

  ///Set properties on the current user in Mixpanel People.
  ///
  /// The properties will be set on the current user.
  /// Property keys must be String objects and the supported value types need to conform to MixpanelType.
  /// You can override the current project token and distinct Id by
  /// including the special properties: $token and $distinct_id. If the existing
  /// user record on the server already has a value for a given property, the old
  /// value is overwritten. Other existing properties will not be affected.

  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void set(Map<String, dynamic> properties) {
    _channel.invokeMapMethod("people", {
      "method": "set",
      "params": properties,
    });
  }

  ///Convenience method for setting a single property in Mixpanel People.
  ///
  /// Property keys must be String objects and the supported value types need to conform to MixpanelType.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void setProperty(String name, dynamic value) {
    set({name: value});
  }

  /// Set properties on the current user in Mixpanel People, but doesn't overwrite if
  /// there is an existing value.
  //
  /// This method is identical to `set:` except it will only set
  /// properties that are not already set. It is particularly useful for collecting
  /// data about the user's initial experience and source, as well as dates
  /// representing the first time something happened.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void setOnce(Map<String, dynamic> properties) {
    _channel.invokeMapMethod("people", {
      "method": "setOnce",
      "params": properties,
    });
  }

  /// Remove a list of properties and their values from the current user's profile
  /// in Mixpanel People.
  ///
  /// The properties array must ony contain String names of properties. For properties
  /// that don't exist there will be no effect.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void unset(List<String> properties) {
    _channel.invokeMapMethod("people", {
      "method": "unset",
      "params": {"names": properties},
    });
  }

  /// Increment the given numeric properties by the given values.
  ///
  /// Property keys must be String names of numeric properties. A property is
  /// numeric if its current value is a number. If a property does not exist, it
  /// will be set to the increment amount. Property values must be number objects.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void increment(Map<String, dynamic> properties) {
    _channel.invokeMapMethod("people", {
      "method": "increment",
      "params": properties,
    });
  }

  /// Convenience method for incrementing a single numeric property by the specified
  /// amount.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void incrementBy(String property, double value) {
    _channel.invokeMapMethod("people", {
      "method": "incrementBy",
      "params": {"property": property, "by": value},
    });
  }

  /// Append values to list properties.
  ///
  /// Property keys must be String objects and the supported value types need to conform to MixpanelType.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void append(Map<String, dynamic> properties) {
    _channel.invokeMapMethod("people", {
      "method": "append",
      "params": properties,
    });
  }

  /// Removes list properties.
  ///
  /// Property keys must be String objects and the supported value types need to conform to MixpanelType.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void remove(Map<String, dynamic> properties) {
    _channel.invokeMapMethod("people", {
      "method": "remove",
      "params": properties,
    });
  }

  /// Track money spent by the current user for revenue analytics and associate
  /// properties with the charge. Properties is optional.
  ///
  /// Charge properties allow you to segment on types of revenue. For instance, you
  /// could record a product ID with each charge so that you could segement on it in
  /// revenue analytics to see which products are generating the most revenue.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void trackCharge(double ammount, {Map<String, dynamic> properties}) {
    _channel.invokeMapMethod("people", {
      "method": "trackCharge",
      "params": {"ammount": ammount, "properties": properties},
    });
  }

  /// Delete current user's revenue history.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void clearCharges() {
    _channel.invokeMapMethod("people", {
      "method": "clearCharges",
    });
  }

  /// Delete current user's record from Mixpanel People.
  /// See native [Mixpanel.reset](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#reset--)
  /// for more information.
  void deleteUser() {
    _channel.invokeMapMethod("people", {
      "method": "deleteUser",
    });
  }
}
