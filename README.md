# Platform

[![Build Status -](https://travis-ci.org/google/platform.dart.svg?branch=master)](https://travis-ci.org/google/platform.dart)
[![Coverage Status -](https://coveralls.io/repos/github/google/platform.dart/badge.svg?branch=master)](https://coveralls.io/github/google/platform.dart?branch=master)
[![Pub](https://img.shields.io/pub/v/platform.svg)](https://pub.dartlang.org/packages/platform)


A generic platform abstraction for Dart.

The [HostPlatform] API, exposed by `package:platform/host.dart`,
provides cross-platform OS detection.
Rather than accessing the `Platform.operatingSystem` from `dart:io` directly,
it can be accessed using `HostPlatform.current.operatingSystem`.
That getter also works in browsers, where `dart:io` is not available,
reporting an `operatingSystem` value of `"browser"`.

Like `dart:io`, `package:platform/native.dart` supplies a rich,
Dart-idiomatic API for accessing platform-specific information.
The [NativePlatform] API provides a lightweight wrapper
around the static `Platform` properties that exist in `dart:io`.
However, the `NativePlatform` class exposes instance properties rather
than static properties, making it possible to inject a mock object
for testing.
The [NativePlatform] API should still only be used by code that
will only run on native platforms. It requires `dart:io` to work
correctly.

For testing, use the [MockHostPlatform] from `package:platform/host_test.dart`
to create and inject a mock `HostPlatform` value,
and the [MockNativePlatform] from `package:platform/native_test.dart`
to mock a `NativePlatform`.

A library should only need to import one of these libraries.
The exported classes from the libraries are:
| Library | `HostPlatform` | `NativePlatform` | `MockHostPlatform` | `MockNativePlatform` |
|:--:|:--:|:--:|:--:|:--:|
| `host.dart` | &check; | |||
| `native.dart`| &check; | &check; | | |
| `host_test.dart` | &check; | | &check; | |
| `native_test.dart` | &check; | &check; | &check; | &check; |

A non-test Dart library should not import a one of the `*_test.dart` libraries,
since the use of a mock can affect how well a compiled can optimize tests
against the operating system ID. If only the non-test libraries are used,
a well-optimizing compiler which knows the host platform it's compiling for,
may be able to deduce the result of tests at compile-time, and efficiently
omit code that won't be reachable on the current host platform.
Just creating a `MockHostPlatform` in the same program may affect
such optimization.

A test file can import any of the libraries, but only need a `*_test.dart`
library if it intends to create a mock of `HostPlatform` or `NativePlatform`.

The `package:platform/platform.dart` library provides a
(mostly) backwards compatible renaming of the classes, to match the names
used in prior versions of this package.
It exposes `NativePlatform` as `Platform`, `MockNativePlatform` as
`MockPlatform`, and a `LocalPlatform` class with a constructor that
should always be invoked with `const`, and which then creates the same
objects as `NativePlatform.current`.

