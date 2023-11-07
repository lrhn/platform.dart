# Migration guide

This migration guide details how to migrate from from earlier Dart platform APIs
in `package:platform` version 3.x to, and in `dart:io`, to `package:platform`
version 4.x.

## From `package:platform` version 3.x

### General platform APIs

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
import 'package:platform/host.dart';     // version 4.x

bool onAndroid = HostPlatform.current.isAndroid;
```

### Native-only 

APIs in `package:platform` which are available only on native platforms (and not,
for example, on the web) have been moved to a separate library,
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

The `dart:io` core library is only available on Dart native platforms 
(and, for example, not available on Dart web platforms). 
We recommend migration to `package:platform` version 4.x, as the APIs in
`package:platform/platform.dart` are available on all current platforms. For the
additional native-only APIs, those available in `package:platform/native.dart`.

### General platform APIs

The `dart:io` library exposes host platform information as static members of the
`Platform` class. This API has historically been made available on some
platforms that don't otherwise support `dart:io`.

To migrate uses of that API to `package:platform` v4.x, use the similarly-named
members on the `HostPlatform.current` object.

Migrate from:
```dart
import 'dart:io';

bool onAndroid = Platform.isAndroid;
```

To:
```dart
import 'package:platform/host.dart';     // version 4.x

bool onAndroid = HostPlatform.current.isAndroid;
```

### Native-only 

The remaining `dart:io` APIs on the `Platform` class, have never worked on
non-native platforms. To migrate uses of those to `package:platform` v4.x, use
the similarly named members of the `NativePlatform.current` object from the
`package:platform/native.dart`.

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

## From package:os_detect

## General platform APIs

Migrate from:
```dart
import 'package:os_detect/os_detect.dart' as Platform;

bool onAndroid = Platform.isAndroid;
```

To:
```dart
import 'package:platform/host.dart';     // version 4.x

bool onAndroid = HostPlatform.current.isAndroid;
```

### Native-only 

`package:os_detect` has no native-only APIs.
