// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific implementations for `LocalPlatform`
/// when `dart:html` is available , but `dart:io` is not.
/// (That is, when compiling for the web).
library;

import 'dart:convert' show JsonEncoder;

import '../testing/zone_overrides.dart' as override;
import '../util/json_keys.dart' as json_key;
import '../util/platform_browser_interop.dart' as window;
import 'platform_native_interface.dart';

export 'platform_native_interface.dart';

const HostPlatform platformInstance = HostPlatform._();
const BrowserPlatform browserPlatformInstance = BrowserPlatform._();

// For the legacy `LocalPlatform`.
const NativePlatform? nativePlatformInstance = null;

/// Dart runtime platform information.
///
/// Provides information about the current runtime environment.
///
/// If running as native code, the [nativePlatform] object is
/// non-`null` and provides information about that platform,
/// including the [NativePlatform.operatingSystem] name.
///
/// If running in a browser, the [browserPlatform] objects is
/// non-`null` and provides information about the browser.
final class HostPlatform {
  /// The current [Platform] information of the running program.
  @pragma('dart2js:prefer-inline')
  static HostPlatform get current =>
      (override.platformOverride as HostPlatform?) ?? platformInstance;

  /// The current native platform, if running on a native platform.
  @pragma('dart2js:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('dart2js:prefer-inline')
  BrowserPlatform? get browserPlatform => browserPlatformInstance;

  /// Whether currently running on a native platform.
  @pragma('dart2js:prefer-inline')
  bool get isNative => false;

  /// Whether currently running in a browser.
  @pragma('dart2js:prefer-inline')
  bool get isBrowser => true;

  const HostPlatform._();
}

abstract base class HostPlatformTestBase extends HostPlatform {
  const HostPlatformTestBase() : super._();
}

/// Information about the current browser.
///
/// Only available while running in a browser.
final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [`Platform.current.browserPlatform`](Platform.browserPlatform).
  static BrowserPlatform? get current => HostPlatform.current.browserPlatform;

  /// The browser's version, as reported by `Navigator.appVersion` by default.
  ///
  /// If a particular browser provides a more specific version string,
  /// it may be used instead of the default.
  ///
  /// No guarantees are made about the format of the string, it may differ
  /// between different browser types, and between different browser versions
  /// or versions of this package.
  ///
  /// If no `Navigator` object is a available,
  /// the string content is unspecified.
  String get version =>
      window.navigator?.appVersion ?? 'No navigator.appVersion';

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  ///
  /// If no `Navigator` object is a available, the value will be
  /// the string `"unknown"`.
  String get userAgent =>
      window.navigator?.userAgent ?? 'No navigator.userAgent';

  /// A JSON representation of the state of this browser platform object.
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        json_key.userAgent: userAgent,
        json_key.version: version,
      });
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
