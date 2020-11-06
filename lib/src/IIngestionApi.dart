const Map<String, dynamic> EmptyMap = <String, dynamic>{};

abstract class IIngestionApi
{
  void track(String eventName, [Map<String, dynamic> properties = EmptyMap]);
}