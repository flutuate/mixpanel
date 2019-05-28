# flutuate_mixpanel
A Flutter plugin for [Mixpanel](https://www.mixpanel.com).

## Getting Started
First, you must be registered at [Mixpanel](https://mixpanel.com/login/) to use the Mixpanel API.
The plugin uses the same concept of method calls used by the Mixpanel Android library.

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
So after, you only call the API methods specified in [Mixpanel Android API documentation](http://mixpanel.github.io/mixpanel-android/index.html).

See also the [Mixpanel documentation](https://developer.mixpanel.com/docs/android) for more informations.

## Example
The [sample project](https://github.com/flutuate/mixpanel/tree/master/example) has more details about how to use the plugin.

