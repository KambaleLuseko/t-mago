import 'package:flutter/material.dart';

import '../../Resources/Constants/global_variables.dart';
import '../../main.dart';

showDatePicketCustom(
    {required Function callback,
    required DateTime firstDate,
    required DateTime lastDate}) async {
  await showDatePicker(
    context: navKey.currentContext!,
    initialDate: lastDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (BuildContext context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.kPrimaryColor,
          accentColor: AppColors.kPrimaryColor,
          colorScheme: ColorScheme.light(primary: AppColors.kPrimaryColor),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  ).then((value) => callback(value)).catchError((error) {});
}
