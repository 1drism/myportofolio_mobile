import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget that applies the portfolio theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.divider),
    );

    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          onPrimary: AppColors.paperDark,
          secondary: AppColors.accent,
          onSecondary: AppColors.paperDark,
          surface: AppColors.paperDark,
          onSurface: AppColors.ink,
          onSurfaceVariant: AppColors.textMuted,
          error: AppColors.danger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paperDark,
          foregroundColor: AppColors.ink,
          titleTextStyle: TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.paperDark,
          elevation: 0,
          shape: cardShape,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.paperDark,
          contentTextStyle: const TextStyle(color: AppColors.ink),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.accent),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
