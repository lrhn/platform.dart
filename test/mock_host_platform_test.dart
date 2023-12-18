// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:platform/host_test.dart';
import 'package:test/test.dart';

void main() {
  group('MockHostPlatform', () {
    group('constructed,', () {
      test('empty', () {
        var mock = MockHostPlatform();
        testMock(mock, null, null);
      });
      test('partially empty', () {
        var mock = MockHostPlatform(operatingSystem: 'os2');
        testMock(mock, 'os2', null);
        mock = MockHostPlatform(operatingSystem: 'android');
        testMock(mock, 'android', null);
      });
      test('fully initialized', () {
        var mock = MockHostPlatform(
            operatingSystem: 'os2', operatingSystemVersion: '1.0');
        testMock(mock, 'os2', '1.0');
      });
    });
    group('fromPlatform,', () {
      test('empty', () {
        var base = MockHostPlatform();
        var mock = MockHostPlatform.fromPlatform(base);
        testMock(mock, null, null);
      });
      test('partiallyEmpty', () {
        var base = MockHostPlatform(operatingSystem: 'os2');
        var mock = MockHostPlatform.fromPlatform(base);
        testMock(mock, 'os2', null);
      });
      test('fully initialized', () {
        var base = MockHostPlatform(
            operatingSystem: 'os2', operatingSystemVersion: '1.0');
        var mock = MockHostPlatform.fromPlatform(base);
        testMock(mock, 'os2', '1.0');
      });
      test('current host', () {
        var base = HostPlatform.current;
        var mock = MockHostPlatform.fromPlatform(base);
        testMock(mock, base.operatingSystem, base.operatingSystemVersion);
      });
    });
    group('fromJson,', () {
      test('empty', () {
        var mock = MockHostPlatform.fromJson('{}');
        testMock(mock, null, null);
      });
      test('partiallyEmpty', () {
        var mock = MockHostPlatform.fromJson('{"operatingSystem": "os2"}');
        testMock(mock, 'os2', null);
      });

      test('fully initialized', () {
        var mock = MockHostPlatform.fromJson(
            '{"operatingSystem": "os2", "operatingSystemVersion": "1.0"}');
        testMock(mock, 'os2', '1.0');
      });

      test('explicit null', () {
        var mock = MockHostPlatform.fromJson(
            '{"operatingSystem": "os2", "operatingSystemVersion": null}');
        testMock(mock, 'os2', null);
      });

      test('extra keys', () {
        // Having extra keys in the JSON object is allowed.
        var mock = MockHostPlatform.fromJson(
            '{"operatingSystem": "os2", "banana": 42}');
        testMock(mock, 'os2', null);
      });

      test('invalid JSON', () {
        // Not JSON at all.
        expect(
            () => MockHostPlatform.fromJson('not json'), throwsFormatException);
        // Not a JSON object.
        expect(() => MockHostPlatform.fromJson('null'), throwsFormatException);
        expect(() => MockHostPlatform.fromJson('42'), throwsFormatException);
        expect(() => MockHostPlatform.fromJson('"{}"'), throwsFormatException);
        expect(() => MockHostPlatform.fromJson('[{}]'), throwsFormatException);
        // Not a String value where needed.
        expect(() => MockHostPlatform.fromJson('{"operatingSystem": 42}'),
            throwsFormatException);
        expect(
            () => MockHostPlatform.fromJson('{"operatingSystemVersion": 42}'),
            throwsFormatException);
      });
    });

    group('copyWith', () {
      test('none', () {
        var base = MockHostPlatform();
        var mock = base.copyWith();
        testMock(mock, null, null);

        base = MockHostPlatform(operatingSystem: 'os2');
        mock = base.copyWith();
        testMock(mock, 'os2', null);
      });

      test('explicit null', () {
        var base = MockHostPlatform();
        var mock = base.copyWith(operatingSystem: null);
        testMock(mock, null, null);

        base = MockHostPlatform(operatingSystem: 'os2');
        mock = base.copyWith(operatingSystem: null);
        testMock(mock, 'os2', null);

        base = MockHostPlatform(operatingSystem: 'os2');
        mock =
            base.copyWith(operatingSystem: null, operatingSystemVersion: null);
        testMock(mock, 'os2', null);
      });

      test('some', () {
        var base = MockHostPlatform();
        var mock = base.copyWith(operatingSystem: 'os2');
        testMock(mock, 'os2', null);

        base = MockHostPlatform(operatingSystem: '360');
        mock = base.copyWith(operatingSystem: 'os2');
        testMock(mock, 'os2', null);

        base = MockHostPlatform(operatingSystem: 'os2');
        mock = base.copyWith(operatingSystemVersion: '1.0');
        testMock(mock, 'os2', '1.0');

        base = MockHostPlatform(
            operatingSystem: 'os2', operatingSystemVersion: '2.0');
        mock = base.copyWith(operatingSystemVersion: '1.0');
        testMock(mock, 'os2', '1.0');
      });

      test('all', () {
        var base = MockHostPlatform();
        var mock = base.copyWith(
            operatingSystem: 'os2', operatingSystemVersion: '1.0');
        testMock(mock, 'os2', '1.0');

        base = MockHostPlatform(operatingSystem: '360');
        mock = base.copyWith(
            operatingSystem: 'os2', operatingSystemVersion: '1.0');
        testMock(mock, 'os2', '1.0');

        base = MockHostPlatform(
            operatingSystem: '360', operatingSystemVersion: '7.0');
        mock = base.copyWith(operatingSystemVersion: '1.0');
        testMock(mock, '360', '1.0');
      });
    });
  });

  group('runtime override, host platform only,', () {
    test('sync', () {
      var currentHost = HostPlatform.current;
      var mock = MockHostPlatform.fromPlatform(currentHost)
          .copyWith(operatingSystemVersion: 'bananas');
      mock.run(() {
        expect(HostPlatform.current, same(mock));
      });
    });
    test('async', () async {
      var currentHost = HostPlatform.current;
      var mock = MockHostPlatform.fromPlatform(currentHost)
          .copyWith(operatingSystemVersion: 'bananas');
      await mock.run(() async {
        await Future(() {}); // Timer-delay.
        expect(HostPlatform.current, same(mock));
      });
    });
    test('zone bound', () {
      var rootPlatform = HostPlatform.current;
      var rootOS = rootPlatform.operatingSystem;
      var mock1 = MockHostPlatform(operatingSystem: 'os1');
      var mock2 = MockHostPlatform(operatingSystem: 'os2');
      var zone0 = Zone.current;
      mock1.run(() {
        expect(HostPlatform.current.operatingSystem, 'os1');
        expect(HostPlatform.current, same(mock1));
        var zone1 = Zone.current;
        mock2.run(() {
          expect(HostPlatform.current.operatingSystem, 'os2');
          expect(HostPlatform.current, same(mock2));
          zone1.run(() {
            // Reinstating the zone also reinstates the mock platform.
            expect(HostPlatform.current.operatingSystem, 'os1');
            expect(HostPlatform.current, same(mock1));
          });
          zone0.run(() {
            expect(HostPlatform.current.operatingSystem, rootOS);
            expect(HostPlatform.current, same(rootPlatform));
          });
          runZoned(() {
            // Creating a new zone inherits the platform.
            expect(HostPlatform.current.operatingSystem, 'os2');
            expect(HostPlatform.current, same(mock2));
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
