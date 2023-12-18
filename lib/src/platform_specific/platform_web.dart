// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific implementations for `LocalPlatform`
/// when `dart:html` is available , but `dart:io` is not.
/// (That is, when compiling for the web).
library;

import 'dart:html';

import 'environment_override_keys.dart';

export 'no_io_support.dart';

/// Exposed by `platforms.dart` for testing.
const hostPlatformKind = 'browser';

const String operatingSystem =
    String.fromEnvironment(environmentOsOverride, defaultValue: 'browser');

final String operatingSystemVersion =
    _operatingSystemVersionOverride ?? window.navigator.userAgent;

const String? _operatingSystemVersionOverride =
    bool.hasEnvironment(environmentOsVersionOverride)
        ? String.fromEnvironment(environmentOsVersionOverride, defaultValue: '')
        : null;

const bool isAndroid = false;
const bool isBrowser = true;
const bool isFuchsia = false;
const bool isIOS = false;
const bool isLinux = false;
const bool isMacOS = false;
const bool isWindows = false;
