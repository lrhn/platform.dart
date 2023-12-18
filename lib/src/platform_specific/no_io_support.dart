// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// /Namespace which mimics `dart:io`, but throws on any access to
/// the members that native platforms use.
///
/// Used by non-`platform_io.dart` platform libraries to expose the needed
/// to compile [_NativePlatform], even if we don't actually expose that class
/// on non-native platforms.
library;

extension Platform on Never {
  static Never get environment => throw _unsupported('environment');
  static Never get executable => throw _unsupported('executable');
  static Never get executableArguments =>
      throw _unsupported('executableArguments');
  static Never get lineTerminator => throw _unsupported('lineTerminator');
  static Never get localeName => throw _unsupported('localeName');
  static Never get localHostname => throw _unsupported('localHostname');
  static Never get numberOfProcessors =>
      throw _unsupported('numberOfProcessors');
  static Never get packageConfig => throw _unsupported('packageConfig');
  static Never get pathSeparator => throw _unsupported('pathSeparator');
  static Never get resolvedExecutable =>
      throw _unsupported('resolvedExecutable');
  static Never get script => throw _unsupported('script');
  static Never get version => throw _unsupported('version');
}

// ignore: camel_case_extensions
extension stdin on Never {
  static Never get supportsAnsiEscapes => throw _unsupported('stdin');
}

// ignore: camel_case_extensions
extension stdout on Never {
  static Never get supportsAnsiEscapes => throw _unsupported('stdin');
}

Error _unsupported(String name) =>
    UnsupportedError('$name only supported on native platforms');
