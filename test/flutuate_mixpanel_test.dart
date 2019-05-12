import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:test/test.dart';

void main()
{
  final String token = ""; //TODO You must fill with your Mixpanel token.

  MixpanelAPI mixpanel;

  setUp(() async {
    mixpanel = await MixpanelAPI.getInstance(token);
  });

  tearDown(() async {
    mixpanel.flush();
  });

  test('getPlatformVersion', () async {
    mixpanel.track("Flutuate's Dart plugin for Mixpanel", <String,dynamic> {
      'nome': 'Luciano',
      'altura': 1.78
    } );
  });
}
