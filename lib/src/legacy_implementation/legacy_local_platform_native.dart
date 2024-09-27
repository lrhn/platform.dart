// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: deprecated_member_use_from_same_package

import '../platforms_impl.dart';
import 'legacy_platform.dart';

/// Legacy name and type for access to the current platform.
///
/// A [Platform] (and [NativePlatform]) that is backed by the `dart:io` library.
/// The `dart:io` library must be available.
///
/// Use [`NativePlatform.current.nativePlatform`](HostPlatform.nativePlatform)
/// instead.
@Deprecated('Use HostPlatform.current.nativePlatform instead')
extension type const LocalPlatform._(NativePlatform _)
    implements NativePlatform {
  const LocalPlatform()
      : assert(nativePlatformInstance != null,
            'LocalPlatform is only available on native platforms'),
        _ = nativePlatformInstance as NativePlatform;
}
