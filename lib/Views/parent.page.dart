import 'package:flutter/material.dart';

import '../Resources/Components/texts.dart';
import '../Resources/Constants/global_variables.dart';

class ParentPage extends StatelessWidget {
  final String title;
  void Function()? callback;
  final Widget listWidget;
  ParentPage(
      {Key? key,
      required this.title,
      required this.listWidget,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(title),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: callback != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    // mini: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: AppColors.kPrimaryColor,
                    onPressed: callback,
                    child: Icon(Icons.add, color: AppColors.kWhiteColor),
                  ),
                  // const SizedBox(height: 72),
                ],
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgets.textBold(
                  title: title, fontSize: 24, textColor: AppColors.kBlackColor),
              TextWidgets.text300(
                  title: 'Liste des ${title.toLowerCase()}',
                  fontSize: 14,
                  textColor: AppColors.kGreyColor),
              const SizedBox(
                height: 16,
              ),
              Expanded(child: listWidget)
            ],
          ),
        ));
  }
}
