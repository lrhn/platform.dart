// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific access to `dart:io` properties.
///
/// Used by `_HostPlatform` and `_NativePlatform` when `dart:io` is available.
library;

import 'dart:io';

import 'environment_override_keys.dart';

/// Export properties that the platform-agnostic code refers to.
export 'dart:io' show Platform, stdin, stdout;

/// Exposed by `platforms.dart` for testing.
const hostPlatformKind = 'native';

@pragma('vm:platform-const')
final String operatingSystem =
    _operatingSystemOverride ?? Platform.operatingSystem;

final String operatingSystemVersion =
    _operatingSystemVersionOverride ?? Platform.operatingSystemVersion;

const String? _operatingSystemOverride =
    bool.hasEnvironment(environmentOsOverride)
        ? String.fromEnvironment(environmentOsOverride, defaultValue: '')
        : null;

const String? _operatingSystemVersionOverride =
    bool.hasEnvironment(environmentOsVersionOverride)
        ? String.fromEnvironment(environmentOsVersionOverride, defaultValue: '')
        : null;

@pragma('vm:platform-const')
bool get isAndroid => Platform.isAndroid;

@pragma('vm:platform-const')
bool get isBrowser => false;

@pragma('vm:platform-const')
bool get isFuchsia => Platform.isFuchsia;

@pragma('vm:platform-const')
bool get isIOS => Platform.isIOS;

@pragma('vm:platform-const')
bool get isLinux => Platform.isLinux;

@pragma('vm:platform-const')
bool get isMacOS => Platform.isMacOS;

@pragma('vm:platform-const')
bool get isWindows => Platform.isWindows;
