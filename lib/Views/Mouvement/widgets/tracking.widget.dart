import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Helpers/date_parser.dart';
import 'package:flutter/material.dart';

class TrackingWidget {
  static buildTrackWidget(
      {required String title,
      required String subtitle,
      required Color color,
      required bool isLast,
      required String date}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxWidth: 120, minWidth: 20),
              // width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgets.text300(
                      title: parseDate(date: date)
                          .toString()
                          .trim()
                          .substring(0, 5),
                      fontSize: 10,
                      textColor: AppColors.kGreyColor),
                  if (date.toString().trim().length >= 16)
                    TextWidgets.text300(
                        title: date.toString().substring(11, 16),
                        fontSize: 10,
                        textColor: AppColors.kGreyColor),
                ],
              ),
            ),
          if (date.isNotEmpty)
            const SizedBox(
              width: 8,
            ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          width: 3,
                          height: 3,
                          // padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10)),
                        ))),
                isLast == false
                    ? Positioned(
                        bottom: 0,
                        top: 15,
                        left: 7,
                        child: Container(
                          width: 1,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: AppColors.kBlackColor,
                              borderRadius: BorderRadius.circular(30)),
                        ))
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: TextWidgets.textBold(
                                title: title.toString().trim(),
                                fontSize: 14,
                                textColor: color)),
                        Container(
                            child: TextWidgets.text300(
                                title: subtitle.toString().trim(),
                                fontSize: 10,
                                textColor: AppColors.kBlackColor)),
                        isLast == false
                            ? const SizedBox(height: 24)
                            : Container(),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
