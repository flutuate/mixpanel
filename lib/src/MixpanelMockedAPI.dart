import 'MixpanelAPI.dart';

class MixpanelMockedAPI
extends MixpanelAPI
{
  @override
  void flush() {
    print('$runtimeType.flush');
  }

  @override
  void track(String eventName, Map<String, dynamic> properties) {
    print('$runtimeType.track: {$eventName=$properties}');
  }
}

