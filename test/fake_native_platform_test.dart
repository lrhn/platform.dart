// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:platform/platform_testing.dart';
import 'package:platform/src/json_keys.dart';
import 'package:test/test.dart';

void main() {
  final original = NativePlatform.current;

  test('Is compiled on native', () {
    expect(original, isNotNull);
    expect(Platform.current.nativePlatform, same(original));
  });

  if (original == null) return; // Promote to non-null from here.

  // For overriding: A valid value guaranteed to be different from
  // the current platform's value.
  final otherOS = original.operatingSystem == NativePlatform.android
      ? NativePlatform.fuchsia
      : NativePlatform.android;
  final otherVersion = original.operatingSystemVersion == '42' ? '87' : '42';

  group('FakeNativePlatform', () {
    group('fromPlatform', () {
      test('copiesAllProperties', () {
        var fake = FakeNativePlatform.fromPlatform(original);
        testNativeFake(
            fake, jsonDecode(original.toJson()) as Map<String, Object?>);
      });

      test('converts properties to mutable', () {
        var fake = FakeNativePlatform.fromPlatform(original);
        var key = fake.environment.keys.first;

        expect(fake.environment[key], original.environment[key]);
        fake.environment[key] = 'FAKE';
        expect(fake.environment[key], 'FAKE');

        expect(fake.executableArguments.length,
            original.executableArguments.length);
        fake.executableArguments.add('ARG');
        expect(fake.executableArguments.last, 'ARG');
      });
    });

    group('copyWith', () {
      test('overrides a value, but leaves others intact', () {
        var expected = jsonDecode(original.toJson()) as Map<String, Object?>;
        var fake = FakeNativePlatform.fromPlatform(original);

        NativePlatform copy = fake.copyWith(
          numberOfProcessors: -1,
        );
        expected[JsonKey.numberOfProcessors] = -1;
        testNativeFake(copy, expected);
      });
      test('can override all values', () {
        var fake = FakeNativePlatform.fromPlatform(original);
        var expected = <String, Object?>{
          JsonKey.environment: <String, String>{'PATH': '.'},
          JsonKey.executable: 'executable',
          JsonKey.executableArguments: <String>['script-arg'],
          JsonKey.lineTerminator: '\r',
          JsonKey.localeName: 'local',
          JsonKey.localHostname: 'host',
          JsonKey.numberOfProcessors: 8,
          JsonKey.operatingSystem: otherOS,
          JsonKey.operatingSystemVersion: '0.1.0',
          JsonKey.pathSeparator: ':',
          JsonKey.packageConfig: 'config.json',
          JsonKey.resolvedExecutable: '/executable',
          JsonKey.script: '/platform/test/fake_platform_test.dart',
          JsonKey.stdinSupportsAnsi: false,
          JsonKey.stdoutSupportsAnsi: true,
          JsonKey.version: '0.1.1',
        };
        var copy = fake.copyWith(
          environment: expected[JsonKey.environment] as Map<String, String>,
          executable: expected[JsonKey.executable] as String,
          executableArguments:
              expected[JsonKey.executableArguments] as List<String>,
          lineTerminator: expected[JsonKey.lineTerminator] as String,
          localeName: expected[JsonKey.localeName] as String,
          localHostname: expected[JsonKey.localHostname] as String,
          numberOfProcessors: expected[JsonKey.numberOfProcessors] as int,
          operatingSystem: expected[JsonKey.operatingSystem] as String,
          operatingSystemVersion:
              expected[JsonKey.operatingSystemVersion] as String,
          packageConfig: expected[JsonKey.packageConfig] as String?,
          pathSeparator: expected[JsonKey.pathSeparator] as String,
          script: Uri.parse(expected[JsonKey.script] as String),
          resolvedExecutable: expected[JsonKey.resolvedExecutable] as String,
          stdinSupportsAnsi: expected[JsonKey.stdinSupportsAnsi] as bool,
          stdoutSupportsAnsi: expected[JsonKey.stdoutSupportsAnsi] as bool,
          version: expected[JsonKey.version] as String,
        );
        testNativeFake(copy, expected);
      });
    });

    group('json', () {
      test('fromJson', () {
        var json = <String, Object?>{
          JsonKey.environment: {'PATH': '/bin', 'PWD': '/platform'},
          JsonKey.executable: '/bin/dart',
          JsonKey.executableArguments: ['--checked'],
          JsonKey.lineTerminator: '\r',
          JsonKey.localeName: 'de/de',
          JsonKey.localHostname: 'platform.test.org',
          JsonKey.numberOfProcessors: 8,
          JsonKey.operatingSystem: 'macos',
          JsonKey.operatingSystemVersion: '10.14.5',
          JsonKey.packageConfig: 'config.json',
          JsonKey.pathSeparator: '/',
          JsonKey.resolvedExecutable: '/bin/dart',
          JsonKey.script: 'file:///platform/test/fake_platform_test.dart',
          JsonKey.stdinSupportsAnsi: true,
          JsonKey.stdoutSupportsAnsi: false,
          JsonKey.version: '1.22.0'
        };
        var jsonText = jsonEncode(json);
        var fake = FakeNativePlatform.fromJson(jsonText);
        testNativeFake(fake, json);
        // Compare toJson.
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromEmptyJson', () {
        var fake = FakeNativePlatform.fromJson('{}');
        testNativeFake(fake, {});
      });

      test('fromNullJson', () {
        // Explicit null values are allowed in the JSON, treated as unset value.
        var allNulls = <String, Object?>{
          JsonKey.environment: null,
          JsonKey.executable: null,
          JsonKey.executableArguments: null,
          JsonKey.lineTerminator: null,
          JsonKey.localeName: null,
          JsonKey.localHostname: null,
          JsonKey.numberOfProcessors: null,
          JsonKey.operatingSystem: null,
          JsonKey.operatingSystemVersion: null,
          JsonKey.packageConfig: null,
          JsonKey.pathSeparator: null,
          JsonKey.resolvedExecutable: null,
          JsonKey.stdinSupportsAnsi: null,
          JsonKey.stdoutSupportsAnsi: null,
          JsonKey.script: null,
          JsonKey.version: null
        };
        var fake = FakeNativePlatform.fromJson(jsonEncode(allNulls));
        testNativeFake(fake, {});
        expect(fake.toJson(), '{}');
      });

      test('fromJsonToJson', () {
        var current = original;
        var jsonText = current.toJson();
        var json = jsonDecode(jsonText) as Map<String, Object?>;
        var fake = FakeNativePlatform.fromJson(jsonText);
        testNativeFake(fake, json);
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromJsonErrors', () {
        void fromJsonError(String source) {
          expect(
              () => FakeNativePlatform.fromJson(source), throwsFormatException);
        }

        // Not valid JSON at all.
        fromJsonError('not-JSON!');

        // Not a map at top-level.
        fromJsonError('"a"');
        fromJsonError('[]');

        // `environment`, if present, must be map from string to string.
        fromJsonError('{"${JsonKey.environment}": "not a map"}');
        fromJsonError('{"${JsonKey.environment}": ["not a map"]}');
        fromJsonError('{"${JsonKey.environment}": {"x": 42}}');

        // `executableArguments`, if present, must be list of strings.
        fromJsonError('{"${JsonKey.executableArguments}": true}');
        fromJsonError('{"${JsonKey.executableArguments}": {}}');
        fromJsonError('{"${JsonKey.executableArguments}": [42]}');
        fromJsonError('{"${JsonKey.executableArguments}": ["a", null, "b"]}');

        // `numberOfProcessors`, if present, must be an integer.
        fromJsonError('{"${JsonKey.numberOfProcessors}": "42"}');
        fromJsonError('{"${JsonKey.numberOfProcessors}": [42]}');
        fromJsonError('{"${JsonKey.numberOfProcessors}": 3.14}');

        // `script`, if present, must be string with valid URI.
        fromJsonError('{"${JsonKey.script}": false}');
        fromJsonError('{"${JsonKey.script}": ["valid:///uri"]}');
        fromJsonError('{"${JsonKey.script}": {"valid": "///uri"}}');
        fromJsonError('{"${JsonKey.script}": false}');
        fromJsonError('{"${JsonKey.script}": "4:///"}'); // Invalid URI scheme.

        // `*AcceptsAnsiCodes`, if present, must be booleans.
        fromJsonError('{"${JsonKey.stdinSupportsAnsi}": 42}');
        fromJsonError('{"${JsonKey.stdinSupportsAnsi}": "false"}');
        fromJsonError('{"${JsonKey.stdinSupportsAnsi}": []}');
        fromJsonError('{"${JsonKey.stdoutSupportsAnsi}": 42}');
        fromJsonError('{"${JsonKey.stdoutSupportsAnsi}": "false"}');
        fromJsonError('{"${JsonKey.stdoutSupportsAnsi}": []}');

        // Remaining properties must be strings.
        for (var name in [
          JsonKey.executable,
          JsonKey.lineTerminator,
          JsonKey.localeName,
          JsonKey.localHostname,
          JsonKey.operatingSystem,
          JsonKey.operatingSystemVersion,
          JsonKey.packageConfig,
          JsonKey.pathSeparator,
          JsonKey.resolvedExecutable,
          JsonKey.version,
        ]) {
          fromJsonError('{"$name": 42}');
          fromJsonError('{"$name": ["not a string"]}');
          fromJsonError('{"$name": {"not" : "a string"}}');
        }
      });
    });
    test('Throws when unset non-null values are read', () {
      final platform = FakeNativePlatform();
      // Sanity check, in case `testNativeFake` was bugged.
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
    test('sync', () {
      var fake = FakeNativePlatform.fromPlatform(original)
          .copyWith(operatingSystem: otherOS);
      expect(fake.operatingSystem, otherOS);
      fake.run(() {
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
      });
    });
    test('async', () async {
      var currentNative = original;
      var fake = FakeNativePlatform.fromPlatform(currentNative)
          .copyWith(operatingSystem: otherOS);
      var parts = 0;
      var asyncTesting = fake.run(() async {
        // Runs synchronously.
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        parts++;
        await Future(() {}); // Timer-delay.
        // Runs later.
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        parts++;
      });
      expect(parts, 1);
      expect(NativePlatform.current, same(original));
      expect(Platform.current.nativePlatform, same(original));
      expect(NativePlatform.current?.operatingSystem, original.operatingSystem);
      await asyncTesting;
      expect(parts, 2);
    });
  });
  group('nested overrides', () {
    final fakeNative = FakeNativePlatform.fromPlatform(original)
        .copyWith(operatingSystem: otherOS);
    final fakeNative2 = FakeNativePlatform.fromPlatform(fakeNative)
        .copyWith(operatingSystemVersion: otherVersion);
    test('sync', () {
      fakeNative.run(() {
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
        fakeNative2.run(() {
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
        });
        // Previous override restored when done.
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
      });
    });
    test('async', () async {
      await fakeNative.run(() async {
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
        var parts = 0;
        var asyncTesting = fakeNative2.run(() async {
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
          parts++;
          await Future(() {});
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
          parts++;
        });
        expect(parts, 1);
        // Previous override restored when done.
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
        await asyncTesting;
        expect(parts, 2);
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

/// Check the properties of a [NativePlatform].
///
/// The [expectedValues] is uses the same format as JSON serialization of a
/// [NativePlatform].
///
/// If any of the expected values arguments are `null`, reading the
/// corresponding property is expected to throw a `StateError`
/// (except for `NativePackage.packageConfig` which is nullable).
/// If the operating system value is `null`, all the  `isAndroid`..`isWindows`
/// are expected to throw too.
/// Otherwise they are tested to give the expected true/false value
/// for the expected operating system.
void testNativeFake(
    NativePlatform actual, Map<String, Object?> expectedValues) {
  var expectedOS = expectedValues[JsonKey.operatingSystem] as String?;
  _testProperty(() => actual.operatingSystem, expectedOS);
  if (expectedOS == null) {
    expect(() => actual.isAndroid, throwsStateError);
    expect(() => actual.isFuchsia, throwsStateError);
    expect(() => actual.isIOS, throwsStateError);
    expect(() => actual.isLinux, throwsStateError);
    expect(() => actual.isMacOS, throwsStateError);
    expect(() => actual.isWindows, throwsStateError);
  } else {
    expect(actual.isAndroid, expectedOS == NativePlatform.android);
    expect(actual.isFuchsia, expectedOS == NativePlatform.fuchsia);
    expect(actual.isIOS, expectedOS == NativePlatform.iOS);
    expect(actual.isLinux, expectedOS == NativePlatform.linux);
    expect(actual.isMacOS, expectedOS == NativePlatform.macOS);
    expect(actual.isWindows, expectedOS == NativePlatform.windows);
  }
  _testProperty(() => actual.operatingSystemVersion,
      expectedValues[JsonKey.operatingSystemVersion]);
  _testProperty(() => actual.environment, expectedValues[JsonKey.environment]);
  _testProperty(() => actual.executable, expectedValues[JsonKey.executable]);
  _testProperty(() => actual.executableArguments,
      expectedValues[JsonKey.executableArguments]);
  _testProperty(
      () => actual.lineTerminator, expectedValues[JsonKey.lineTerminator]);
  _testProperty(() => actual.localeName, expectedValues[JsonKey.localeName]);
  _testProperty(
      () => actual.localHostname, expectedValues[JsonKey.localHostname]);
  _testProperty(() => actual.numberOfProcessors,
      expectedValues[JsonKey.numberOfProcessors]);
  // Package-config is nullable, so doesn't throw if null.
  expect(actual.packageConfig, expectedValues[JsonKey.packageConfig]);
  _testProperty(
      () => actual.pathSeparator, expectedValues[JsonKey.pathSeparator]);
  _testProperty(() => actual.resolvedExecutable,
      expectedValues[JsonKey.resolvedExecutable]);
  var scriptText = expectedValues[JsonKey.script] as String?;
  var scriptUri = scriptText != null ? Uri.parse(scriptText) : null;
  _testProperty(() => actual.script, scriptUri);
  _testProperty(() => actual.stdinSupportsAnsi,
      expectedValues[JsonKey.stdinSupportsAnsi]);
  _testProperty(() => actual.stdoutSupportsAnsi,
      expectedValues[JsonKey.stdoutSupportsAnsi]);
  _testProperty(() => actual.version, expectedValues[JsonKey.version]);
}
