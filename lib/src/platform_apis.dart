// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore: use_string_in_part_of_directives
part of pkg.platform.impl;

/// Set to true only if someone uses a fake platform to override the default.
///
/// Until then, there is no need to even check for an override.
bool _platformOverrideUsed = false;

/// Key used in Zone environment to override the current platform.
const _platformOverrideKey = #_currentPlatformOverride;

/// Dart runtime platform information.
///
/// Provides information about the current runtime environment.
///
/// If running as native code, the [nativePlatform] object is
/// non-`null` and provides information about that platform,
/// including the [NativePlatform.operatingSystem] name.
///
/// If running in a browser, the [browserPlatform] objects is
/// non-`null` and provides information about the browser.
///
/// If running in a WebAssembly (Wasm) runtime, the [wasmPlatform] is
/// non-`null` and may one day provide information about the Wasm runtime.
final class Platform {
  /// The current [Platform] information of the running program.
  static Platform get current => !_platformOverrideUsed
      ? _currentPlatform // Is declared in the main library files.
      : ((Zone.current[_platformOverrideKey] as Platform?) ?? _currentPlatform);

  /// The current native platform, if running on a native platform.
  @pragma('vm:platform_const')
  final NativePlatform? nativePlatform;

  /// The current browser platform, if running on a browser platform.
  final BrowserPlatform? browserPlatform;

  /// THe current Wasm platform, if running on a Wasm platform.
  final WasmPlatform? wasmPlatform;

  /// Whether currently running on a native platform.
  @pragma('vm:platform_const')
  bool get isNative => nativePlatform != null;

  /// Whether currently running in a browser.
  bool get isBrowser => browserPlatform != null;

  /// Whether currently running in a Wasm runtime.
  bool get isWasm => wasmPlatform != null;

  const Platform._native(NativePlatform this.nativePlatform)
      : browserPlatform = null,
        wasmPlatform = null;
  const Platform._browser(BrowserPlatform this.browserPlatform)
      : nativePlatform = null,
        wasmPlatform = null;
  const Platform._wasm(WasmPlatform this.wasmPlatform)
      : nativePlatform = null,
        browserPlatform = null;

  /// A platform with *none* of the native, browser or Wasm platforms set.
  const Platform._unknown()
      : nativePlatform = null,
        browserPlatform = null,
        wasmPlatform = null;
}

/// Shorthands for checking operating system on the native platform.
///
/// Extension getters on `Platform` which forward to the operating system
/// checks on [Platform.nativePlatform], after checking that this is a native
/// platform.
extension PlatformIsOS on Platform {
  /// Whether this is a [nativePlatform] on [Android](NativePlatform.isAndroid).
  @pragma('vm:prefer_inline')
  bool get isAndroid => nativePlatform?.isAndroid ?? false;

  /// Whether this is a [nativePlatform] on [Fuchsia](NativePlatform.isFuchsia).
  @pragma('vm:prefer_inline')
  bool get isFuchsia => nativePlatform?.isFuchsia ?? false;

  /// Whether this is a [nativePlatform] on [iOS](NativePlatform.isIOS).
  @pragma('vm:prefer_inline')
  bool get isIOS => nativePlatform?.isIOS ?? false;

  /// Whether this is a [nativePlatform] on [Linux](NativePlatform.isLinux).
  @pragma('vm:prefer_inline')
  bool get isLinux => nativePlatform?.isLinux ?? false;

  /// Whether this is a [nativePlatform] on [MacOS](NativePlatform.isMacOS).
  @pragma('vm:prefer_inline')
  bool get isMacOS => nativePlatform?.isMacOS ?? false;

  /// Whether this is a [nativePlatform] on [Windows](NativePlatform.isWindows).
  @pragma('vm:prefer_inline')
  bool get isWindows => nativePlatform?.isWindows ?? false;
}

/// Properties of the current Wasm runtime environment.
abstract final class WasmPlatform {
  const WasmPlatform._();

