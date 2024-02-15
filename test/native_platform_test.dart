// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test of [NativePlatform].
@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:io' as io;
import 'package:test/test.dart';
import 'package:platform/platform.dart';

void main() {
  final platform = Platform.current;
  final nativePlatform = platform.nativePlatform;

  test('Running on native', () {
    expect(nativePlatform, isNotNull);
    expect(platform.isNative, true);
    expect(platform.isBrowser, false);
    expect(platform.isWasm, false);
    expect(platform.browserPlatform, isNull);
    expect(platform.wasmPlatform, isNull);
  });

  if (nativePlatform == null) return; // Promote to non-null.

  test('static properties', () {
    // The `current` getter is the same objects as
    // `Platform.current.nativePlatform`.
    expect(nativePlatform, same(NativePlatform.current));

    // Tests that the constants are what we expect them to be.
    // Update this test if we add more supported operating systems,
    // or if we change the values.
    expect(NativePlatform.android, 'android');
    expect(NativePlatform.fuchsia, 'fuchsia');
    expect(NativePlatform.iOS, 'ios');
    expect(NativePlatform.linux, 'linux');
    expect(NativePlatform.macOS, 'macos');
    expect(NativePlatform.windows, 'windows');
    expect({
      ...NativePlatform.operatingSystemValues
    }, {
      NativePlatform.android,
      NativePlatform.fuchsia,
      NativePlatform.iOS,
      NativePlatform.linux,
      NativePlatform.macOS,
      NativePlatform.windows,
    });
  });

  test('Has same values as dart:io', () {
    // Everything is taken from `dart:io`.
    expect(nativePlatform.executable, io.Platform.executable);
    expect(nativePlatform.environment, io.Platform.environment);
    expect(nativePlatform.executableArguments, io.Platform.executableArguments);
    expect(nativePlatform.lineTerminator, io.Platform.lineTerminator);
    expect(nativePlatform.localHostname, io.Platform.localHostname);
    expect(nativePlatform.localeName, io.Platform.localeName);
    expect(nativePlatform.numberOfProcessors, io.Platform.numberOfProcessors);
    expect(nativePlatform.operatingSystem, io.Platform.operatingSystem);
    expect(nativePlatform.operatingSystemVersion,
        io.Platform.operatingSystemVersion);
    expect(nativePlatform.packageConfig, io.Platform.packageConfig);
    expect(nativePlatform.pathSeparator, io.Platform.pathSeparator);
    expect(nativePlatform.resolvedExecutable, io.Platform.resolvedExecutable);
    expect(nativePlatform.script, io.Platform.script);
    expect(nativePlatform.stdinSupportsAnsi, io.stdin.supportsAnsiEscapes);
    expect(nativePlatform.stdoutSupportsAnsi, io.stdout.supportsAnsiEscapes);
    expect(nativePlatform.version, io.Platform.version);

    expect(nativePlatform.isAndroid, io.Platform.isAndroid);
    expect(nativePlatform.isFuchsia, io.Platform.isFuchsia);
    expect(nativePlatform.isIOS, io.Platform.isIOS);
    expect(nativePlatform.isLinux, io.Platform.isLinux);
    expect(nativePlatform.isMacOS, io.Platform.isMacOS);
    expect(nativePlatform.isWindows, io.Platform.isWindows);

    // Consistence between `operatingSystem` and `isSomeOS`.
    var os = nativePlatform.operatingSystem;
    expect(os, isNotNull);

    expect(nativePlatform.isAndroid, os == NativePlatform.android);
    expect(nativePlatform.isFuchsia, os == NativePlatform.fuchsia);
    expect(nativePlatform.isIOS, os == NativePlatform.iOS);
    expect(nativePlatform.isLinux, os == NativePlatform.linux);
    expect(nativePlatform.isMacOS, os == NativePlatform.macOS);
    expect(nativePlatform.isWindows, os == NativePlatform.windows);
  });
}
