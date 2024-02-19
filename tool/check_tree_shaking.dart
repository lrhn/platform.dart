#! /bin/env dart
// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Run this script as
//
//     dart check_tree_shaking.dart
//
// or
//
//     dart tool/check_tree_shaking.dart
//
// from the package root directory.
//
// It will compile each example in `../example/` to both `.exe` and `.js`,
// then check which of the source program strings are retained in the
// executable.
//
// When tree-shaking works optimally, there should be precisely one
// 'RUNNING ...' string in the generated executable.
//
// (The script uses `Platform.executable` from `dart:io` as the compiler,
// which is why it must be invoked with that compiler.)
library;

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  // Keep the files after running.
  var retain = false;
  var retainOnError = false;
  var executeOnError = false;
  var verbose = false;
  var nativeOnly = false;
  var jsOnly = false;
  var files = <String>[];
  for (var arg in args) {
    if (arg == '-n') {
      nativeOnly = true;
    } else if (arg == '-j') {
      jsOnly = true;
    } else if (arg == '-e') {
      executeOnError = true;
    } else if (arg == '-r') {
      retainOnError = true;
    } else if (arg == '-R') {
      retain = retainOnError = true;
    } else if (arg == '-v') {
      verbose = true;
    } else {
      files.add(arg);
    }
  }
  if (nativeOnly && jsOnly) {
    stderr.writeln("Use only one of -j (JS only) or -n (native only).");
    exit(1);
  }

  // Only works on Linux, MacOS or Windows, since those are the platforms
  // the examples check for. (Others can be added, but this should be sufficient
  // for checking the general approach.)
  var platform = Platform.isLinux
      ? 'linux'
      : Platform.isMacOS
          ? 'macos'
          : Platform.isWindows
              ? 'windows'
              : null;
  if (platform == null) {
    print('Test only works on Linux, MacOS or Windows.');
    exit(1);
  }

  var self = Platform.script;

  // Try to detect whether this script was run by the `dart` CLI.
  //
  // Currently it assumes so if the executable exists and is named `dart`
  // or `dart.exe`.
  var hasDartExe = false;
  var dartExe = File(Platform.executable);
  if (dartExe.existsSync()) {
    var exeUri = dartExe.uri;
    // If someone compiles this file to dart.exe and runs it, we don't want an
    // infinite loop.
    if (exeUri != self) {
      var exeName = clipEnd(exeUri.pathSegments.last, '.exe');
      if (exeName == 'dart') {
        hasDartExe = true; // We hope.
      }
    }
  }
  if (!hasDartExe) {
    print('Must be run with the Dart CLI executable.');
    exit(1);
  }
  if (verbose) {
    print("Executable: ${dartExe.path}");
  }

  // Where executables are written.
  var outputDir = Directory.systemTemp.createTempSync('platform.examples-');
  outputDir.createSync(recursive: true);
  if (verbose) {
    print("Output: ${outputDir.path}");
  }

  if (files.isEmpty) {
    // Where examples are.
    var exampleDir = Directory.fromUri(self.resolve('../example/'));
    for (var example in exampleDir.listSync()) {
      if (example is File && example.path.endsWith('.dart')) {
        files.add(example.path);
      }
    }
  }

  var failures = <String>[];

  for (var examplePath in files) {
    var example = File(examplePath);
    var uri = Uri.file(examplePath);
    var exampleName = clipEnd(uri.pathSegments.last, '.dart');
    if (!jsOnly) {
      var exeOutput =
          '${outputDir.path}${Platform.pathSeparator}$exampleName.exe';
      var result = Process.runSync(
          dartExe.path,
          stdoutEncoding: utf8,
          stderrEncoding: utf8,
          [
            'compile',
            'exe',
            '--target-os',
            platform,
            '-o',
            exeOutput,
            example.path,
          ]);
      if (!_checkCompiled(example, File(exeOutput), verbose)) {
        print("STDOUT:\n ${result.stdout}\nSTDERR:\n${result.stderr}");
        continue;
      }

      var exampleExe = '$exampleName.exe';
      if (!check(exeOutput, exampleExe)) {
        failures.add(exampleExe);
        if (executeOnError) {
          var result = Process.runSync(
              exeOutput, stdoutEncoding: utf8, stderrEncoding: utf8, []);
          print("Running program $exampleExe: Exit code = ${result.exitCode}");
          print("STDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}");
        }
      }
    }

    if (!nativeOnly) {
      var jsOutput =
          '${outputDir.path}${Platform.pathSeparator}$exampleName.js';
      var result = Process.runSync(
          dartExe.path,
          stdoutEncoding: utf8,
          stderrEncoding: utf8,
          [
            'compile',
            'js',
            '-o',
            jsOutput,
            example.path,
          ]);
      if (!_checkCompiled(example, File(jsOutput), verbose)) {
        print("STDOUT:\n ${result.stdout}\nSTDERR:\n${result.stderr}");
        continue;
      }
      var exampleJS = '$exampleName.js';
      if (!check(jsOutput, exampleJS)) {
        failures.add(exampleJS);
        // Try finding `d8` in path, and d8.js preamble in SDK.
        // Until then, make sure to have a `d8` in then path which adds
        // the preamble.
        if (executeOnError) {
          var result = Process.runSync(
              'd8', stdoutEncoding: utf8, stderrEncoding: utf8, [jsOutput]);
          print("Running program $exampleJS: Exit code = ${result.exitCode}");
          print("STDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}");
        }
      }
    }
  }

  // And clean-up.
  if (retain || (retainOnError && failures.isNotEmpty)) {
    print('Executables written to: ${outputDir.path}');
  } else {
    outputDir.deleteSync(recursive: true);
  }
  if (verbose) {
    print("Failures:");
    for (var failure in failures) {
      print("- $failure");
    }
  }
}

bool check(String path, String name) {
  print('Checking $name:');
  var file = File(path);

  var content = file.readAsBytesSync();
  const needle = 'RUNNING';
  int matchCount = 0;
  // Find RUNNING
  outer:
  for (var i = 0; i < content.length - needle.length; i++) {
    var j = 0;
    for (; j < needle.length; j++) {
      if (content[i + j] != needle.codeUnitAt(j)) continue outer;
    }
    // Needle found. Find end of printable text.
    for (; i + j < content.length; j++) {
      var byte = content[i + j];
      if (byte < 0x20 || byte >= 0x7F) {
        break;
      }
    }
    var printableText = String.fromCharCodes(content, i, i + j);
    print('Found: $printableText');
    matchCount++;
    i += j;
  }
  if (matchCount == 0) {
    print('No matches found?');
    return false;
  } else if (matchCount > 1) {
    print('Too many matches found: $matchCount');
    return false;
  }
  return true;
}

String clipEnd(String text, String end) {
  if (text.endsWith(end)) return text.substring(0, text.length - end.length);
  return text;
}

bool _checkCompiled(File source, File output, bool verbose) {
  if (output.existsSync()) {
    if (verbose) {
      var stat = output.statSync();
      print("Compiled: ${source.path} to ${output.path}: ${stat.size} bytes");
    }
    return true;
  }
  print("FILE NOT COMPILED: ${source.path} to ${output.path}");
  return false;
}
