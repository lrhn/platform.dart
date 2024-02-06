// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';

// Compile this for a specific platform, and check that the executable
// does not contain the strings for other platforms.
// (On Unix, use `string tree_shake.exe | grep "RUNNING ON"`.)
void main() {
  if (Platform.current.isBrowser) {
    print('RUNNING IN A BROWSER');
  } else if (Platform.current.isNative) {
    var native = Platform.current.nativePlatform!;
    if (native.isLinux) {
      print('RUNNING ON LINUX');
    } else if (native.isMacOS) {
      print('RUNNING ON MACOS');
    } else if (native.isWindows) {
      print('RUNNING ON WINDOWS');
    }
  }
}
