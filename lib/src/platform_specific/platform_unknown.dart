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

const Platform _currentPlatform = Platform._unknown();
