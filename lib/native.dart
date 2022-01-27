// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/native_platform/local_native_platform.dart' as local;

/// Native platform specific classes and interfaces.
export 'src/native_platform/native_platform.dart';
export 'src/native_platform/testing/fake_native_platform.dart';

@Deprecated('Use NativePlatform.current instead')
typedef LocalNativePlatform = local.LocalNativePlatform;
