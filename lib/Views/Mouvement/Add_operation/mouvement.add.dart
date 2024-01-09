import 'select_mouv_dest.widget.dart';

import '../../../Resources/Models/mouvement.model.dart';
import '../../../Resources/Providers/mouvement.provider.dart';

import 'new_mouvement_resume.widget.dart';
import 'select_mouv_store.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late PageController pageViewCtrller;

class AddMouvementPage extends StatefulWidget {
  int? pageIndex;
  List<MouvementDetailsModel>? data = [];
  AddMouvementPage({Key? key, this.pageIndex = 0, this.data = const []})
      : super(key: key);

  @override
  State<AddMouvementPage> createState() => _AddMouvementPageState();
}

class _AddMouvementPageState extends State<AddMouvementPage> {
  @override
  void initState() {
    super.initState();
    pageViewCtrller = PageController(
      initialPage: context.read<MouvementProvider>().index,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageViewCtrller.animateToPage(widget.pageIndex!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Nouveau mouvement')),
      body: PageView(
        controller: pageViewCtrller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        // onPageChanged: (index) {
        //   pageViewCtrller.jumpToPage(0);
        //   setState(() {});
        // },
        children: [
          // SelectMouvementTypeWidget(
          //   callback: () {
          //     pageViewCtrller.animateToPage(1,
          //         duration: const Duration(milliseconds: 300),
          //         curve: Curves.easeInCubic);
          //     setState(() {});
          //   },
          // ),
          SelectMouvementStoreWidget(
            callback: () {
              pageViewCtrller.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic);
              setState(() {});
            },
            // back: () {
            //   pageViewCtrller.animateToPage(0,
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInCubic);
            //   setState(() {});
            // },
          ),
          SelectMouvementDestinationWidget(
            callback: () {
              pageViewCtrller.animateToPage(2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic);
              setState(() {});
            },
            backCallback: () {
              pageViewCtrller.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic);
              setState(() {});
            },
          ),
          MouvementResumeWidget(
            data: widget.data,
            backCallback: () {
              pageViewCtrller.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
