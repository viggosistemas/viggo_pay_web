import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorSchemeDark = ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(0, 0, 0, 1),
  primary: const Color.fromRGBO(0, 0, 0, 1),
  secondary: const Color.fromRGBO(255, 209, 56, 1),
  brightness: Brightness.dark,
  onPrimary: const Color.fromRGBO(255, 255, 255, 1),
);

class DarkTheme {
  ThemeData get theme {
    return ThemeData.dark().copyWith(
      checkboxTheme: const CheckboxThemeData().copyWith(
        checkColor: const MaterialStatePropertyAll(Colors.white),
        // fillColor: const MaterialStatePropertyAll(Colors.black),
        mouseCursor: const MaterialStatePropertyAll(MouseCursor.defer),
        overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.8)),
        side: BorderSide(color: kColorSchemeDark.primary),
      ),
      disabledColor: Colors.grey,
      hintColor: Colors.white,
      highlightColor: Colors.black,
      focusColor: Colors.black,
      hoverColor: Colors.black,
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        focusColor: Colors.black,
        fillColor: Colors.black,
        outlineBorder: BorderSide(color: Colors.black.withOpacity(0.8)),
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.8))),
        errorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        hoverColor: Colors.black,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.8))),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
      ),
      colorScheme: kColorSchemeDark,
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: kColorSchemeDark.secondary.withOpacity(0.8),
        foregroundColor: kColorSchemeDark.onPrimaryContainer,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      navigationRailTheme: const NavigationRailThemeData().copyWith(
        selectedIconTheme: IconThemeData(color: kColorSchemeDark.secondary),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        // backgroundColor: kColorSchemeDark.secondary.withOpacity(0.8),
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.8),
        surfaceTintColor: Colors.white.withOpacity(0.8),
        shadowColor: Colors.black,
        elevation: 10,
      ),
      dataTableTheme: DataTableThemeData(
        dataRowColor: MaterialStatePropertyAll(
          Colors.white.withOpacity(0.8),
        ),
        headingRowColor: MaterialStatePropertyAll(
          Colors.white.withOpacity(0.8),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData().copyWith(
        color: kColorSchemeDark.primary,
        iconColor: kColorSchemeDark.onPrimary,
        surfaceTintColor: kColorSchemeDark.onPrimary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData()
          .copyWith(color: kColorSchemeDark.onPrimary),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll(
            kColorSchemeDark.onPrimary,
          ),
          surfaceTintColor: MaterialStatePropertyAll(
            kColorSchemeDark.onPrimary,
          ),
          shadowColor: MaterialStatePropertyAll(
            kColorSchemeDark.onPrimary,
          ),
        ),
        textStyle: const TextStyle(color: Colors.white),
        inputDecorationTheme: const InputDecorationTheme().copyWith(
          fillColor: kColorSchemeDark.onPrimary,
          focusColor: kColorSchemeDark.onPrimary,
          hoverColor: kColorSchemeDark.onPrimary,
        ),
      ),
      chipTheme: const ChipThemeData().copyWith(
        backgroundColor: kColorSchemeDark.onPrimary,
        iconTheme: const IconThemeData().copyWith(
          color: kColorSchemeDark.onPrimary,
        ),
        color: MaterialStatePropertyAll(
          kColorSchemeDark.onPrimary,
        ),
      ),
      buttonTheme: const ButtonThemeData().copyWith(
        colorScheme: kColorSchemeDark,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(),
        titleMedium: GoogleFonts.lato(),
        titleSmall: GoogleFonts.lato(),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: kColorSchemeDark.primary,
          focusColor: kColorSchemeDark.primary,
          enabledMouseCursor: MouseCursor.defer,
          surfaceTintColor: kColorSchemeDark.primary,
        ),
      ),
      dialogBackgroundColor: Colors.white,
      iconTheme: const IconThemeData().copyWith(
        color: kColorSchemeDark.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorSchemeDark.primary,
          foregroundColor: kColorSchemeDark.onPrimary,
          enabledMouseCursor: MouseCursor.defer,
          padding: const EdgeInsets.all(16),
          textStyle: GoogleFonts.lato(
            color: kColorSchemeDark.onPrimary,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          surfaceTintColor: kColorSchemeDark.onPrimary,
          foregroundColor: kColorSchemeDark.primary,
          enabledMouseCursor: MouseCursor.defer,
          textStyle: GoogleFonts.lato(
            color: kColorSchemeDark.onPrimary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
