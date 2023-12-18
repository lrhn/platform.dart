// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:platform/native_test.dart';
import 'package:platform/src/platforms.dart' show hostPlatformKind;
import 'package:test/test.dart';

void main() {
  test('Is compiled on native', () {
    expect(hostPlatformKind, 'native');
    expect(const bool.fromEnvironment('dart.library.html'), false);
    expect(const bool.fromEnvironment('dart.library.io'), true);
  });
  group('MockNativePlatform', () {
    group('fromPlatform', () {
      test('copiesAllProperties', () {
        var mock = MockNativePlatform.fromPlatform(NativePlatform.current);
        testNativeMock(mock, NativePlatform.current.toJsonMap());
      });

      test('convertsPropertiesToMutable', () {
        var mock = MockNativePlatform.fromPlatform(NativePlatform.current);
        var key = mock.environment.keys.first;

        expect(mock.environment[key], NativePlatform.current.environment[key]);
        mock.environment[key] = 'FAKE';
        expect(mock.environment[key], 'FAKE');

        expect(mock.executableArguments.length,
            NativePlatform.current.executableArguments.length);
        mock.executableArguments.add('ARG');
        expect(mock.executableArguments.last, 'ARG');
      });
    });

    group('copyWith', () {
      test('overrides a value, but leaves others intact', () {
        var current = NativePlatform.current;
        var expected = current.toJsonMap();
        var mock = MockNativePlatform.fromPlatform(current);

        NativePlatform copy = mock.copyWith(
          numberOfProcessors: -1,
        );
        expected['numberOfProcessors'] = -1;
        testNativeMock(copy, expected);
      });
      test('can override all values', () {
        var mock = MockNativePlatform.fromPlatform(NativePlatform.current);
        var expected = <String, Object?>{
          'environment': <String, String>{'PATH': '.'},
          'executable': 'executable',
          'executableArguments': <String>['scriptArg'],
          'lineTerminator': '\r',
          'localeName': 'local',
          'localHostname': 'host',
          'numberOfProcessors': 8,
          'operatingSystem': 'mock',
          'operatingSystemVersion': '0.1.0',
          'pathSeparator': ':',
          'packageConfig': 'config.json',
          'resolvedExecutable': '/executable',
          'script': '/platform/test/mock_platform_test.dart',
          'stdinSupportsAnsi': false,
          'stdoutSupportsAnsi': true,
          'version': '0.1.1',
        };
        var copy = mock.copyWith(
          environment: expected['environment'] as Map<String, String>,
          executable: expected['executable'] as String,
          executableArguments: expected['executableArguments'] as List<String>,
          lineTerminator: expected['lineTerminator'] as String,
          localeName: expected['localeName'] as String,
          localHostname: expected['localHostname'] as String,
          numberOfProcessors: expected['numberOfProcessors'] as int,
          operatingSystem: expected['operatingSystem'] as String,
          operatingSystemVersion: expected['operatingSystemVersion'] as String,
          packageConfig: expected['packageConfig'] as String?,
          pathSeparator: expected['pathSeparator'] as String,
          script: Uri.parse(expected['script'] as String),
          resolvedExecutable: expected['resolvedExecutable'] as String,
          stdinSupportsAnsi: expected['stdinSupportsAnsi'] as bool,
          stdoutSupportsAnsi: expected['stdoutSupportsAnsi'] as bool,
          version: expected['version'] as String,
        );
        testNativeMock(copy, expected);
      });
    });

    group('json', () {
      const sampleJson = <String, Object?>{
        'environment': {'PATH': '/bin', 'PWD': '/platform'},
        'executable': '/bin/dart',
        'executableArguments': ['--checked'],
        'lineTerminator': '\r',
        'localeName': 'de/de',
        'localHostname': 'platform.test.org',
        'numberOfProcessors': 8,
        'operatingSystem': 'macos',
        'operatingSystemVersion': '10.14.5',
        'packageConfig': 'config.json',
        'pathSeparator': '/',
        'resolvedExecutable': '/bin/dart',
        'script': 'file:///platform/test/mock_platform_test.dart',
        'stdinSupportsAnsi': true,
        'stdoutSupportsAnsi': false,
        'version': '1.22.0'
      };
      test('fromJson', () {
        var jsonText = jsonEncode(sampleJson);
        var mock = MockNativePlatform.fromJson(jsonText);
        testNativeMock(mock, sampleJson);
      });

      test('fromJsonMap', () {
        var mock = MockNativePlatform.fromJsonMap(sampleJson);
        testNativeMock(mock, sampleJson);
      });

      test('fromEmptyJson', () {
        var mock = MockNativePlatform.fromJson('{}');
        testNativeMock(mock, {});
      });

      test('fromNullJson', () {
        // Explicit null values are allowed in the JSON, treated as unset value.
        var allNulls = <String, Object?>{
          'environment': null,
          'executable': null,
          'executableArguments': null,
          'lineTerminator': null,
          'localeName': null,
          'localHostname': null,
          'numberOfProcessors': null,
          'operatingSystem': null,
          'operatingSystemVersion': null,
          'packageConfig': null,
          'pathSeparator': null,
          'resolvedExecutable': null,
          'stdinSupportsAnsi': null,
          'stdoutSupportsAnsi': null,
          'script': null,
          'version': null
        };
        var mock = MockNativePlatform.fromJson(jsonEncode(allNulls));
        testNativeMock(mock, {});
      });

      test('toJson(terse)', () {
        var current = NativePlatform.current;
        // The `toMap` always creates properties in the same order,
        // and puts them into a `LinkedHashMap`, so we can assume the
        // ordering of properties is the same.
        var verboseJson = current.toJson();
        var terseJson = current.toJson(terse: true);
        // Check that the difference is only whitespace.
        var ws = RegExp(r'\s+');
        expect(verboseJson.replaceAll(ws, ''), terseJson.replaceAll(ws, ''));
      });

      test('fromJsonToJson', () {
        var current = NativePlatform.current;
        var jsonMap = current.toJsonMap();
        var mock = MockNativePlatform.fromJsonMap(jsonMap);
        testNativeMock(mock, jsonMap);
        var jsonText = current.toJson();
        mock = MockNativePlatform.fromJson(jsonText);
        testNativeMock(mock, jsonMap);
      });

      test('fromJsonErrors', () {
        void fromJsonError(String source) {
          expect(
              () => MockNativePlatform.fromJson(source), throwsFormatException);
        }

        // Not valid JSON at all.
        fromJsonError('not-JSON!');

        // Not a map at top-level.
        fromJsonError('"a"');
        fromJsonError('[]');

        // `environment`, if present, must be map from string to string.
        fromJsonError('{"environment": "not a map"}');
        fromJsonError('{"environment": ["not a map"]}');
        fromJsonError('{"environment": {"x": 42}}');

        // `executableArguments`, if present, must be list of strings.
        fromJsonError('{"executableArguments": true}');
        fromJsonError('{"executableArguments": {}}');
        fromJsonError('{"executableArguments": [42]}');
        fromJsonError('{"executableArguments": ["a", null, "b"]}');

        // `numberOfProcessors`, if present, must be an integer.
        fromJsonError('{"numberOfProcessors": "42"}');
        fromJsonError('{"numberOfProcessors": [42]}');
        fromJsonError('{"numberOfProcessors": 3.14}');

        // `script`, if present, must be string with a valid URI.
        fromJsonError('{"script": false}');
        fromJsonError('{"script": ["valid:///uri"]}');
        fromJsonError('{"script": {"valid": "///uri"}}');
        fromJsonError('{"script": false}');
        fromJsonError('{"script": "4:///"}'); // Invalid URI scheme.

        // `*SupportsAnsi`, if present, must be booleans.
        fromJsonError('{"stdinSupportsAnsi": 42}');
        fromJsonError('{"stdinSupportsAnsi": "false"}');
        fromJsonError('{"stdinSupportsAnsi": []}');
        fromJsonError('{"stdoutSupportsAnsi": 42}');
        fromJsonError('{"stdoutSupportsAnsi": "false"}');
        fromJsonError('{"stdoutSupportsAnsi": []}');

        // Remaining properties must be strings.
        for (var name in [
          'executable',
          'lineTerminator',
          'localeName',
          'localHostname',
          'operatingSystem',
          'operatingSystemVersion',
          'packageConfig',
          'pathSeparator',
          'resolvedExecutable',
          'version',
        ]) {
          fromJsonError('{"$name": 42}');
          fromJsonError('{"$name": ["not a string"]}');
          fromJsonError('{"$name": {"not" : "a string"}}');
        }
      });
      test('fromJsonMapErrors', () {
        void fromJsonError(Map<String, Object?> source) {
          expect(() => MockNativePlatform.fromJsonMap(source),
              throwsFormatException);
        }

        // `environment`, if present, must be map from string to string.
        fromJsonError({'environment': 'not a map'});
        fromJsonError({
          'environment': ['not a map']
        });
        fromJsonError({
          'environment': {'x': 42}
        });

        // `executableArguments`, if present, must be list of strings.
        fromJsonError({'executableArguments': true});
        fromJsonError({'executableArguments': {}});
        fromJsonError({
          'executableArguments': [42]
        });
        fromJsonError({
          'executableArguments': ['a', null, 'b']
        });

        // `numberOfProcessors`, if present, must be an integer.
        fromJsonError({'numberOfProcessors': '42'});
        fromJsonError({
          'numberOfProcessors': [42]
        });
        fromJsonError({'numberOfProcessors': 3.14});

        // `script`, if present, must be string with a valid URI.
        fromJsonError({'script': false});
        fromJsonError({
          'script': ['valid:///uri']
        });
        fromJsonError({
          'script': {'valid': '///uri'}
        });
        fromJsonError({'script': false});
        fromJsonError({'script': '4:///'}); // Invalid URI scheme.

        // `*SupportsAnsi`, if present, must be booleans.
        fromJsonError({'stdinSupportsAnsi': 42});
        fromJsonError({'stdinSupportsAnsi': 'false'});
        fromJsonError({'stdinSupportsAnsi': []});
        fromJsonError({'stdoutSupportsAnsi': 42});
        fromJsonError({'stdoutSupportsAnsi': 'false'});
        fromJsonError({'stdoutSupportsAnsi': []});

        // Remaining properties must be strings.
        for (var name in [
          'executable',
          'lineTerminator',
          'localeName',
          'localHostname',
          'operatingSystem',
          'operatingSystemVersion',
          'packageConfig',
          'pathSeparator',
          'resolvedExecutable',
          'version',
        ]) {
          fromJsonError({name: 42});
          fromJsonError({
            name: ['not a string']
          });
          fromJsonError({
            name: {'not': 'a string'}
          });
        }
      });
    });
    test('Throws when unset non-null values are read', () {
      final platform = MockNativePlatform();
      // Sanity check, in case `testNativeMock` was bugged.
      expect(() => platform.environment, throwsA(isStateError));
      expect(() => platform.executable, throwsA(isStateError));
      expect(() => platform.executableArguments, throwsA(isStateError));
      expect(() => platform.lineTerminator, throwsA(isStateError));
      expect(() => platform.localeName, throwsA(isStateError));
      expect(() => platform.localHostname, throwsA(isStateError));
      expect(() => platform.numberOfProcessors, throwsA(isStateError));
      expect(() => platform.operatingSystem, throwsA(isStateError));
      expect(() => platform.operatingSystemVersion, throwsA(isStateError));
      expect(platform.packageConfig, isNull);
      expect(() => platform.pathSeparator, throwsA(isStateError));
      expect(() => platform.resolvedExecutable, throwsA(isStateError));
      expect(() => platform.script, throwsA(isStateError));
      expect(() => platform.stdinSupportsAnsi, throwsA(isStateError));
      expect(() => platform.stdoutSupportsAnsi, throwsA(isStateError));
      expect(() => platform.version, throwsA(isStateError));
    });
  });

  group('runtime override', () {
    group('host platform only', () {
      test('sync', () {
        var currentHost = HostPlatform.current;
        var currentNative = NativePlatform.current;
        var mock = MockHostPlatform.fromPlatform(currentHost)
            .copyWith(operatingSystemVersion: 'bananas');
        mock.run(() {
          expect(HostPlatform.current, same(mock));
          expect(NativePlatform.current, same(currentNative));
        });
      });
      test('async', () async {
        var currentHost = HostPlatform.current;
        var currentNative = NativePlatform.current;
        var mock = MockHostPlatform.fromPlatform(currentHost)
            .copyWith(operatingSystemVersion: 'bananas');
        await mock.run(() async {
          await Future(() {}); // Timer-delay.
          expect(HostPlatform.current, same(mock));
          expect(NativePlatform.current, same(currentNative));
        });
      });
    });

    group('native and host platform', () {
      test('sync', () {
        var currentNative = NativePlatform.current;
        var mock = MockNativePlatform.fromPlatform(currentNative)
            .copyWith(operatingSystemVersion: 'bananas');
        mock.run(() {
          expect(HostPlatform.current, same(mock));
          expect(NativePlatform.current, same(mock));
        });
      });
      test('async', () async {
        var currentNative = NativePlatform.current;
        var mock = MockNativePlatform.fromPlatform(currentNative)
            .copyWith(operatingSystemVersion: 'bananas');
        await mock.run(() async {
          await Future(() {}); // Timer-delay.
          expect(HostPlatform.current, same(mock));
          expect(NativePlatform.current, same(mock));
        });
      });
    });
    group('nested overrides', () {
      test('sync', () {
        var currentNative = NativePlatform.current;
        var mockNative = MockNativePlatform.fromPlatform(currentNative)
            .copyWith(operatingSystem: 'bananas');
        var mockHost = MockHostPlatform.fromPlatform(mockNative)
            .copyWith(operatingSystemVersion: '42');

        mockNative.run(() {
          expect(HostPlatform.current, same(mockNative));
          expect(NativePlatform.current, same(mockNative));
          mockHost.run(() {
            expect(HostPlatform.current, same(mockHost));
            expect(NativePlatform.current, same(mockNative));
          });
        });
      });
      test('async', () async {
        var currentNative = NativePlatform.current;
        var mockNative = MockNativePlatform.fromPlatform(currentNative)
            .copyWith(operatingSystem: 'bananas');
        var mockHost = MockHostPlatform.fromPlatform(mockNative)
            .copyWith(operatingSystemVersion: '42');

        await mockNative.run(() async {
          await Future(() {});
          expect(HostPlatform.current, same(mockNative));
          expect(NativePlatform.current, same(mockNative));
          await mockHost.run(() async {
            await Future(() {});
            expect(HostPlatform.current, same(mockHost));
            expect(NativePlatform.current, same(mockNative));
          });
        });
      });
    });
  });
}

