import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/Components/dialogs.dart';
import '../../Resources/Components/empty_model.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/mouvement.model.dart';
import '../../Resources/Providers/app_state_provider.dart';
import '../../Resources/Providers/humidity.provider.dart';
import '../../Resources/Providers/mouvement.provider.dart';
import 'Add_operation/choose_type.widget.dart';
import 'widgets/mouvement.widget.dart';

class MouvementListPage extends StatefulWidget {
  const MouvementListPage({Key? key}) : super(key: key);

  @override
  State<MouvementListPage> createState() => _MouvementListPageState();
}

class _MouvementListPageState extends State<MouvementListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MouvementProvider>().getOffline();
      context.read<MouvementProvider>().getOfflineStores();
      context.read<MouvementProvider>().getOfflinePrices();
      context.read<HumidityPricesProvider>().getOfflineHumidity();
    });
  }

  List<Map> printList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'scan-qr-box',
              mini: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.kGreenColor,
              onPressed: () {
                Dialogs.showBottomModalSheet(
                    content: const ChooseOperationTypeWidget());
              },
              child: Icon(Icons.qr_code_scanner_rounded,
                  color: AppColors.kWhiteColor),
            ),
            const SizedBox(height: 64),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<MouvementProvider>().getOnline(isRefresh: true);
            context.read<MouvementProvider>().getOnlineStores(isRefresh: true);
            context.read<MouvementProvider>().getOnlinePrices(isRefresh: true);
            context
                .read<HumidityPricesProvider>()
                .getOnlineHumidity(isRefresh: true);
            printList.clear();
            setState(() {});
          },
          child: Selector<MouvementProvider, List<MouvementModel>>(
              builder: (context, offlineData, _) {
                return offlineData.isNotEmpty &&
                        context.read<AppStateProvider>().isAsync == false
                    ? ListView.builder(
                        itemCount: offlineData.length,
                        itemBuilder: (context, index) {
                          return MouvementItemWidget(data: offlineData[index]);
                        })
                    : ListView(
                        children: [EmptyModel(color: AppColors.kBlackColor)],
                      );
              },
              selector: (_, provider) => provider.offlineData),
        ));
  }
}
