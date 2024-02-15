// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// All classes and interfaces exposed by the package.
///
/// All classes are declared in the same library, so that they can all be final,
/// and still depend on each other.
library;

export 'platform_specific/platform_unknown.dart'
    if (dart.library.html) 'platform_specific/platform_browser.dart'
    if (dart.library.io) 'platform_specific/platform_native.dart'
    if (dart.library.wasm) 'platform_specific/platform_wasm.dart'
    show
        BrowserPlatform,
        FakeBrowserPlatform,
        FakeNativePlatform,
        FakeWasmPlatform,
        NativePlatform,
        Platform,
        PlatformIsOS,
        WasmPlatform;
