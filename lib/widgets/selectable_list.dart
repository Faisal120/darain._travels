import 'package:darain_travels/utils/currencies.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

Center selectableList(String value, bool isFrom,
    Function(bool, String) changeCurr) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        border: Border.all(
          color: mainTheme,
        ),
      ),
      width: 120,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            'Select',
          ),
          menuMaxHeight: 40,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          style: GoogleFonts.poppins(color: mainTheme),
          value: value,
          items: currencies.map(
                (String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            changeCurr(isFrom, value.toString());
          },
        ),
      ),
    ),
  );
}