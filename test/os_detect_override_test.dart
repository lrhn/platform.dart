// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:platform/platform.dart';

void main() {
  test("Has consistent values", () {
    var os = Platform.current.operatingSystem;
    expect(os, isNotNull);

    expect(Platform.current.isAndroid, os == Platform.android);
    expect(Platform.current.isBrowser, os == Platform.browser);
    expect(Platform.current.isFuchsia, os == Platform.fuchsia);
    expect(Platform.current.isIOS, os == Platform.iOS);
    expect(Platform.current.isLinux, os == Platform.linux);
    expect(Platform.current.isMacOS, os == Platform.macOS);
    expect(Platform.current.isWindows, os == Platform.windows);

    expect(Platform.current.operatingSystemVersion, isNotNull);
  });
}
