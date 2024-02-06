// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Properties of the current platform.
///
/// The [Platform.current] object represents the current runtime platform
/// by having one of [Platform.nativePlatform], [Platform.browserPlatform]
/// or [Platform.wasmPlatform] being non-`null`, depending on the runtime
/// system the current program is running on.
///
/// That value can the provide more information about the current native,
/// browser or Wasm platform.
library;

export 'src/platforms.dart'
    show Platform, NativePlatform, BrowserPlatform, WasmPlatform;
