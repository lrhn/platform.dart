// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Wasm specific platform.
library pkg.platform.impl;

import 'dart:async' show Zone;
import 'dart:convert' show JsonEncoder;

import '../json_keys.dart' as json_key;
import '../zone_overrides.dart' as override;
import 'platform_browser_interface.dart';
import 'platform_native_interface.dart';

const Platform platformInstance = Platform._();
const WasmPlatform wasmPlatformInstance = WasmPlatform._();

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
  @pragma('vm:prefer-inline')
  static Platform get current => override.marker == null
      ? platformInstance
      : ((Zone.current[override.zoneKey] as Platform?) ?? platformInstance);

  /// The current native platform, if running on a native platform.
  @pragma('vm:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('vm:prefer-inline')
  BrowserPlatform? get browserPlatform => null;

  /// The current Wasm platform, if running on a Wasm platform.
  @pragma('vm:prefer-inline')
  WasmPlatform? get wasmPlatform => wasmPlatformInstance;

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

/// Properties of the current Wasm runtime environment.
final class WasmPlatform {
  const WasmPlatform._();

  /// The current Wasm platform, if any.
  ///
  /// Same as [Platform.current.wasmPlatform].
  static WasmPlatform? get current => Platform.current.wasmPlatform;

  /// Version number divined from somewhere.
  String get version => '1.0.0'; // Don't know how to detect Wasm runtime.

  /// A JSON representation of the state available through this Wasm platform.
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        json_key.version: version,
      });
}

abstract base class WasmPlatformTestBase implements WasmPlatform {}
