import '../../Resources/Constants/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Providers/app_state_provider.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key? key,
      required this.text,
      required this.backColor,
      required this.textColor,
      required this.callback,
      this.size,
      this.icon,
      this.canSync = false})
      : super(key: key);

  final String text;
  final Color backColor;
  final Color textColor;
  Function callback;
  double? size = 250;
  IconData? icon;
  bool? canSync = false;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isButtonHovered = false;

  // double width = 250;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
      // if (appStateProvider.isAsync == true && widget.canSync == true) {
      //   width = 40;
      //   setState(() {});
      // }
      return Center(
        child: GestureDetector(
          onTap: () async {
            widget.callback();
          },
          child: MouseRegion(
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                constraints: const BoxConstraints(
                    maxWidth: double.maxFinite, minWidth: 40),
                width:
                    appStateProvider.isAsync == true && widget.canSync == true
                        ? 56
                        : double.maxFinite,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding / 2, vertical: 5),
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding / 2, vertical: 10),
                decoration: BoxDecoration(
                  color: isButtonHovered
                      ? widget.backColor.withOpacity(0.9)
                      : widget.backColor,
                  borderRadius: BorderRadius.circular(
                      appStateProvider.isAsync == true && widget.canSync == true
                          ? 100
                          : kDefaultPadding / 4),
                ),
                child: widget.canSync == null || widget.canSync == false
                    ? FittedBox(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            color: isButtonHovered
                                ? widget.textColor.withOpacity(0.5)
                                : widget.textColor,
                          ),
                        ),
                      )
                    : appStateProvider.isAsync == false &&
                            (widget.canSync != null && widget.canSync == true)
                        ? FittedBox(
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                color: isButtonHovered
                                    ? widget.textColor.withOpacity(0.5)
                                    : widget.textColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.textColor),
                            ),
                          )),
          ),
        ),
      );
    });
  }
}
