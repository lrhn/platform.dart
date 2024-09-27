// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../platforms_impl.dart';
import 'legacy_platform.dart';

// ignore: deprecated_member_use_from_same_package
/// Legacy [Platform] implementation that only works on native platforms.
///
/// Use [HostPlatform.current.nativePlatform] to access a native platform
/// instead.
@Deprecated('Use HostPlatform.current.nativePlatform instead')
final class LocalPlatform extends NativePlatformTestBase {
  const factory LocalPlatform() = LocalPlatform._;

  const LocalPlatform._();

  @override
  Map<String, String> get environment =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get executable =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  List<String> get executableArguments =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isAndroid =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isFuchsia =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isIOS =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isLinux =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isMacOS =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get isWindows =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get lineTerminator =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get localHostname =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get localeName =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  int get numberOfProcessors =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get operatingSystem =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get operatingSystemVersion =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String? get packageConfig =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get pathSeparator =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get resolvedExecutable =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  Uri get script =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get stdinSupportsAnsi =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  bool get stdoutSupportsAnsi =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String toJson() =>
      throw UnsupportedError('LocalPlatform only works on native platforms');

  @override
  String get version =>
      throw UnsupportedError('LocalPlatform only works on native platforms');
}
