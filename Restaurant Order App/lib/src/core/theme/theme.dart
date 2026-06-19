import 'package:flutter/cupertino.dart';

const CupertinoThemeData lightTheme = CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: CupertinoColors.activeBlue,
  scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
  barBackgroundColor: CupertinoColors.white,
  textTheme: CupertinoTextThemeData(
    primaryColor: CupertinoColors.black,
  ),
);

const CupertinoThemeData darkTheme = CupertinoThemeData(
  brightness: Brightness.dark,
  primaryColor: CupertinoColors.activeOrange,
  scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
  barBackgroundColor: CupertinoColors.black,
  textTheme: CupertinoTextThemeData(
    primaryColor: CupertinoColors.white,
  ),
);