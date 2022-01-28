# Platform

[![Build Status -](https://travis-ci.org/google/platform.dart.svg?branch=master)](https://travis-ci.org/google/platform.dart)
[![Coverage Status -](https://coveralls.io/repos/github/google/platform.dart/badge.svg?branch=master)](https://coveralls.io/github/google/platform.dart?branch=master)
[![Pub](https://img.shields.io/pub/v/platform.svg)](https://pub.dartlang.org/packages/platform)


A generic platform abstraction for Dart.

`package:platform/platform.dart` provides cross-platform OS detection
capabilities.
Like `Platform.operatingSystem` from `dart:io`, but provided by
instance members instead of static members, making it possible to
mock out in tests.


Like `dart:io`, `package:platform/native.dart` supplies a rich,
Dart-idiomatic API for accessing platform-specific information.

`package:platform/native.dart` provides a lightweight wrapper
around the static `Platform` properties that exist in `dart:io`.
However, it uses instance properties rather
than static properties, making it possible to mock out in tests.

Setting the environment variables `pkg.platform.operatingSystem` and
`pkg.platform.operatingSystemVersion` overrides the default,
and should be used judiciosuly.
If provided during production compilation, it *might* allow a compiler
to recognize the operating system as a constant, and improve the
compiled program size.