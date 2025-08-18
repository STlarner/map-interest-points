import "package:flutter/material.dart";

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFF4CAF50),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC8E6C9),
  onPrimaryContainer: Color(0xFF1B5E20),

  secondary: Color(0xFF009688),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFB2DFDB),
  onSecondaryContainer: Color(0xFF004D40),

  tertiary: Color(0xFFFFC107),
  onTertiary: Color(0xFF212121),
  tertiaryContainer: Color(0xFFFFF8E1),
  onTertiaryContainer: Color(0xFF745D00),

  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFCDD2),
  onErrorContainer: Color(0xFFB71C1C),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF212121),
  surfaceContainerHighest: Color(0xFFE8F5E9),
  onSurfaceVariant: Color(0xFF424242),

  outline: Color(0xFF9E9E9E),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF303030),
  onInverseSurface: Color(0xFFF5F5F5),
  inversePrimary: Color(0xFF81C784),
);

/// Dark mode color scheme
const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color(0xFF81C784),
  onPrimary: Color(0xFF1B5E20),
  primaryContainer: Color(0xFF2E7D32),
  onPrimaryContainer: Color(0xFFC8E6C9),

  secondary: Color(0xFF4DB6AC),
  onSecondary: Color(0xFF004D40),
  secondaryContainer: Color(0xFF00796B),
  onSecondaryContainer: Color(0xFFB2DFDB),

  tertiary: Color(0xFFFFD54F),
  onTertiary: Color(0xFF212121),
  tertiaryContainer: Color(0xFFFFA000),
  onTertiaryContainer: Color(0xFFFFF8E1),

  error: Color(0xFFEF5350),
  onError: Color(0xFFB71C1C),
  errorContainer: Color(0xFFB71C1C),
  onErrorContainer: Color(0xFFFFCDD2),

  surface: Color(0xFF121212),
  onSurface: Color(0xFFE0E0E0),
  surfaceContainerHighest: Color(0xFF1E1E1E),
  onSurfaceVariant: Color(0xFFBDBDBD),

  outline: Color(0xFF757575),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE0E0E0),
  onInverseSurface: Color(0xFF121212),
  inversePrimary: Color(0xFF4CAF50),
);

ThemeData get light {
  return ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // squircle-like curve
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
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
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
