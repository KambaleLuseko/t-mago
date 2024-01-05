import 'dart:convert';

import '../Constants/app_providers.dart';
import '../Constants/enums.dart';
import '../Constants/global_variables.dart';
import '../Helpers/LocalData/local_data.helper.dart';
import '../Helpers/sync_online_local.dart';
import '../Models/field.model.dart';
import 'app_state_provider.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FieldsProvider extends ChangeNotifier {
  String keyName = 'fields';
  bool canCheckData = true;
  List<FieldsModel> offlineData = [];
  addData(
      {required FieldsModel data,
      EnumActions? action = EnumActions.SAVE,
      required Function callback}) async {
    if (data.adresseCh.toString().isEmpty || data.refMuku.toString().isEmpty) {
      return ToastNotification.showToast(
          msg: "Veuillez remplir tous les champs",
          msgType: MessageType.error,
          title: 'Error');
    }

    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(
            url: BaseUrl.saveData,
            body: {"transaction": 'field', ...data.toJSON()});
    // debugPrint(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      data.syncStatus = 1;
      LocalDataHelper.saveData(key: keyName, value: data.toJSON());
      var decoded = jsonDecode(response.body);
      if (decoded['state'].toString().toLowerCase() == 'success') {
        ToastNotification.showToast(
            msg: "Données enregistrées",
            msgType: MessageType.success,
            title: 'Success');
        callback();
        notifyListeners();
        getOffline(isRefresh: true);
        return;
      } else {
        ToastNotification.showToast(
            msg: decoded['message']?.toString().trim() ??
                'Une erreur est survenue',
            msgType: MessageType.error,
            title: 'Error');
      }
    } else if (response.statusCode == 408 || response.statusCode == 500) {
      LocalDataHelper.saveData(key: keyName, value: data.toJSON());
      ToastNotification.showToast(
          msg: "Erreur de connexion veuillez réessayer",
          msgType: MessageType.error,
          title: 'Error');
      callback();
      notifyListeners();
      getOffline(isRefresh: true);
      return;
    } else {
      var decoded = jsonDecode(response.body);
      ToastNotification.showToast(
          msg: decoded['message']?.toString().trim() ??
              "Une erreur est survenue, veuillez contacter l'Administrateur",
          msgType: MessageType.error,
          title: 'Error');
    }
  }

  // getData() {
  //   dataList = List<Map>.from(dataList).reversed.toList();
  //   notifyListeners();
  // }

  getOnline({bool? isRefresh = false, String? value}) async {
    if (isRefresh == false && offlineData.isNotEmpty) return;
    var response = await AppProviders.appProvider
        .httpPost(url: BaseUrl.transaction, body: {"transaction": "fields"});
    List data = [];
    // print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) return;
      data = jsonDecode(response.body);
    } else {
      return;
    }
    canCheckData = false;
    List<FieldsModel> dataList =
        List<FieldsModel>.from(data.map((item) => FieldsModel.fromJSON(item)))
            .reversed
            .toList();
    SyncOnlineLocalHelper.insertNewDataOffline(
        mustClearLocalData: true,
        onlineData: dataList.map((e) => e.toJSON()).toList(),
        offlineData: offlineData.map((e) => e.toJSON()).toList(),
        key: keyName,
        callback: () {
          getOffline(isRefresh: true);
        });

    notifyListeners();
  }

  get({bool? isRefresh = false}) {
    // if (AppProviders.appProvider.isApiReachable) {
    //   getOnline(isRefresh: isRefresh);
    // }
    getOffline(isRefresh: isRefresh);
  }

  getOffline({bool? isRefresh = false}) async {
    if (isRefresh == false && offlineData.isNotEmpty) return;
    List data = await LocalDataHelper.getData(
      key: keyName,
    );
    if (data.isEmpty && offlineData.isEmpty && canCheckData == true) {
      getOnline(isRefresh: true);
    }
    offlineData = List<FieldsModel>.from(
        data.map((item) => FieldsModel.fromJSON(item)).toList());
    notifyListeners();
  }
}
