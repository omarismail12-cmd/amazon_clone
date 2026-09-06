import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: appColorScheme,
  scaffoldBackgroundColor: appColorScheme.surface,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: appColorScheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      color: appColorScheme.onSurfaceVariant,
      fontSize: 13,
      fontWeight: FontWeight.normal,
    ),
    labelMedium: TextStyle(
      color: appColorScheme.onSurfaceVariant,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: appColorScheme.onSurfaceVariant,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: appColorScheme.surface,
    foregroundColor: appColorScheme.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    color: appColorScheme.surface,
    elevation: 1.5,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColorScheme.primary,
      foregroundColor: appColorScheme.onPrimary,
      disabledBackgroundColor: appColorScheme.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: appColorScheme.onSurface.withValues(alpha: 0.38),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: appColorScheme.onSurface,
      side: BorderSide(color: appColorScheme.outline),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: appColorScheme.primary,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: appColorScheme.surfaceContainerLow,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(color: appColorScheme.onSurfaceVariant, fontSize: 14),
    labelStyle: TextStyle(color: appColorScheme.onSurfaceVariant, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColorScheme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColorScheme.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColorScheme.error, width: 1.5),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: appColorScheme.surfaceContainerLow,
    labelStyle: TextStyle(color: appColorScheme.onSurface, fontSize: 13),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  dividerTheme: DividerThemeData(
    color: appColorScheme.outlineVariant,
    thickness: 1,
  ),
);