  /// The current Wasm platform, if any.
  ///
  /// Same as [Platform.current.wasmPlatform].
  static WasmPlatform? get current => Platform.current.wasmPlatform;

  /// Version number divined from somewhere.
  abstract final String version;

  /// A JSON representation of the state available through this Wasm platform.
  String toJson();
}

/// Fake [WasmPlatform] for testing.
///
/// Create a fake platform, and install it as current platform
/// while running code as:
/// ```dart
/// FakeWasmPlatform(/*...*/).run(() { /*code*/ });`
/// ```
@visibleForTesting
final class FakeWasmPlatform extends WasmPlatform {
  static const String _className = 'FakeWasmPlatform';
  final String? _version;

  /// Creates a fake [WasmPlatform] with the provided properties.
  const FakeWasmPlatform({String? version})
      : _version = version,
        super._();

  /// Creates a fake [WasmPlatform] from the properties encoded in [jsonText].
  ///
  /// The properties should be the output of [WasmPlatform.toJson],
  /// or be compatible with that. Extra properties are ignored.
  ///
  /// Throws a [FormatException] if the [jsonText] is not acceptable.
  factory FakeWasmPlatform.fromJson(String jsonText) {
    var json = jsonDecode(jsonText);
    if (json is! Map<String, Object?>) {
      throw FormatException('Not a JSON map', jsonText);
    }
    return FakeWasmPlatform(
        version: _getJsonProperty<String>(json, JsonKey.version, jsonText));
  }

  factory FakeWasmPlatform.fromPlatform(WasmPlatform platform) {
    if (platform is FakeWasmPlatform) {
      return platform.copyWith();
    }
    return FakeWasmPlatform(version: platform.version);
  }

  FakeWasmPlatform copyWith({String? version}) =>
      FakeWasmPlatform(version: version ?? _version);

  /// Creates a JSON string from the state of the current fake [WasmPlatform].
  ///
  /// The result can be used as input to [FakeWasmPlatform.fromJson].
  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert(
      <String, Object?>{if (_version != null) JsonKey.version: _version});

  @override
  String get version => _throwIfUnset(_version, _className, JsonKey.version);

  /// Runs [fakePlatformCode] with this platform as the current Wasm platform.
  ///
  /// While [fakePlatformCode] is running, the [Platform.wasmPlatform]
  /// of [Platform.current] refers to this [FakeWasmPlatform].
  ///
  /// Prior reads of [Platform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [Platform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) {
    _platformOverrideUsed = true;
    return runZoned<R>(fakePlatformCode,
        zoneValues: {_platformOverrideKey: Platform._wasm(this)});
  }
}

/// Information about the current browser.
///
/// Only available while running in a browser.
abstract final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [Platform.current.browserPlatform].
  static BrowserPlatform? get current => Platform.current.browserPlatform;

  /// The browser's version, as reported by (something).
  String get version;

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  String get userAgent;

  /// A best-effort attempt to detect when running in a Chromium-based browser.
  ///
  /// May detect Chrome or browsers based on Chromium or the Blink engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Chromium behavior, or if another browser engine
  /// tries to impersonate the Chromium runtime environment.
  bool get isChromium;

  /// A best-effort attempt to detect when running in a Webkit-based browser.
  ///
  /// May detect the Safari browser, or other browsers based on the Webkit
  /// browser engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Webkit behavior, or if another browser engine
  /// tries to impersonate the Safari runtime environment.
  bool get isWebkit;

  /// A best-effort attempt to detect when running in a Mozilla-based browser.
  ///
  /// May detect the Mozilla Firefox browser, other browsers based on the
  /// Mozilla Gecko or Quantum browser engines.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Firefox behavior, or if another browser engine
  /// tries to impersonate the Firefox runtime environment.
  bool get isMozilla;

  /// A JSON representation of the state of this platform object.
  String toJson();
}

/// Fake [BrowserPlatform] for testing.
@visibleForTesting
final class FakeBrowserPlatform extends BrowserPlatform {
  static const _className = 'FakeBrowserPlatform';

