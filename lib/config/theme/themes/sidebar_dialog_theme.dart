import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

DialogTheme sidebarDialogTheme(Color mainColor, Color dialogColor) {
  return DialogTheme(
    backgroundColor: mainColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    insetPadding: EdgeInsets.all(10),
    contentTextStyle: TextStyle(
      fontFamily: 'Nova',
      color: dialogColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  );
}
