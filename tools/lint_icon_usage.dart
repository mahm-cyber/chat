import 'dart:io';

void main() {
  final directoriesToScan = [
    Directory('packages/features'),
    Directory('apps/chat_flutter/lib'),
  ];

  final iconRegex = RegExp(r'(?<![a-zA-Z])Icon\s*\(');
  int violationCount = 0;

  stdout.writeln('🔍 Scanning for raw Icon widget usages in feature packages and apps...');

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
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('//') || line.startsWith('import ') || line.startsWith('export ')) continue;

        if (iconRegex.hasMatch(line)) {
          violationCount++;
          stdout.writeln('\n⚠️  Violation #$violationCount:');
          stdout.writeln('   📁 File: ${file.path}');
          stdout.writeln('   📍 Line ${i + 1}: "$line"');
          stdout.writeln('   💡 Recommendation: Replace "Icon" with "ChatIcon" from component_library.');
        }
      }
    }
  }

  if (violationCount > 0) {
    stdout.writeln('\n❌ Lint check failed: Found $violationCount instances of raw "Icon" widgets.');
    exit(1);
  } else {
    stdout.writeln('\n✅ Lint check passed! All widgets conform to using reusable ChatIcon widgets.');
    exit(0);
  }
}
