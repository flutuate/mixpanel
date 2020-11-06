import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:flutuate_mixpanel/src/IMixpanelServices.dart';
import 'package:flutuate_mixpanel/src/models/DataProperties.dart';

import 'IIngestionApi.dart';
import 'IngestionApi.dart';

MethodChannel _channel;

/// A web implementation of the FlutuateMixpanel plugin.
class FlutuateMixpanelPluginWeb implements IMixpanelServices
{
  static void registerWith(Registrar registrar) {
    _channel = MethodChannel(
      MixpanelAPI.pluginName,
      const StandardMethodCodec(),
      registrar.messenger,
    );

    final pluginInstance = FlutuateMixpanelPluginWeb();

    _channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  static FlutuateMixpanelPluginWeb? _instance = FlutuateMixpanelPluginWeb._('');

  final String _token;

  final IIngestionApi ingestionApi;

  FlutuateMixpanelPluginWeb._(this._token)
      : ingestionApi = IngestionApi(_token)
      ;

  bool get isValid => _token.trim().isNotEmpty;

  ///
  /// Get the instance of native MixpanelAPI associated with your Mixpanel project
  /// [token].
  ///
  /// See native [Mixpanel.getInstance](http://mixpanel.github.io/mixpanel-android/com/mixpanel/android/mpmetrics/MixpanelAPI.html#getInstance-android.content.Context-java.lang.String-boolean-)
  /// for more information.
  static Future<IMixpanelServices> getInstance(String token, bool optOutTrackingDefault) async {
    if( !_instance.isValid ) {
      return _instance;
    }

    var properties = DataProperties(token);

    if (optOutTrackingDefault != null) {
      properties['optOutTrackingDefault'] = optOutTrackingDefault;
    }

    var name = await channel.invokeMethod<String>('getInstance', properties);

    return FlutuateMixpanelPluginWeb._(_channel, token);

    return MixpanelAPI.getInstanceUsingChannel(token, optOutTrackingDefault, _channel);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'flutuate_mixpanel for web doesn\'t implement \'${call.method}\'',
        );
    }
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

}

