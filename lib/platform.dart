// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Properties of the current platform.
///
/// The [Platform.current] object represents the current runtime platform
/// by having one of [Platform.nativePlatform] or [Platform.browserPlatform]
/// being non-`null`, depending on the runtime system the current program is
/// running on.
///
/// That value can the provide more information about the current native,
/// or browser platform.
///
/// [!NOTE]
/// This library currently provides  deprecated legacy [LocalPlatform]
/// and [FakePlatform] classes, and exposes deprecated members on the
/// [Platform] interface.
/// Code using those deprecated members or the class [LocalPlatform] should use
/// [Platform.current.nativePlatform] instead.
/// Code using [FakePlatform] should import `package:platform/platform_testing.dart`
/// and use `FakeNativePlatform` instead.
/// Be aware that `package:platform/platform_testing.dart` exposes a
/// *different* class named `FakePlatform`, so using the two libraries
/// together requires hiding `FakePlatform` from `platform_testing.dart`
/// until all legacy [FakePlatform] uses have been removed.
/// The legacy [FakePlatform] is also available as [LegacyFakePlatform].
library;

// Legacy classes, `LocalPlatform` and `FakePlatform`
// (not the same as `FakePlatform` from `testing.dart`).
// ignore: deprecated_member_use_from_same_package
export 'src/legacy_implementation/legacy_classes.dart'
    show
        FakePlatform, // ignore: deprecated_member_use_from_same_package
        LegacyFakePlatform, // ignore: deprecated_member_use_from_same_package
        LocalPlatform; // ignore: deprecated_member_use_from_same_package

export 'src/platforms.dart'
    show BrowserPlatform, NativePlatform, Platform, PlatformIsOS;
