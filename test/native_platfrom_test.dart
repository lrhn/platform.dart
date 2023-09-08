// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:io' as io;

import 'package:platform/native.dart';
import 'package:platform/src/platforms.dart' show hostPlatformKind;
import 'package:test/test.dart';

// Check that when running on a native platform, the default behavior of
// `NativePlatform.current` is to expose the `Platform`/`stdin`/`stdout`
// properties, or copies of them, directly.
// (We do not check that the values are *identical* because the `dart:io`
// getters may not return the same object every time.)
void main() {
  var nativePlatform = NativePlatform.current;
  test('Is compiled on native', () {
    expect(hostPlatformKind, 'native');
    expect(const bool.fromEnvironment('dart.library.html'), false);
    expect(const bool.fromEnvironment('dart.library.io'), true);
  });

  test('environment', () {
    expect(nativePlatform.environment, io.Platform.environment);
  });
  test('executable', () {
    expect(nativePlatform.executable, io.Platform.executable);
  });
  test('executableArguments', () {
    expect(nativePlatform.executableArguments, io.Platform.executableArguments);
  });
  test('lineTerminator', () {
    expect(nativePlatform.lineTerminator, io.Platform.lineTerminator);
  });
  test('localeName', () {
    expect(nativePlatform.localeName, io.Platform.localeName);
  });
  test('localHostname', () {
    expect(nativePlatform.localHostname, io.Platform.localHostname);
  });
  test('numberOfProcessors', () {
    expect(nativePlatform.numberOfProcessors, io.Platform.numberOfProcessors);
  });
  test('operatingSystem', () {
    expect(nativePlatform.operatingSystem, io.Platform.operatingSystem);
  });
  test('operatingSystemVersion', () {
    expect(nativePlatform.operatingSystemVersion,
        io.Platform.operatingSystemVersion);
  });
  test('packageConfig', () {
    expect(nativePlatform.packageConfig, io.Platform.packageConfig);
  });
  test('pathSeparator', () {
    expect(nativePlatform.pathSeparator, io.Platform.pathSeparator);
  });
  test('resolvedExecutable', () {
    expect(nativePlatform.resolvedExecutable, io.Platform.resolvedExecutable);
  });
  test('script', () {
    expect(nativePlatform.script, io.Platform.script);
  });
  test('stdinSupportsAnsi', () {
    expect(nativePlatform.stdinSupportsAnsi, io.stdin.supportsAnsiEscapes);
  });
  test('stdoutSupportsAnsi', () {
    expect(nativePlatform.stdoutSupportsAnsi, io.stdout.supportsAnsiEscapes);
  });
  test('version', () {
    expect(nativePlatform.version, io.Platform.version);
  });
}
