import 'package:flutter/material.dart';

abstract final class AppPalette {
   static const Color primary        = Color(0xFF1565C0);
   static const Color primaryLight   = Color(0xFF5E92F3);
   static const Color primaryLighter = Color(0xFFBBDEFB);
   static const Color primaryDark    = Color(0xFF003C8F);
   static const Color primarySurface = Color(0xFFE3F2FD);

   static const Color secondary        = Color(0xFFEF5350);
   static const Color secondaryLight   = Color(0xFFFF867C);
   static const Color secondaryLighter = Color(0xFFFFCDD2);
   static const Color secondaryDark    = Color(0xFFB61827);
   static const Color secondarySurface = Color(0xFFFFF0F0);

   static const Color tertiary        = Color(0xFF5C6BC0);
   static const Color tertiaryLight   = Color(0xFF8E99F3);
   static const Color tertiaryLighter = Color(0xFFE8EAF6);
   static const Color tertiaryDark    = Color(0xFF26418F);
   static const Color tertiarySurface = Color(0xFFEEF0FB);

   static const Color neutral950 = Color(0xFF0F0F1A);
   static const Color neutral900 = Color(0xFF1A1A2E);
   static const Color neutral800 = Color(0xFF22223B);
   static const Color neutral750 = Color(0xFF2A2A42);
   static const Color neutral700 = Color(0xFF3E3E5C);
   static const Color neutral600 = Color(0xFF5A5A7A);
   static const Color neutral500 = Color(0xFF74788D);
   static const Color neutral400 = Color(0xFF9E9EBF);
   static const Color neutral300 = Color(0xFFC4C6D8);
   static const Color neutral200 = Color(0xFFE0E2ED);
   static const Color neutral100 = Color(0xFFF0F1F7);
   static const Color neutral50  = Color(0xFFF8F8FC);
   static const Color white      = Color(0xFFFFFFFF);

   static const Color errorBase         = Color(0xFFD32F2F);
   static const Color errorLight        = Color(0xFFFFCDD2);
   static const Color errorDark         = Color(0xFFFF6659);
   static const Color errorSurface      = Color(0xFFFFF0F0);
   static const Color errorSurfaceDark  = Color(0xFF2C1010);

   static const Color successBase        = Color(0xFF2E7D32);
   static const Color successLight       = Color(0xFFC8E6C9);
   static const Color successDark        = Color(0xFF66BB6A);
   static const Color successSurface     = Color(0xFFF1F8F1);
   static const Color successSurfaceDark = Color(0xFF0D2B0E);

   static const Color warningBase        = Color(0xFFF57F17);
   static const Color warningLight       = Color(0xFFFFE082);
   static const Color warningDark        = Color(0xFFFFCA28);
   static const Color warningSurface     = Color(0xFFFFFBEF);
   static const Color warningSurfaceDark = Color(0xFF2B1F05);

   static const List<Color> gradientPrimary   = [primary, primaryLight];
   static const List<Color> gradientSecondary = [secondary, secondaryLight];
   static const List<Color> gradientBlend     = [primary, tertiary, secondary];
   static const List<Color> gradientSoftLight = [primarySurface, secondarySurface];
   static const List<Color> gradientSoftDark  = [Color(0xFF1A2A3E), Color(0xFF2E1A1A)];
}

