import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MixpanelAPI _mixpanel;

  String _mixpanelToken;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
/*
    /// ATTENTION: Before run, you must to inform your Mixpanel token in the file 'resources/secrets.json'.

    Secrets.load().then((secrets) {
      if (secrets != null) {
        _mixpanelToken = secrets.mixpanelToken;
        MixpanelAPI.getInstance(_mixpanelToken).then((mixpanel) {
          setState(() {
            _mixpanel = mixpanel;
          });
        });
      }
    });*/
    
    /// ATTENTION: Before run, you must to inform your Mixpanel token in environment variable called 'mixpanel_token'.
    var envVars = Platform.environment;
    _mixpanelToken = envVars['mixpanel_token'];
    MixpanelAPI.getInstance(_mixpanelToken).then((mixpanel) {
      setState(() {
        _mixpanel = mixpanel;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons;
    if (_mixpanelToken == null || _mixpanelToken.trim().length == 0) {
      buttons = [Text('Your Mixpanel Token was not informed')];
    } else {
      buttons = [
        RaisedButton(
            child: Text('Press me to track an event'),
            onPressed: () => trackEvent()),
        RaisedButton(
            child: Text('Press me to get device info'),
            onPressed: () => getDeviceInfo()),
        RaisedButton(
            child: Text('Press me to get distinct id'),
            onPressed: () => getDistinctId())
      ];
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutuate.io Mixpanel Plugin Example App'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
        )),
      ),
    );
  }

  void trackEvent() {
    Map<String, String> properties = {"Button Pressed": "A button was pressed"};
    _mixpanel.track('Flutuate.io Mixpanel Plugin Event', properties);
  }

  void getDeviceInfo() async {
    Map<String, String> devInfo = await _mixpanel.getDeviceInfo();
    print(devInfo);
  }

  void getDistinctId() async {
    String distinctId = await _mixpanel.getDistinctId();
    print(distinctId);
  }
}
