// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform information and mocking for tests.
///
/// This library provides the [Platform] interface of the `platform.dart`
/// library, and the [BrowserPlatform], [NativePlatform] and [WasmPlatform]
/// types that it may or may not expose an instance of.
///
/// On top of that, this library also exposes mock-versions of those
/// platform specific classes: [FakeBrowserPlatform], [FakeNativePlatform]
/// and [FakeWasmPlatform].
///
/// These classes can be used to specify a platform configuration that is not
/// the actual current platform.
/// Using the `run` methods of those fake-classes will run a function in
/// a context where [Platform.current] exposes the fake configuration.
///
/// These fake classes should *only* be used for testing.
/// Even including them in a production program may cause more code to
/// be retained than necessary.
library;

export 'platform.dart';
export 'src/fake_platforms.dart'
    show
        FakeBrowserPlatform,
        FakeNativePlatform,
        FakePlatform,
        FakeWasmPlatform;