class AppColorTokens {
   const AppColorTokens._({
      required this.scaffoldBackground,
      required this.backgroundAlt,
      required this.surfaceCard,
      required this.surfaceCardElevated,
      required this.surfaceInput,
      required this.surfacePrimary,
      required this.surfaceSecondary,
      required this.surfaceTertiary,
      required this.surfaceOverlay,
      required this.appBarBackground,
      required this.appBarForeground,
      required this.appBarShadow,
      required this.bottomNavBackground,
      required this.bottomNavSelected,
      required this.bottomNavUnselected,
      required this.bottomNavIndicator,
      required this.drawerBackground,
      required this.drawerHeaderBg,
      required this.drawerHeaderFg,
      required this.drawerItemActiveBg,
      required this.drawerItemActiveText,
      required this.drawerItemText,
      required this.tabBarSelected,
      required this.tabBarUnselected,
      required this.tabBarIndicator,
      required this.textPrimary,
      required this.textSecondary,
      required this.textDisabled,
      required this.textHint,
      required this.textInverse,
      required this.textOnPrimary,
      required this.textOnSecondary,
      required this.textLink,
      required this.textLinkVisited,
      required this.textHighlight,
      required this.textError,
      required this.textSuccess,
      required this.textWarning,
      required this.iconPrimary,
      required this.iconSecondary,
      required this.iconOnPrimary,
      required this.iconOnSecondary,
      required this.iconActive,
      required this.iconAccent,
      required this.iconDisabled,
      required this.iconError,
      required this.iconSuccess,
      required this.iconWarning,
      required this.buttonPrimaryBg,
      required this.buttonPrimaryFg,
      required this.buttonPrimaryHover,
      required this.buttonPrimaryDisabled,
      required this.buttonSecondaryBg,
      required this.buttonSecondaryFg,
      required this.buttonSecondaryHover,
      required this.buttonOutlineBorder,
      required this.buttonOutlineFg,
      required this.buttonTextFg,
      required this.buttonDangerBg,
      required this.buttonDangerFg,
      required this.cardBackground,
      required this.cardBorder,
      required this.cardPrimaryBg,
      required this.cardPrimaryBorder,
      required this.cardSecondaryBg,
      required this.cardSecondaryBorder,
      required this.cardTertiaryBg,
      required this.cardTertiaryBorder,
      required this.inputBackground,
      required this.inputBorder,
      required this.inputBorderFocused,
      required this.inputBorderError,
      required this.inputLabel,
      required this.inputHint,
      required this.inputText,
      required this.inputCursor,
      required this.inputSelectionFill,
      required this.divider,
      required this.dividerSubtle,
      required this.borderDefault,
      required this.borderFocus,
      required this.borderStrong,
      required this.errorDefault,
      required this.errorLight,
      required this.errorSurface,
      required this.successDefault,
      required this.successLight,
      required this.successSurface,
      required this.warningDefault,
      required this.warningLight,
      required this.warningSurface,
      required this.infoDefault,
      required this.infoLight,
      required this.infoSurface,
      required this.statusOnline,
      required this.statusOffline,
      required this.statusBusy,
      required this.statusAway,
      required this.badgePrimaryBg,
      required this.badgePrimaryFg,
      required this.badgeSecondaryBg,
      required this.badgeSecondaryFg,
      required this.badgeTertiaryBg,
      required this.badgeTertiaryFg,
      required this.badgeNeutralBg,
      required this.badgeNeutralFg,
      required this.badgeSuccessBg,
      required this.badgeSuccessFg,
      required this.badgeErrorBg,
      required this.badgeErrorFg,
      required this.badgeWarningBg,
      required this.badgeWarningFg,
      required this.shimmerBase,
      required this.shimmerHighlight,
      required this.scrim,
      required this.ripple,
      required this.gradientPrimary,
      required this.gradientSecondary,
      required this.gradientBlend,
      required this.gradientSoft,
   });

   final Color scaffoldBackground;
   final Color backgroundAlt;
   final Color surfaceCard;
   final Color surfaceCardElevated;
   final Color surfaceInput;
   final Color surfacePrimary;
   final Color surfaceSecondary;
   final Color surfaceTertiary;
   final Color surfaceOverlay;

   final Color appBarBackground;
   final Color appBarForeground;
   final Color appBarShadow;
   final Color bottomNavBackground;
   final Color bottomNavSelected;
   final Color bottomNavUnselected;
   final Color bottomNavIndicator;
   final Color drawerBackground;
   final Color drawerHeaderBg;
   final Color drawerHeaderFg;
   final Color drawerItemActiveBg;
   final Color drawerItemActiveText;
   final Color drawerItemText;
   final Color tabBarSelected;
   final Color tabBarUnselected;
   final Color tabBarIndicator;

   final Color textPrimary;
   final Color textSecondary;
   final Color textDisabled;
   final Color textHint;
   final Color textInverse;
   final Color textOnPrimary;
   final Color textOnSecondary;
   final Color textLink;
   final Color textLinkVisited;
   final Color textHighlight;
   final Color textError;
   final Color textSuccess;
   final Color textWarning;

   final Color iconPrimary;
   final Color iconSecondary;
   final Color iconOnPrimary;
   final Color iconOnSecondary;
   final Color iconActive;
   final Color iconAccent;
   final Color iconDisabled;
   final Color iconError;
   final Color iconSuccess;
   final Color iconWarning;

