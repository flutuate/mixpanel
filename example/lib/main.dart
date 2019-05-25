import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';

import 'Secrets.dart';

void main() => runApp(MyApp());

class MyApp
extends StatefulWidget
{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState
extends State<MyApp>
{
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

    //TODO Before run, you must to inform your Mixpanel token in the file 'resources/secrets.json'.

    Secrets.load().then((secrets) {
      if( secrets != null ) {
        _mixpanelToken = secrets.mixpanelToken;
        MixpanelAPI.getInstance(_mixpanelToken).then((mixpanel) {
          setState(() {
            _mixpanel = mixpanel;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutuate.io Mixpanel Plugin Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>
            [
              //(_mixpanelToken == null || _mixpanelToken.trim().length == 0)
              (_mixpanelToken != null && _mixpanelToken.trim().length > 0)
                ? Text('Your Mixpanel Token was not informed')
                : RaisedButton(
                    child: Text('Press me to track an event'),
                    onPressed: () => trackEvent(),
                  ),
            ],
          )
        ),
      ),
    );
  }

  void trackEvent() {
    Map<String,String> properties = {
      "Button Pressed": "A button was pressed"
    };
    _mixpanel.track('Flutuate.io Mixpanel Plugin Event', properties );
  }

}
	