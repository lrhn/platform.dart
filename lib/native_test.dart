// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Native platform information access, and mocking for tests.
///
/// When using this library, the program should not be running in a browser,
/// since correct behavior depends on using the `dart:io` library.
/// Use `package:platform/host_test.dart` for host-platform detection
/// and mocking that also works in a browser.
///
/// This library provides an interface, [NativePlatform],
/// a default implementation provided by [NativePlatform.current],
/// and a mockable implementation [MockNativePlatform],
/// which can be used for testing.
///
/// The [NativePlatform] provides access to most of the static properties
/// of the [dart:io.Platform] namespace, and a few other properties
/// from `dart:io`.
/// The [NativePlatform] is a drop-in replacement for [HostPlatform]
/// but also exposes *more* native properties that are only available to
/// native programs, those not running in a browser.
/// See [HostPlatform] for how to detect the host operating system.
///
/// By using an object to provide access to the members of `dart:io`'s
/// `Platform`, `stdin` and `stdout`,
/// instead using direct access to the static getters in `dart:io`,
/// code can be parameterized by a `NativePlatform` object,
/// and one can then provide a custom/mock implementation
/// using [MockNativePlatform], for testing.
/// Also, the [MockNativePlatform.run] method provides a way to *override* the
/// [NativePlatform.current] getter while running its argument function,
/// which works for asynchronous functions using a custom zone.
/// Using that, even code using, e.g., `NativePlatform.current.isLinux` directly
/// can still have its behavior modified during testing.
///
/// {@canonicalFor platforms.MockNativePlatform}
library;

export 'src/platforms.dart'
    if (dart.library.html) 'src/no_native_platform.dart'
    if (dart.library.io) 'src/platforms.dart'
    if (dart.library.core) 'src/no_native_platform.dart'
    show HostPlatform, MockHostPlatform, MockNativePlatform, NativePlatform;