  final String? _version;
  final String? _userAgent;

  FakeBrowserPlatform({String? version, String? userAgent})
      : _version = version,
        _userAgent = userAgent,
        super._();

  factory FakeBrowserPlatform.fromJson(String jsonText) {
    var json = jsonDecode(jsonText);
    if (json is! Map<String, Object?>) {
      throw FormatException('Not a JSON map', jsonText);
    }
    return FakeBrowserPlatform(
      version: _getJsonProperty<String>(json, JsonKey.version, jsonText),
      userAgent: _getJsonProperty<String>(json, JsonKey.userAgent, jsonText),
    );
  }

  factory FakeBrowserPlatform.fromPlatform(BrowserPlatform platform) {
    if (platform is FakeBrowserPlatform) {
      return platform.copyWith();
    }
    return FakeBrowserPlatform(
      version: platform.version,
      userAgent: platform.userAgent,
    );
  }

  FakeBrowserPlatform copyWith({
    String? version,
    String? userAgent,
  }) =>
      FakeBrowserPlatform(
        version: version ?? _version,
        userAgent: userAgent ?? _userAgent,
      );

  @override
  bool get isChromium => false;

  @override
  bool get isMozilla => false;

  @override
  bool get isWebkit => false;

  /// Runs [fakePlatformCode] with this platform as the current browser platform.
  ///
  /// While [fakePlatformCode] is running, the [Platform.browserPlatform]
  /// of [Platform.current] refers to this [FakeBrowserPlatform].
  ///
  /// Prior reads of [Platform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [Platform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) {
    _platformOverrideUsed = true;
    return runZoned<R>(fakePlatformCode,
        zoneValues: {_platformOverrideKey: Platform._browser(this)});
  }

  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        if (_version != null) JsonKey.version: _version,
        if (_userAgent != null) JsonKey.userAgent: _userAgent,
      });

  @override
  String get userAgent =>
      _throwIfUnset(_userAgent, _className, JsonKey.userAgent);

  @override
  String get version => _throwIfUnset(_version, _className, JsonKey.version);
}

/// Properties of the native host platform and process.
///
/// Provides API parity with the `Platform` class in `dart:io`, but using
/// instance properties rather than static properties. This difference enables
/// the use of these APIs in tests, where you can provide mock implementations.
/// Also provides access to a few chosen properties from other
/// parts of `dart:io`.
abstract final class NativePlatform {
  const NativePlatform._();

  /// The current native platform, if any.
  ///
  /// Same as [Platform.current.nativePlatform].
  static NativePlatform? get current => Platform.current.nativePlatform;

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

  /// A list of the known values that [operatingSystem] can have.
  static const List<String> operatingSystemValues = <String>[
    android,
    fuchsia,
    iOS,
    linux,
    macOS,
    windows,
  ];

  /// Whether the operating system is Android.
  bool get isAndroid => operatingSystem == NativePlatform.android;

  /// Whether the operating system is Fuchsia.
  bool get isFuchsia => operatingSystem == NativePlatform.fuchsia;

  /// Whether the operating system is iOS.
  bool get isIOS => operatingSystem == NativePlatform.iOS;

  /// Whether the operating system is Linux.
  bool get isLinux => operatingSystem == NativePlatform.linux;

  /// Whether the operating system is OS X.
  bool get isMacOS => operatingSystem == NativePlatform.macOS;

  /// Whether the operating system is Windows.
  bool get isWindows => operatingSystem == NativePlatform.windows;

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

  /// The file path of the executable used to run the script in this isolate.
  ///
  /// The file path returned is the literal path used to run the script.
  /// This path might be relative or just be a name from which the executable
  /// was found by searching the system path.
  ///
  /// For the absolute path to the resolved executable use [resolvedExecutable].
  String get executable;

  /// The flags passed to the executable used to run the script of this program.
  ///
  /// These are the command-line entries between the executable name
  /// and the script name. Each access to `executableArguments` returns a new
  /// list containing the flags passed to the executable.
  List<String> get executableArguments;

