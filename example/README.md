# flutuate_mixpanel_example

Demonstrates how to use the flutuate_mixpanel plugin.

## Getting Started

This project is a starting point for a Flutter application. 

It uses your Mixpanel token can be specified in the file ```resources/secrets.json```, with the follow format:

```json
{
  "mixpanel_token": "<your token>"
}
```

or you can inform your Mixpanel token in environment variable called **mixpanel_token**:

```dart
    var envVars = Platform.environment;
    _mixpanelToken = envVars['mixpanel_token'];
    MixpanelAPI.getInstance(_mixpanelToken, mocked:true).then((mixpanel) {
      _mixpanel = mixpanel;
    });
```