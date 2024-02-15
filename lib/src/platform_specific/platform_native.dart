// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A native platform with access to `dart:io`.
library pkg.platform.impl;

import 'dart:async' show Zone, runZoned;
import 'dart:collection' show HashMap; // For case-insensitive environment.
import 'dart:convert' show JsonEncoder, jsonDecode;
import 'dart:io' as io;

import 'package:meta/meta.dart' show visibleForTesting;

import 'environment_override_keys.dart';
import '../json_keys.dart';

part '../platform_apis.dart';

@pragma('vm:platform-const')
final String _operatingSystem =
    _operatingSystemOverride ?? io.Platform.operatingSystem;

final String _operatingSystemVersion =
    _operatingSystemVersionOverride ?? io.Platform.operatingSystemVersion;

const String? _operatingSystemOverride =
    bool.hasEnvironment(environmentOsOverride)
        ? String.fromEnvironment(environmentOsOverride, defaultValue: '')
        : null;

const String? _operatingSystemVersionOverride =
    bool.hasEnvironment(environmentOsVersionOverride)
        ? String.fromEnvironment(environmentOsVersionOverride, defaultValue: '')
        : null;

const Platform _currentPlatform = Platform._native(_NativePlatform());

/// Temporary exposure of a const instance of `_NativePlatform` for the
/// `legacy_adapter.dart` `const` constructor for `LocalPlatform`.
const NativePlatform $nativePlatform = _NativePlatform();

final class _NativePlatform extends NativePlatform {
  const _NativePlatform() : super._();

  @pragma('vm:prefer-inline')
  @override
  bool get isAndroid => _operatingSystem == NativePlatform.android;

  @pragma('vm:prefer-inline')
  @override
  bool get isFuchsia => _operatingSystem == NativePlatform.fuchsia;

  @pragma('vm:prefer-inline')
  @override
  bool get isIOS => _operatingSystem == NativePlatform.iOS;

  @pragma('vm:prefer-inline')
  @override
  bool get isLinux => _operatingSystem == NativePlatform.linux;

  @pragma('vm:prefer-inline')
  @override
  bool get isMacOS => _operatingSystem == NativePlatform.macOS;

  @pragma('vm:prefer-inline')
  @override
  bool get isWindows => _operatingSystem == NativePlatform.windows;

  @pragma('vm:prefer-inline')
  @override
  String get operatingSystem => _operatingSystem;

  @pragma('vm:prefer-inline')
  @override
  String get operatingSystemVersion => _operatingSystemVersion;

  @pragma('vm:prefer-inline')
  @override
  Map<String, String> get environment => io.Platform.environment;

  @pragma('vm:prefer-inline')
  @override
  String get executable => io.Platform.executable;

  @pragma('vm:prefer-inline')
  @override
  List<String> get executableArguments => io.Platform.executableArguments;

  @pragma('vm:prefer-inline')
  @override
  String get lineTerminator => io.Platform.lineTerminator;

  @pragma('vm:prefer-inline')
  @override
  String get localHostname => io.Platform.localHostname;

  @pragma('vm:prefer-inline')
  @override
  String get localeName => io.Platform.localeName;

  @pragma('vm:prefer-inline')
  @override
  int get numberOfProcessors => io.Platform.numberOfProcessors;

  @pragma('vm:prefer-inline')
  @override
  String? get packageConfig => io.Platform.packageConfig;

  @pragma('vm:prefer-inline')
  @override
  String get pathSeparator => io.Platform.pathSeparator;

  @pragma('vm:prefer-inline')
  @override
  String get resolvedExecutable => io.Platform.resolvedExecutable;

  @pragma('vm:prefer-inline')
  @override
  Uri get script => io.Platform.script;

  @pragma('vm:prefer-inline')
  @override
  bool get stdinSupportsAnsi => io.stdin.supportsAnsiEscapes;

  @pragma('vm:prefer-inline')
  @override
  bool get stdoutSupportsAnsi => io.stdout.supportsAnsiEscapes;

  @pragma('vm:prefer-inline')
  @override
  String get version => io.Platform.version;
}
