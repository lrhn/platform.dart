// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' as io;
import 'package:platform/native.dart';
import 'package:test/test.dart';

void main() {
  var localPlatform = NativePlatform.current;
  test('numberOfProcessors', () {
    expect(localPlatform.numberOfProcessors, io.Platform.numberOfProcessors);
  });
  test('pathSeparator', () {
    expect(localPlatform.pathSeparator, io.Platform.pathSeparator);
  });
  test('operatingSystem', () {
    expect(localPlatform.operatingSystem, io.Platform.operatingSystem);
  });
  test('operatingSystemVersion', () {
    expect(localPlatform.operatingSystemVersion,
        io.Platform.operatingSystemVersion);
  });
  test('localHostname', () {
    expect(localPlatform.localHostname, io.Platform.localHostname);
  });
  test('environment', () {
    expect(localPlatform.environment, io.Platform.environment);
  });
  test('executable', () {
    expect(localPlatform.executable, io.Platform.executable);
  });
  test('resolvedExecutable', () {
    expect(localPlatform.resolvedExecutable, io.Platform.resolvedExecutable);
  });
  test('script', () {
    expect(localPlatform.script, io.Platform.script);
  });
  test('executableArguments', () {
    expect(localPlatform.executableArguments, io.Platform.executableArguments);
  });
  test('packageConfig', () {
    expect(localPlatform.packageConfig, io.Platform.packageConfig);
  });
  test('version', () {
    expect(localPlatform.version, io.Platform.version);
  });
  test('stdinSupportsAnsi', () {
    expect(localPlatform.stdinSupportsAnsi, io.stdin.supportsAnsiEscapes);
  });
  test('stdoutSupportsAnsi', () {
    expect(localPlatform.stdoutSupportsAnsi, io.stdout.supportsAnsiEscapes);
  });
  test('localeName', () {
    expect(localPlatform.localeName, io.Platform.localeName);
  });
}
