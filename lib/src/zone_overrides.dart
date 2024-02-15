// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Shared functionality for overriding a `Platform` in zones.
library;

import 'dart:async';

OverrideMarker? marker;
const zoneKey = #_platformOverride;

abstract class OverrideMarker {}

R runWith<R>(R Function() code, Object? overrideValue, OverrideMarker mark) {
  // After this, lookups on `Platform.current` will check for zone overrides.
  marker = mark;
  return runZoned(code, zoneValues: {zoneKey: overrideValue});
}
