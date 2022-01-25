// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../interface/native_platform.dart';
import 'fake_platform.dart';

class FakeNativePlatform extends FakePlatform implements NativePlatform {
  /// Creates a new [FakeNativePlatform] with the specified properties.
  ///
  /// Unspecified properties will *not* be assigned default values (they will
  /// remain `null`). If an unset non-null value is read, a [StateError] will
  /// be thrown instead of returnin `null`.
  FakeNativePlatform({
    int? numberOfProcessors,
    String? pathSeparator,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostname,
    Map<String, String>? environment,
    String? executable,
    String? resolvedExecutable,
    Uri? script,
    List<String>? executableArguments,
    this.packageConfig,
    String? version,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? localeName,
  })  : _pathSeparator = pathSeparator,
        _numberOfProcessors = numberOfProcessors,
        _localHostname = localHostname,
        _environment = environment,
        _executable = executable,
        _resolvedExecutable = resolvedExecutable,
        _script = script,
        _executableArguments = executableArguments,
        _version = version,
        _stdinSupportsAnsi = stdinSupportsAnsi,
        _stdoutSupportsAnsi = stdoutSupportsAnsi,
        _localeName = localeName,
        super(
            operatingSystem: operatingSystem,
            operatingSystemVersion: operatingSystemVersion);

  /// Creates a new [FakePlatform] with properties whose initial values mirror
  /// the specified [platform].
  FakeNativePlatform.fromPlatform(NativePlatform platform)
      : this(
          numberOfProcessors: platform.numberOfProcessors,
          pathSeparator: platform.pathSeparator,
          operatingSystem: platform.operatingSystem,
          operatingSystemVersion: platform.operatingSystemVersion,
          localHostname: platform.localHostname,
          environment: Map<String, String>.from(platform.environment),
          executable: platform.executable,
          resolvedExecutable: platform.resolvedExecutable,
          script: platform.script,
          executableArguments: List<String>.from(platform.executableArguments),
          packageConfig: platform.packageConfig,
          version: platform.version,
          stdinSupportsAnsi: platform.stdinSupportsAnsi,
          stdoutSupportsAnsi: platform.stdoutSupportsAnsi,
          localeName: platform.localeName,
        );

  /// Creates a new [FakeNativePlatform] with properties extracted
  /// from the encoded JSON string.
  ///
  /// [json] must be a JSON string that matches the encoding produced by
  /// [toJson].
  factory FakeNativePlatform.fromJson(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FakeNativePlatform(
      numberOfProcessors: map['numberOfProcessors'],
      pathSeparator: map['pathSeparator'],
      operatingSystem: map['operatingSystem'],
      operatingSystemVersion: map['operatingSystemVersion'],
      localHostname: map['localHostname'],
      environment: map['environment'].cast<String, String>(),
      executable: map['executable'],
      resolvedExecutable: map['resolvedExecutable'],
      script: Uri.parse(map['script']),
      executableArguments: map['executableArguments'].cast<String>(),
      packageConfig: map['packageConfig'],
      version: map['version'],
      stdinSupportsAnsi: map['stdinSupportsAnsi'],
      stdoutSupportsAnsi: map['stdoutSupportsAnsi'],
      localeName: map['localeName'],
    );
  }

  /// Creates a new [FakeNativePlatform] from this one,
  /// with some properties replaced by the given arguments.
  @override
  NativePlatform copyWith({
    int? numberOfProcessors,
    String? pathSeparator,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostname,
    Map<String, String>? environment,
    String? executable,
    String? resolvedExecutable,
    Uri? script,
    List<String>? executableArguments,
    String? packageConfig,
    String? version,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? localeName,
  }) {
    return FakeNativePlatform(
      numberOfProcessors: numberOfProcessors ?? this.numberOfProcessors,
      pathSeparator: pathSeparator ?? this.pathSeparator,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      operatingSystemVersion:
          operatingSystemVersion ?? this.operatingSystemVersion,
      localHostname: localHostname ?? this.localHostname,
      environment: environment ?? this.environment,
      executable: executable ?? this.executable,
      resolvedExecutable: resolvedExecutable ?? this.resolvedExecutable,
      script: script ?? this.script,
      executableArguments: executableArguments ?? this.executableArguments,
      packageConfig: packageConfig ?? this.packageConfig,
      version: version ?? this.version,
      stdinSupportsAnsi: stdinSupportsAnsi ?? this.stdinSupportsAnsi,
      stdoutSupportsAnsi: stdoutSupportsAnsi ?? this.stdoutSupportsAnsi,
      localeName: localeName ?? this.localeName,
    );
  }

  @override
  int get numberOfProcessors => throwIfNull(_numberOfProcessors);
  int? _numberOfProcessors;

  @override
  String get pathSeparator => throwIfNull(_pathSeparator);
  String? _pathSeparator;

  @override
  String get localHostname => throwIfNull(_localHostname);
  String? _localHostname;

  @override
  Map<String, String> get environment => throwIfNull(_environment);
  Map<String, String>? _environment;

  @override
  String get executable => throwIfNull(_executable);
  String? _executable;

  @override
  String get resolvedExecutable => throwIfNull(_resolvedExecutable);
  String? _resolvedExecutable;

  @override
  Uri get script => throwIfNull(_script);
  Uri? _script;

  @override
  List<String> get executableArguments => throwIfNull(_executableArguments);
  List<String>? _executableArguments;

  @override
  String? packageConfig;

  @override
  String get version => throwIfNull(_version);
  String? _version;

  @override
  bool get stdinSupportsAnsi => throwIfNull(_stdinSupportsAnsi);
  bool? _stdinSupportsAnsi;

  @override
  bool get stdoutSupportsAnsi => throwIfNull(_stdoutSupportsAnsi);
  bool? _stdoutSupportsAnsi;

  @override
  String get localeName => throwIfNull(_localeName);
  String? _localeName;
}
