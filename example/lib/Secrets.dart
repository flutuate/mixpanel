class Secrets 
{
  final String mixpanelToken;

  Secrets({this.mixpanelToken = ""});

  factory Secrets._fromJson(Map<String, dynamic> jsonMap) {
    return new Secrets(mixpanelToken: jsonMap["mixpanel_token"]);
  }
  
  static Future<Secrets> load() {
    return rootBundle.loadStructuredData<Secrets>(
      'resources/secrets.json', (jsonStr) async {
        return Secrets._fromJson(json.decode(jsonStr));
      }
    );
  }
}
