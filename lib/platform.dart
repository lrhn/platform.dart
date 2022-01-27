// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/cross_platform/local_platform.dart' as local;

/// Cross-platform classes and interfaces.
export 'src/cross_platform/platform.dart';
export 'src/cross_platform/testing/fake_platform.dart' show FakePlatform;

@Deprecated('Use Platform.current instead')
typedef LocalPlatform = local.LocalPlatform;
