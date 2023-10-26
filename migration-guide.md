# Migration guide

This migration guide details how to migrate from from earlier Dart platform APIs
in `package:platform` version 3.x to, and in `dart:io`, to `package:platform`
version 4.x.

## From `package:platform` version 3.x

### General platform getters

The general APIs in `package:platform` v3.x, that determine what the host
platform is, rely on instantiating an instance of the `LocalPlatform` class. In
v4.0 a new convenience `.current` getter can be used, which returns the current
host platform.

Migrate from:
```dart
import 'package:platform/platform.dart'; // version 3.x

bool onAndroid = LocalPlatform().isAndroid;
```

To:
```dart
import 'package:platform/platform.dart'; // version 4.x

bool onAndroid = Platform.current.isAndroid;
```

### Native-only 

APIs in `package:platform` which are available only on native platforms (and not e.g.
on the web) have been moved to a separate library,
`package:platform/native.dart`.

Migrate from:
```dart
import 'package:platform/platform.dart'; // version 3.x

String hostname = LocalPlatform().localHostname;
```

To:
```dart
import 'package:platform/native.dart'; // version 4.x

String hostName = NativePlatform.current.localHostname;
```

## From `dart:io`

The `dart:io` core library is a special custom library only available on Dart
native platforms (and for example, not available on Dart web platforms). We
recommend migration to `package:platform` version 4.x, as the APIs in
`package:platform/platform.dart` are available on all platforms. For the
additional native-only APIs, those available in `package:platform/native.dart`.

### General platform getters

The general APIs in `dart:io` that determine what the host platform are accessed
via static methods on the `Platform` class. To migrate to `package:platform`
v4.x, use the similar methods on instance returned via the
`LocalPlatform.current` getter.

Migrate from:
```dart
import 'dart:io';

bool onAndroid = Platform.isMacOS;
```

To:
```dart
import 'package:platform/platform.dart'; // version 4.x

bool onAndroid = Platform.current.isAndroid;
```

### Native-only 

The native APIs in `dart:io` are accessed via static methods on the `Platform`
class. To migrate to `package:platform` v4.x, use the similar methods on
instance returned via the `NativePlatform.current` getter.

Migrate from:
```dart
import 'dart:io';

String hostname = Platform.localHostname;
```

To:
```dart
import 'package:platform/native.dart'; // version 4.x

String hostName = NativePlatform.current.localHostname;
```

