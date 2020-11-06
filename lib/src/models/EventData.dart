import 'DataProperties.dart';

class EventData {
  final String event;
  final DataProperties properties;

  EventData(this.event, this.properties);

  EventData.fromJson(Map<String,dynamic> json)
      : event = json['event']
  , properties = DataProperties.fromJson(json['properties']);

  Map<String, dynamic> toJson() => {
    'event': event,
    'properties': properties.toJson()
  };
}

