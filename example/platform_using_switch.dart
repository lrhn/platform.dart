// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';

void main() {
  switch (HostPlatform.current) {
    case HostPlatform(:var browserPlatform?):
      print('Running in a browser');
      print('User-agent: ${browserPlatform.userAgent}');
    case HostPlatform(nativePlatform: var nativePlatform?)
        when nativePlatform.isLinux |
            nativePlatform.isMacOS |
            nativePlatform.isWindows:
      print('Running on ${nativePlatform.operatingSystem}');
      print('Hostname: ${nativePlatform.localHostname}');
    default:
      print('Not running on supported platform');
  }
}