  /// The default line terminator on the current platform.
  ///
  /// Is a line feed (`"\n"`, U+000A) on most platforms, but
  /// carriage return followed by linefeed (`"\r\n"`, U+000D + U+000A)
  /// on Windows.
  @pragma('vm:platform_const')
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
  @pragma('vm:platform_const')
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

  /// A JSON-encoded representation of platform information.
  ///
  /// Can be emitted for debugging, or be used as input to a fake environment
  /// used for debugging.
  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      JsonKey.environment: environment,
      JsonKey.executable: executable,
      JsonKey.executableArguments: executableArguments,
      JsonKey.lineTerminator: lineTerminator,
      JsonKey.localeName: localeName,
      JsonKey.localHostname: localHostname,
      JsonKey.numberOfProcessors: numberOfProcessors,
      JsonKey.operatingSystem: operatingSystem,
      JsonKey.operatingSystemVersion: operatingSystemVersion,
      if (packageConfig != null) JsonKey.packageConfig: packageConfig,
      JsonKey.pathSeparator: pathSeparator,
      JsonKey.resolvedExecutable: resolvedExecutable,
      JsonKey.script: script.toString(),
      JsonKey.stdinSupportsAnsi: stdinSupportsAnsi,
      JsonKey.stdoutSupportsAnsi: stdoutSupportsAnsi,
      JsonKey.version: version,
    });
  }
}

/// A mock [NativePlatform] which can have empty fields.
///
/// This class should only be used for testing.
///
/// The individual properties can be left unset by the constructors.
///
/// This class should not be used in production, since it reduces the
/// compiler's ability to predict the values of the
/// [HostPlatform.operatingSystem] or, for example, [HostPlatform.isLinux]
/// checks, which can lead to larger compiled programs.
@visibleForTesting
final class FakeNativePlatform extends NativePlatform {
  static const String _className = 'FakeNativePlatform';

  /// Operating system ID string, or `null` if not configured.
  ///
  /// Use one of the [NativePlatform.android] through [HostPlatform.windows]
  /// constants.
  final String? _operatingSystem;
  final String? _operatingSystemVersion;
  final Map<String, String>? _environment;
  final String? _executable;
  final List<String>? _executableArguments;
  final String? _lineTerminator;
  final String? _localeName;
  final String? _localHostname;
  final int? _numberOfProcessors;
  final String? _pathSeparator;
  @override
  final String? packageConfig;
  final String? _resolvedExecutable;
  final Uri? _script;
  final bool? _stdinSupportsAnsi;
  final bool? _stdoutSupportsAnsi;
  final String? _version;

  /// Creates a new [FakeNativePlatform] with the specified properties.
  ///
  /// Parameters that are not provided with a non-`null` value
  /// will leave the corresponding property without a value.
  ///
  /// Reading, for example, [FakeNativePlatform.operatingSystem]
  /// when it had not been given a value, will throw an error.
  /// This behavior can be used in tests to ensure that code does not
  /// read properties that it is not supposed to.
  ///
  /// The [operatingSystem] string must be one of the known operating system
  /// ID strings in [NativePlatform.operatingSystemValues].
  FakeNativePlatform({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    this.packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  })  : _environment = environment == null
            ? null
            : operatingSystem == NativePlatform.windows
                ? (_caseInsensitiveMap()..addAll(environment))
                : environment,
        _executable = executable,
        _executableArguments = executableArguments,
        _lineTerminator = lineTerminator,
        _localeName = localeName,
        _localHostname = localHostname,
        _numberOfProcessors = numberOfProcessors,
        _operatingSystem = operatingSystem,
        _operatingSystemVersion = operatingSystemVersion,
        _pathSeparator = pathSeparator,
        _resolvedExecutable = resolvedExecutable,
        _script = script,
        _stdinSupportsAnsi = stdinSupportsAnsi,
        _stdoutSupportsAnsi = stdoutSupportsAnsi,
        _version = version,
        super._();

