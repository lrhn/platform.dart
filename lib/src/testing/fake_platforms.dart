// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:meta/meta.dart';

import '../platforms_impl.dart';
import '../util/json_keys.dart' as json_key;
import 'fake_native_platform.dart';
import 'zone_overrides.dart' as overrides;

export 'fake_native_platform.dart' show FakeNativePlatform;

/// Fake Dart runtime platform information.
///
/// Implements [HostPlatform], but allows a [FakeBrowserPlatform] or
/// [FakeNativePlatform] to be the non-`null` platform object.
@visibleForTesting
final class FakeHostPlatform extends HostPlatformTestBase {
  /// The current native platform, if running on a native platform.
  @override
  final FakeNativePlatform? nativePlatform;

  /// The current browser platform, if running on a browser platform.
  @override
  final FakeBrowserPlatform? browserPlatform;

  /// Whether currently running on a native platform.
  @override
  bool get isNative => nativePlatform != null;

  /// Whether currently running in a browser.
  @override
  bool get isBrowser => browserPlatform != null;

  /// A fake platform with the given [nativePlatform].
  ///
  /// Used by [FakeNativePlatform.run] to create a fake [HostPlatform]
  /// with itself as the [HostPlatform.nativePlatform].
  const FakeHostPlatform._native(FakeNativePlatform this.nativePlatform)
      : browserPlatform = null;

  /// A fake platform with the given [browserPlatform].
  ///
  /// Used by [FakeBrowserPlatform.run] to create a fake [HostPlatform]
  /// with itself as the [HostPlatform.browserPlatform].
  const FakeHostPlatform._browser(FakeBrowserPlatform this.browserPlatform)
      : nativePlatform = null;

  /// A platform with *none* of the native or browser platforms set.
  const FakeHostPlatform.unknown()
      : nativePlatform = null,
        browserPlatform = null;

  /// A fake platform with the same properties as [platform].
  factory FakeHostPlatform.fromPlatform(HostPlatform platform) {
    // There is currently no way to have a platform with both
    // a browser platform and a native platform.
    var native = platform.nativePlatform;
    if (native != null) return FakeHostPlatform.fromNative(native);
    var browser = platform.browserPlatform;
    if (browser != null) return FakeHostPlatform.fromBrowser(browser);
    return const FakeHostPlatform.unknown();
  }

