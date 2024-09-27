// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:meta/meta.dart';

import '../platforms_impl.dart';
import '../testing/fake_native_platform.dart' show FakeNativePlatform;
export 'legacy_local_platform_non_native.dart'
    if (dart.library.io) 'legacy_local_platform_native.dart';

/// Legacy `Platform` type representing a native platform.
///
/// Use [NativePlatform] instead.
@Deprecated('Use NativePlatform instead')
typedef Platform = NativePlatform;

/// Legacy name and API for [FakeNativePlatform].
///
/// Import `package:platform/testing.dart` and use [FakeNativePlatform] instead.
@visibleForTesting
@Deprecated(
    'Use FakeNativePlatform from \'package:platform/testing.dart\' instead')
typedef FakePlatform = FakeNativePlatform;
