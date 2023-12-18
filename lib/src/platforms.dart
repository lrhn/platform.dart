// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// All classes and interfaces exposed by the package.
///
/// All classes are declared in the same library, so that they can all be final,
/// and still depend on each other.
///
/// The [NativePlatform] type and subtypes are only intended to be used
/// on native platforms.
/// When compiled on other platforms, the declarations still exist,
/// but all operations throw.
/// The throwing classes are not exposed in the package's public API,
/// instead the `native.dart`, `native_test.dart` and `platform.dart`
/// libraries conditionally export an empty library when `dart:io`
/// is not available.
library;

import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

import 'platform_specific/platform_unknown.dart'
    if (dart.library.html) 'platform_specific/platform_web.dart'
    if (dart.library.io) 'platform_specific/platform_io.dart' as impl;

part 'platforms_api_part.dart';
part 'platforms_impl_part.dart';
part 'platforms_mock_part.dart';

/// String tag identifying which import was used for `impl`.
///
/// Used in this package's own tests.
/// One of `"native"`, `"browser"` or `"unknown"`.
@visibleForTesting
const hostPlatformKind = impl.hostPlatformKind;

// Set to true if any of the mock platforms are used to override
// the `current` platform getters using a zone variable.
// Until that happens, there is no need to check whether the zone contains
// an override value.
bool _potentialOverride = false;

/// Rename of [MockHostPlatform] for backwards compatibility.
///
/// Name is currently exported by the `package:platform/platform.dart` library.
/// Users should use [MockHostPlatform] from
/// `package:platform/host_test.dart` instead.
@visibleForTesting
typedef FakePlatform = MockNativePlatform;

/// Rename of an implementation of [HostPlatform] for backwards compatibility.
///
/// Name is currently exported by the `package:platform/platform.dart` library.
/// Users should use [HostPlatform.current] instead of constructing a
/// [LocalPlatform].
typedef LocalPlatform = _NativePlatform;

/// Rename of [HostPlatform] for backwards compatibility.
///
/// Name is currently exported by the `package:platform/platform.dart` library.
/// Users should use [HostPlatform] instead.
typedef Platform = NativePlatform;
