// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:io' as io;

import 'package:platform/platform.dart';
import 'package:test/test.dart';

/// Tests the legacy API exposed by `package:platform/platform.dart`.
/// The library exposes three type names `Platform`, `LocalPlatform` and
/// `MockPlatform`, which map to the new `NativePlatform` and
/// `MockNativePlatform` classes.
///
/// In a later version, those type aliases will be removed again.
void main() {
  test('Platform legacy API', () {
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

  test('LocalPlatform legacy API', () {
    var local = const LocalPlatform();
    expect(local, isA<Platform>());
    expect(io.Platform.operatingSystem, local.operatingSystem);
    expect(io.Platform.operatingSystemVersion, local.operatingSystemVersion);
  });

  test('MockPlatform legacy API', () {
    var fake = FakePlatform();
    expect(fake, isA<Platform>());
    expect(() => fake.operatingSystem, throwsStateError);
    expect(() => fake.operatingSystemVersion, throwsStateError);
    fake = fake.copyWith(operatingSystem: 'os2');
    expect(fake, isA<Platform>());
    expect(fake.operatingSystem, 'os2');
    expect(() => fake.operatingSystemVersion, throwsStateError);
    fake = fake.copyWith(operatingSystemVersion: '1.0');
    expect(fake, isA<Platform>());
    expect(fake.operatingSystem, 'os2');
    expect(fake.operatingSystemVersion, '1.0');

    fake = FakePlatform.fromPlatform(LocalPlatform());
    expect(fake, isA<Platform>());
    expect(fake.operatingSystem, HostPlatform.current.operatingSystem);
    expect(fake.operatingSystemVersion,
        HostPlatform.current.operatingSystemVersion);
  });
}
