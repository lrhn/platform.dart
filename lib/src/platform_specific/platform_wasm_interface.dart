// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Wasm specific platform.
library pkg.platform.impl;

import 'platforms_impl.dart' show Platform;

/// Properties of the current Wasm runtime environment.
abstract final class WasmPlatform {
  const WasmPlatform._();

  /// The current Wasm platform, if any.
  ///
  /// Same as [Platform.current.wasmPlatform].
  static WasmPlatform? get current => Platform.current.wasmPlatform;

  /// Version number divined from somewhere.
  abstract final String version;

  /// A JSON representation of the state available through this Wasm platform.
  String toJson();
}

abstract base class WasmPlatformTestBase implements WasmPlatform {}
