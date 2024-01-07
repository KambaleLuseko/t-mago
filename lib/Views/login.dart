import '../Resources/Components/button.dart';
import '../Resources/Components/text_fields.dart';
import '../Resources/Components/texts.dart';
import '../Resources/Constants/global_variables.dart';
import '../Resources/Constants/navigators.dart';
import '../Resources/Providers/users_provider.dart';
import 'main_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameCtrller = TextEditingController();
  final TextEditingController _pwdCtrller = TextEditingController();
  bool stayConnected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            decoration:
                BoxDecoration(color: AppColors.kWhiteColor.withOpacity(0.7)),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 180,
                  height: 180,
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(1000),
                    child: Image.asset(
                      "Assets/Images/text_logo.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidgets.text300(
                    textColor: AppColors.kPrimaryColor,
                    fontSize: 14,
                    title: "Login now to continue"),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(
                    hintText: "Username",
                    textColor: AppColors.kPrimaryColor,
                    backColor: AppColors.kBlackColor.withOpacity(0.05),
                    // icon: Icons.person,
                    inputType: TextInputType.text,
                    isEnabled: true,
                    editCtrller: _usernameCtrller),
                TextFormFieldWidget(
                    maxLines: 1,
                    hintText: "Password",
                    textColor: AppColors.kPrimaryColor,
                    backColor: AppColors.kBlackColor.withOpacity(0.05),
                    inputType: TextInputType.text,
                    isObsCured: true,
                    isEnabled: true,
                    editCtrller: _pwdCtrller),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Center(
                //           child: InkWell(
                //         onTap: () {
                //           stayConnected = !stayConnected;
                //           setState(() {});
                //         },
                //         child: Row(
                //           children: [
                //             Container(
                //               decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: AppColors.kPrimaryColor),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(2.0),
                //                 child: stayConnected
                //                     ? const Icon(
                //                         Icons.check,
                //                         size: 15.0,
                //                         color: Colors.white,
                //                       )
                //                     : Icon(
                //                         Icons.radio_button_unchecked,
                //                         size: 15.0,
                //                         color: AppColors.kPrimaryColor,
                //                       ),
                //               ),
                //             ),
                //             const SizedBox(width: 10),
                //             const Text(
                //               'Rester connecter',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w300, fontSize: 16),
                //             ),
                //           ],
                //         ),
                //       )),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    canSync: true,
                    backColor: AppColors.kPrimaryColor,
                    textColor: AppColors.kWhiteColor,
                    text: 'Login',
                    callback: () {
                      context.read<UserProvider>().login(
                          data: {
                            "username": _usernameCtrller.text.toString().trim(),
                            "password": _pwdCtrller.text.toString().trim(),
                          },
                          callback: () {
                            Navigation.pushReplaceNavigate(
                                page: const MainPage());
                          });
                    }),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
