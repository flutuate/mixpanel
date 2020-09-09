# flutuate_mixpanel
A Flutter plugin for [Mixpanel](https://www.mixpanel.com).

## Getting Started
This plugin wraps the most of the functions from [Mixpanel SDK](https://developer.mixpanel.com/docs). It runs on both Android and iOS.
To use it, you must have a registered token from [Mixpanel](https://mixpanel.com/login/).

## Configuration
Add `flutuate_mixpanel` to `pubspec.yaml` under the `dependencies` field.

```yaml
dependencies:
  flutuate_mixpanel: ^latest_version
```


## Import
Add the following import in your library :

```dart
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
```


## Usage
For you to use the plugin, in your Flutter app, get an instance of Mixpanel plugin:
```dart
    MixpanelAPI instance = await MixpanelAPI.getInstance('<your_mixpanel_token');
```
So after, you only call the API methods specified in [Mixpanel Android API documentation](https://github.com/mixpanel/mixpanel-android).

See also the [Mixpanel documentation](https://developer.mixpanel.com/docs/android) for more informations.

## Example
The [sample project](https://github.com/flutuate/mixpanel/tree/master/example) has more details about how to use the plugin.

