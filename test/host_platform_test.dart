// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/host.dart';
import 'package:platform/src/platforms.dart' show hostPlatformKind;
import 'package:test/test.dart';

void main() {
  test('uses expected platform', () {
    if (const bool.fromEnvironment('dart.library.html')) {
      expect(hostPlatformKind, 'browser');
    } else if (const bool.fromEnvironment('dart.library.io')) {
      expect(hostPlatformKind, 'native');
    } else {
      expect(hostPlatformKind, 'unknown');
    }

    if (hostPlatformKind == 'browser') {
      expect(const String.fromEnvironment('dart.library.html'), 'true');
    } else if (hostPlatformKind == 'native') {
      expect(const String.fromEnvironment('dart.library.io'), 'true');
      expect(const String.fromEnvironment('dart.library.html'), isNot('true'));
    } else {
      expect(hostPlatformKind, 'unknown');
      expect(const String.fromEnvironment('dart.library.io'), isNot('true'));
      expect(const String.fromEnvironment('dart.library.html'), isNot('true'));
    }
  });
  test('static properties', () {
    // Tests that the constants are what we expect them to be.
    // Update this test if we add more supported operating systems,
    // or if we change the values.
    expect(HostPlatform.android, 'android');
    expect(HostPlatform.browser, 'browser');
    expect(HostPlatform.fuchsia, 'fuchsia');
    expect(HostPlatform.iOS, 'ios');
    expect(HostPlatform.linux, 'linux');
    expect(HostPlatform.macOS, 'macos');
    expect(HostPlatform.windows, 'windows');

    expect(HostPlatform.operatingSystemValues, hasLength(7));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.android));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.browser));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.fuchsia));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.iOS));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.linux));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.macOS));
    expect(HostPlatform.operatingSystemValues, contains(HostPlatform.windows));
  });

  test('Has consistent values', () {
    var current = HostPlatform.current;
    var os = current.operatingSystem;
    expect(os, isNotNull);

    expect(current.isAndroid, os == HostPlatform.android);
    expect(current.isBrowser, os == HostPlatform.browser);
    expect(current.isFuchsia, os == HostPlatform.fuchsia);
    expect(current.isIOS, os == HostPlatform.iOS);
    expect(current.isLinux, os == HostPlatform.linux);
    expect(current.isMacOS, os == HostPlatform.macOS);
    expect(current.isWindows, os == HostPlatform.windows);

    expect(current.operatingSystemVersion, isNotNull);
  });
}
