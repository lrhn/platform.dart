// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Unknown platform.
library;

import '../testing/zone_overrides.dart' as override;
import 'platform_browser_interface.dart';
import 'platform_native_interface.dart';

export 'platform_browser_interface.dart';
export 'platform_native_interface.dart';

const platformInstance = HostPlatform._();

// For the legacy `LocalPlatform`.
const NativePlatform? nativePlatformInstance = null;

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
final class HostPlatform {
  /// The current [HostPlatform] information of the running program.
  @pragma('vm:prefer-inline')
  static HostPlatform get current =>
      (override.platformOverride as HostPlatform?) ?? platformInstance;

  /// The current native platform, if running on a native platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  BrowserPlatform? get browserPlatform => null;

  /// Whether currently running on a native platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isNative => false;

  /// Whether currently running in a browser.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isBrowser => false;

  const HostPlatform._();
}

// Extensible class so testing classes can subclass an otherwise final class.
abstract base class HostPlatformTestBase extends HostPlatform {
  const HostPlatformTestBase() : super._();
}
