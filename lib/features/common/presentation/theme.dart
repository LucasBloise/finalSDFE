import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Rick and Morty Inspired Design System Colors
const portalGreen =
    Color(0xFF97F049); // Bright green for portals and primary actions
const rickBlue = Color(0xFFA2D1F5); // Light blue from Rick's hair, for accents
const mortyYellow =
    Color(0xFFF3E64F); // Yellow from Morty's shirt, for highlights
const spaceDark =
    Color(0xFF201931); // Deep space color for backgrounds or dark themes
const labCoatWhite = Color(0xFFF5F5F5); // For clean, primary backgrounds
const lightGray = Color(0xFFE0E0E0); // A secondary background color
const accentPink =
    Color(0xFFE4448B); // A vibrant accent for special UI elements
const darkGreen =
    Color(0xFF448A39); // A more subdued green for text or secondary elements
const dangerRed = Color(0xFFF44336); // For errors and downvotes

// Core Theme Colors
const baseColor = labCoatWhite;
const alternativeColor = lightGray;
const brandColor = darkGreen;
const inverseColor = spaceDark;
const inverseAlternativeColor =
    Color(0xFF3a3252); // A lighter shade of spaceDark
const accentColor = mortyYellow;
const accentColorSecondary = rickBlue;
const mutedRedColor = dangerRed; // Re-purposing for consistency

// Vote Colors (Thematic)
const upvoteColor = portalGreen;
const downvoteColor = dangerRed;

// Background Colors
const lightBackgroundPrimary = labCoatWhite;
const lightBackgroundSecondary = lightGray;

// Component-specific Colors
const cardBackgroundColor = Colors.white;
const cardBorderColor = lightGray;

// Navbar Colors
const navBarBackground = Colors.white;
const navBarSelectedColor = darkGreen;
const navBarUnselectedColor = Colors.grey;

final lightTheme = ThemeData(
  primaryColor: baseColor,
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
  ).copyWith(
    surface: cardBackgroundColor,
    secondary: accentColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: brandColor,
    circularTrackColor: alternativeColor,
  ),
  extensions: [],
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
);
