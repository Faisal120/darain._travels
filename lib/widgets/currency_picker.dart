import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/selectable_list.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:unicons/unicons.dart';

Padding currencyPickers(
    RxString selectedFrom,
    RxString selectedTo,
    Function() switchCurrencies,
    Function(bool, String) changeSelected,
    ) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          selectableList(selectedFrom.value, true, changeSelected),
          Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => switchCurrencies(),
              child: Icon(
                UniconsLine.exchange_alt,
                color: mainTheme,
                size: 30,
              ),
            ),
          ),
          selectableList(selectedTo.value, false, changeSelected),
        ],
      ),
  );
}