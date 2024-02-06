// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific implementations for `LocalPlatform`
/// when `dart:html` is available , but `dart:io` is not.
/// (That is, when compiling for the web).
library pkg.platform.impl;

import 'dart:async' show Zone, runZoned;
import 'dart:collection' show HashMap;
import 'dart:convert' show JsonEncoder, jsonDecode;
import 'dart:html';

import 'package:meta/meta.dart' show visibleForTesting;

import '../json_keys.dart';

part '../platform_apis.dart';

const Platform _currentPlatform = Platform._browser(_BrowserPlatform());

final class _BrowserPlatform extends BrowserPlatform {
  const _BrowserPlatform() : super._();

  @override
  bool get isChromium => false; // TODO: Try!

  @override
  bool get isMozilla => false;

  @override
  bool get isWebkit => false;

  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        JsonKey.userAgent: userAgent,
        JsonKey.version: version,
      });

  @override
  String get userAgent => window.navigator.userAgent;

  @override
  String get version => window.navigator.appVersion;
}
