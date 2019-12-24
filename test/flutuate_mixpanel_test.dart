import 'package:flutuate_mixpanel/src/Secrets.dart';
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:test/test.dart';
import 'dart:io' show Platform;

void main()
{
  // Use a fictitious key.
  String _mixpanelToken;

  MixpanelAPI _mixpanel;

  //TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() async {
/*
    Secrets.load(inUnitTest: true)
      .then((secrets) {
        if( secrets != null ) {
          _mixpanelToken = secrets.mixpanelToken;
          MixpanelAPI.getInstance(_mixpanelToken, mocked: true).then((mixpanel) {
            _mixpanel = mixpanel;
          });
        }
      });*/
    
    /// ATTENTION: Before run, you must to inform your Mixpanel token in environment variable called 'mixpanel_token'.
    var envVars = Platform.environment;
    _mixpanelToken = envVars['mixpanel_token'];
    MixpanelAPI.getInstance(_mixpanelToken, mocked:true).then((mixpanel) {
      _mixpanel = mixpanel;
    });

  });

  tearDownAll(() async {
    _mixpanel.flush();
  });

  test('Mixpanel.track', () async {
    _mixpanel.track("Flutuate's Dart plugin for Mixpanel", <String,dynamic> {
      'username': 'Luciano',
      'country': 'Brazil'
    } );
  });

  test('Mixpanel.flush', () async {
    _mixpanel.flush();
  } );

  test('Mixpanel.getDeviceInfo', () async {
    Map<String,String> devInfo = await _mixpanel.getDeviceInfo();
    expect(devInfo.containsKey('\$android_os'), equals(true));
    expect(devInfo['\$android_os'], equals('Android'));
  } );

  test('Mixpanel.getDistinctId', () async {
    String distinctId = await _mixpanel.getDistinctId();
    expect(distinctId, equals('2345d678-fb90-12b3-4567-8a90e1cdc234'));
  } );

  test('Mixpanel.optInTracking', () async {
    _mixpanel.optInTracking();
  } );

  test('Mixpanel.optOutTracking', () async {
    _mixpanel.optOutTracking();
  } );

  test('Mixpanel.reset', () async {
    _mixpanel.reset();
  } );

}
