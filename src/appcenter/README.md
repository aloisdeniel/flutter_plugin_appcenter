# Visual Studio App Center Plugin for Flutter

[![pub package](https://img.shields.io/pub/v/appcenter.svg)](https://pub.dartlang.org/packages/appcenter)

Several Flutter plugins to use the [Microsoft Visual Studio App Center SDKs](https://docs.microsoft.com/en-us/appcenter/sdk/).

*Note*: This plugin is still under development, and some APIs (*Distribute* and *Push* are still missing) might not be available yet. [Feedback](https://github.com/aloisdeniel/flutter_plugin_appcenter/issues) and [Pull Requests](https://github.com/aloisdeniel/flutter_plugin_appcenter/pulls) are most welcome!

## Setup

To use this plugin:

1. Connect to [Visual Studio App Center Portal](https://appcenter.ms/apps)
1. From the index page, select `Add new` and create a new **iOS application (Platform: Objective-C/Swift)**, and keep your iOS app secret (ex: `123cfac9-123b-123a-123f-123273416a48`).
1. From the index page, select `Add new` and create a new **Android application (Platform: Java)**, and keep your Android app secret (ex: `321cfac9-123b-123a-123f-123273416a48`).
1. Add those as [dependencies in your pubspec.yaml file](https://flutter.io/platform-plugins/):
	* `appcenter`
	* `appcenter_analytics`
	* `appcenter_crashes`

## Usage

### Global

```dart
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
```

#### Starting services

```dart
final ios = defaultTargetPlatform == TargetPlatform.iOS;
var app_secret = ios ? "123cfac9-123b-123a-123f-123273416a48" : "321cfac9-123b-123a-123f-123273416a48";

await AppCenter.start(app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
```

#### Enabling or disabling services

```dart
await AppCenter.setEnabled(false); // global
await AppCenterAnalytics.setEnabled(false); // just a service
await AppCenterCrashes.setEnabled(false); // just a service
```

### Analytics

#### Track events

```dart
AppCenterAnalytics.trackEvent("map");
AppCenterAnalytics.trackEvent("casino", { "dollars" : "10" }); // with custom properties
```

## Getting Started

See the `example` directory for a complete sample app using Visual Studio App Center.