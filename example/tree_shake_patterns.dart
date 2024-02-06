// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';

// Compile this for a specific platform, and check that the executable
// does not contain the strings for other platforms.
// (On Unix, use `string tree_shake_patterns.exe | grep "RUNNING ON"`.)
//
// Current optimizations do *not* allow tree-shaking based on patterns.
void main() {
  switch (Platform.current) {
    case Platform(:var browserPlatform?):
      print('RUNNING IN A BROWSER');
      print('User-agent: ${browserPlatform.userAgent}');
    case Platform(:var nativePlatform?) when nativePlatform.isLinux:
      print('RUNNING ON LINUX');
    case Platform(:var nativePlatform?) when nativePlatform.isMacOS:
      print('RUNNING ON MACOS');
    case Platform(:var nativePlatform?) when nativePlatform.isWindows:
      print('RUNNING ON WINDOWS');
  }
}
