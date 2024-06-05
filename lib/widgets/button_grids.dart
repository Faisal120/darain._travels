import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unicons/unicons.dart';

import 'number_buttons.dart';

Padding buttonsGrid(
    Function(String) changeAmmount,
    Function() backspace,
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 5,
    ),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int i) {
        if (i == 9) {
          return numberButton(',', changeAmmount);
        } else if (i == 10) {
          return numberButton(0.toString(), changeAmmount);
        } else if (i == 11) {
          return Center(
            child: GestureDetector(
              onTap: () => backspace(),
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainTheme,
                ),
                child: Center(
                  child: Icon(
                    UniconsLine.backspace,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        } else {
          return numberButton(
            (i + 1).toString(),
            changeAmmount
          );
        }
      },
    ),
  );
}