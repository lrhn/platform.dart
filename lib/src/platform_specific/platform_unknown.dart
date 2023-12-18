// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Default fallback for platform detection if neither
/// `dart:io` nor `dart:html` are available.
///
/// An unknown platform can set the compile-time environment entries
/// * `pkg.platform.operatingSystem`
/// * `pkg.platform.operatingSystemVersion`
///
/// to the string values that these constants should return.
library;

import '../platforms.dart' show HostPlatform;
import 'environment_override_keys.dart';

export 'no_io_support.dart';

/// Exposed by `platforms.dart` for testing.
const hostPlatformKind = 'unknown';

const String operatingSystem =
    String.fromEnvironment(environmentOsOverride, defaultValue: 'unknown');

const String operatingSystemVersion = String.fromEnvironment(
    environmentOsVersionOverride,
    defaultValue: 'unknown');

const bool isAndroid = operatingSystem == HostPlatform.android;
const bool isBrowser = operatingSystem == HostPlatform.browser;
const bool isFuchsia = operatingSystem == HostPlatform.fuchsia;
const bool isIOS = operatingSystem == HostPlatform.iOS;
const bool isLinux = operatingSystem == HostPlatform.linux;
const bool isMacOS = operatingSystem == HostPlatform.macOS;
const bool isWindows = operatingSystem == HostPlatform.windows;
