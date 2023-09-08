// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The "Mock" platform implementations used for testing.
///
/// In the same library as `platforms.dart` and `platforms_impl.dart`
/// because the mock classes extend `final` classes.
part of 'platforms.dart';

/// A [HostPlatform] which can have unset values.
///
/// This class should only be used for testing.
///
/// The [operatingSystem] and [operatingSystemVersion]
/// values can be left unset by the constructors.
///
/// It should not be used in production, since it reduces the
/// compiler's ability to predict the values of the
/// [HostPlatform.operatingSystem] or, for example, [HostPlatform.isLinux]
/// checks, which can lead to larger compiled programs.
@visibleForTesting
final class MockHostPlatform extends _BasePlatform {
  final String? _operatingSystem;

  final String? _operatingSystemVersion;

  /// Creates a new [MockHostPlatform] with the specified properties.
  ///
  /// Parameters that are not provided, or have a `null` value,
  /// will leave the corresponding property undefined, without a value.
  /// Reading a property, like [MockHostPlatform.operatingSystem],
  /// when it doesn't have a value will throw an error.
  /// This behavior can be used in tests to ensure that code doesn't
  /// read properties that it is not intended to read.
  const MockHostPlatform({
    String? operatingSystem,
    String? operatingSystemVersion,
  })  : _operatingSystem = operatingSystem,
        _operatingSystemVersion = operatingSystemVersion,
        super._();

