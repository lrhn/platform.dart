// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The abstract interfaces of [HostPlatform] and [NativePlatform].
part of 'platforms.dart';

/// The operating system information of the current host platform.
///
/// Works both natively and on the web.
///
/// The host platform is the underlying operating system that a native
/// program is running on.
/// For example when running on a Linux host,
/// the [operatingSystem] is ['"linux"'](linux) and [isLinux] is true, while
/// the other `is...` predicates are false.
/// On the the web, [operatingSystem] is always [`"browser"`](browser),
/// and [isBrowser] is always the true predicate.
abstract final class HostPlatform {
  /// The value of [operatingSystem] on Linux.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Linux, use
  /// [isLinux](HostPlatforms.isLinux).
  static const String linux = 'linux';

  /// The value of [operatingSystem] on Windows.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Windows, use
  /// [isWindows](HostPlatforms.isWindows).
  static const String windows = 'windows';

  /// The value of [operatingSystem] on macOS.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is macOS, use [isMacOS].
  static const String macOS = 'macos';

  /// The value of [operatingSystem] on Android.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Android, use [isAndroid].
  static const String android = 'android';

  /// The value of [operatingSystem] on iOS.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is iOS, use [isIOS].
  static const String iOS = 'ios';

  /// The value of [operatingSystem] on Fuchsia.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Fuchsia, use [isFuchsia].
  static const String fuchsia = 'fuchsia';

  /// The value of [operatingSystem] on a browser.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is a browser, use [isBrowser].
  static const String browser = 'browser';

  /// A list of the known values that [operatingSystem] can have.
  static const List<String> operatingSystemValues = <String>[
    android,
    browser,
    fuchsia,
    iOS,
    linux,
    macOS,
    windows,
  ];

