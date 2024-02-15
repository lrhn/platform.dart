// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// The names of properties and the keys used by `toJson` and `fromJson`.
// As constants to avoid typos. In a namespace to avoid pollution,
// and non-private so they can be used in tests.
extension JsonKey on Never {
  static const environment = 'environment';
  static const executable = 'executable';
  static const executableArguments = 'executableArguments';
  static const lineTerminator = 'lineTerminator';
  static const localeName = 'localeName';
  static const localHostname = 'localHostname';
  static const numberOfProcessors = 'numberOfProcessors';
  static const operatingSystem = 'operatingSystem';
  static const operatingSystemVersion = 'operatingSystemVersion';
  static const packageConfig = 'packageConfig';
  static const pathSeparator = 'pathSeparator';
  static const resolvedExecutable = 'resolvedExecutable';
  static const script = 'script';
  static const stdinSupportsAnsi = 'stdinSupportsAnsi';
  static const stdoutSupportsAnsi = 'stdoutSupportsAnsi';
  static const userAgent = 'userAgent';
  static const version = 'version';
}
