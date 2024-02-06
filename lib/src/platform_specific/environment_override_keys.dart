// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Constants for the compilation environment keys for overrides.
library;

/// Compilation environment key for overriding the operating system string
///
/// Only has effect on native platforms.
const String environmentOsOverride = 'pkg.platform.operatingSystem';

/// Compilation environment key for overriding the operating system version
/// string.
///
/// Only has effect on native platforms.
const String environmentOsVersionOverride =
    'pkg.platform.operatingSystemVersion';
