// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

/// Properties of the current platform.
///
/// The [HostPlatform.current] object represents the current runtime platform
/// with at most one of [HostPlatform.nativePlatform] or
/// [HostPlatform.browserPlatform] being non-`null`.
/// Which one is non-`null` depends on the runtime system the current program is
/// running on.
///
/// That non-`null` value can provide more information about the current native
/// or browser platform, respectively.
///
/// [!NOTE]
/// This library currently provides deprecated legacy [Platform],
/// [LocalPlatform] and [FakePlatform] types, which only gives access to
/// native platform information.
/// Code using those types should use [NativePlatform] instead of [Platform],
/// use [`Platform.current.nativePlatform`](Platform.nativePlatform) to access
/// an instance instead of creating a [LocalPlatform].
/// Code using [FakePlatform] should import `package:platform/testing.dart`
/// and use [FakeNativePlatform] instead.
///
/// @docImport 'src/legacy_implementation/legacy_platform.dart';
/// @docImport 'src/platforms.dart';
/// @docImport 'testing.dart';
library;

// Legacy classes implemented as type aliases and extension types.
export 'src/legacy_implementation/legacy_platform.dart'
    show FakePlatform, LocalPlatform, Platform;

export 'src/platforms.dart'
    show BrowserPlatform, HostPlatform, NativePlatform, PlatformIsOS;
