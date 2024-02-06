// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';
import 'package:test/test.dart';

void main() {
  // Change these if we get better ways to detect the platform.
  const bool expectBrowser = bool.fromEnvironment('dart.library.html');
  const bool expectNative = bool.fromEnvironment('dart.library.io');
  const bool expectWasm = false; // For now.

  test('uses expected platform', () {
    var platform = Platform.current;
    expect(platform.isBrowser, expectBrowser);
    expect(platform.isNative, expectNative);
    expect(platform.isWasm, expectWasm);

    expect(platform.browserPlatform, platform.isBrowser ? isNotNull : isNull);
    expect(platform.nativePlatform, platform.isNative ? isNotNull : isNull);
    expect(platform.wasmPlatform, platform.isWasm ? isNotNull : isNull);
  });
}
