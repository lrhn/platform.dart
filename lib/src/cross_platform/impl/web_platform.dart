// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Platform specific implementations for `LocalPlatform`
// when `dart:html` is available (which means it's on the web).

import 'dart:html';

const String operatingSystem = String.fromEnvironment(
    'pkg.platform.operatingSystem',
    defaultValue: 'browser');

final String operatingSystemVersion =
    _operatingSystemVersionOverride ?? window.navigator.userAgent;

const String? _operatingSystemVersionOverride =
    bool.hasEnvironment('pkg.platform.operatingSystemVersion')
        ? String.fromEnvironment('pkg.platform.operatingSystemVersion',
            defaultValue: '')
        : null;
