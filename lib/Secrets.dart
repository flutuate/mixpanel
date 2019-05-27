import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class Secrets {
  final String mixpanelToken;

  Secrets({this.mixpanelToken = ''});

  factory Secrets._fromJson(Map<String, dynamic> jsonMap) {
    return new Secrets(mixpanelToken: jsonMap['mixpanel_token']);
  }

  static Future<Secrets> load({bool inUnitTest = false}) {
    if (inUnitTest) {
      return loadFromFile();
    }
    return rootBundle.loadStructuredData<Secrets>('resources/secrets.json',
        (jsonStr) async {
      return Secrets._fromJson(json.decode(jsonStr));
    });
  }

  static Future<Secrets> loadFromFile() {
    File file = new File('test/resources/secrets.json');
    if (!file.existsSync()) {
      file = new File('resources/secrets.json');
    }
    final String content = file.readAsStringSync();
    final Map map = json.decode(content);
    return Future<Secrets>.value(Secrets._fromJson(map));
  }
}
