import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graville_operations/core/style/color.dart';


class AppTheme {
  AppTheme._();

  static final double _radius = 10;

  static ThemeData get light => _build(AppColor.light, Brightness.light);
  static ThemeData get dark => _build(AppColor.dark, Brightness.dark);

  static ThemeData _build(AppColorTokens color, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: color.scaffoldBackground,
      primaryColor: AppColor.primary,
      splashColor: color.ripple,
      highlightColor: Colors.transparent,
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: brightness,

        primary: AppColor.primary,
        onPrimary: color.textOnPrimary,
        primaryContainer: color.surfacePrimary,
        onPrimaryContainer: AppColor.primaryDark,

        secondary: AppColor.secondary,
        onSecondary: color.textOnSecondary,
        secondaryContainer: color.surfaceSecondary,
        onSecondaryContainer: AppColor.secondaryDark,

        tertiary: AppColor.tertiary,
        onTertiary: AppColor.white,
        tertiaryContainer: color.surfaceTertiary,
        onTertiaryContainer: AppColor.tertiaryDark,

        error: color.errorDefault,
        onError: AppColor.white,
        errorContainer: color.errorSurface,
        onErrorContainer: color.errorDefault,

        surface: color.surfaceCard,
        onSurface: color.textPrimary,
        surfaceContainerHighest: color.surfaceInput,
        onSurfaceVariant: color.textSecondary,

        outline: color.borderDefault,
        outlineVariant: color.borderStrong,
        shadow: color.appBarShadow,
        scrim: color.scrim,

        inverseSurface: brightness == Brightness.light
            ? AppPalette.neutral900
            : AppPalette.neutral50,
        onInverseSurface: brightness == Brightness.light
            ? AppColor.white
            : AppPalette.neutral900,
        inversePrimary: brightness == Brightness.light
            ? AppColor.primaryLight
            : AppColor.primary,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: color.appBarBackground,
        foregroundColor: color.appBarForeground,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: color.appBarBackground,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(color: color.iconOnPrimary),
        actionsIconTheme: IconThemeData(color: color.iconOnPrimary),
        titleTextStyle: TextStyle(
          color: color.appBarForeground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: TextStyle(
          color: color.appBarForeground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: color.bottomNavBackground,
        selectedItemColor: color.bottomNavSelected,
        unselectedItemColor: color.bottomNavUnselected,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: color.bottomNavBackground,
        indicatorColor: color.bottomNavIndicator,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? color.iconActive
                : color.iconSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            color: states.contains(WidgetState.selected)
                ? color.bottomNavSelected
                : color.bottomNavUnselected,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.normal,
          );
        }),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: color.drawerBackground,
        surfaceTintColor: Colors.transparent,
      ),

      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: color.tabBarIndicator,
        labelColor: color.tabBarSelected,
        unselectedLabelColor: color.tabBarUnselected,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),

      cardTheme: CardThemeData(
        color: color.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: brightness == Brightness.dark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: color.cardBorder),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.buttonPrimaryBg,
          foregroundColor: color.buttonPrimaryFg,
          disabledBackgroundColor: color.buttonPrimaryDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: color.buttonOutlineFg,
          side: BorderSide(color: color.buttonOutlineBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color.buttonTextFg,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: color.buttonSecondaryBg,
          foregroundColor: color.buttonSecondaryFg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color.buttonPrimaryBg,
        foregroundColor: color.buttonPrimaryFg,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.inputBackground,
        hintStyle: TextStyle(color: color.inputHint, fontSize: 14),
        labelStyle: TextStyle(color: color.inputLabel, fontSize: 14),
        prefixIconColor: color.iconSecondary,
        suffixIconColor: color.iconSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: color.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: color.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: color.inputBorderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: color.inputBorderError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: color.inputBorderError, width: 2),
        ),
      ),

      textTheme: TextTheme(
        displayLarge:   TextStyle(color: color.textPrimary, fontWeight: FontWeight.w700),
        displayMedium:  TextStyle(color: color.textPrimary, fontWeight: FontWeight.w700),
        displaySmall:   TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        headlineLarge:  TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall:  TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        titleLarge:     TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: color.textPrimary, fontWeight: FontWeight.w500),
        titleSmall:     TextStyle(color: color.textSecondary, fontWeight: FontWeight.w500),
        bodyLarge:      TextStyle(color: color.textPrimary),
        bodyMedium:     TextStyle(color: color.textPrimary),
        bodySmall:      TextStyle(color: color.textSecondary),
        labelLarge:     TextStyle(color: color.textPrimary, fontWeight: FontWeight.w600),
        labelMedium:    TextStyle(color: color.textSecondary),
        labelSmall:     TextStyle(color: color.textDisabled),
      ),

      iconTheme: IconThemeData(color: color.iconPrimary),
      primaryIconTheme: IconThemeData(color: color.iconOnPrimary),

      dividerTheme: DividerThemeData(
        color: color.divider,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: color.surfaceInput,
        selectedColor: color.surfacePrimary,
        labelStyle: TextStyle(color: color.textPrimary, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: color.bottomNavSelected, fontSize: 13),
        side: BorderSide(color: color.borderDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: color.surfaceCardElevated,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: color.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(color: color.textSecondary, fontSize: 14),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.light
            ? AppPalette.neutral900
            : AppPalette.neutral750,
        contentTextStyle: const TextStyle(color: AppPalette.white, fontSize: 14),
        actionTextColor: AppColor.secondaryLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? color.buttonPrimaryBg
              : color.iconDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? color.bottomNavIndicator
              : color.borderDefault;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? color.buttonPrimaryBg
              : Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColor.white),
        side: BorderSide(color: color.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? color.buttonPrimaryBg
              : color.borderStrong;
        }),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: color.buttonPrimaryBg,
        linearTrackColor: color.bottomNavIndicator,
        circularTrackColor: color.bottomNavIndicator,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: color.buttonPrimaryBg,
        inactiveTrackColor: color.bottomNavIndicator,
        thumbColor: color.buttonPrimaryBg,
        overlayColor: color.ripple,
        valueIndicatorColor: color.buttonPrimaryHover,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: color.surfaceCardElevated,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: color.iconPrimary,
        textColor: color.textPrimary,
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: color.badgeSecondaryBg,
        textColor: color.badgeSecondaryFg,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: color.surfaceCardElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: color.borderDefault),
        ),
        textStyle: TextStyle(color: color.textPrimary, fontSize: 14),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppPalette.neutral900
              : AppPalette.neutral700,
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(color: AppPalette.white, fontSize: 12),
      ),
    );
  }
}