  /// Creates a new [FakeNativePlatform] with properties from a JSON string.
  ///
  /// The [jsonText] must be a valid JSON string representing a JSON object,
  /// and the values for the [NativePlatform] properties are extracted from
  /// the object's values for keys with the properties names.
  ///
  /// Example:
  /// ```dart
  /// var fake = FakeNativePlatform.fromJson('''{
  ///   "operatingSystem": "linux",
  ///   "operatingSystemVersion": "fakeVersion.2.3",
  ///   "numberOfProcessors": 42,
  ///   "lineTerminator": "\r",
  ///   "packageConfig": null
  /// }''')'
  /// ```
  /// The JSON object's value for such a keys must be either a string or `null`.
  ///
  /// Throws a [FormatException] if the [jsonText] string is not valid
  /// JSON text, or the JSON text does not represent a JSON object.
  /// The property values must have the correct type for the corresponding
  /// [NativePlatform] property, or be `null`.
  /// If the map value of a property key is not a string, integer, boolean,
  /// list of strings, or map with string keys and values,
  /// as required by the corresponding property,
  /// a [FormatException] is also thrown.
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJson] method will leave out undefined properties, so
  /// `FakeNativePlatform.fromJson(fakeNativePlatform.toJson())` can create
  /// an exact copy at a later time.
  /// (To create a copy _right now_, `fakeNativePlatform.copyWith()`
  /// is easier and more efficient.)
  factory FakeNativePlatform.fromJson(String jsonText) {
    Object? jsonObject = jsonDecode(jsonText);
    if (jsonObject is! Map<String, Object?>) {
      throw FormatException('Not a JSON object', jsonText);
    }

    // Read out the values that require special validation first.
    var environment = _getJsonProperty<Map<String, Object?>>(
        jsonObject, JsonKey.environment, jsonText);
    var executableArguments = _getJsonProperty<List<Object?>>(
        jsonObject, JsonKey.executableArguments, jsonText);
    var script = _getJsonProperty<String>(jsonObject, 'script', jsonText);

    return FakeNativePlatform(
      // Check that environment values are strings. Filter out null values.
      environment: environment == null
          ? null
          : <String, String>{
              for (var MapEntry(:key, :value) in environment.entries)
                if (value != null)
                  key: (value is String
                      ? value
                      : _failJsonParse<String>(
                          'environment[$key]', value, jsonText))
            },
      executable:
          _getJsonProperty<String>(jsonObject, JsonKey.executable, jsonText),
      // Check the executable arguments are strings.
      executableArguments: executableArguments == null
          ? null
          : <String>[
              for (var argument in executableArguments)
                argument is String
                    ? argument
                    : _failJsonParse('executableArguments', argument, jsonText)
            ],
      lineTerminator: _getJsonProperty<String>(
          jsonObject, JsonKey.lineTerminator, jsonText),
      localeName:
          _getJsonProperty<String>(jsonObject, JsonKey.localeName, jsonText),
      localHostname:
          _getJsonProperty<String>(jsonObject, JsonKey.localHostname, jsonText),
      numberOfProcessors: _getJsonProperty<int>(
          jsonObject, JsonKey.numberOfProcessors, jsonText),
      operatingSystem: _getJsonProperty<String>(
          jsonObject, JsonKey.operatingSystem, jsonText),
      operatingSystemVersion: _getJsonProperty<String>(
          jsonObject, JsonKey.operatingSystemVersion, jsonText),
      packageConfig:
          _getJsonProperty<String>(jsonObject, JsonKey.packageConfig, jsonText),
      pathSeparator:
          _getJsonProperty<String>(jsonObject, JsonKey.pathSeparator, jsonText),
      resolvedExecutable: _getJsonProperty<String>(
          jsonObject, JsonKey.resolvedExecutable, jsonText),
      // Checks that the script is a valid URI.
      script: script == null ? null : Uri.parse(script),
      stdinSupportsAnsi: _getJsonProperty<bool>(
          jsonObject, JsonKey.stdinSupportsAnsi, jsonText),
      stdoutSupportsAnsi: _getJsonProperty<bool>(
          jsonObject, JsonKey.stdoutSupportsAnsi, jsonText),
      version: _getJsonProperty<String>(jsonObject, JsonKey.version, jsonText),
    );
  }

  /// Creates a new [FakeHostPlatform] with the properties of [platform].
  factory FakeNativePlatform.fromPlatform(NativePlatform platform) =>
      platform is FakeNativePlatform // Values may be unset.
          ? platform.copyWith()
          : FakeNativePlatform(
              environment: <String, String>{...platform.environment},
              executable: platform.executable,
              executableArguments: List.of(platform.executableArguments),
              lineTerminator: platform.lineTerminator,
              localeName: platform.localeName,
              localHostname: platform.localHostname,
              numberOfProcessors: platform.numberOfProcessors,
              operatingSystem: platform.operatingSystem,
              operatingSystemVersion: platform.operatingSystemVersion,
              packageConfig: platform.packageConfig,
              pathSeparator: platform.pathSeparator,
              resolvedExecutable: platform.resolvedExecutable,
              script: platform.script,
              stdinSupportsAnsi: platform.stdinSupportsAnsi,
              stdoutSupportsAnsi: platform.stdoutSupportsAnsi,
              version: platform.version,
            );

  @override
  String get operatingSystem =>
      _throwIfUnset(_operatingSystem, _className, JsonKey.operatingSystem);

  @override
  String get operatingSystemVersion => _throwIfUnset(
      _operatingSystemVersion, _className, JsonKey.operatingSystemVersion);

  @override
  Map<String, String> get environment =>
      _throwIfUnset(_environment, _className, JsonKey.environment);

  @override
  String get executable =>
      _throwIfUnset(_executable, _className, JsonKey.executable);

  @override
  List<String> get executableArguments => _throwIfUnset<List<String>>(
      _executableArguments, _className, JsonKey.executableArguments);

  @override
  String get lineTerminator =>
      _throwIfUnset(_lineTerminator, _className, JsonKey.lineTerminator);

  @override
  String get localeName =>
      _throwIfUnset(_localeName, _className, JsonKey.localeName);

  @override
  String get localHostname =>
      _throwIfUnset(_localHostname, _className, JsonKey.localHostname);

  @override
  int get numberOfProcessors => _throwIfUnset(
      _numberOfProcessors, _className, JsonKey.numberOfProcessors);

  @override
  String get pathSeparator =>
      _throwIfUnset(_pathSeparator, _className, JsonKey.pathSeparator);

  @override
  String get resolvedExecutable => _throwIfUnset(
      _resolvedExecutable, _className, JsonKey.resolvedExecutable);

  @override
  Uri get script => _throwIfUnset(_script, _className, JsonKey.script);

  @override
  bool get stdinSupportsAnsi =>
      _throwIfUnset(_stdinSupportsAnsi, _className, JsonKey.stdinSupportsAnsi);

  @override
  bool get stdoutSupportsAnsi => _throwIfUnset(
      _stdoutSupportsAnsi, _className, JsonKey.stdoutSupportsAnsi);

  @override
  String get version => _throwIfUnset(_version, _className, JsonKey.version);

  /// Creates a new [FakeNativePlatform] from this one.
  ///
  /// If a parameter is given non-`null` argument value,
  /// the created object will have that value for the corresponding property,
  /// otherwise it will use this object's value of that property.
  FakeNativePlatform copyWith({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  }) {
    return FakeNativePlatform(
      environment: environment ??
          (_environment == null ? null : <String, String>{..._environment}),
      executable: executable ?? _executable,
      executableArguments:
          (executableArguments ?? _executableArguments)?.toList(),
      lineTerminator: lineTerminator ?? _lineTerminator,
      localeName: localeName ?? _localeName,
      localHostname: localHostname ?? _localHostname,
      numberOfProcessors: numberOfProcessors ?? _numberOfProcessors,
      operatingSystem: operatingSystem ?? _operatingSystem,
      operatingSystemVersion: operatingSystemVersion ?? _operatingSystemVersion,
      packageConfig: packageConfig ?? this.packageConfig,
      pathSeparator: pathSeparator ?? _pathSeparator,
      resolvedExecutable: resolvedExecutable ?? _resolvedExecutable,
      script: script ?? _script,
      stdinSupportsAnsi: stdinSupportsAnsi ?? _stdinSupportsAnsi,
      stdoutSupportsAnsi: stdoutSupportsAnsi ?? _stdoutSupportsAnsi,
      version: version ?? _version,
    );
  }

  /// Runs [withOverride] with this fake native platform as current platform.
  ///
  /// If [withOverride] reads [Platform.current], it gets a platform object
  /// whose [Platform.nativePlatform] is this fake native platform.
  R run<R>(R Function() withOverride) {
    _platformOverrideUsed = true;
    return runZoned(
        zoneValues: {_platformOverrideKey: Platform._native(this)},
        withOverride);
  }

  /// Wraps [withOverride] to run it with this fake native platform as current.
  ///
  /// The returned function runs [withOverride] through [run] every time it's
  /// called, to ensure all the calls will see the same override.
  R Function() bind<R>(R Function() withOverride) => () => run(withOverride);

  /// A JSON-encoded representation of this platform configuration.
  ///
  /// Unset values are not included.
  ///
  /// Can be parsed back by [FakeNativePlatform.fromJson].
  @override
  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
      if (_environment != null) JsonKey.environment: _environment,
      if (_executable != null) JsonKey.executable: _executable,
      if (_executableArguments != null)
        JsonKey.executableArguments: _executableArguments,
      if (_lineTerminator != null) JsonKey.lineTerminator: _lineTerminator,
      if (_localeName != null) JsonKey.localeName: _localeName,
      if (_localHostname != null) JsonKey.localHostname: _localHostname,
      if (_numberOfProcessors != null)
        JsonKey.numberOfProcessors: _numberOfProcessors,
      if (_operatingSystem != null) JsonKey.operatingSystem: _operatingSystem,
      if (_operatingSystemVersion != null)
        JsonKey.operatingSystemVersion: _operatingSystemVersion,
      if (packageConfig != null) JsonKey.packageConfig: packageConfig,
      if (_pathSeparator != null) JsonKey.pathSeparator: _pathSeparator,
      if (_resolvedExecutable != null)
        JsonKey.resolvedExecutable: _resolvedExecutable,
      if (_script != null) JsonKey.script: _script.toString(),
      if (_stdinSupportsAnsi != null)
        JsonKey.stdinSupportsAnsi: _stdinSupportsAnsi,
      if (_stdoutSupportsAnsi != null)
        JsonKey.stdoutSupportsAnsi: _stdoutSupportsAnsi,
      if (_version != null) JsonKey.version: _version,
    });
  }
}

Never _failJsonParse<T>(String property, Object? value, String? source) {
  throw FormatException('Property "$property" is not a $T: $value', source);
}

T? _getJsonProperty<T extends Object>(
    Map<String, Object?> jsonMap, String property, String? source) {
  var value = jsonMap[property];
  if (value is T?) return value;
  _failJsonParse<T>(property, value, source);
}

T _throwIfUnset<T>(T? value, String className, String name) {
  if (value == null) {
    throw StateError('$className.$name property is unset');
  }
  return value;
}

/// A simple inefficient case-insensitive map.
///
/// Used by [FakeNativePlatform.environment] when the (possibly fake)
/// operating system is [NativePlatform.windows].
Map<String, String> _caseInsensitiveMap() => HashMap<String, String>(
    equals: (String a, String b) =>
        a == b || a.toLowerCase() == b.toLowerCase(),
    hashCode: (String a) => a.toLowerCase().hashCode);
