// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An empty library exported by `native.dart` and `native_test.dart` when
/// not compiled for a native platform (anywhere `dart:io` is not available).
/// This ensures that the API is native-only, and the deprecations notice
/// will inform the user about this.
@Deprecated('Only import native platform libraries in native applications')
library;
