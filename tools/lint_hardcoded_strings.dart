import 'dart:developer';
import 'dart:io';

void main() {
  final directoriesToScan = [
    Directory('packages/features'),
    Directory('apps/chat_flutter/lib'),
    Directory('apps/chat_web/lib'),
  ];

  // Regex to detect ChatText('...') or ChatText("...") with string literals
  final chatTextLiteralRegex = RegExp(r'''ChatText\s*\(\s*(['"][^'"]+['"])''');
  // Regex to detect Jaspr text('...') with string literals (excluding tr('...'))
  final jasprTextLiteralRegex = RegExp(r'''(?<!\btr\(\s*)text\s*\(\s*(['"][^'"]+['"])''');

  int violationCount = 0;

  log('🔍 Scanning for hardcoded string literals in UI widgets...');

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

        final matchChat = chatTextLiteralRegex.firstMatch(line);
        final matchJaspr = jasprTextLiteralRegex.firstMatch(line);

        if (matchChat != null) {
          final literal = matchChat.group(1);
          violationCount++;
          log('\n⚠️  Hardcoded String Violation #$violationCount:');
          log('   📁 File: ${file.path}');
          log('   📍 Line ${i + 1}: "$line"');
          log('   ❌ Hardcoded string: $literal');
          log('   💡 Recommendation: Use context.tr("key") or dynamic server localization.');
        } else if (matchJaspr != null && !line.contains('tr(')) {
          final literal = matchJaspr.group(1);
          violationCount++;
          log('\n⚠️  Hardcoded String Violation #$violationCount:');
          log('   📁 File: ${file.path}');
          log('   📍 Line ${i + 1}: "$line"');
          log('   ❌ Hardcoded string: $literal');
          log('   💡 Recommendation: Use tr("key") or dynamic server localization.');
        }
      }
    }
  }

  if (violationCount > 0) {
    log('\n❌ Lint check failed: Found $violationCount hardcoded string literals in UI.');
    log('All UI strings must be retrieved dynamically from Serverpod localization using translation keys.');
    exit(1);
  } else {
    log('\n✅ Lint check passed! Zero hardcoded UI strings detected.');
    exit(0);
  }
}
