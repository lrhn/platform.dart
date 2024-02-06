// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Wasm specific platform.
library pkg.platform.impl;

import 'dart:async' show Zone, runZoned;
import 'dart:collection' show HashMap;
import 'dart:convert' show JsonEncoder, jsonDecode;

import 'package:meta/meta.dart' show visibleForTesting;
import '../json_keys.dart';

part '../platform_apis.dart';

const Platform _currentPlatform = Platform._wasm(_WasmPlatform());

final class _WasmPlatform extends WasmPlatform {
  const _WasmPlatform() : super._();

  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        JsonKey.version: version,
      });

  @override
  String get version => '1.0.0'; // Don't know how to detect Wasm runtime.
}
