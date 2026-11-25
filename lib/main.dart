import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

/// Root widget that applies the portfolio theme.
class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    final cardShape = RoundedRectangleBorder(
      borderRadius: radius,
      side: const BorderSide(color: AppColors.divider),
    );
    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color),
    );

    return Provider<ApiClient>.value(
      value: apiClient,
      child: MaterialApp(
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
            error: AppColors.dangerLight,
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
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.paperDark,
            labelStyle: const TextStyle(color: AppColors.textMuted),
            hintStyle: const TextStyle(color: AppColors.textMuted),
            border: inputBorder(AppColors.divider),
            enabledBorder: inputBorder(AppColors.divider),
            focusedBorder: inputBorder(AppColors.accent),
            errorBorder: inputBorder(AppColors.dangerLight),
            focusedErrorBorder: inputBorder(AppColors.dangerLight),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.paperDark,
              minimumSize: const Size(120, 48),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: radius),
            ),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.paperDark,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: const BorderSide(color: AppColors.divider),
            ),
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: AppColors.paperDark,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: AppColors.textMuted,
            textColor: AppColors.ink,
            selectedColor: AppColors.accent,
            selectedTileColor: AppColors.accentGlow,
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
      ),
    );
  }
}
