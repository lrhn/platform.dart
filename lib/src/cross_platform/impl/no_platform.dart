// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Default fallback for platform detection if neither
// dart:io nor dart:html are available.
//
// A platform can set the compile-time environment entries
// * `pkg.platform.operatingSystem`
// * `pkg.platform.operatingSystemVersion`
//
// to the string values that these constants return.

const String operatingSystem = String.fromEnvironment(
    'pkg.platform.operatingSystem',
    defaultValue: 'unknown');

const String operatingSystemVersion = String.fromEnvironment(
    'pkg.platform.operatingSystemVersion',
    defaultValue: 'unknown');
