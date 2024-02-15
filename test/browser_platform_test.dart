// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test of [browserPlatform].
@OnPlatform({'!browser': Skip('Browser-only functionality')})
library;

import 'dart:html';
import 'package:test/test.dart';
import 'package:platform/platform.dart';

void main() {
  print(
      "native? dart.library.io: ${const bool.fromEnvironment('dart.library.io')}");
  print(
      "browser? dart.library.js: ${const bool.fromEnvironment('dart.library.js')}");
  final platform = Platform.current;
  final browserPlatform = platform.browserPlatform;

  test('Running on browser', () {
    expect(browserPlatform, isNotNull);
    expect(platform.isNative, false);
    expect(platform.isBrowser, true);
    expect(platform.isWasm, false);
    expect(platform.nativePlatform, isNull);
    expect(platform.wasmPlatform, isNull);
  });

  if (browserPlatform == null) return; // Promote to non-null.

  test('static properties', () {
    // The `current` getter is the same objects as
    // `Platform.current.browserPlatform`.
    expect(browserPlatform, same(BrowserPlatform.current));
  });

  test('Has same values as JS', () {
    // Everything is taken from browser (`window.navigator`).
    expect(browserPlatform.userAgent, window.navigator.userAgent);
    expect(browserPlatform.version, window.navigator.appVersion);
  });
}