   final Color buttonPrimaryBg;
   final Color buttonPrimaryFg;
   final Color buttonPrimaryHover;
   final Color buttonPrimaryDisabled;
   final Color buttonSecondaryBg;
   final Color buttonSecondaryFg;
   final Color buttonSecondaryHover;
   final Color buttonOutlineBorder;
   final Color buttonOutlineFg;
   final Color buttonTextFg;
   final Color buttonDangerBg;
   final Color buttonDangerFg;

   final Color cardBackground;
   final Color cardBorder;
   final Color cardPrimaryBg;
   final Color cardPrimaryBorder;
   final Color cardSecondaryBg;
   final Color cardSecondaryBorder;
   final Color cardTertiaryBg;
   final Color cardTertiaryBorder;

   final Color inputBackground;
   final Color inputBorder;
   final Color inputBorderFocused;
   final Color inputBorderError;
   final Color inputLabel;
   final Color inputHint;
   final Color inputText;
   final Color inputCursor;
   final Color inputSelectionFill;

   final Color divider;
   final Color dividerSubtle;
   final Color borderDefault;
   final Color borderFocus;
   final Color borderStrong;

   final Color errorDefault;
   final Color errorLight;
   final Color errorSurface;
   final Color successDefault;
   final Color successLight;
   final Color successSurface;
   final Color warningDefault;
   final Color warningLight;
   final Color warningSurface;
   final Color infoDefault;
   final Color infoLight;
   final Color infoSurface;

   final Color statusOnline;
   final Color statusOffline;
   final Color statusBusy;
   final Color statusAway;

   final Color badgePrimaryBg;
   final Color badgePrimaryFg;
   final Color badgeSecondaryBg;
   final Color badgeSecondaryFg;
   final Color badgeTertiaryBg;
   final Color badgeTertiaryFg;
   final Color badgeNeutralBg;
   final Color badgeNeutralFg;
   final Color badgeSuccessBg;
   final Color badgeSuccessFg;
   final Color badgeErrorBg;
   final Color badgeErrorFg;
   final Color badgeWarningBg;
   final Color badgeWarningFg;

   final Color shimmerBase;
   final Color shimmerHighlight;

   final Color scrim;
   final Color ripple;

   final List<Color> gradientPrimary;
   final List<Color> gradientSecondary;
   final List<Color> gradientBlend;
   final List<Color> gradientSoft;
}

