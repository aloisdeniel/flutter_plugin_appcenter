# Visual Studio App Center (Crash) Plugin for Flutter

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
	* `appcenter_crashes`

## Usage

### Global

```dart
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
```

#### Starting service

```dart
final ios = defaultTargetPlatform == TargetPlatform.iOS;
var app_secret = ios ? "123cfac9-123b-123a-123f-123273416a48" : "321cfac9-123b-123a-123f-123273416a48";

await AppCenter.start(app_secret, [AppCenterCrashes.id]);
```

#### Enabling or disabling service

```dart
await AppCenterCrashes.setEnabled(false); // just a service
```

## Getting Started

See the `example` directory for a complete sample app using Visual Studio App Center.