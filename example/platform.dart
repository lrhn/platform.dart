// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';

void main(List<String> arguments) {
  final nativePlatform = HostPlatform.current.nativePlatform;
  if (nativePlatform == null) {
    print('This program only supports execution on native platforms.');
  } else {
    print('Operating System: ${nativePlatform.operatingSystem}.');
    print('Local Hostname: ${nativePlatform.localHostname}.');
    print('Number of Processors: ${nativePlatform.numberOfProcessors}.');
    print('Path Separator: ${nativePlatform.pathSeparator}.');
    print('Locale Name: ${nativePlatform.localeName}.');
    print('Stdin Supports ANSI: ${yn(nativePlatform.stdinSupportsAnsi)}.');
    print('Stdout Supports ANSI: ${yn(nativePlatform.stdoutSupportsAnsi)}.');
    print('Executable Arguments: ${nativePlatform.executableArguments}.');
    print('Dart Version: ${nativePlatform.version}.');
  }
}

String yn(bool yesOrNo) => yesOrNo ? 'yes' : 'no';
