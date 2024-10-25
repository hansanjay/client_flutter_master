import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class MyTheme {

  ThemeData lightTheme = ThemeData(

      primaryColor: Color(0xFF000000),
      cardTheme:
          CardTheme(surfaceTintColor: Color(0xFFFFFFFF), color: Colors.white),
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFF000000)),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins(
          fontSize: 17,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF000000)),
          shape: MaterialStateProperty.all(StadiumBorder()),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ));
}
