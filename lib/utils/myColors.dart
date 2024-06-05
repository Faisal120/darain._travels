import 'package:flutter/material.dart';

const MaterialColor mainTheme = MaterialColor(
    _mainThemePrimaryValue, <int, Color>{
  50: Color(0xFFE6E9F3),
  100: Color(0xFFC1C8E1),
  200: Color(0xFF98A3CE),
  300: Color(0xFF6E7EBA),
  400: Color(0xFF4F62AB),
  500: Color(_mainThemePrimaryValue),
  600: Color(0xFF2B3F94),
  700: Color(0xFF24378A),
  800: Color(0xFF1E2F80),
  900: Color(0xFF13206E),
});
const int _mainThemePrimaryValue = 0xFF30469C;

const MaterialColor mainThemeAccent = MaterialColor(
    _mainThemeAccentValue, <int, Color>{
  100: Color(0xFFA5AFFF),
  200: Color(_mainThemeAccentValue),
  400: Color(0xFF3F55FF),
  700: Color(0xFF253FFF),
});
const int _mainThemeAccentValue = 0xFF7282FF;

const MaterialColor grey = MaterialColor(_greyPrimaryValue, <int, Color>{
  50: Color(0xFFFAFAFA),
  100: Color(0xFFF2F2F2),
  200: Color(0xFFE9E9E9),
  300: Color(0xFFE0E0E0),
  400: Color(0xFFDADADA),
  500: Color(_greyPrimaryValue),
  600: Color(0xFFCECECE),
  700: Color(0xFFC8C8C8),
  800: Color(0xFFC2C2C2),
  900: Color(0xFFB7B7B7),
});
const int _greyPrimaryValue = 0xFFD3D3D3;

const MaterialColor greyAccent = MaterialColor(_greyAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_greyAccentValue),
  400: Color(0xFFFFFFFF),
  700: Color(0xFFFFF5F5),
});
const int _greyAccentValue = 0xFFFFFFFF;