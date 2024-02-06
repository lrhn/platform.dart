// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Legacy API adapter. Only works on native platforms.
library;

import 'package:meta/meta.dart' show visibleForTesting;

import 'src/platform_specific/platform_native.dart' as p;

extension type Platform._(p.NativePlatform _) implements p.NativePlatform {
  static const String android = p.NativePlatform.android;
  static const String browser = 'browser';
  static const String fuchsia = p.NativePlatform.fuchsia;
  static const String iOS = p.NativePlatform.iOS;
  static const String linux = p.NativePlatform.linux;
  static const String macOS = p.NativePlatform.macOS;
  static const String windows = p.NativePlatform.windows;

  bool get isBrowser => false;

  static LocalPlatform get current =>
      LocalPlatform._(p.Platform.current.nativePlatform!);
}

extension type const LocalPlatform._(p.NativePlatform _)
    implements p.NativePlatform, Platform {
  const LocalPlatform() : this._(p.$nativePlatform);

  bool get isBrowser => false;
}

/// Legacy adaption of `NativePlatform` to the old `FakePlatform` name.
///
/// The `NativePlatform` from `package:platform/platform_testing.dart`
///
@visibleForTesting
// ignore: invalid_use_of_visible_for_testing_member
extension type const FakePlatform._(p.FakeNativePlatform _)
    // ignore: invalid_use_of_visible_for_testing_member
    implements p.FakeNativePlatform, Platform {
  FakePlatform({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  }) : this._(p.FakeNativePlatform(
          environment: environment,
          executable: executable,
          executableArguments: executableArguments,
          lineTerminator: lineTerminator,
          localeName: localeName,
          localHostname: localHostname,
          numberOfProcessors: numberOfProcessors,
          operatingSystem: operatingSystem,
          operatingSystemVersion: operatingSystemVersion,
          packageConfig: packageConfig,
          pathSeparator: pathSeparator,
          resolvedExecutable: resolvedExecutable,
          script: script,
          stdinSupportsAnsi: stdinSupportsAnsi,
          stdoutSupportsAnsi: stdoutSupportsAnsi,
          version: version,
        ));

  FakePlatform.fromJson(String jsonText)
      : this._(p.FakeNativePlatform.fromJson(jsonText));

  FakePlatform.fromPlatform(p.NativePlatform platform)
      : this._(p.FakeNativePlatform.fromPlatform(platform));

  FakePlatform copyWith({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  }) =>
      FakePlatform._(_.copyWith(
        environment: environment,
        executable: executable,
        executableArguments: executableArguments,
        lineTerminator: lineTerminator,
        localeName: localeName,
        localHostname: localHostname,
        numberOfProcessors: numberOfProcessors,
        operatingSystem: operatingSystem,
        operatingSystemVersion: operatingSystemVersion,
        packageConfig: packageConfig,
        pathSeparator: pathSeparator,
        resolvedExecutable: resolvedExecutable,
        script: script,
        stdinSupportsAnsi: stdinSupportsAnsi,
        stdoutSupportsAnsi: stdoutSupportsAnsi,
        version: version,
      ));
}
