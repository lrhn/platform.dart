// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Constants of the compilation environment keys for overrides.
///
/// Using the compilation environment to override the operating system
/// ID string should only be used for testing this package.
/// It interacts badly with tree-shaking.
library;

/// Compilation environment key for overriding the platform string.
const String environmentOsOverride = 'pkg.platform.operatingSystem';

/// Compilation environment key for overriding the platform version string.
const String environmentOsVersionOverride =
    'pkg.platform.operatingSystemVersion';
