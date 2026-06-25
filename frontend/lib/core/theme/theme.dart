import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006a6a),
      surfaceTint: Color(0xff006a6a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9cf1f0),
      onPrimaryContainer: Color(0xff004f4f),
      secondary: Color(0xff00696b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9cf1f1),
      onSecondaryContainer: Color(0xff004f50),
      tertiary: Color(0xff36618e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd1e4ff),
      onTertiaryContainer: Color(0xff1a4975),
      error: Color(0xff904a41),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad5),
      onErrorContainer: Color(0xff73342c),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1d),
      onSurfaceVariant: Color(0xff3f4948),
      outline: Color(0xff6f7979),
      outlineVariant: Color(0xffbec9c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3132),
      inversePrimary: Color(0xff80d5d4),
      primaryFixed: Color(0xff9cf1f0),
      onPrimaryFixed: Color(0xff002020),
      primaryFixedDim: Color(0xff80d5d4),
      onPrimaryFixedVariant: Color(0xff004f4f),
      secondaryFixed: Color(0xff9cf1f1),
      onSecondaryFixed: Color(0xff002020),
      secondaryFixedDim: Color(0xff80d4d5),
      onSecondaryFixedVariant: Color(0xff004f50),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff001d36),
      tertiaryFixedDim: Color(0xffa0cafd),
      onTertiaryFixedVariant: Color(0xff1a4975),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee4e4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003d3d),
      surfaceTint: Color(0xff006a6a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff167979),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003d3e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff16797a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003862),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff46709e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e241d),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa2594f),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff2e3838),
      outline: Color(0xff4a5454),
      outlineVariant: Color(0xff656f6f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3132),
      inversePrimary: Color(0xff80d5d4),
      primaryFixed: Color(0xff167979),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005f5f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff16797a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005f60),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff46709e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2b5784),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c8),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe3e9ea),
      surfaceContainerHigh: Color(0xffd8dedf),
      surfaceContainerHighest: Color(0xffcdd3d3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003232),
      surfaceTint: Color(0xff006a6a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005252),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003233),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005253),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002e51),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1d4b77),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511a14),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff76362e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e2e),
      outlineVariant: Color(0xff414b4b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3132),
      inversePrimary: Color(0xff80d5d4),
      primaryFixed: Color(0xff005252),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003939),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005253),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00393a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1d4b77),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00345c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4babb),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f2),
      surfaceContainer: Color(0xffdee4e4),
      surfaceContainerHigh: Color(0xffcfd5d6),
      surfaceContainerHighest: Color(0xffc1c8c8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d5d4),
      surfaceTint: Color(0xff80d5d4),
      onPrimary: Color(0xff003737),
      primaryContainer: Color(0xff004f4f),
      onPrimaryContainer: Color(0xff9cf1f0),
      secondary: Color(0xff80d4d5),
      onSecondary: Color(0xff003737),
      secondaryContainer: Color(0xff004f50),
      onSecondaryContainer: Color(0xff9cf1f1),
      tertiary: Color(0xffa0cafd),
      onTertiary: Color(0xff003258),
      tertiaryContainer: Color(0xff1a4975),
      onTertiaryContainer: Color(0xffd1e4ff),
      error: Color(0xffffb4a9),
      onError: Color(0xff561e17),
      errorContainer: Color(0xff73342c),
      onErrorContainer: Color(0xffffdad5),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee4e4),
      onSurfaceVariant: Color(0xffbec9c8),
      outline: Color(0xff889392),
      outlineVariant: Color(0xff3f4948),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e4),
      inversePrimary: Color(0xff006a6a),
      primaryFixed: Color(0xff9cf1f0),
      onPrimaryFixed: Color(0xff002020),
      primaryFixedDim: Color(0xff80d5d4),
      onPrimaryFixedVariant: Color(0xff004f4f),
      secondaryFixed: Color(0xff9cf1f1),
      onSecondaryFixed: Color(0xff002020),
      secondaryFixedDim: Color(0xff80d4d5),
      onSecondaryFixedVariant: Color(0xff004f50),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff001d36),
      tertiaryFixedDim: Color(0xffa0cafd),
      onTertiaryFixedVariant: Color(0xff1a4975),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1d),
      surfaceContainer: Color(0xff1b2121),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96ebea),
      surfaceTint: Color(0xff80d5d4),
      onPrimary: Color(0xff002b2b),
      primaryContainer: Color(0xff479e9d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff96ebeb),
      onSecondary: Color(0xff002b2b),
      secondaryContainer: Color(0xff479e9e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc7deff),
      onTertiary: Color(0xff002747),
      tertiaryContainer: Color(0xff6b94c4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cb),
      onError: Color(0xff48130e),
      errorContainer: Color(0xffcc7b70),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dede),
      outline: Color(0xffaab4b3),
      outlineVariant: Color(0xff889292),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e4),
      inversePrimary: Color(0xff005151),
      primaryFixed: Color(0xff9cf1f0),
      onPrimaryFixed: Color(0xff001414),
      primaryFixedDim: Color(0xff80d5d4),
      onPrimaryFixedVariant: Color(0xff003d3d),
      secondaryFixed: Color(0xff9cf1f1),
      onSecondaryFixed: Color(0xff001415),
      secondaryFixedDim: Color(0xff80d4d5),
      onSecondaryFixedVariant: Color(0xff003d3e),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff001225),
      tertiaryFixedDim: Color(0xffa0cafd),
      onTertiaryFixedVariant: Color(0xff003862),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4646),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff191f1f),
      surfaceContainer: Color(0xff23292a),
      surfaceContainerHigh: Color(0xff2d3435),
      surfaceContainerHighest: Color(0xff383f40),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaafffe),
      surfaceTint: Color(0xff80d5d4),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff7cd1d0),
      onPrimaryContainer: Color(0xff000e0e),
      secondary: Color(0xffaaffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7cd0d1),
      onSecondaryContainer: Color(0xff000e0e),
      tertiary: Color(0xffe8f0ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9dc6f9),
      onTertiaryContainer: Color(0xff000c1b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea3),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f1),
      outlineVariant: Color(0xffbac5c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e4),
      inversePrimary: Color(0xff005151),
      primaryFixed: Color(0xff9cf1f0),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff80d5d4),
      onPrimaryFixedVariant: Color(0xff001414),
      secondaryFixed: Color(0xff9cf1f1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff80d4d5),
      onSecondaryFixedVariant: Color(0xff001415),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa0cafd),
      onTertiaryFixedVariant: Color(0xff001225),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5152),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2121),
      surfaceContainer: Color(0xff2b3132),
      surfaceContainerHigh: Color(0xff363c3d),
      surfaceContainerHighest: Color(0xff424849),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  /// Priority 1
  static const priority1 = ExtendedColor(
    seed: Color(0xffab2d25),
    value: Color(0xffab2d25),
    light: ColorFamily(
      color: Color(0xff904a42),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdad5),
      onColorContainer: Color(0xff73342d),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff904a42),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdad5),
      onColorContainer: Color(0xff73342d),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff904a42),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdad5),
      onColorContainer: Color(0xff73342d),
    ),
    dark: ColorFamily(
      color: Color(0xffffb4aa),
      onColor: Color(0xff561e18),
      colorContainer: Color(0xff73342d),
      onColorContainer: Color(0xffffdad5),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb4aa),
      onColor: Color(0xff561e18),
      colorContainer: Color(0xff73342d),
      onColorContainer: Color(0xffffdad5),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb4aa),
      onColor: Color(0xff561e18),
      colorContainer: Color(0xff73342d),
      onColorContainer: Color(0xffffdad5),
    ),
  );

  /// Priority 2
  static const priority2 = ExtendedColor(
    seed: Color(0xfff09235),
    value: Color(0xfff09235),
    light: ColorFamily(
      color: Color(0xff88511c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdcc2),
      onColorContainer: Color(0xff6b3b05),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff88511c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdcc2),
      onColorContainer: Color(0xff6b3b05),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff88511c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdcc2),
      onColorContainer: Color(0xff6b3b05),
    ),
    dark: ColorFamily(
      color: Color(0xffffb77a),
      onColor: Color(0xff4c2700),
      colorContainer: Color(0xff6b3b05),
      onColorContainer: Color(0xffffdcc2),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb77a),
      onColor: Color(0xff4c2700),
      colorContainer: Color(0xff6b3b05),
      onColorContainer: Color(0xffffdcc2),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb77a),
      onColor: Color(0xff4c2700),
      colorContainer: Color(0xff6b3b05),
      onColorContainer: Color(0xffffdcc2),
    ),
  );

  /// Priority 3
  static const priority3 = ExtendedColor(
    seed: Color(0xfff5c344),
    value: Color(0xfff5c344),
    light: ColorFamily(
      color: Color(0xff765a0b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdf9a),
      onColorContainer: Color(0xff5a4300),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff765a0b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdf9a),
      onColorContainer: Color(0xff5a4300),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff765a0b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdf9a),
      onColorContainer: Color(0xff5a4300),
    ),
    dark: ColorFamily(
      color: Color(0xffe7c26c),
      onColor: Color(0xff3f2e00),
      colorContainer: Color(0xff5a4300),
      onColorContainer: Color(0xffffdf9a),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffe7c26c),
      onColor: Color(0xff3f2e00),
      colorContainer: Color(0xff5a4300),
      onColorContainer: Color(0xffffdf9a),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffe7c26c),
      onColor: Color(0xff3f2e00),
      colorContainer: Color(0xff5a4300),
      onColorContainer: Color(0xffffdf9a),
    ),
  );

  /// Priority 4
  static const priority4 = ExtendedColor(
    seed: Color(0xff75b56b),
    value: Color(0xff75b56b),
    light: ColorFamily(
      color: Color(0xff3d6838),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbef0b2),
      onColorContainer: Color(0xff265022),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff3d6838),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbef0b2),
      onColorContainer: Color(0xff265022),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff3d6838),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbef0b2),
      onColorContainer: Color(0xff265022),
    ),
    dark: ColorFamily(
      color: Color(0xffa3d398),
      onColor: Color(0xff0e380d),
      colorContainer: Color(0xff265022),
      onColorContainer: Color(0xffbef0b2),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffa3d398),
      onColor: Color(0xff0e380d),
      colorContainer: Color(0xff265022),
      onColorContainer: Color(0xffbef0b2),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffa3d398),
      onColor: Color(0xff0e380d),
      colorContainer: Color(0xff265022),
      onColorContainer: Color(0xffbef0b2),
    ),
  );

  /// Priority 5
  static const priority5 = ExtendedColor(
    seed: Color(0xff6ca8ef),
    value: Color(0xff6ca8ef),
    light: ColorFamily(
      color: Color(0xff38608f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd2e4ff),
      onColorContainer: Color(0xff1c4875),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff38608f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd2e4ff),
      onColorContainer: Color(0xff1c4875),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff38608f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd2e4ff),
      onColorContainer: Color(0xff1c4875),
    ),
    dark: ColorFamily(
      color: Color(0xffa2c9fe),
      onColor: Color(0xff00325a),
      colorContainer: Color(0xff1c4875),
      onColorContainer: Color(0xffd2e4ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffa2c9fe),
      onColor: Color(0xff00325a),
      colorContainer: Color(0xff1c4875),
      onColorContainer: Color(0xffd2e4ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffa2c9fe),
      onColor: Color(0xff00325a),
      colorContainer: Color(0xff1c4875),
      onColorContainer: Color(0xffd2e4ff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
    priority1,
    priority2,
    priority3,
    priority4,
    priority5,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
