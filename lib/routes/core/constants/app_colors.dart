import 'package:flutter/material.dart';

/// AppColors — Jobee Job Portal
/// Extracted from Light Mode (Image 1) & Dark Mode (Image 2) design screens.
/// All colours are grouped by purpose and mode for easy theming.
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // 01  BRAND / PRIMARY PALETTE
  //     Blue CTA buttons, logo icon, active
  //     indicators — consistent across both modes.
  // ─────────────────────────────────────────────

  /// Main brand blue — CTA buttons, logo power-icon ring, active nav dot
  static const Color primary = Color(0xFF4F7DF7);

  /// Slightly lighter brand blue — gradient end, secondary accents
  static const Color secondary = Color(0xFF6B92FF);

  /// Soft sky-blue — hover states, subtle tint fills
  static const Color accent = Color(0xFF7EA3FF);

  /// Deep royal blue — pressed button state, active badge fill
  static const Color primaryDark = Color(0xFF2F5BE8);

  /// Pale brand tint — chip backgrounds, tag pills (light mode)
  static const Color primaryLight = Color(0xFFEBF0FF);

  // ─────────────────────────────────────────────
  // 02  BACKGROUND  —  LIGHT MODE
  //     Screen 1 (splash) → 41 (filter options)
  // ─────────────────────────────────────────────

  /// Page / scaffold background — very light blue-grey
  static const Color lightBackground = Color(0xFFFFFFFF);

  /// Card, sheet, modal surface — pure white
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Secondary surface — slightly off-white for list rows, inner cards
  static const Color lightSurfaceVariant = Color(0xFFF7F8FC);

  /// Onboarding hero panel — vivid blue with white illustration overlay
  static const Color lightHeroPanelBackground = Color(0xFF4F7DF7);

  // ─────────────────────────────────────────────
  // 03  BACKGROUND  —  DARK MODE
  //     Screen 1-Dar (splash) → 41-Dar (filter)
  // ─────────────────────────────────────────────

  /// Deep navy-black scaffold — darkest layer
  static const Color darkBackground = Color(0xFF181A20);

  /// Card / bottom-sheet surface — raised dark layer
  static const Color darkSurface = Color(0xFF151929);

  /// Secondary card surface — slightly lighter dark, inner sections
  static const Color darkSurfaceVariant = Color(0xFF1E2235);

  /// Elevated surface (modals, side drawers) — lightest dark layer
  static const Color darkSurfaceElevated = Color(0xFF252A40);

  /// Onboarding hero panel dark tint — navy blue with illustration overlay
  static const Color darkHeroPanelBackground = Color(0xFF1A2140);

  /// Light border color for dark mode
  static const Color line = Color(0xFFE9E9F0);


  // ─────────────────────────────────────────────
  // 04  TEXT  —  LIGHT MODE
  // ─────────────────────────────────────────────

  /// Primary body text (headings, labels) — near-black
  static const Color textPrimary = Color(0xFF000000);

  /// Secondary / supporting text — dark grey
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// Tertiary / meta text — medium grey
  static const Color textTertiary = Color(0xFF6B7280);

  /// Placeholder / hint text — light grey
  static const Color textHint = Color(0xFF9CA3AF);

  /// Disabled text — very light grey
  static const Color textDisabled = Color(0xFFD1D5DB);

  /// Link / brand text — primary blue
  static const Color textLink = Color(0xFF4F7DF7);

  // ─────────────────────────────────────────────
  // 05  TEXT  —  DARK MODE
  // ─────────────────────────────────────────────

  /// Primary body text (headings, labels) — white
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// Secondary / supporting text — light blue-grey
  static const Color darkTextSecondary = Color(0xFFB0B8D1);

  /// Tertiary / meta text — muted grey
  static const Color darkTextTertiary = Color(0xFF6B7A99);

  /// Placeholder / hint text — dim grey
  static const Color darkTextHint = Color(0xFF4A5472);

  /// Disabled text — very dim
  static const Color darkTextDisabled = Color(0xFF2D3451);

  /// Link / brand text — same primary blue works on dark
  static const Color darkTextLink = Color(0xFF6B92FF);

  // ─────────────────────────────────────────────
  // 06  INPUT FIELDS  —  LIGHT MODE
  //     Visible in account-setup & login screens
  // ─────────────────────────────────────────────

  /// Input fill — pale grey-white
  static const Color inputBackground = Color(0xFFF5F5F8);

  static const Color inputFocusedBackground = Color(0xFFEEF4FF);

  /// Idle border — soft grey
  static const Color inputBorder = Color(0xFFFAFAFA);
  
  /// Icon text color
  static const Color inputIconText = Color(0xFF9E9E9E);

  /// Focused border — brand blue
  static const Color inputFocusedBorder = Color(0xFF6C9BFE);

  /// Error border — red
  static const Color inputErrorBorder = Color(0xFFEF4444);

  /// Text inside field — near-black
  static const Color inputText = Color(0xFF2D3748);

  /// Hint / placeholder
  static const Color inputHint = Color(0xFF9CA3AF);

  // ─────────────────────────────────────────────
  // 07  INPUT FIELDS  —  DARK MODE
  // ─────────────────────────────────────────────

  /// Input fill — deep navy
  static const Color darkInputBackground = Color(0xFF1F222A);

  static const Color darkInputFocusedBackground = Color(0xFF192131);

  /// Idle border — subtle dark blue
  static const Color darkInputBorder = Color(0xFF1F222A);

  /// Focused border — brand blue
  static const Color darkInputFocusedBorder = Color(0xFF192131);

  /// Error border
  static const Color darkInputErrorBorder = Color(0xFFEF4444);

  /// Text inside field
  static const Color darkInputText = Color(0xFFE8EAF6);

  /// Hint / placeholder
  static const Color darkInputHint = Color(0xFF4A5472);

  // ─────────────────────────────────────────────
  // 08  BUTTONS
  //     Extracted from CTA rows across all screens
  // ─────────────────────────────────────────────

  /// Primary fill — brand blue
  static const Color buttonPrimary = Color(0xFF4F7DF7);

  /// Primary pressed — deeper blue
  static const Color buttonPressed = Color(0xFF2F5BE8);

  /// Primary disabled — washed-out blue
  static const Color buttonDisabled = Color(0xFFC7D2FE);

  /// Primary text — white
  static const Color buttonPrimaryText = Color(0xFFFFFFFF);

  /// Secondary / outlined button border (light)
  static const Color buttonOutlineBorder = Color(0xFF4F7DF7);

  /// Secondary / outlined button text (light)
  static const Color buttonOutlineText = Color(0xFF4F7DF7);

  /// Ghost / text-only button
  static const Color buttonGhostText = Color(0xFF6B7280);

  // ─────────────────────────────────────────────
  // 09  ICONS
  // ─────────────────────────────────────────────

  /// Active / brand icon — blue
  static const Color iconPrimary = Color(0xFF4F7DF7);

  /// Default icon (light mode) — slate
  static const Color iconSecondary = Color(0xFF94A3B8);

  /// Default icon (dark mode) — muted blue-grey
  static const Color darkIconSecondary = Color(0xFF6B7A99);

  /// Disabled icon
  static const Color iconDisabled = Color(0xFFD1D5DB);

  /// Icon on coloured surface (e.g. white on blue card)
  static const Color iconOnColor = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────
  // 10  CHECKBOX & RADIO
  //     Profile setup expertise screen (16_Li, 16_Dar)
  // ─────────────────────────────────────────────

  /// Checked fill — brand blue
  static const Color checkboxActive = Color(0xFF4F7DF7);

  /// Checked icon colour — white tick
  static const Color checkboxCheck = Color(0xFFFFFFFF);

  /// Unchecked border (light)
  static const Color checkboxBorder = Color(0xFFCBD5E0);

  /// Unchecked border (dark)
  static const Color darkCheckboxBorder = Color(0xFF3A4260);

  // ─────────────────────────────────────────────
  // 11  CARDS & CONTAINERS
  // ─────────────────────────────────────────────

  /// Card background (light)
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Card border (light) — hairline grey
  static const Color cardBorder = Color(0xFFE5E7EB);

  /// Card background (dark)
  static const Color darkCardBackground = Color(0xFF1E2235);

  /// Card border (dark) — subtle navy
  static const Color darkCardBorder = Color(0xFF2D3555);

  /// Section / row divider (light)
  static const Color divider = Color(0xFFF1F5F9);

  /// Section / row divider (dark)
  static const Color darkDivider = Color(0xFF252A40);

  // ─────────────────────────────────────────────
  // 12  BOTTOM NAVIGATION BAR
  //     Home & Action Menu screens (29–41)
  // ─────────────────────────────────────────────

  /// Nav bar background (light) — white
  static const Color navBarBackground = Color(0xFFFFFFFF);

  /// Nav bar background (dark) — deep navy
  static const Color darkNavBarBackground = Color(0xFF151929);

  /// Active tab icon & label — brand blue
  static const Color navBarActive = Color(0xFF4F7DF7);

  /// Inactive tab icon & label (light)
  static const Color navBarInactive = Color(0xFFB0B8C1);

  /// Inactive tab icon & label (dark)
  static const Color darkNavBarInactive = Color(0xFF4A5472);

  /// Nav bar top border / shadow (light)
  static const Color navBarBorder = Color(0xFFE8ECF4);

  // ─────────────────────────────────────────────
  // 13  NOTIFICATION / BADGE CHIPS
  //     Notification screens 31–37 (light & dark)
  // ─────────────────────────────────────────────

  /// Unread badge background — brand blue
  static const Color badgeBackground = Color(0xFF4F7DF7);

  /// Badge text — white
  static const Color badgeText = Color(0xFFFFFFFF);

  /// "New" green badge
  static const Color badgeNew = Color(0xFF22C55E);

  /// Alert / warning amber badge
  static const Color badgeWarning = Color(0xFFF59E0B);

  // ─────────────────────────────────────────────
  // 14  JOB TYPE SELECTOR CHIPS
  //     Choose Job Type screen (15_Li / 15_Dar)
  // ─────────────────────────────────────────────

  /// Selected chip — brand blue fill
  static const Color chipSelected = Color(0xFF4F7DF7);

  /// Selected chip text — white
  static const Color chipSelectedText = Color(0xFFFFFFFF);

  /// Unselected chip fill (light) — pale blue tint
  static const Color chipUnselected = Color(0xFFEBF0FF);

  /// Unselected chip fill (dark) — dark blue tint
  static const Color darkChipUnselected = Color(0xFF1E2745);

  /// Unselected chip text (light)
  static const Color chipUnselectedText = Color(0xFF4F7DF7);

  /// Unselected chip text (dark)
  static const Color darkChipUnselectedText = Color(0xFF6B92FF);

  // ─────────────────────────────────────────────
  // 15  ONBOARDING  (Splash / Welcome / Hero screens 1–6)
  // ─────────────────────────────────────────────

  /// Splash screen background — deep navy (dark mode) / white (light mode)
  static const Color splashBackgroundDark = Color(0xFF0B0E1A);
  static const Color splashBackgroundLight = Color(0xFFFFFFFF);

  /// Onboarding page-indicator dot — active
  static const Color pageIndicatorActive = Color(0xFF4F7DF7);

  /// Onboarding page-indicator dot — inactive (light)
  static const Color pageIndicatorInactive = Color(0xFFCBD5E0);

  /// Onboarding page-indicator dot — inactive (dark)
  static const Color darkPageIndicatorInactive = Color(0xFF2D3555);

  // ─────────────────────────────────────────────
  // 16  PIN / OTP ENTRY
  //     PIN screens (19_Li / 19–20_Dar) &
  //     OTP screens (25–26_Li / 25–26_Dar)
  // ─────────────────────────────────────────────

  /// PIN dot — filled (light)
  static const Color pinDotFilled = Color(0xFF4F7DF7);

  /// PIN dot — empty (light)
  static const Color pinDotEmpty = Color(0xFFE2E8F0);

  /// PIN dot — filled (dark)
  static const Color darkPinDotFilled = Color(0xFF4F7DF7);

  /// PIN dot — empty (dark)
  static const Color darkPinDotEmpty = Color(0xFF252A40);

  /// PIN keypad background (light)
  static const Color pinKeypadBackground = Color(0xFFF7F8FC);

  /// PIN keypad background (dark)
  static const Color darkPinKeypadBackground = Color(0xFF1E2235);

  /// PIN keypad text (light)
  static const Color pinKeypadText = Color(0xFF1A1F36);

  /// PIN keypad text (dark)
  static const Color darkPinKeypadText = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────
  // 17  BIOMETRIC (Fingerprint / Face ID)
  //     Screens 21–23_Dar
  // ─────────────────────────────────────────────

  /// Fingerprint scan ring — active blue
  static const Color biometricRingActive = Color(0xFF4F7DF7);

  /// Fingerprint scan ring — idle (dark)
  static const Color darkBiometricRingIdle = Color(0xFF252A40);

  /// Face recognition progress arc — brand blue
  static const Color faceIdProgressArc = Color(0xFF4F7DF7);

  /// Face recognition success — green
  static const Color faceIdSuccess = Color(0xFF22C55E);

  // ─────────────────────────────────────────────
  // 18  SUCCESS / CONGRATULATIONS OVERLAY
  //     Screen 28_Li / 28_Dar
  // ─────────────────────────────────────────────

  /// Success circle fill — brand blue (matches illustration)
  static const Color successCircle = Color(0xFF4F7DF7);

  /// Success icon — white check
  static const Color successIcon = Color(0xFFFFFFFF);

  /// Confetti accent 1 — bright yellow
  static const Color confettiYellow = Color(0xFFFBBC04);

  /// Confetti accent 2 — coral / orange-red
  static const Color confettiCoral = Color(0xFFFF6B6B);

  /// Confetti accent 3 — lime green
  static const Color confettiGreen = Color(0xFF34D399);

  // ─────────────────────────────────────────────
  // 19  STATUS COLOURS
  // ─────────────────────────────────────────────

  /// Success — emerald green
  static const Color success = Color(0xFF22C55E);

  /// Success background tint (light)
  static const Color successBackground = Color(0xFFECFDF5);

  /// Warning — amber
  static const Color warning = Color(0xFFF59E0B);

  /// Warning background tint (light)
  static const Color warningBackground = Color(0xFFFFFBEB);

  /// Error / destructive — red
  static const Color error = Color(0xFFEF4444);

  /// Error background tint (light)
  static const Color errorBackground = Color(0xFFFEF2F2);

  /// Info — secondary blue
  static const Color info = Color(0xFF6B92FF);

  /// Info background tint (light)
  static const Color infoBackground = Color(0xFFEBF0FF);

  // ─────────────────────────────────────────────
  // 20  SHADOWS & ELEVATION
  // ─────────────────────────────────────────────

  /// Generic soft shadow — 8% black
  static const Color shadowLight = Color(0x14000000);

  /// Brand-tinted shadow — 10% primary blue
  static const Color shadowBlue = Color(0x1A4F7DF7);

  /// Dark mode card shadow — 30% deep black
  static const Color shadowDark = Color(0x4D000000);

  // ─────────────────────────────────────────────
  // 21  MISC / UTILITY
  // ─────────────────────────────────────────────

  /// Transparent / no colour
  static const Color transparent = Colors.transparent;

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Overlay scrim (modal backdrop) — 60% black
  static const Color scrim = Color(0x99000000);

  /// Skeleton / shimmer base (light)
  static const Color shimmerBase = Color(0xFFE2E8F0);

  /// Skeleton / shimmer highlight (light)
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  /// Skeleton / shimmer base (dark)
  static const Color darkShimmerBase = Color(0xFF252A40);

  /// Skeleton / shimmer highlight (dark)
  static const Color darkShimmerHighlight = Color(0xFF2D3555);
}
