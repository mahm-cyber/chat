import 'dart:io';

void main() {
  final directoriesToScan = [
    Directory('packages/features'),
    Directory('apps/chat_flutter/lib'),
  ];

  final textRegex = RegExp(r'(?<![a-zA-Z])Text\s*\(');
  int violationCount = 0;

  stdout.writeln('🔍 Scanning for raw Text widget usages in feature packages and apps...');

  for (final dir in directoriesToScan) {
    if (!dir.existsSync()) continue;

    final files = dir.listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path;
      return path.endsWith('.dart') &&
          path.contains('/lib/') &&
          !path.contains('.plugin_symlinks') &&
          !path.contains('ephemeral') &&
          !path.contains('.g.dart') &&
          !path.contains('.freezed.dart') &&
          !path.contains('.mocks.dart') &&
          !path.contains('/.dart_tool/') &&
          !path.contains('/build/');
    });

    for (final file in files) {
      final lines = file.readAsLinesSync();
      bool inBlockComment = false;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        if (inBlockComment) {
          if (line.contains('*/')) inBlockComment = false;
          continue;
        }
        if (line.contains('/*')) {
          inBlockComment = true;
          if (line.contains('*/')) inBlockComment = false;
          continue;
        }

        if (line.startsWith('//') ||
            line.startsWith('///') ||
            line.startsWith('import ') ||
            line.startsWith('export ')) {
          continue;
        }

        if (textRegex.hasMatch(line)) {
          violationCount++;
          stdout.writeln('\n⚠️  Violation #$violationCount:');
          stdout.writeln('   📁 File: ${file.path}');
          stdout.writeln('   📍 Line ${i + 1}: "$line"');
          stdout.writeln('   💡 Recommendation: Replace "Text" with "ChatText" from component_library.');
        }
      }
    }
  }

  if (violationCount > 0) {
    stdout.writeln('\n❌ Lint check failed: Found $violationCount instances of raw "Text" widgets.');
    stdout.writeln('Please use "ChatText" instead to maintain design system consistency.');
    exit(1);
  } else {
    stdout.writeln('\n✅ Lint check passed! All widgets conform to using reusable ChatText widgets.');
    exit(0);
  }
}