/// Checks that the operation `read()` throws if `expected` is `null`,
/// and otherwise it returns a value equal to `expected`.
void _testProperty(Object? Function() read, Object? expected) {
  if (expected == null) {
    expect(read, throwsStateError);
  } else {
    expect(read(), expected);
  }
}

/// Check the properties of a `HostPlatform`.
///
/// If any of the expected string arguments are `null`, reading the property is
/// expected to throw a `StateError`./
/// If the operating system value is `null`, all the  `isAndroid`..`isWindows`
/// are expected to throw too.
/// Otherwise they are tested to give the expected true/false value
/// for the expected operating system.
void testMock(HostPlatform actual, String? operatingSystem,
    String? operatingSystemVersion) {
  _testProperty(() => actual.operatingSystem, operatingSystem);
  _testProperty(() => actual.operatingSystemVersion, operatingSystemVersion);

  if (operatingSystem == null) {
    expect(() => actual.isAndroid, throwsStateError);
    expect(() => actual.isBrowser, throwsStateError);
    expect(() => actual.isFuchsia, throwsStateError);
    expect(() => actual.isIOS, throwsStateError);
    expect(() => actual.isLinux, throwsStateError);
    expect(() => actual.isMacOS, throwsStateError);
    expect(() => actual.isWindows, throwsStateError);
  } else {
    expect(actual.isAndroid, operatingSystem == HostPlatform.android);
    expect(actual.isBrowser, operatingSystem == HostPlatform.browser);
    expect(actual.isFuchsia, operatingSystem == HostPlatform.fuchsia);
    expect(actual.isIOS, operatingSystem == HostPlatform.iOS);
    expect(actual.isLinux, operatingSystem == HostPlatform.linux);
    expect(actual.isMacOS, operatingSystem == HostPlatform.macOS);
    expect(actual.isWindows, operatingSystem == HostPlatform.windows);
  }
}

