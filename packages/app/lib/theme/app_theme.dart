import "package:flutter/material.dart";

import "package:flutter/material.dart";

/// Light mode color scheme
const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFF4B5563), // Graphite gray
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD1D5DB), // Silver container
  onPrimaryContainer: Color(0xFF111827),

  secondary: Color(0xFF6B7280), // Neutral gray
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE5E7EB), // Light silver
  onSecondaryContainer: Color(0xFF1F2937),

  tertiary: Color(0xFF9CA3AF), // Soft silver accent
  onTertiary: Color(0xFF111827),
  tertiaryContainer: Color(0xFFF3F4F6), // Very light gray
  onTertiaryContainer: Color(0xFF1F2937),

  error: Color(0xFFB91C1C),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFECACA),
  onErrorContainer: Color(0xFF450A0A),

  surface: Color(0xFFFFFFFF), // White
  onSurface: Color(0xFF111827),
  surfaceContainerHighest: Color(0xFFF3F4F6),
  onSurfaceVariant: Color(0xFF4B5563),

  outline: Color(0xFF9CA3AF),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF1F2937),
  onInverseSurface: Color(0xFFF9FAFB),
  inversePrimary: Color(0xFFCBD5E1), // Light steel gray
);

/// Dark mode color scheme
const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color(0xFF9CA3AF), // Silver-gray
  onPrimary: Color(0xFF1F2937),
  primaryContainer: Color(0xFF4B5563), // Graphite
  onPrimaryContainer: Color(0xFFD1D5DB),

  secondary: Color(0xFF6B7280), // Neutral mid-gray
  onSecondary: Color(0xFFE5E7EB),
  secondaryContainer: Color(0xFF374151),
  onSecondaryContainer: Color(0xFFE5E7EB),

  tertiary: Color(0xFFCBD5E1), // Light silver
  onTertiary: Color(0xFF1F2937),
  tertiaryContainer: Color(0xFF475569), // Slate
  onTertiaryContainer: Color(0xFFE2E8F0),

  error: Color(0xFFFCA5A5),
  onError: Color(0xFF450A0A),
  errorContainer: Color(0xFF7F1D1D),
  onErrorContainer: Color(0xFFFECACA),

  surface: Color(0xFF111827), // Dark graphite
  onSurface: Color(0xFFE5E7EB),
  surfaceContainerHighest: Color(0xFF1F2937),
  onSurfaceVariant: Color(0xFF9CA3AF),

  outline: Color(0xFF6B7280),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE5E7EB),
  onInverseSurface: Color(0xFF1F2937),
  inversePrimary: Color(0xFF4B5563),
);

ThemeData get light {
  return ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.primaryContainer,
      elevation: 0,
      foregroundColor: _lightColorScheme.onPrimaryContainer,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.error, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
  );
}

ThemeData get dark {
  return ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.primaryContainer,
      foregroundColor: _darkColorScheme.onPrimaryContainer,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _darkColorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _darkColorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _darkColorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _lightColorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
