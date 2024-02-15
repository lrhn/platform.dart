// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific interface for `BrowserPlatform`.
library;

import 'platforms_impl.dart' show Platform;

/// Information about the current browser.
///
/// Only available while running in a browser.
abstract final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [Platform.current.browserPlatform].
  static BrowserPlatform? get current => Platform.current.browserPlatform;

  /// The browser's version, as reported by (something).
  String get version;

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  String get userAgent;

  /// A best-effort attempt to detect when running in a Chromium-based browser.
  ///
  /// May detect Chrome or browsers based on Chromium or the Blink engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Chromium behavior, or if another browser engine
  /// tries to impersonate the Chromium runtime environment.
  bool get isChromium;

  /// A best-effort attempt to detect when running in a Webkit-based browser.
  ///
  /// May detect the Safari browser, or other browsers based on the Webkit
  /// browser engine.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Webkit behavior, or if another browser engine
  /// tries to impersonate the Safari runtime environment.
  bool get isWebkit;

  /// A best-effort attempt to detect when running in a Mozilla-based browser.
  ///
  /// May detect the Mozilla Firefox browser, other browsers based on the
  /// Mozilla Gecko or Quantum browser engines.
  /// May also fail to do so correctly, if a browser differs significantly
  /// from the mainline Firefox behavior, or if another browser engine
  /// tries to impersonate the Firefox runtime environment.
  bool get isMozilla;

  /// A JSON representation of the state of this platform object.
  String toJson();
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
