import '../Constants/enums.dart';
import '../Constants/global_variables.dart';
import '../Helpers/LocalData/local_data.helper.dart';
import 'cultivator.provider.dart';
import 'fields.provider.dart';
import 'mouvement.provider.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyncProvider extends ChangeNotifier {
  List cultivatorData = [], fieldData = [], mouvementData = [];
  getData() {
    cultivatorData.clear();
    fieldData.clear();
    mouvementData.clear();
    cultivatorData = navKey.currentContext!
        .read<CultivatorProvider>()
        .offlineData
        .where((element) => element.syncStatus == 0)
        .toList();
    fieldData = navKey.currentContext!
        .read<FieldsProvider>()
        .offlineData
        .where((element) => element.syncStatus == 0)
        .toList();
    mouvementData = navKey.currentContext!
        .read<MouvementProvider>()
        .offlineData
        .where((element) => element.syncStatus == 0)
        .toList();
    notifyListeners();
  }

  double syncPercent = 0;
  bool isSynching = false;
  syncData() async {
    int totalItems =
        cultivatorData.length + fieldData.length + mouvementData.length;
    if (totalItems <= 0) {
      ToastNotification.showToast(
          msg: "Aucune donnée trouvée",
          msgType: MessageType.info,
          title: 'Information');
      return;
    }
    isSynching = true;
    notifyListeners();
    for (var i = 0; i < cultivatorData.length; i++) {
      await navKey.currentContext!
          .read<CultivatorProvider>()
          .addData(data: cultivatorData[i], callback: () {});
    }

    for (var i = 0; i < fieldData.length; i++) {
      await navKey.currentContext!
          .read<FieldsProvider>()
          .addData(data: fieldData[i], callback: () {});
    }
    for (var i = 0; i < mouvementData.length; i++) {
      await navKey.currentContext!
          .read<MouvementProvider>()
          .addData(data: mouvementData[i], callback: () {});
    }
    // await Future.delayed(const Duration(seconds: 5));
    isSynching = false;
    notifyListeners();
    // Getting farmer
    LocalDataHelper.clearLocalData(
        deleteAll: true,
        key: navKey.currentContext!.read<CultivatorProvider>().keyName);
    navKey.currentContext!
        .read<CultivatorProvider>()
        .getOnline(isRefresh: true);
// Getting fields
    LocalDataHelper.clearLocalData(
        deleteAll: true,
        key: navKey.currentContext!.read<FieldsProvider>().keyName);
    navKey.currentContext!.read<FieldsProvider>().getOnline(isRefresh: true);
// Getting transactions
    LocalDataHelper.clearLocalData(
        deleteAll: true,
        key: navKey.currentContext!.read<MouvementProvider>().keyName);
    navKey.currentContext!.read<MouvementProvider>().getOnline(isRefresh: true);
    getData();
  }
}
