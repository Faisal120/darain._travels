import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

Center numberButton(
    String str, Function(String) changeValue) {
  return Center(
    child: GestureDetector(
      onTap: () => changeValue(str),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mainTheme,
        ),
        width: 60,
        child: Center(
          child: Text(
            str,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}