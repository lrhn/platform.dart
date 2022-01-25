// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

/// Provides API parity with the `Platform` class in `dart:io`, but using
/// instance properties rather than static properties. This difference enables
/// the use of these APIs in tests, where you can provide mock implementations.
abstract class Platform {
  /// Creates a new [Platform].
  const Platform();

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is Linux.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is Linux, use [isLinux].
  static const String linux = 'linux';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is Windows.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is Windows, use [isWindows].
  static const String windows = 'windows';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is macOS.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is macOS, use [isMacOS].
  static const String macOS = 'macos';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is Android.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is Android, use [isAndroid].
  static const String android = 'android';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is iOS.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is iOS, use [isIOS].
  static const String iOS = 'ios';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is Fuchsia.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is Fuchsia, use [isFuchsia].
  static const String fuchsia = 'fuchsia';

  /// A string constant to compare with [operatingSystem] to see if the platform
  /// is a browser.
  ///
  /// Useful in case statements when switching on [operatingSystem].
  ///
  /// To just check if the platform is a browser, use [isBrowser].
  static const String browser = 'browser';

  /// A list of the possible values that [operatingSystem] can return.
  static const List<String> operatingSystemValues = <String>[
    linux,
    macOS,
    windows,
    android,
    iOS,
    fuchsia,
    browser,
  ];

  /// A string representing the operating system.
  ///
  /// The currently possible return values are available
  /// from [operatingSystemValues], and there are constants
  /// for each of the platforms to use in switch statements
  /// or conditionals (See [linux], [macOS], [windows], [android], [iOS],
  /// [fuchsia], and [browser]).
  String get operatingSystem;

  /// A string representing the version of the operating system or platform.
  String get operatingSystemVersion;

  /// Whether if the operating system is Linux.
  bool get isLinux => operatingSystem == linux;

  /// Whether if the operating system is OS X.
  bool get isMacOS => operatingSystem == macOS;

  /// Whether if the operating system is Windows.
  bool get isWindows => operatingSystem == windows;

  /// Whether if the operating system is Android.
  bool get isAndroid => operatingSystem == android;

  /// Whether if the operating system is iOS.
  bool get isIOS => operatingSystem == iOS;

  /// Whether if the operating system is Fuchsia.
  bool get isFuchsia => operatingSystem == fuchsia;

  /// Whether if the operating system is a browser.
  bool get isBrowser => operatingSystem == browser;

  /// A JSON-encoded representation of this platform.
  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
      'operatingSystem': operatingSystem,
      'operatingSystemVersion': operatingSystemVersion,
    });
  }
}
