import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff745b0b),
      surfaceTint: Color(0xff745b0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdf92),
      onPrimaryContainer: Color(0xff594400),
      secondary: Color(0xff745b0c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdf91),
      onSecondaryContainer: Color(0xff594400),
      tertiary: Color(0xff6d5e0f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff8e287),
      onTertiaryContainer: Color(0xff534600),
      error: Color(0xff904a45),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff73332f),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1e),
      onSurfaceVariant: Color(0xff3f484a),
      outline: Color(0xff6f797a),
      outlineVariant: Color(0xffbfc8ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xffe5c36c),
      primaryFixed: Color(0xffffdf92),
      onPrimaryFixed: Color(0xff241a00),
      primaryFixedDim: Color(0xffe5c36c),
      onPrimaryFixedVariant: Color(0xff594400),
      secondaryFixed: Color(0xffffdf91),
      onSecondaryFixed: Color(0xff241a00),
      secondaryFixedDim: Color(0xffe4c36c),
      onSecondaryFixedVariant: Color(0xff594400),
      tertiaryFixed: Color(0xfff8e287),
      onTertiaryFixed: Color(0xff221b00),
      tertiaryFixedDim: Color(0xffdbc66f),
      onTertiaryFixedVariant: Color(0xff534600),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff453400),
      surfaceTint: Color(0xff745b0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff846a1c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff443400),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff846a1c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff403600),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7d6c1e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e2320),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa15852),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff2f3839),
      outline: Color(0xff4b5456),
      outlineVariant: Color(0xff656f70),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xffe5c36c),
      primaryFixed: Color(0xff846a1c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6a5100),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff846a1c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff695200),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7d6c1e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff635403),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c7c9),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe3e9ea),
      surfaceContainerHigh: Color(0xffd8dedf),
      surfaceContainerHighest: Color(0xffcdd3d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff382a00),
      surfaceTint: Color(0xff745b0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5c4600),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff382a00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5b4600),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff352c00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff564900),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511917),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff763631),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff252e2f),
      outlineVariant: Color(0xff414b4c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xffe5c36c),
      primaryFixed: Color(0xff5c4600),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff403000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5b4600),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff403100),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff564900),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3c3200),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4babb),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f3),
      surfaceContainer: Color(0xffdee3e5),
      surfaceContainerHigh: Color(0xffcfd5d6),
      surfaceContainerHighest: Color(0xffc2c7c9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe5c36c),
      surfaceTint: Color(0xffe5c36c),
      onPrimary: Color(0xff3e2e00),
      primaryContainer: Color(0xff594400),
      onPrimaryContainer: Color(0xffffdf92),
      secondary: Color(0xffe4c36c),
      onSecondary: Color(0xff3d2e00),
      secondaryContainer: Color(0xff594400),
      onSecondaryContainer: Color(0xffffdf91),
      tertiary: Color(0xffdbc66f),
      onTertiary: Color(0xff393000),
      tertiaryContainer: Color(0xff534600),
      onTertiaryContainer: Color(0xfff8e287),
      error: Color(0xffffb3ac),
      onError: Color(0xff571e1a),
      errorContainer: Color(0xff73332f),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee3e5),
      onSurfaceVariant: Color(0xffbfc8ca),
      outline: Color(0xff899294),
      outlineVariant: Color(0xff3f484a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff745b0b),
      primaryFixed: Color(0xffffdf92),
      onPrimaryFixed: Color(0xff241a00),
      primaryFixedDim: Color(0xffe5c36c),
      onPrimaryFixedVariant: Color(0xff594400),
      secondaryFixed: Color(0xffffdf91),
      onSecondaryFixed: Color(0xff241a00),
      secondaryFixedDim: Color(0xffe4c36c),
      onSecondaryFixedVariant: Color(0xff594400),
      tertiaryFixed: Color(0xfff8e287),
      onTertiaryFixed: Color(0xff221b00),
      tertiaryFixedDim: Color(0xffdbc66f),
      onTertiaryFixedVariant: Color(0xff534600),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
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
      primary: Color(0xfffcd980),
      surfaceTint: Color(0xffe5c36c),
      onPrimary: Color(0xff312400),
      primaryContainer: Color(0xffab8d3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcd980),
      onSecondary: Color(0xff302400),
      secondaryContainer: Color(0xffab8d3d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff2dc82),
      onTertiary: Color(0xff2d2500),
      tertiaryContainer: Color(0xffa2903f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cd),
      onError: Color(0xff481311),
      errorContainer: Color(0xffcc7b74),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dee0),
      outline: Color(0xffaab4b5),
      outlineVariant: Color(0xff889294),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff5a4500),
      primaryFixed: Color(0xffffdf92),
      onPrimaryFixed: Color(0xff181000),
      primaryFixedDim: Color(0xffe5c36c),
      onPrimaryFixedVariant: Color(0xff453400),
      secondaryFixed: Color(0xffffdf91),
      onSecondaryFixed: Color(0xff181000),
      secondaryFixedDim: Color(0xffe4c36c),
      onSecondaryFixedVariant: Color(0xff443400),
      tertiaryFixed: Color(0xfff8e287),
      onTertiaryFixed: Color(0xff161100),
      tertiaryFixedDim: Color(0xffdbc66f),
      onTertiaryFixedVariant: Color(0xff403600),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4647),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff191f20),
      surfaceContainer: Color(0xff23292a),
      surfaceContainerHigh: Color(0xff2d3435),
      surfaceContainerHighest: Color(0xff393f40),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeecc),
      surfaceTint: Color(0xffe5c36c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe1bf69),
      onPrimaryContainer: Color(0xff110a00),
      secondary: Color(0xffffeecc),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe0bf69),
      onSecondaryContainer: Color(0xff100a00),
      tertiary: Color(0xfffff0b9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd7c26b),
      onTertiaryContainer: Color(0xff0f0b00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea6),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f3),
      outlineVariant: Color(0xffbbc4c6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff5a4500),
      primaryFixed: Color(0xffffdf92),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe5c36c),
      onPrimaryFixedVariant: Color(0xff181000),
      secondaryFixed: Color(0xffffdf91),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe4c36c),
      onSecondaryFixedVariant: Color(0xff181000),
      tertiaryFixed: Color(0xfff8e287),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdbc66f),
      onTertiaryFixedVariant: Color(0xff161100),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5152),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2122),
      surfaceContainer: Color(0xff2b3133),
      surfaceContainerHigh: Color(0xff363c3e),
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


  List<ExtendedColor> get extendedColors => [
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
