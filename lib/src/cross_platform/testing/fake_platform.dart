// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../platform.dart';

/// Provides a mutable implementation of the [Platform] interface.
class FakePlatform extends Platform {
  /// Creates a new [FakePlatform] with the specified properties.
  ///
  /// Unspecified properties will *not* be assigned default values (they will
  /// remain `null`). If an unset non-null value is read, a [StateError] will
  /// be thrown instead of returnin `null`.
  FakePlatform({
    String? operatingSystem,
    String? operatingSystemVersion,
  })  : _operatingSystem = operatingSystem,
        _operatingSystemVersion = operatingSystemVersion;

  /// Creates a new [FakePlatform] with properties whose initial values mirror
  /// the specified [platform].
  FakePlatform.fromPlatform(Platform platform)
      : _operatingSystem = platform.operatingSystem,
        _operatingSystemVersion = platform.operatingSystemVersion;

  /// Creates a new [FakePlatform] with properties extracted from the encoded
  /// JSON string.
  ///
  /// [json] must be a JSON string that matches the encoding produced by
  /// [toJson].
  factory FakePlatform.fromJson(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FakePlatform(
      operatingSystem: map['operatingSystem'],
      operatingSystemVersion: map['operatingSystemVersion'],
    );
  }

  /// Creates a new [FakePlatform] from this one, with some properties replaced by the given properties.
  Platform copyWith({
    String? operatingSystem,
    String? operatingSystemVersion,
  }) {
    return FakePlatform(
      operatingSystem: operatingSystem ?? this.operatingSystem,
      operatingSystemVersion:
          operatingSystemVersion ?? this.operatingSystemVersion,
    );
  }

  @override
  String get operatingSystem => throwIfNull(_operatingSystem);
  String? _operatingSystem;

  @override
  String get operatingSystemVersion => throwIfNull(_operatingSystemVersion);
  String? _operatingSystemVersion;
}

T throwIfNull<T>(T? value) {
  if (value == null) {
    throw StateError(
        'Tried to read property of fake platform, but it was unset.');
  }
  return value;
}
