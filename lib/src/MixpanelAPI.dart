import 'dart:async';
import 'package:flutter/services.dart';

class MixpanelAPI
{
  static const String _pluginName = "flutuate.io/plugins/mixpanel";

  static const MethodChannel _channel = const MethodChannel(_pluginName);

  static Future<MixpanelAPI> getInstance(String token) async {
    await _channel.invokeMethod<int>('getInstance', <String, dynamic>{
      'token': token
    });
    return new MixpanelAPI();
  }

  void flush() {
    _channel.invokeMethod<void>('flush');
  }

  void track(String eventName, Map<String, dynamic> properties) {
    _channel.invokeMethod<void>('track', <String, dynamic> {
      'eventName': eventName,
      'properties': properties
    });
  }
}
