// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Guarded export of `NativePlatform` implementation, to ensure that there
// is no class even if the web platform provides a mock `dart:io` library.

export 'src/native_platform/native_platform_guarded.dart'
    if (dart.library.io ==
        "false") 'src/native_platform/no_native_platform.dart'
    if (dart.library.io == "") 'src/native_platform/no_native_platform.dart';
