// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Exports an implementation of the *current* platform,
/// and abstract interfaces for the rest.
library;

export "platform_native_interface.dart"
    if (dart.library.io) "platform_native_impl.dart" show NativePlatform;

export "platform_browser_interface.dart"
    if (dart.library.js) "platform_browser_impl.dart" show BrowserPlatform;

export "platform_wasm_interface.dart"
    if (dart.library.wasm) "platform_wasm_impl.dart" show WasmPlatform;

export "platform_unknown_interface.dart"
    if (dart.library.io) "platform_native_impl.dart"
    if (dart.library.js) "platform_browser_impl.dart"
    if (dart.library.wasm) "platform_wasm_impl.dart" show Platform;
