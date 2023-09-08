// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Backwards compatibility for users of earlier versions of this package.
///
/// New users should use the `package:platform/host.dart` library's
/// [HostPlatform] class to detect the current operating system,
/// and they can use native-only/`dart:io`-specific
/// `package:platform/native.dart` library's [NativePlatform] as an abstraction
/// over the `Platform` data from `dart:io`.
///
/// Both of these libraries have an associated library only intended for
/// testing, `package:platform/host_test.dart` and
/// `package:platform/native_test.dart`.
/// Those libraries provide a configurable mock that can be injected
/// into code that are parameterized by `HostPlatform` or `NativePlatform`
/// objects, and a way to dynamically override the default value provided by
/// [HostPlatform.current] and [NativePlatform.current] properties.
library;

export 'host.dart';

export 'src/platforms.dart'
    if (dart.library.html) 'src/no_native_platform.dart'
    if (dart.library.io) 'src/platforms.dart'
    if (dart.library.core) 'src/no_native_platform.dart'
    show FakePlatform, LocalPlatform, Platform;
