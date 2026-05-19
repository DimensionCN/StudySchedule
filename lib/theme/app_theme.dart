import 'package:flutter/material.dart';

/// 设计令牌 - 统一管理颜色、间距、圆角、阴影
class AppTheme {
  AppTheme._();

  // 主色调 - 更温暖的靛蓝色系
  static const Color primaryColor = Color(0xFF5B7CF4);
  static const Color secondaryColor = Color(0xFF7C5BF4);
  static const Color accentColor = Color(0xFFF45B8C);

  // 语义化颜色
  static const Color successColor = Color(0xFF34C759);
  static const Color warningColor = Color(0xFFFF9F0A);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color infoColor = Color(0xFF5AC8FA);

  // 背景色
  static const Color backgroundLight = Color(0xFFF8F9FC);
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF161B22);

  // 卡片渐变 - 不同类型使用不同渐变
  static const List<Color> wakeGradient = [Color(0xFFFFD93D), Color(0xFFFF9F0A)];
  static const List<Color> sleepGradient = [Color(0xFF5B7CF4), Color(0xFF7C5BF4)];
  static const List<Color> studyGradient = [Color(0xFF5B7CF4), Color(0xFF5BC0EB)];
  static const List<Color> restGradient = [Color(0xFF34C759), Color(0xFF5AC8FA)];
  static const List<Color> classGradient = [Color(0xFF7C5BF4), Color(0xFFF45B8C)];
  static const List<Color> freeTimeGradient = [Color(0xFFE8E8E8), Color(0xFFF5F5F5)];
  static const List<Color> freeTimeDarkGradient = [Color(0xFF21262D), Color(0xFF292E36)];

  // 圆角
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // 间距
  static const double spacingXS = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;

  // 阴影
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get activeCardShadow => [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  // 字体大小
  static const double fontXS = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 22.0;
  static const double fontTitle = 28.0;

  // 动画时长
  static const int animShort = 200;
  static const int animMedium = 300;
  static const int animLong = 500;

  static ThemeData lightTheme = ThemeData(
    colorSchemeSeed: primaryColor,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorSchemeSeed: primaryColor,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
    ),
  );
}
