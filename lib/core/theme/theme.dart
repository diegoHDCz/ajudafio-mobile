import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static _border([Color color = AppPallet.primaryColorLight]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 3),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallet.backgroundColor,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(17),
      enabledBorder: _border(),

      focusedBorder: _border(AppPallet.primaryColorDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: AppPallet.surfaceColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallet.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPallet.textColor),
    ),
  );
}