const AppColorTokens _lightTokens = AppColorTokens._(
   scaffoldBackground   : AppPalette.white,
   backgroundAlt        : AppPalette.neutral50,
   surfaceCard          : AppPalette.white,
   surfaceCardElevated  : AppPalette.white,
   surfaceInput         : AppPalette.neutral100,
   surfacePrimary       : AppPalette.primarySurface,
   surfaceSecondary     : AppPalette.secondarySurface,
   surfaceTertiary      : AppPalette.tertiarySurface,
   surfaceOverlay       : AppPalette.neutral900,

   appBarBackground     : AppPalette.primary,
   appBarForeground     : AppPalette.white,
   appBarShadow         : AppPalette.primaryDark,
   bottomNavBackground  : AppPalette.white,
   bottomNavSelected    : AppPalette.primary,
   bottomNavUnselected  : AppPalette.neutral500,
   bottomNavIndicator   : AppPalette.primaryLighter,
   drawerBackground     : AppPalette.white,
   drawerHeaderBg       : AppPalette.primary,
   drawerHeaderFg       : AppPalette.white,
   drawerItemActiveBg   : AppPalette.primarySurface,
   drawerItemActiveText : AppPalette.primary,
   drawerItemText       : AppPalette.neutral700,
   tabBarSelected       : AppPalette.primary,
   tabBarUnselected     : AppPalette.neutral500,
   tabBarIndicator      : AppPalette.secondary,

   textPrimary          : AppPalette.neutral900,
   textSecondary        : AppPalette.neutral500,
   textDisabled         : AppPalette.neutral400,
   textHint             : AppPalette.neutral400,
   textInverse          : AppPalette.white,
   textOnPrimary        : AppPalette.white,
   textOnSecondary      : AppPalette.white,
   textLink             : AppPalette.primary,
   textLinkVisited      : AppPalette.primaryDark,
   textHighlight        : AppPalette.secondary,
   textError            : AppPalette.errorBase,
   textSuccess          : AppPalette.successBase,
   textWarning          : AppPalette.warningBase,

   iconPrimary          : AppPalette.neutral700,
   iconSecondary        : AppPalette.neutral400,
   iconOnPrimary        : AppPalette.white,
   iconOnSecondary      : AppPalette.white,
   iconActive           : AppPalette.primary,
   iconAccent           : AppPalette.secondary,
   iconDisabled         : AppPalette.neutral300,
   iconError            : AppPalette.errorBase,
   iconSuccess          : AppPalette.successBase,
   iconWarning          : AppPalette.warningBase,

   buttonPrimaryBg      : AppPalette.primary,
   buttonPrimaryFg      : AppPalette.white,
   buttonPrimaryHover   : AppPalette.primaryDark,
   buttonPrimaryDisabled: AppPalette.neutral300,
   buttonSecondaryBg    : AppPalette.secondary,
   buttonSecondaryFg    : AppPalette.white,
   buttonSecondaryHover : AppPalette.secondaryDark,
   buttonOutlineBorder  : AppPalette.primary,
   buttonOutlineFg      : AppPalette.primary,
   buttonTextFg         : AppPalette.primary,
   buttonDangerBg       : AppPalette.secondary,
   buttonDangerFg       : AppPalette.white,

   cardBackground       : AppPalette.white,
   cardBorder           : AppPalette.neutral200,
   cardPrimaryBg        : AppPalette.primarySurface,
   cardPrimaryBorder    : AppPalette.primaryLighter,
   cardSecondaryBg      : AppPalette.secondarySurface,
   cardSecondaryBorder  : AppPalette.secondaryLighter,
   cardTertiaryBg       : AppPalette.tertiarySurface,
   cardTertiaryBorder   : AppPalette.tertiaryLighter,

   inputBackground      : AppPalette.neutral100,
   inputBorder          : AppPalette.neutral300,
   inputBorderFocused   : AppPalette.primary,
   inputBorderError     : AppPalette.errorBase,
   inputLabel           : AppPalette.neutral600,
   inputHint            : AppPalette.neutral400,
   inputText            : AppPalette.neutral900,
   inputCursor          : AppPalette.primary,
   inputSelectionFill   : AppPalette.primaryLighter,

   divider              : AppPalette.neutral200,
   dividerSubtle        : AppPalette.neutral100,
   borderDefault        : AppPalette.neutral200,
   borderFocus          : AppPalette.primary,
   borderStrong         : AppPalette.neutral400,

   errorDefault         : AppPalette.errorBase,
   errorLight           : AppPalette.errorLight,
   errorSurface         : AppPalette.errorSurface,
   successDefault       : AppPalette.successBase,
   successLight         : AppPalette.successLight,
   successSurface       : AppPalette.successSurface,
   warningDefault       : AppPalette.warningBase,
   warningLight         : AppPalette.warningLight,
   warningSurface       : AppPalette.warningSurface,
   infoDefault          : AppPalette.primaryLight,
   infoLight            : AppPalette.primaryLighter,
   infoSurface          : AppPalette.primarySurface,

   statusOnline         : AppPalette.successBase,
   statusOffline        : AppPalette.neutral400,
   statusBusy           : AppPalette.secondary,
   statusAway           : AppPalette.warningBase,

   badgePrimaryBg       : AppPalette.primary,
   badgePrimaryFg       : AppPalette.white,
   badgeSecondaryBg     : AppPalette.secondary,
   badgeSecondaryFg     : AppPalette.white,
   badgeTertiaryBg      : AppPalette.tertiary,
   badgeTertiaryFg      : AppPalette.white,
   badgeNeutralBg       : AppPalette.neutral200,
   badgeNeutralFg       : AppPalette.neutral700,
   badgeSuccessBg       : AppPalette.successLight,
   badgeSuccessFg       : AppPalette.successBase,
   badgeErrorBg         : AppPalette.errorLight,
   badgeErrorFg         : AppPalette.errorBase,
   badgeWarningBg       : AppPalette.warningLight,
   badgeWarningFg       : AppPalette.warningBase,

   shimmerBase          : AppPalette.neutral100,
   shimmerHighlight     : AppPalette.neutral50,

   scrim                : Color(0x801A1A2E),
   ripple               : Color(0x141565C0),

   gradientPrimary      : AppPalette.gradientPrimary,
   gradientSecondary    : AppPalette.gradientSecondary,
   gradientBlend        : AppPalette.gradientBlend,
   gradientSoft         : AppPalette.gradientSoftLight,
);

