import 'package:flutter/material.dart';

import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/responsive.dart';
import '../../main.dart';

Map<String, String> headers = {
  // 'Accept': 'application/json; charset=UTF-8',
  'Content-Type': 'application/json',
  // 'Authorization': 'Bearer ${Provider.of<AppStateProvider>(navKey.currentContext!, listen: false).userToken}'
};

double kDefaultPadding = 32;

class AppColors {
  static Color kPrimaryColor = const Color.fromRGBO(6, 51, 35, 1);
  static Color kSecondaryColor = const Color.fromRGBO(30, 174, 181, 1);
  static Color kScaffoldColor = Colors.grey.shade300;
  static Color kAccentColor = const Color.fromRGBO(78, 159, 102, 1);
  static Color kBlackColor = const Color.fromRGBO(0, 0, 0, 1);

  // static Color kBlackColor = Colors.black;
  static Color kBlackLightColor = const Color.fromRGBO(40, 40, 40, 1);
  static Color kWhiteColor = Colors.white;
  static Color kWhiteDarkColor = Colors.grey.shade400;
  static Color kGreenColor = Colors.green;
  static Color kRedColor = Colors.red;
  static Color kBlueColor = Colors.blue;
  static Color kGreyColor = Colors.grey;
  static Color kWarningColor = Colors.orange;

  // static Color kYellowColor = const Color.fromRGBO(255, 184, 57, 1);
  static Color kYellowColor = const Color.fromRGBO(255, 185, 35, 1);
  static Color kTextFormWhiteColor = Colors.white.withOpacity(0.05);
  static Color kTextFormBackColor = Colors.black.withOpacity(0.05);
  static Color kTransparentColor = Colors.transparent;
}

class BaseUrl {
  // static String ip = "https://biakuuza.com/api";
  // static String ip = "https://mck-coop-ca.com/api/api";
  // static String ip = "http://192.168.188.22:8000";
  static String ip = "http://192.168.2.125:8000";
  static String apiUrl = ip;
  static String getLogin = '$apiUrl/user/login/';
  static String user = '$apiUrl/user/';
  static String getData = '$apiUrl/get_data.php';
  static String saveData = '$apiUrl/saveClass.php';
  static String transaction = '$apiUrl/transactions.php';

  //=================User========================
}

class ToastNotification {
  static showToast(
      {required String msg,
      String? title = "Information",
      Alignment? align = Alignment.topCenter,
      MessageType? msgType = MessageType.warning}) {
    ScaffoldMessenger.of(navKey.currentContext!).removeCurrentSnackBar();
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
      SnackBar(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        margin: Responsive.isWeb(navKey.currentContext!)
            ? EdgeInsets.only(
                left: align == Alignment.center
                    ? MediaQuery.of(navKey.currentContext!).size.width / 2.5
                    : MediaQuery.of(navKey.currentContext!).size.width / 1.3,
                right: align == Alignment.center
                    ? MediaQuery.of(navKey.currentContext!).size.width / 2.5
                    : 8,
                bottom: 8)
            : const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.kWhiteColor,
              // msgType == MessageType.error
              //     ? AppColors.kRedColor.withOpacity(0.1)
              //     : msgType == MessageType.success
              //         ? AppColors.kGreenColor.withOpacity(0.1)
              //         : AppColors.kWarningColor.withOpacity(0.1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  // padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    msgType == MessageType.info
                        ? Icons.info
                        : msgType == MessageType.error
                            ? Icons.cancel
                            : msgType == MessageType.success
                                ? Icons.check_circle
                                : Icons.warning_amber_rounded,
                    color: msgType == MessageType.info
                        ? AppColors.kBlueColor
                        : msgType == MessageType.error
                            ? AppColors.kRedColor
                            : msgType == MessageType.success
                                ? AppColors.kGreenColor
                                : AppColors.kWarningColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidgets.textBold(
                            title: title!,
                            fontSize: 14,
                            textColor: msgType == MessageType.info
                                ? AppColors.kBlueColor
                                : msgType == MessageType.error
                                    ? AppColors.kRedColor
                                    : msgType == MessageType.success
                                        ? AppColors.kGreenColor
                                        : AppColors.kWarningColor),
                        TextWidgets.textNormal(
                            title: msg,
                            fontSize: 12,
                            textColor: msgType == MessageType.info
                                ? AppColors.kBlueColor
                                : msgType == MessageType.error
                                    ? AppColors.kRedColor
                                    : msgType == MessageType.success
                                        ? AppColors.kGreenColor
                                        : AppColors.kWarningColor),
                      ]),
                ),
              ],
            )),
      ),
    );
  }

  static showContextToast(
      {required String msg,
      required BuildContext context,
      String? title = "Information",
      MessageType? msgType = MessageType.warning}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        margin: Responsive.isWeb(navKey.currentContext!)
            ? EdgeInsets.only(
                left: MediaQuery.of(navKey.currentContext!).size.width / 1.5,
                right: 8,
                bottom: 8)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.kWhiteColor,
              // msgType == MessageType.error
              //     ? AppColors.kRedColor.withOpacity(0.1)
              //     : msgType == MessageType.success
              //         ? AppColors.kGreenColor.withOpacity(0.1)
              //         : AppColors.kWarningColor.withOpacity(0.1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  // padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    msgType == MessageType.error
                        ? Icons.cancel
                        : msgType == MessageType.success
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                    color: msgType == MessageType.error
                        ? AppColors.kRedColor
                        : msgType == MessageType.success
                            ? AppColors.kGreenColor
                            : AppColors.kWarningColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidgets.textBold(
                            title: title!,
                            fontSize: 14,
                            textColor: msgType == MessageType.error
                                ? AppColors.kRedColor
                                : msgType == MessageType.success
                                    ? AppColors.kGreenColor
                                    : AppColors.kWarningColor),
                        TextWidgets.textNormal(
                            title: msg,
                            fontSize: 12,
                            textColor: msgType == MessageType.error
                                ? AppColors.kRedColor
                                : msgType == MessageType.success
                                    ? AppColors.kGreenColor
                                    : AppColors.kWarningColor),
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}
