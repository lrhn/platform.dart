// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Default implementation of the [HostPlatform] and [NativePlatform] types.
///
/// The default implementation accesses the actual host platform's information
/// to provide the [HostPlatform] values, and the `dart:io` members
/// to provide the [NativePlatform] values. On non-native platforms,
/// [NativePlatform] should not be used, and will throw if accessing anything
/// except the properties of [HostPlatform].
part of 'platforms.dart';

/// Shared implementation used by both real and mock classes.
abstract base class _BasePlatform extends HostPlatform {
  const _BasePlatform._() : super._();

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isAndroid => HostPlatform.android == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isBrowser => HostPlatform.browser == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isFuchsia => HostPlatform.fuchsia == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isIOS => HostPlatform.iOS == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isLinux => HostPlatform.linux == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isMacOS => HostPlatform.macOS == operatingSystem;

  @pragma('dart2js:tryInline')
  @pragma('vm:platform-const')
  @pragma('vm:prefer-inline')
  @override
  bool get isWindows => HostPlatform.windows == operatingSystem;

  @override
  String toJson({bool terse = false}) {
    var map = toJsonMap();
    if (terse) return jsonEncode(map);
    return const JsonEncoder.withIndent('  ').convert(map);
  }
}

/// [HostPlatform] implementation backed by platform-specific information.
final class _HostPlatform extends _BasePlatform {
  static const _HostPlatform _instance = _HostPlatform._();

  /// Factory providing the canonical instance of this class.
  factory _HostPlatform() => _instance;

  const _HostPlatform._() : super._();

  @pragma('vm:prefer-inline')
  @pragma('vm:platform-const')
  @pragma('dart2js:tryInline')
  @override
  String get operatingSystem => impl.operatingSystem;

  @override
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String get operatingSystemVersion => impl.operatingSystemVersion;

  @override
  Map<String, Object?> toJsonMap() => <String, Object?>{
        JsonKey.operatingSystem: operatingSystem,
        JsonKey.operatingSystemVersion: operatingSystemVersion,
      };
}

/// [NativePlatform] implementation that delegates directly to `dart:io`.
final class _NativePlatform extends _HostPlatform implements NativePlatform {
  static const _NativePlatform _instance = _NativePlatform._();

  /// Provides an object accessing the native platform information.
  ///
  /// It's sadly not possible to have a `const` constructor which always
  /// returns the same instance (`_instance`). A constant factory constructor
  /// can only be redirecting, a generating constructor can always be invoked
  /// using `new`.
  const _NativePlatform() : super._();

  /// Creates a new [NativePlatform].
  ///
  /// Called precisely once, in the constant initializer of `_instance` above,
  /// unless someone calls the unnamed constructor above, which is only
  /// visible through the legacy [LocalPlatform] alias.
  ///
  /// Those calls should preferably all be `const` invocations, but we have
  /// no way to control that.
  const _NativePlatform._() : super._();

  @pragma('vm:prefer-inline')
  @override
  Map<String, String> get environment => impl.Platform.environment;

  @pragma('vm:prefer-inline')
  @override
  String get executable => impl.Platform.executable;

  @pragma('vm:prefer-inline')
  @override
  List<String> get executableArguments => impl.Platform.executableArguments;

  @pragma('vm:prefer-inline')
  @pragma('vm:platform-const')
  @override
  String get lineTerminator => impl.Platform.lineTerminator;

  @pragma('vm:prefer-inline')
  @override
  String get localeName => impl.Platform.localeName;

  @pragma('vm:prefer-inline')
  @override
  String get localHostname => impl.Platform.localHostname;

  @pragma('vm:prefer-inline')
  @override
  int get numberOfProcessors => impl.Platform.numberOfProcessors;

  @pragma('vm:prefer-inline')
  @override
  String? get packageConfig => impl.Platform.packageConfig;

  @pragma('vm:prefer-inline')
  @pragma('vm:platform-const')
  @override
  String get pathSeparator => impl.Platform.pathSeparator;

  @pragma('vm:prefer-inline')
  @override
  String get resolvedExecutable => impl.Platform.resolvedExecutable;

  @pragma('vm:prefer-inline')
  @override
  Uri get script => impl.Platform.script;

  @pragma('vm:prefer-inline')
  @override
  bool get stdinSupportsAnsi => impl.stdin.supportsAnsiEscapes;

  @pragma('vm:prefer-inline')
  @override
  bool get stdoutSupportsAnsi => impl.stdout.supportsAnsiEscapes;

  @pragma('vm:prefer-inline')
  @override
  String get version => impl.Platform.version;

  @override
  Map<String, Object?> toJsonMap() => <String, Object?>{
        JsonKey.environment: environment,
        JsonKey.executable: executable,
        JsonKey.executableArguments: executableArguments,
        JsonKey.lineTerminator: lineTerminator,
        JsonKey.localeName: localeName,
        JsonKey.localHostname: localHostname,
        JsonKey.numberOfProcessors: numberOfProcessors,
        JsonKey.operatingSystem: operatingSystem,
        JsonKey.operatingSystemVersion: operatingSystemVersion,
        if (packageConfig != null) JsonKey.packageConfig: packageConfig,
        JsonKey.pathSeparator: pathSeparator,
        JsonKey.resolvedExecutable: resolvedExecutable,
        JsonKey.script: script.toString(),
        JsonKey.stdinSupportsAnsi: stdinSupportsAnsi,
        JsonKey.stdoutSupportsAnsi: stdoutSupportsAnsi,
        JsonKey.version: version,
      };
}
