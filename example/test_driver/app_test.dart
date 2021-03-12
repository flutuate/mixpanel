import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main()
{
  group('Plugin tests', ()
  {
    FlutterDriver? driver;

    final resultMessageFinder = find.byValueKey('resultMessage');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver?.close();
    });

    // This need be the first test, because it get instance of plugin.
    test('Mixpanel.getInstance', () async {
      final button = find.byValueKey('getInstance');
      await driver?.tap(button);
      final result = await driver?.getText(resultMessageFinder);
      expect(result, 'Instance created with success!');
    });

    test('Mixpanel.track', () async {
      final button = find.byValueKey('trackEvent');
      await driver?.tap(button);
      final result = await driver?.getText(resultMessageFinder);
      expect(result, 'Event sent with success!');
    });

    test('Mixpanel.getDeviceInfo', () async {
      final button = find.byValueKey('getDeviceInfo');
      await driver?.tap(button);
      final result = await driver?.getText(resultMessageFinder);
      expect(result, isNotEmpty);
    });

    test('Mixpanel.getDistinctId', () async {
      final button = find.byValueKey('getDistinctId');
      await driver?.tap(button);
      final result = await driver?.getText(resultMessageFinder);
      expect(result, isNotEmpty);
    });

    test('Mixpanel.flushId', () async {
      final button = find.byValueKey('flush');
      await driver?.tap(button);
      final result = await driver?.getText(resultMessageFinder);
      expect(result, 'Flushed with success!');
    });

  });
}
