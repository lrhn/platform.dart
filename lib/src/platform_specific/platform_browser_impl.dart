// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific implementations for `LocalPlatform`
/// when `dart:html` is available , but `dart:io` is not.
/// (That is, when compiling for the web).
library;

import 'dart:async' show Zone;
import 'dart:convert' show JsonEncoder;
import 'dart:html';

import 'platform_native_interface.dart';
import 'platform_wasm_interface.dart';
import '../json_keys.dart' as json_key;
import '../zone_overrides.dart' as override;

const Platform platformInstance = Platform._();
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
///
/// If running in a WebAssembly (Wasm) runtime, the [wasmPlatform] is
/// non-`null` and may one day provide information about the Wasm runtime.
final class Platform {
  /// The current [Platform] information of the running program.
  static Platform get current => override.marker == null
      ? platformInstance
      : ((Zone.current[override.zoneKey] as Platform?) ?? platformInstance);

  /// The current native platform, if running on a native platform.
  @pragma('vm:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('vm:prefer-inline')
  BrowserPlatform? get browserPlatform => browserPlatformInstance;

  /// The current Wasm platform, if running on a Wasm platform.
  @pragma('vm:prefer-inline')
  WasmPlatform? get wasmPlatform => null;

  /// Whether currently running on a native platform.
  @pragma('vm:prefer-inline')
  bool get isNative => true;

  /// Whether currently running in a browser.
  @pragma('vm:prefer-inline')
  bool get isBrowser => false;

  /// Whether currently running in a Wasm runtime.
  @pragma('vm:prefer-inline')
  bool get isWasm => false;

  const Platform._();
}

abstract base class PlatformTestBase implements Platform {}

/// Information about the current browser.
///
/// Only available while running in a browser.
final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [Platform.current.browserPlatform].
  static BrowserPlatform? get current => Platform.current.browserPlatform;

  /// The browser's version, as reported by (something).
  String get version => window.navigator.appVersion;

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  String get userAgent => window.navigator.userAgent;

  /// A best-effort attempt to detect when running in a Chromium-based browser.
  ///
  /// May detect Chrome or browsers based on Chromium or the Blink engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Chromium behavior, or if another browser engine
  /// tries to impersonate the Chromium runtime environment.
  bool get isChromium => false; // TODO: How?

  /// A best-effort attempt to detect when running in a Webkit-based browser.
  ///
  /// May detect the Safari browser, or other browsers based on the Webkit
  /// browser engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Webkit behavior, or if another browser engine
  /// tries to impersonate the Safari runtime environment.
  bool get isWebkit => false;

  /// A best-effort attempt to detect when running in a Mozilla-based browser.
  ///
  /// May detect the Mozilla Firefox browser, other browsers based on the
  /// Mozilla Gecko or Quantum browser engines.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Firefox behavior, or if another browser engine
  /// tries to impersonate the Firefox runtime environment.
  bool get isMozilla => false;

  /// A JSON representation of the state of this platform object.
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        json_key.userAgent: userAgent,
        json_key.version: version,
      });
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