  /// Creates a new [MockHostPlatform] with properties from the JSON string.
  ///
  /// The [json] must be a valid JSON string for of a JSON object,
  /// and the values for the [HostPlatform] properties are extracted from
  /// the value of string keys containing the property's name.
  ///
  /// The JSON object's values for those keys must be strings or `null`.
  ///
  /// If the [json] string is not valid JSON text, it does not represent
  /// a JSON object, or one of the property keys has a value which is
  /// neither `String` nor `null`, a [FormatException] is thrown.
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJson] method will leave out undefined properties, so
  /// `MockHostPlatform.fromJson(mockHostPlatform.toJson())` can create
  /// an exact copy at a later time.
  /// (To create a copy _right now_, `mockHostPlatform.copyWith()`
  /// is easier and more efficient.)
  factory MockHostPlatform.fromJson(String json) {
    Object? map = jsonDecode(json); // Throws FormatException if wrong.
    if (map is! Map<String, Object?>) {
      throw FormatException('Not a JSON map', json);
    }
    return _parseMap(map, json);
  }

  /// Creates a new [MockHostPlatform] with properties from the JSON-like map.
  ///
  /// The [map] must be a valid JSON string for of a JSON object,
  /// and the values for the [HostPlatform] properties are extracted from
  /// the value of string keys containing the property's name.
  ///
  /// The JSON object's values for those keys must be strings or `null`.
  ///
  /// If the [map] has a needed value value for one of those properties,
  /// which is neither `String` nor `null`, a [FormatException] is thrown.
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJsonMap] method will leave out undefined properties, so
  /// `MockHostPlatform.fromJson(mockHostPlatform.toJson())` can create
  /// an exact copy at a later time.
  /// (To create a copy _right now_, `mockHostPlatform.copyWith()`
  /// is easier and more efficient.)
  factory MockHostPlatform.fromJsonMap(Map<String, Object?> map) {
    return _parseMap(map, map);
  }

  /// Parses the values of the [map] corresponding to
  ///
  /// The [source] is the original source that the map comes from,
  /// which is a string if coming from [MockHostPlatform.fromJson]
  /// and the map itself if coming from [MockHostPlatform.fromJsonMap].
  static MockHostPlatform _parseMap(Map<String, Object?> map, Object? source) {
    return MockHostPlatform(
      operatingSystem:
          _getJsonProperty<String>(map, JsonKey.operatingSystem, source),
      operatingSystemVersion:
          _getJsonProperty<String>(map, JsonKey.operatingSystemVersion, source),
    );
  }

  /// Creates a new [MockHostPlatform] with the same values as [platform].
  ///
  /// If [platform] is a [MockHostPlatform], this is equivalent to
  /// doing `mockHostPlatform.copyWith()`.
  factory MockHostPlatform.fromPlatform(HostPlatform platform) =>
      platform is MockHostPlatform
          ? MockHostPlatform(
              operatingSystem: platform._operatingSystem,
              operatingSystemVersion: platform._operatingSystemVersion)
          : MockHostPlatform(
              operatingSystem: platform.operatingSystem,
              operatingSystemVersion: platform.operatingSystemVersion);

  @override
  String get operatingSystem => _throwIfUnset(
      _operatingSystem, 'MockHostPlatform', JsonKey.operatingSystem);

  @override
  String get operatingSystemVersion => _throwIfUnset(_operatingSystemVersion,
      'MockHostPlatform', JsonKey.operatingSystemVersion);

  /// Creates a new [MockHostPlatform] from this one.
  ///
  /// If a parameter is given non-`null` argument value,
  /// the created object will have that value for the corresponding property,
  /// otherwise it will use this object's value of that property.
  MockHostPlatform copyWith({
    String? operatingSystem,
    String? operatingSystemVersion,
  }) =>
      MockHostPlatform(
        operatingSystem: operatingSystem ?? _operatingSystem,
        operatingSystemVersion:
            operatingSystemVersion ?? _operatingSystemVersion,
      );

  /// Runs [withOverride] in a zone which overrides [HostPlatform.current].
  ///
  /// Accesses to [HostPlatform.current] inside the zone created
  /// by this call will get this `MockHostPlatform` instead of the
  /// actual host platform.
  R run<R>(R Function() withOverride) {
    _potentialOverride = true;
    return runZoned(zoneValues: {#_override: this}, withOverride);
  }

  @override
  Map<String, Object?> toJsonMap() => <String, dynamic>{
        if (_operatingSystem != null) JsonKey.operatingSystem: _operatingSystem,
        if (_operatingSystemVersion != null)
          JsonKey.operatingSystemVersion: _operatingSystemVersion,
      };
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
final class MockNativePlatform extends MockHostPlatform
    implements NativePlatform {
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

  /// Creates a new [MockNativePlatform] with the specified properties.
  ///
  /// Parameters that are not provided with a non-`null` value
  /// will leave the corresponding property without a value.
  /// Reading, for example, [MockNativePlatform.operatingSystem]
  /// when it doesn't have a value will throw an error.
  /// This behavior can be used in tests to ensure that code doesn't
  /// read properties that it shouldn't.
  const MockNativePlatform({
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
  })  : _environment = environment,
        _executable = executable,
        _executableArguments = executableArguments,
        _lineTerminator = lineTerminator,
        _localeName = localeName,
        _localHostname = localHostname,
        _numberOfProcessors = numberOfProcessors,
        _pathSeparator = pathSeparator,
        _resolvedExecutable = resolvedExecutable,
        _script = script,
        _stdinSupportsAnsi = stdinSupportsAnsi,
        _stdoutSupportsAnsi = stdoutSupportsAnsi,
        _version = version,
        super(
            operatingSystem: operatingSystem,
            operatingSystemVersion: operatingSystemVersion);

  /// Creates a new [MockNativePlatform] with properties from a JSON string.
  ///
  /// The [jsonText] must be a valid JSON string representing a JSON object.
  /// For each property of the [NativePlatform], except the `is*` predicates,
  /// the property's name is used as a key for the [jsonMap],
  /// and if the value is non-`null`, that value is used for the
  /// created mock platform's property value.
  ///
  /// * The `"environment"` value must be a map with only string values.
  /// * The `"executableArguments"` value must be a list of strings.
  /// * The `"script"` value must be a string containing a valid URI.
  ///
  /// For these three, a new list or map copy, or a [Uri], is created for
  /// the value in the create mock platform.
  /// The remaining properties must have values of the same type as the
  /// native platform properties, one of `String`, `int` or `bool`, if
  /// they are not `null`.
  ///
  /// Throws a [FormatException] if any [NativePlatform] property's value does
  /// not have the correct type or form.
  ///
  /// Example:
  /// ```dart
  /// var mock = MockNativePlatform.fromJson('''{
  ///   "operatingSystem": "mockName",
  ///   "operatingSystemVersion": "mockVersion.2.3",
  ///   "numberOfProcessors": 42,
  ///   "lineTerminator": "\r",
  ///   "stdinSupportsAnsi": true,
  ///   "packageConfig": null
  /// }''');
  /// ```
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJson] method will leave out undefined properties, so
  /// `MockNativePlatform.fromJson(mockNativePlatform.toJson())` creates
  /// an exact copy.
  /// This is useful during testing, for example for storing a configuration
  /// for a later test, or even sharing it between different test files.
  /// (To just create a copy, `mockNativePlatform.copyWith()`
  /// is easier and more efficient.)
  factory MockNativePlatform.fromJson(String jsonText) {
    Object? jsonObject = jsonDecode(jsonText);
    if (jsonObject is! Map<String, Object?>) {
      throw FormatException('Not a JSON object', jsonText);
    }
    return _parseMap(jsonObject, jsonText);
  }

  /// Creates a new [MockNativePlatform] with properties from a JSON-like map.
  ///
  /// For each property of the [NativePlatform], except the `is*` predicates,
  /// the property's name is used as a key for the [jsonMap],
  /// and if the value is non-`null`, that value is used for the
  /// created mock platform's property value.
  ///
  /// * The `"environment"` value must be a map with only string values.
  /// * The `"executableArguments"` value must be a list of strings.
  /// * The `"script"` value must be a string containing a valid URI.
  ///
  /// For these three, a new list or map copy, or a [Uri], is created for
  /// the value in the create mock platform.
  /// The remaining properties must have values of the same type as the
  /// native platform properties, one of `String`, `int` or `bool`, if
  /// they are not `null`.
  ///
  /// Throws a [FormatException] if any [NativePlatform] property's value does
  /// not have the correct type or form.
  ///
  /// Example:
  /// ```dart
  /// var mock = MockNativePlatform.fromJsonMap({
  ///   'operatingSystem': 'mockName',
  ///   'operatingSystemVersion': 'mockVersion.2.3',
  ///   'numberOfProcessors': 42,
  ///   'lineTerminator': '\r',
  ///   'stdinSupportsAnsi': true,
  ///   'packageConfig': null
  /// });
  /// ```
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJsonMap] method will leave out undefined properties, so
  /// `MockNativePlatform.fromJsonMap(mockNativePlatform.toJsonMap())`
  /// creates an exact copy. This is mainly intended for inspecting
  /// or modifying the platform properties when testing.
  /// (To just create a copy, `mockNativePlatform.copyWith()` is easier
  /// and more efficient.)
  factory MockNativePlatform.fromJsonMap(Map<String, Object?> jsonMap) {
    return _parseMap(jsonMap, jsonMap);
  }

  /// Parses the properties of the [jsonObject] into properties.
  ///
  /// Throws [FormatException] on invalid values.
  static MockNativePlatform _parseMap(
      Map<String, Object?> jsonObject, Object source) {
    // Extract values that require special validation first,
    // and therefore will be referenced more than once.
    var environment = _getJsonProperty<Map<String, Object?>>(
        jsonObject, JsonKey.environment, source);
    var executableArguments = _getJsonProperty<List<Object?>>(
        jsonObject, JsonKey.executableArguments, source);
    var script = _getJsonProperty<String>(jsonObject, 'script', source);

    return MockNativePlatform(
      // Check that environment values are strings. Filter out null values.
      environment: environment == null
          ? null
          : <String, String>{
              for (var MapEntry(:key, :value) in environment.entries)
                if (value != null)
                  key: (value is String
                      ? value
                      : _failJsonParse<String>(
                          'environment[$key]', value, source))
            },
      executable:
          _getJsonProperty<String>(jsonObject, JsonKey.executable, source),
      // Check the executable arguments are strings.
      executableArguments: executableArguments == null
          ? null
          : <String>[
              for (var argument in executableArguments)
                argument is String
                    ? argument
                    : _failJsonParse('executableArguments', argument, source)
            ],
      lineTerminator:
          _getJsonProperty<String>(jsonObject, JsonKey.lineTerminator, source),
      localeName:
          _getJsonProperty<String>(jsonObject, JsonKey.localeName, source),
      localHostname:
          _getJsonProperty<String>(jsonObject, JsonKey.localHostname, source),
      numberOfProcessors:
          _getJsonProperty<int>(jsonObject, JsonKey.numberOfProcessors, source),
      operatingSystem:
          _getJsonProperty<String>(jsonObject, JsonKey.operatingSystem, source),
      operatingSystemVersion: _getJsonProperty<String>(
          jsonObject, JsonKey.operatingSystemVersion, source),
      packageConfig:
          _getJsonProperty<String>(jsonObject, JsonKey.packageConfig, source),
      pathSeparator:
          _getJsonProperty<String>(jsonObject, JsonKey.pathSeparator, source),
      resolvedExecutable: _getJsonProperty<String>(
          jsonObject, JsonKey.resolvedExecutable, source),
      // Checks that the script is a valid URI.
      script: script == null ? null : Uri.parse(script),
      stdinSupportsAnsi:
          _getJsonProperty<bool>(jsonObject, JsonKey.stdinSupportsAnsi, source),
      stdoutSupportsAnsi: _getJsonProperty<bool>(
          jsonObject, JsonKey.stdoutSupportsAnsi, source),
      version: _getJsonProperty<String>(jsonObject, JsonKey.version, source),
    );
  }

  /// Creates a new [MockHostPlatform] with the properties of [platform].
  factory MockNativePlatform.fromPlatform(NativePlatform platform) =>
      platform is MockNativePlatform // Values may be unset.
          ? MockNativePlatform(
              environment: platform._environment == null
                  ? null
                  : <String, String>{...platform._environment!},
              executable: platform._executable,
              executableArguments: platform._executableArguments == null
                  ? null
                  : <String>[...platform._executableArguments!],
              lineTerminator: platform._lineTerminator,
              localeName: platform._localeName,
              localHostname: platform._localHostname,
              numberOfProcessors: platform._numberOfProcessors,
              operatingSystem: platform._operatingSystem,
              operatingSystemVersion: platform._operatingSystemVersion,
              packageConfig: platform.packageConfig,
              pathSeparator: platform._pathSeparator,
              resolvedExecutable: platform._resolvedExecutable,
              script: platform._script,
              stdinSupportsAnsi: platform._stdinSupportsAnsi,
              stdoutSupportsAnsi: platform._stdoutSupportsAnsi,
              version: platform._version,
            )
          : MockNativePlatform(
              environment: Map<String, String>.from(platform.environment),
              executable: platform.executable,
              executableArguments:
                  List<String>.from(platform.executableArguments),
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
  Map<String, String> get environment =>
      _throwIfUnset(_environment, 'MockNativePlatform', JsonKey.environment);

  @override
  String get executable =>
      _throwIfUnset(_executable, 'MockNativePlatform', JsonKey.executable);
  @override
  List<String> get executableArguments => _throwIfUnset(
      _executableArguments, 'MockNativePlatform', JsonKey.executableArguments);

  @override
  String get lineTerminator => _throwIfUnset(
      _lineTerminator, 'MockNativePlatform', JsonKey.lineTerminator);

  @override
  String get localeName =>
      _throwIfUnset(_localeName, 'MockNativePlatform', JsonKey.localeName);
  @override
  String get localHostname => _throwIfUnset(
      _localHostname, 'MockNativePlatform', JsonKey.localHostname);

  @override
  int get numberOfProcessors => _throwIfUnset(
      _numberOfProcessors, 'MockNativePlatform', JsonKey.numberOfProcessors);

  @override
  String get pathSeparator => _throwIfUnset(
      _pathSeparator, 'MockNativePlatform', JsonKey.pathSeparator);

  @override
  String get resolvedExecutable => _throwIfUnset(
      _resolvedExecutable, 'MockNativePlatform', JsonKey.resolvedExecutable);

  @override
  Uri get script =>
      _throwIfUnset(_script, 'MockNativePlatform', JsonKey.script);

  @override
  bool get stdinSupportsAnsi => _throwIfUnset(
      _stdinSupportsAnsi, 'MockNativePlatform', JsonKey.stdinSupportsAnsi);

  @override
  bool get stdoutSupportsAnsi => _throwIfUnset(
      _stdoutSupportsAnsi, 'MockNativePlatform', JsonKey.stdoutSupportsAnsi);

  @override
  String get version =>
      _throwIfUnset(_version, 'MockNativePlatform', JsonKey.version);

  /// Creates a new [MockNativePlatform] from this one.
  ///
  /// If a parameter is given non-`null` argument value,
  /// the created object will have that value for the corresponding property,
  /// otherwise it will use this object's value of that property.
  @override
  MockNativePlatform copyWith({
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
    return MockNativePlatform(
      environment: environment ?? _environment,
      executable: executable ?? _executable,
      executableArguments: executableArguments ?? _executableArguments,
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

  /// Runs [withOverride] in a zone which overrides [NativePlatform.current].
  ///
  /// Also overrides [HostPlatform.current].
  ///
  /// Access to [NativePlatform.current] and [HostPlatform.current] inside
  /// the zone created by this call, will get this `MockNativePlatform` instead
  /// of the actual native platform.
  @override
  R run<R>(R Function() withOverride) {
    _potentialOverride = true;
    return runZoned(
        zoneValues: {#_override: this, #_overrideNative: this}, withOverride);
  }

  /// A JSON-encoded representation of this platform configuration.
  ///
  /// Unset values are not included.
  ///
  /// Can be parsed back by [MockNativePlatform.fromJson].
  @override
  Map<String, Object?> toJsonMap() => <String, dynamic>{
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
      };
}

Never _failJsonParse<T>(String property, Object? value, Object? source) {
  throw FormatException('Property "$property" is not a $T: $value', source);
}

T? _getJsonProperty<T extends Object>(
    Map<String, Object?> jsonMap, String property, Object? source) {
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
  static const version = 'version';
}
