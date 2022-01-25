// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'platform.dart';

import 'impl/no_platform.dart'
    if (dart.library.io) 'impl/io_platform.dart'
    if (dart.library.html) 'impl/io_platform.dart' as impl;

/// [Platform] implementation that reveals the current platform
class LocalPlatform extends Platform {
  /// Creates a new [LocalPlatform].
  const LocalPlatform();

  @override
  String get operatingSystem => impl.operatingSystem;

  @override
  String get operatingSystemVersion => impl.operatingSystemVersion;
}
