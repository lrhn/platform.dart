// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Platform specific implementations for `LocalPlatform`
// when `dart:html` is available (which means it's on the web).

import 'dart:html';

const String operatingSystem = "browser";

final String operatingVersion = window.navigator.userAgent;