const AppColorTokens _darkTokens = AppColorTokens._(
   scaffoldBackground   : AppPalette.neutral950,
   backgroundAlt        : AppPalette.neutral900,
   surfaceCard          : AppPalette.neutral800,
   surfaceCardElevated  : AppPalette.neutral750,
   surfaceInput         : AppPalette.neutral700,
   surfacePrimary       : Color(0xFF0D1F35),
   surfaceSecondary     : Color(0xFF2C1010),
   surfaceTertiary      : Color(0xFF141429),
   surfaceOverlay       : AppPalette.neutral950,

   appBarBackground     : AppPalette.neutral900,
   appBarForeground     : AppPalette.white,
   appBarShadow         : AppPalette.neutral950,
   bottomNavBackground  : AppPalette.neutral800,
   bottomNavSelected    : AppPalette.primaryLight,
   bottomNavUnselected  : AppPalette.neutral500,
   bottomNavIndicator   : Color(0xFF1A3A5C),
   drawerBackground     : AppPalette.neutral800,
   drawerHeaderBg       : AppPalette.primaryDark,
   drawerHeaderFg       : AppPalette.white,
   drawerItemActiveBg   : Color(0xFF0D1F35),
   drawerItemActiveText : AppPalette.primaryLight,
   drawerItemText       : AppPalette.neutral300,
   tabBarSelected       : AppPalette.primaryLight,
   tabBarUnselected     : AppPalette.neutral500,
   tabBarIndicator      : AppPalette.secondaryLight,

   textPrimary          : Color(0xFFECECF4),
   textSecondary        : AppPalette.neutral400,
   textDisabled         : AppPalette.neutral600,
   textHint             : AppPalette.neutral600,
   textInverse          : AppPalette.neutral900,
   textOnPrimary        : AppPalette.white,
   textOnSecondary      : AppPalette.white,
   textLink             : AppPalette.primaryLight,
   textLinkVisited      : AppPalette.tertiaryLight,
   textHighlight        : AppPalette.secondaryLight,
   textError            : AppPalette.errorDark,
   textSuccess          : AppPalette.successDark,
   textWarning          : AppPalette.warningDark,

   iconPrimary          : AppPalette.neutral300,
   iconSecondary        : AppPalette.neutral600,
   iconOnPrimary        : AppPalette.white,
   iconOnSecondary      : AppPalette.white,
   iconActive           : AppPalette.primaryLight,
   iconAccent           : AppPalette.secondaryLight,
   iconDisabled         : AppPalette.neutral700,
   iconError            : AppPalette.errorDark,
   iconSuccess          : AppPalette.successDark,
   iconWarning          : AppPalette.warningDark,

   buttonPrimaryBg      : AppPalette.primaryLight,
   buttonPrimaryFg      : AppPalette.white,
   buttonPrimaryHover   : AppPalette.primary,
   buttonPrimaryDisabled: AppPalette.neutral700,
   buttonSecondaryBg    : AppPalette.secondaryLight,
   buttonSecondaryFg    : AppPalette.white,
   buttonSecondaryHover : AppPalette.secondary,
   buttonOutlineBorder  : AppPalette.primaryLight,
   buttonOutlineFg      : AppPalette.primaryLight,
   buttonTextFg         : AppPalette.primaryLight,
   buttonDangerBg       : AppPalette.secondaryLight,
   buttonDangerFg       : AppPalette.white,

   cardBackground       : AppPalette.neutral800,
   cardBorder           : AppPalette.neutral700,
   cardPrimaryBg        : Color(0xFF0D1F35),
   cardPrimaryBorder    : Color(0xFF1A3A5C),
   cardSecondaryBg      : Color(0xFF2C1010),
   cardSecondaryBorder  : Color(0xFF4A1A1A),
   cardTertiaryBg       : Color(0xFF141429),
   cardTertiaryBorder   : Color(0xFF2A2A4A),

   inputBackground      : AppPalette.neutral750,
   inputBorder          : AppPalette.neutral700,
   inputBorderFocused   : AppPalette.primaryLight,
   inputBorderError     : AppPalette.errorDark,
   inputLabel           : AppPalette.neutral400,
   inputHint            : AppPalette.neutral600,
   inputText            : Color(0xFFECECF4),
   inputCursor          : AppPalette.primaryLight,
   inputSelectionFill   : Color(0xFF1A3A5C),

   divider              : AppPalette.neutral700,
   dividerSubtle        : AppPalette.neutral800,
   borderDefault        : AppPalette.neutral700,
   borderFocus          : AppPalette.primaryLight,
   borderStrong         : AppPalette.neutral600,

   errorDefault         : AppPalette.errorDark,
   errorLight           : Color(0xFF4A1A1A),
   errorSurface         : AppPalette.errorSurfaceDark,
   successDefault       : AppPalette.successDark,
   successLight         : Color(0xFF0D2B0E),
   successSurface       : AppPalette.successSurfaceDark,
   warningDefault       : AppPalette.warningDark,
   warningLight         : Color(0xFF2B1F05),
   warningSurface       : AppPalette.warningSurfaceDark,
   infoDefault          : AppPalette.primaryLight,
   infoLight            : Color(0xFF1A3A5C),
   infoSurface          : Color(0xFF0D1F35),

   statusOnline         : AppPalette.successDark,
   statusOffline        : AppPalette.neutral600,
   statusBusy           : AppPalette.secondaryLight,
   statusAway           : AppPalette.warningDark,

   badgePrimaryBg       : Color(0xFF1A3A5C),
   badgePrimaryFg       : AppPalette.primaryLight,
   badgeSecondaryBg     : Color(0xFF4A1A1A),
   badgeSecondaryFg     : AppPalette.secondaryLight,
   badgeTertiaryBg      : Color(0xFF2A2A4A),
   badgeTertiaryFg      : AppPalette.tertiaryLight,
   badgeNeutralBg       : AppPalette.neutral700,
   badgeNeutralFg       : AppPalette.neutral300,
   badgeSuccessBg       : Color(0xFF0D2B0E),
   badgeSuccessFg       : AppPalette.successDark,
   badgeErrorBg         : Color(0xFF2C1010),
   badgeErrorFg         : AppPalette.errorDark,
   badgeWarningBg       : Color(0xFF2B1F05),
   badgeWarningFg       : AppPalette.warningDark,

   shimmerBase          : AppPalette.neutral750,
   shimmerHighlight     : AppPalette.neutral700,

   scrim                : Color(0xCC0F0F1A),
   ripple               : Color(0x1AFFFFFF),

   gradientPrimary      : [AppPalette.primaryDark, AppPalette.primary],
   gradientSecondary    : [AppPalette.secondaryDark, AppPalette.secondary],
   gradientBlend        : [AppPalette.primaryDark, AppPalette.tertiaryDark, AppPalette.secondaryDark],
   gradientSoft         : AppPalette.gradientSoftDark,
);

class AppColor {
   AppColor._();

   static AppColorTokens of(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return isDark ? _darkTokens : _lightTokens;
   }

   static AppColorTokens get light => _lightTokens;
   static AppColorTokens get dark => _darkTokens;

   static const Color primary          = AppPalette.primary;
   static const Color primaryLight     = AppPalette.primaryLight;
   static const Color primaryLighter   = AppPalette.primaryLighter;
   static const Color primaryDark      = AppPalette.primaryDark;
   static const Color primarySurface   = AppPalette.primarySurface;

   static const Color secondary        = AppPalette.secondary;
   static const Color secondaryLight   = AppPalette.secondaryLight;
   static const Color secondaryLighter = AppPalette.secondaryLighter;
   static const Color secondaryDark    = AppPalette.secondaryDark;
   static const Color secondarySurface = AppPalette.secondarySurface;

   static const Color tertiary         = AppPalette.tertiary;
   static const Color tertiaryLight    = AppPalette.tertiaryLight;
   static const Color tertiaryLighter  = AppPalette.tertiaryLighter;
   static const Color tertiaryDark     = AppPalette.tertiaryDark;
   static const Color tertiarySurface  = AppPalette.tertiarySurface;

   static const Color white            = AppPalette.white;
}