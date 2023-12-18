// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Operating system detection and mocking for tests.
///
/// This library provides an interface, [HostPlatform],
/// a default implementation provided by [HostPlatform.current],
/// and a mockable implementation [MockHostPlatform],
/// which can be used for testing.
///
/// The [HostPlatform.operatingSystem] string can be used to recognize
/// known host platforms. On currently supported platforms the value is one of
/// * `"android"` when running on an Android host.
/// * `"browser"` when running inside a browser.
/// * `"fuchsia"` when running on a Fuchsia OS host.
/// * `"ios"` when running on Apple iOS host.
/// * `"linux"` when running on a Linux host.
/// * `"macos"` when running on an Apple MacOS/OSX host.
/// * `"windows"` when running on a Microsoft Windows host.
///
/// When running inside a browser, it's not possible to detect the underlying
/// host platform that the browser is running on through this library.
///
/// The currently recognized ID strings are available as static properties of
/// [HostPlatform], for example [HostPlatform.android], [HostPlatform.macOS]
/// and [HostPlatform.windows],
/// and as a list, [HostPlatform.operatingSystemValues].
///
/// The [HostPlatform] has a number of helpers properties,
/// [HostPlatform.isAndroid] through [HostPlatform.isWindows],
/// which checks the [HostPlatform.operatingSystem] values against these
/// known values.
///
/// By using an object to provide access to the information,
/// instead of directly accessing the static getters from `dart:io`,
/// `Platform.operatingSystem` and `Platform.operatingSystemVersion`,
/// code can be parameterized by a `HostPlatform` object,
/// and a custom/mock implementation can be provided for testing.
///
/// Use the `package:platform/host_test.dart` instead of this one
/// in tests that need to introduce a mock platform.
///
/// {@canonicalFor platforms.HostPlatform}
library;

export 'src/platforms.dart' show HostPlatform;
