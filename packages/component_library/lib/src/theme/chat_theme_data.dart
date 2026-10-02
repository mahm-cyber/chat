import 'package:flutter/material.dart';
import 'chat_palette.dart';
import 'chat_spacing.dart';

class ChatThemeData {
  const ChatThemeData._();

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: ChatPalette.indigo600,
      onPrimary: Colors.white,
      primaryContainer: ChatPalette.indigo50,
      onPrimaryContainer: ChatPalette.indigo700,
      secondary: ChatPalette.slate600,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: ChatPalette.slate900,
      error: ChatPalette.rose500,
      onError: Colors.white,
      outline: ChatPalette.slate200,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ChatPalette.slate50,
      dividerColor: ChatPalette.slate200,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ChatPalette.slate900,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChatPalette.slate100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.lg,
          vertical: ChatSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: const BorderSide(color: ChatPalette.indigo600, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: ChatPalette.indigo500,
      onPrimary: Colors.white,
      primaryContainer: ChatPalette.indigo700,
      onPrimaryContainer: ChatPalette.indigo100,
      secondary: ChatPalette.zinc400,
      onSecondary: ChatPalette.zinc950,
      surface: ChatPalette.zinc900,
      onSurface: ChatPalette.zinc50,
      error: ChatPalette.rose500,
      onError: Colors.white,
      outline: ChatPalette.zinc800,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ChatPalette.zinc950,
      dividerColor: ChatPalette.zinc800,
      appBarTheme: const AppBarTheme(
        backgroundColor: ChatPalette.zinc900,
        foregroundColor: ChatPalette.zinc50,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChatPalette.zinc800,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.lg,
          vertical: ChatSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChatSpacing.radiusLg),
          borderSide: const BorderSide(color: ChatPalette.indigo500, width: 1.5),
        ),
      ),
    );
  }
}
