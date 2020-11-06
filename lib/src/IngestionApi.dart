import 'dart:convert';

import 'package:flutuate_mixpanel/src/IIngestionApi.dart';
import 'package:flutuate_mixpanel/src/models/DataProperties.dart';
/// https://developer.mixpanel.com/reference/events

import 'package:http/http.dart';
import 'models/EventData.dart';
import 'network.dart';

typedef NewHttpClientInstance = BaseClient Function();

class IngestionApi implements IIngestionApi
{
  final String _apiurl = 'https://api.mixpanel.com/track';

  final DataProperties _dataProperties;

  IngestionApi(String token)
      : _dataProperties = DataProperties(token);

  /// https://developer.mixpanel.com/reference/events#track-event
  Future<Response> trackEvent(EventData data, {bool useIncomingIp=false, bool verbose=false,
      String redirectTo='', bool img=false, String callback=''}) async {
    final headers = <String,String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final url = _buildUrl('#live-event');

    final client = newSelfSignedHttpClient();

    final timeout = const Duration(seconds: 30);

    final params = {
      'data': json.encode(data),
      'ip': useIncomingIp ? 1 : 0,
      'verbose': verbose ? 1 : 0,
      'redirect': redirectTo,
      'img': img ? 1 : 0,
      'callback': callback
    };

    final response = client.post( url,
      headers: headers,
      body:params,
    ).timeout(timeout);

    return response;
  }

  Uri _buildUrl([String endpoint='']) {
    if( endpoint.isEmpty ) {
      return Uri.parse(_apiurl);
    }
    return Uri.parse('$_apiurl/$endpoint');
  }

  @override
  void track(String eventName, [Map<String, dynamic> properties = EmptyMap]) {
    // TODO: implement track
  }
}

