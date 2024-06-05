import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

Center valueCounter(
    RxString ammount,
    RxString selectedFrom,
    RxString selectedTo,
    RxDouble selectedPrice,
    ) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: mainTheme.withOpacity(0.05),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
            ammount.value.isEmpty
                ? '0,00 $selectedFrom = 0,00 $selectedTo'
                : '${(double.parse(ammount.value.replaceAll(',', '.')).toStringAsFixed(2)).replaceAll('.', ',')} $selectedFrom = ${(double.parse(ammount.value.replaceAll(',', '.')) * selectedPrice.value).toStringAsFixed(2).replaceAll('.', ',')} $selectedTo',
            style: GoogleFonts.lato(
              color: mainTheme,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
      ),
    ),
  );
}