  /// Creates a [FakeHostPlatform] with a [NativePlatform].
  ///
  /// Creates a [FakeNativePlatform.new] with the same arguments,
  /// and a [FakeHostPlatform] with that as [nativePlatform].
  ///
  /// It's recommended to use
  /// ```dart
  /// FakeHostPlatform.fromNative(FakeNativePlatform(...))
  /// ```
  FakeHostPlatform.native({
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
  }) : this._native(FakeNativePlatform(
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

  /// Creates a [FakeHostPlatform] with a [NativePlatform].
  ///
  /// If [nativePlatform] is omitted or `null`, the created `FakeHostPlatform]
  /// has a new [FakeNativePlatform] as [HostPlatform.nativePlatform].
  FakeHostPlatform.fromNative(NativePlatform nativePlatform)
      : this._native(FakeNativePlatform.from(nativePlatform));

  /// Creates a [FakeHostPlatform] with a [FakeNativePlatform] created from JSON.
  ///
  /// A new [FakeNativePlatform] is created using [FakeNativePlatform.fromJson]
  /// with [nativePlatformJson] as argument, an a new [FakeHostPlatform] is created
  /// with that native platform as [HostPlatform.nativePlatform].
  FakeHostPlatform.nativeFromJson(String nativePlatformJson)
      : this._native(FakeNativePlatform.fromJson(nativePlatformJson));

  /// Creates a [FakeHostPlatform] with a [BrowserPlatform].
  ///
  /// If [browserPlatform] is omitted or `null`, the created `FakeHostPlatform]
  /// has a new [FakeBrowserPlatform] as [HostPlatform.browserPlatform].
  FakeHostPlatform.fromBrowser([BrowserPlatform? browserPlatform])
      : this._browser(browserPlatform = browserPlatform == null
            ? FakeBrowserPlatform()
            : FakeBrowserPlatform.fromPlatform(browserPlatform));

  /// Creates a [FakeHostPlatform] with a [FakeBrowserPlatform] created from JSON.
  ///
  /// A new [FakeBrowserPlatform] is created using
  /// [FakeBrowserPlatform.fromJson] with [browserPlatformJson] as argument,
  /// and a new [FakeHostPlatform] is created with that native platform as
  /// [HostPlatform.browserPlatform].
  FakeHostPlatform.browserFromJson(String browserPlatformJson)
      : this._browser(FakeBrowserPlatform.fromJson(browserPlatformJson));

  /// Runs [fakePlatformCode] with this fake platform as the current platform.
  ///
  /// While [fakePlatformCode] is running, the [HostPlatform.current] refers to this
  /// fake platform, which is likely the [FakeHostPlatform.unknown] platform.
  ///
  /// Prior reads of [HostPlatform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [HostPlatform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) =>
      overrides.runWith(fakePlatformCode, this, _OverrideMarker.marker);

  /// Migration helper for legacy `FakeHostPlatform.copyWith`.
  ///
  /// Use [FakeNativePlatform.copyWith] instead.
  /// Work directly with [FakeNativePlatform], rather than creating a
  /// `FakeHostPlatform` from it.
  ///
  /// Only works if there is a current [nativePlatform].
  ///
  /// Will be deprecated and removed when legacy classes are removed.
  FakeHostPlatform copyWithNativeMigrationHelper({
    int? numberOfProcessors,
    String? pathSeparator,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostname,
    Map<String, String>? environment,
    String? executable,
    String? resolvedExecutable,
    Uri? script,
    List<String>? executableArguments,
    String? packageConfig,
    String? version,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? localeName,
  }) {
    return FakeHostPlatform._native(nativePlatform!.copyWith(
      numberOfProcessors: numberOfProcessors,
      pathSeparator: pathSeparator,
      operatingSystem: operatingSystem,
      operatingSystemVersion: operatingSystemVersion,
      localHostname: localHostname,
      environment: environment,
      executable: executable,
      resolvedExecutable: resolvedExecutable,
      script: script,
      executableArguments: executableArguments,
      packageConfig: packageConfig,
      version: version,
      stdinSupportsAnsi: stdinSupportsAnsi,
      stdoutSupportsAnsi: stdoutSupportsAnsi,
      localeName: localeName,
    ));
  }
}

/// Instance used to mark overrides as used.
enum _OverrideMarker implements overrides.OverrideMarker {
  marker;
}

/// Fake [BrowserPlatform] for testing.
@visibleForTesting
final class FakeBrowserPlatform extends BrowserPlatformTestBase {
  static const _className = 'FakeBrowserPlatform';

  final String? _version;
  final String? _userAgent;

  FakeBrowserPlatform({String? version, String? userAgent})
      : _version = version,
        _userAgent = userAgent;

  factory FakeBrowserPlatform.fromJson(String jsonText) {
    var json = jsonDecode(jsonText);
    if (json is! Map<String, Object?>) {
      throw FormatException('Not a JSON map', jsonText);
    }
    return FakeBrowserPlatform(
      version: getJsonProperty<String>(json, json_key.version, jsonText),
      userAgent: getJsonProperty<String>(json, json_key.userAgent, jsonText),
    );
  }

  factory FakeBrowserPlatform.fromPlatform(BrowserPlatform platform) {
    if (platform is FakeBrowserPlatform) {
      return platform.copyWith();
    }
    return FakeBrowserPlatform(
      version: platform.version,
      userAgent: platform.userAgent,
    );
  }

  FakeBrowserPlatform copyWith({
    String? version,
    String? userAgent,
  }) =>
      FakeBrowserPlatform(
        version: version ?? _version,
        userAgent: userAgent ?? _userAgent,
      );

  /// Runs [fakePlatformCode] with this as the current browser platform.
  ///
  /// While [fakePlatformCode] is running, the [HostPlatform.browserPlatform]
  /// of [HostPlatform.current] refers to this [FakeBrowserPlatform].
  ///
  /// Prior reads of [HostPlatform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [HostPlatform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) => overrides.runWith(fakePlatformCode,
      FakeHostPlatform._browser(this), _OverrideMarker.marker);

  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        if (_version != null) json_key.version: _version,
        if (_userAgent != null) json_key.userAgent: _userAgent,
      });

  @override
  String get userAgent =>
      throwIfUnset(_userAgent, _className, json_key.userAgent);

  @override
  String get version => throwIfUnset(_version, _className, json_key.version);
}

/// Extensions to install a fake native platform
extension RunFakeNativePlatform on FakeNativePlatform {
  /// Runs [fakePlatformCode] with this native platform as current platform.
  ///
  /// If [fakePlatformCode] reads [HostPlatform.current], it gets a platform
  /// object whose [HostPlatform.nativePlatform] is this fake native platform.
  R run<R>(R Function() fakePlatformCode) => overrides.runWith(
      fakePlatformCode, FakeHostPlatform._native(this), _OverrideMarker.marker);

  /// Wraps [withOverride] to run it with this fake native platform as current.
  ///
  /// The returned function runs [withOverride] through [run] every time it's
  /// called, to ensure all the calls will see the same override.
  R Function() bind<R>(R Function() withOverride) => () => run(withOverride);
}
