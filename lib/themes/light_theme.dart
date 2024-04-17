import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(16, 58, 134, 1),
  primary: const Color.fromRGBO(16, 58, 134, 1),
  secondary: const Color.fromRGBO(255, 209, 56, 1),
);

class LightTheme {
  ThemeData get theme {
    return ThemeData().copyWith(
      colorScheme: kColorScheme,
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: kColorScheme.primary,
        foregroundColor: kColorScheme.primaryContainer,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      navigationRailTheme: const NavigationRailThemeData().copyWith(
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: kColorScheme.primary),
        indicatorColor: kColorScheme.primary.withOpacity(0.8),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 10,
      ),
      dataTableTheme: const DataTableThemeData(
        dataRowColor: MaterialStatePropertyAll(
          Colors.white,
        ),
        headingRowColor: MaterialStatePropertyAll(
          Colors.white,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: kColorScheme.primary,
          focusColor: kColorScheme.primary,
          surfaceTintColor: kColorScheme.primary,
        ),
      ),
      iconTheme: const IconThemeData().copyWith(color: kColorScheme.primary),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(color: Colors.black),
        titleMedium: GoogleFonts.lato(color: Colors.black),
        titleSmall: GoogleFonts.lato(color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.onPrimary,
          padding: const EdgeInsets.all(16),
          textStyle: GoogleFonts.lato(
            color: kColorScheme.onPrimary,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          surfaceTintColor: kColorScheme.onPrimary,
          foregroundColor: kColorScheme.primary,
          textStyle: GoogleFonts.lato(
            color: kColorScheme.onPrimary,
            fontSize: 18,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
        color: kColorScheme.primary
      )
    );
  }
}