void testNativeMock(
    NativePlatform actual, Map<String, Object?> expectedValues) {
  testMock(actual, expectedValues['operatingSystem'] as String?,
      expectedValues['operatingSystemVersion'] as String?);
  _testProperty(() => actual.environment, expectedValues['environment']);
  _testProperty(() => actual.executable, expectedValues['executable']);
  _testProperty(
      () => actual.executableArguments, expectedValues['executableArguments']);
  _testProperty(() => actual.lineTerminator, expectedValues['lineTerminator']);
  _testProperty(() => actual.localeName, expectedValues['localeName']);
  _testProperty(() => actual.localHostname, expectedValues['localHostname']);
  _testProperty(
      () => actual.numberOfProcessors, expectedValues['numberOfProcessors']);
  // Package-config is nullable, so doesn't throw if null.
  expect(actual.packageConfig, expectedValues['packageConfig']);
  _testProperty(() => actual.pathSeparator, expectedValues['pathSeparator']);
  _testProperty(
      () => actual.resolvedExecutable, expectedValues['resolvedExecutable']);
  var scriptText = expectedValues['script'] as String?;
  var scriptUri = scriptText != null ? Uri.parse(scriptText) : null;
  _testProperty(() => actual.script, scriptUri);
  _testProperty(
      () => actual.stdinSupportsAnsi, expectedValues['stdinSupportsAnsi']);
  _testProperty(
      () => actual.stdoutSupportsAnsi, expectedValues['stdoutSupportsAnsi']);
  _testProperty(() => actual.version, expectedValues['version']);

  expect(actual.toJsonMap(), expectedValues);
  expect(jsonDecode(actual.toJson()), expectedValues);
  expect(jsonDecode(actual.toJson(terse: true)), expectedValues);
}
