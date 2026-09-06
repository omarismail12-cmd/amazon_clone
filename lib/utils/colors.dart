import 'package:flutter/material.dart';

// Material 3 design system color scheme.
// Seeded from Amazon's brand orange, with primary pinned to the existing
// amber CTA color so buttons don't visually shift.
final ColorScheme appColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF9900),
  brightness: Brightness.light,
).copyWith(
  primary: Colors.amber,
  onPrimary: Colors.black,
  secondary: const Color(0xFFFF9900),
  onSecondary: Colors.white,
);

// --- Legacy aliases -----------------------------------------------------
// Superseded by Theme.of(context).colorScheme / Theme.of(context).textTheme.
// Kept (rather than mass find-and-replaced) so the ~30 existing call sites
// across the app keep compiling and looking consistent with the new scheme.
// Not annotated @Deprecated on purpose: these are used pervasively by design
// in this pass, and flagging every call site would just be noise.
Color white = appColorScheme.surface;
Color black = appColorScheme.onSurface;
Color black38 = appColorScheme.onSurface.withValues(alpha: 0.38);
Color grey = appColorScheme.outline;
Color greyShade1 = appColorScheme.surfaceContainerLow;
Color greyShade2 = appColorScheme.surfaceContainer;
Color greyShade3 = appColorScheme.surfaceContainerHigh;
Color orange = appColorScheme.secondary;
Color blue = appColorScheme.tertiary;
Color amber = appColorScheme.primary;
Color buttonColor = appColorScheme.primary;
Color transparent = Colors.transparent;
Color teal = appColorScheme.tertiaryContainer;
// Kept const (matches appColorScheme.secondary exactly, see the copyWith
// above) so existing `const BorderSide(color: secondaryColor)` call sites
// keep compiling.
const Color secondaryColor = Color(0xFFFF9900);
Color red = appColorScheme.error;

// Lienar Gradient Color

List<Color> appBarGradientColor = [
  const Color(0xff82d9e3),
  const Color(0xffa7e7cd),
];
List<Color> addressBarGradientColor = [
  const Color(0xffb5e7ee),
  const Color(0xffcbf1e2),
];