  /// The current host platform.
  ///
  /// A `HostPlatform` object which represents the current host platform.
  /// Its [operatingSystem] and [operatingSystemVersion] corresponds
  /// to the host platform and version that the current program runs on.
  static HostPlatform get current =>
      (_potentialOverride ? Zone.current[#_override] as HostPlatform? : null) ??
      _HostPlatform._instance;

  /// A string representing the operating system.
  ///
  /// The currently possible return values are available
  /// from [operatingSystemValues], and there are constants
  /// for each of the platforms to use in switch statements
  /// or conditionals (See [linux], [macOS], [windows], [android], [iOS],
  /// [fuchsia], and [browser]).
  abstract final String operatingSystem;

  /// A string representing the version of the operating system or platform.
  abstract final String operatingSystemVersion;

  const HostPlatform._();

  /// Whether the operating system is Android.
  bool get isAndroid;

  /// Whether the operating system is a browser.
  bool get isBrowser;

  /// Whether the operating system is Fuchsia.
  bool get isFuchsia;

  /// Whether the operating system is iOS.
  bool get isIOS;

  /// Whether the operating system is Linux.
  bool get isLinux;

  /// Whether the operating system is OS X.
  bool get isMacOS;

  /// Whether the operating system is Windows.
  bool get isWindows;

  /// A JSON-like map representation of the operating system information.
  Map<String, Object?> toJsonMap();

  /// A JSON-encoded representation of the operating system information.
  ///
  /// If [terse] is set to `true`, the representation will omit unnecessary
  /// whitespace.
  String toJson({bool terse = false});
}

/// Access to the properties of the [HostPlatform] class from `dart:io`.
///
/// Provides API parity with the `HostPlatform` class in `dart:io`, but using
/// instance properties rather than static properties. This difference enables
/// the use of these APIs in tests, where you can provide mock implementations.
abstract final class NativePlatform implements HostPlatform {
  /// The [operatingSystem] value on Android.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Android, use [isAndroid].
  static const String android = HostPlatform.android;

  /// The [operatingSystem] value in a browser.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is a browser, use [isBrowser].
  static const String browser = HostPlatform.browser;

  /// The [operatingSystem] value on iOS.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is iOS, use [isIOS].
  static const String iOS = HostPlatform.iOS;

  /// The [operatingSystem] value on Fuchsia.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Fuchsia, use [isFuchsia].
  static const String fuchsia = HostPlatform.fuchsia;

  /// The [operatingSystem] value on Linux.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Linux, use [isLinux].
  static const String linux = HostPlatform.linux;

  /// The [operatingSystem] value on macOS.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is macOS, use [isMacOS].
  static const String macOS = HostPlatform.macOS;

  /// The [operatingSystem] value on Windows.
  ///
  /// Can be used, for example, in switch cases when switching on
  /// [operatingSystem].
  ///
  /// To just check if the platform is Windows, use [isWindows].
  static const String windows = HostPlatform.windows;

  /// A list of the possible values that [operatingSystem] can return.
  static const List<String> operatingSystemValues =
      HostPlatform.operatingSystemValues;

  /// The current native platform.
  ///
  /// An instance of `NativePlatform` which responds with the properties
  /// available through the `dart:io` library.
  static NativePlatform get current =>
      (_potentialOverride
          ? Zone.current[#_overrideNative] as NativePlatform?
          : null) ??
      _NativePlatform._instance;

  /// The environment for this process.
  ///
  /// The returned environment is an unmodifiable map whose content is
  /// retrieved from the operating system on its first use.
  ///
  /// Environment variables on Windows are case-insensitive. The map
  /// returned on Windows is therefore case-insensitive and will convert
  /// all keys to upper case. On other platforms the returned map is
  /// a standard case-sensitive map.
  Map<String, String> get environment;

  /// The path of the executable used to run the script in this isolate.
  ///
  /// The path returned is the literal path used to run the script. This
  /// path might be relative or just be a name from which the executable
  /// was found by searching the `PATH`.
  ///
  /// To get the absolute path to the resolved executable use
  /// [resolvedExecutable].
  String get executable;

  /// The flags passed to the executable used to run the script in this
  /// isolate. These are the command-line flags between the executable name
  /// and the script name. Each fetch of `executableArguments` returns a new
  /// list containing the flags passed to the executable.
  List<String> get executableArguments;

  /// The default line terminator on the current platform.
  ///
  /// Is a line feed (`"\n"`, U+000A) on most platforms, but
  /// carriage return followed by linefeed (`"\r\n"`, U+000D + U+000A)
  /// on Windows.
  String get lineTerminator;

  /// Get the name of the current locale.
  String get localeName;

  /// Get the local hostname for the system.
  String get localHostname;

  /// The number of processors of the machine.
  int get numberOfProcessors;

  /// The value of the `--packages` flag passed to the executable
  /// used to run the script in this isolate. This is the configuration which
  /// specifies how Dart packages are looked up.
  ///
  /// If there is no `--packages` flag, `null` is returned.
  String? get packageConfig;

  /// The path separator used by the operating system to separate
  /// components in file paths.
  String get pathSeparator;

  /// The path of the executable used to run the script in this
  /// isolate after it has been resolved by the OS.
  ///
  /// This is the absolute path, with all symlinks resolved, to the
  /// executable used to run the script.
  String get resolvedExecutable;

  /// The absolute URI of the script being run in this
  /// isolate.
  ///
  /// If the script argument on the command line is relative,
  /// it is resolved to an absolute URI before fetching the script, and
  /// this absolute URI is returned.
  ///
  /// URI resolution only does string manipulation on the script path, and this
  /// may be different from the file system's path resolution behavior. For
  /// example, a symbolic link immediately followed by '..' will not be
  /// looked up.
  ///
  /// If the executable environment does not support [script] an empty
  /// [Uri] is returned.
  Uri get script;

  /// When stdin is connected to a terminal, whether ANSI codes are supported.
  bool get stdinSupportsAnsi;

  /// When stdout is connected to a terminal, whether ANSI codes are supported.
  bool get stdoutSupportsAnsi;

  /// The version of the current Dart runtime.
  ///
  /// The returned `String` is formatted as the [semver](http://semver.org)
  /// version string of the current dart runtime, possibly followed by
  /// whitespace and other version and build details.
  String get version;

  /// A JSON-like map representation of platform information.
  @override
  Map<String, Object?> toJsonMap();

  /// A JSON-encoded representation of platform information.
  @override
  String toJson({bool terse = false});
}
