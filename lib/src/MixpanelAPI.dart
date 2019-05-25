import 'dart:async';
import 'package:flutter/services.dart';

import 'MixpanelMockedAPI.dart';

class MixpanelAPI
{
  static const String _pluginName = "flutuate.io/plugins/mixpanel";

  static const MethodChannel _channel = const MethodChannel(_pluginName);

  static Future<MixpanelAPI> getInstance(String token, {bool mocked=false}) async {
    if( mocked) {
      return new MixpanelMockedAPI();
    }

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

