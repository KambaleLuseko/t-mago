import 'dart:convert';

import '../Constants/app_providers.dart';
import '../Constants/enums.dart';
import '../Constants/global_variables.dart';
import '../Helpers/LocalData/local_data.helper.dart';
import '../Helpers/sync_online_local.dart';
import '../Models/mouvement.model.dart';
import '../Models/store.model.dart';
import 'app_state_provider.dart';
import 'users_provider.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class MouvementProvider extends ChangeNotifier {
  String keyName = 'mouvements',
      storeKeyName = 'stores',
      priceKeyName = 'prices';
  List<MouvementModel> offlineData = [];
  List<StoreModel> offlineStoreData = [];
  List<PriceModel> offlinePricesData = [];

  int index = 0;

  setIndex({required int newIndex}) {
    index = newIndex;
    notifyListeners();
  }

  MouvementModel newMouvement = MouvementModel(
      mouvementType: '',
      storeID: '',
      senderID: '',
      userID: navKey.currentContext!
              .read<UserProvider>()
              .userLogged
              ?.user
              .id!
              .toString() ??
          '',
      // receiverID: '',
      detailsMouvement: []);

  addData(
      {required MouvementModel data,
      EnumActions? action = EnumActions.SAVE,
      required Function callback}) async {
    if (data.detailsMouvement.toString().isEmpty ||
        data.senderID.toString().isEmpty ||
        data.storeID.toString().isEmpty) {
      return ToastNotification.showToast(
          msg: "Veuillez remplir tous les champs",
          msgType: MessageType.error,
          title: 'Error');
    }
    Map body = data.toJSON();
    body.remove('sender');
    body.remove('receiver');
    body.remove('destinationStore');
    // return;
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(
            url: BaseUrl.saveData, body: {"transaction": 'mouvement', ...body});
    // debugPrint(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      if (decoded['state'].toString().toLowerCase() == 'success') {
        data.syncStatus = 1;
        offlineData.insert(0, data);
        LocalDataHelper.saveData(key: keyName, value: data.toJSON());
        ToastNotification.showToast(
            msg: "Données enregistrées",
            msgType: MessageType.success,
            title: 'Success');
        callback();
        notifyListeners();
        newMouvement = MouvementModel(
            userID: navKey.currentContext!
                    .read<UserProvider>()
                    .userLogged
                    ?.user
                    .id!
                    .toString() ??
                '',
            mouvementType: '',
            storeID: '',
            senderID: '',
            // receiverID: '',
            detailsMouvement: []);
        index = 0;
        return;
      } else {
        ToastNotification.showToast(
            msg: decoded['message']?.toString().trim() ??
                'Une erreur est survenue',
            msgType: MessageType.error,
            title: 'Error');
      }
    } else if (response.statusCode == 408 || response.statusCode == 500) {
      offlineData.insert(0, data);
      LocalDataHelper.saveData(key: keyName, value: data.toJSON());
      ToastNotification.showToast(
          msg: "Erreur de connexion veuillez réessayer",
          msgType: MessageType.error,
          title: 'Error');

      callback();
      notifyListeners();
      newMouvement = MouvementModel(
          userID: navKey.currentContext!
                  .read<UserProvider>()
                  .userLogged
                  ?.user
                  .id!
                  .toString() ??
              '',
          mouvementType: '',
          storeID: '',
          senderID: '',
          // receiverID: '',
          detailsMouvement: []);
      index = 0;
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
        .httpPost(url: BaseUrl.transaction, body: {
      "transaction": "getmouvement",
      "userID": navKey.currentContext!
          .read<UserProvider>()
          .userLogged!
          .user
          .id!
          .toString()
    });
    List data = [];
    // print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) return;
      data = jsonDecode(response.body);
    } else {
      return;
    }
    if (data.isEmpty) {
      LocalDataHelper.clearLocalData(key: keyName);
      offlineData.clear();
      notifyListeners();
      return;
    }
    // print('clearing data');
    List<MouvementModel> dataList = List<MouvementModel>.from(data.map((item) {
      // print(item['ref_mouv_entry']);
      MouvementModel data = MouvementModel.fromJSON(item);
      // print(data.outStock?.toJSON());
      return data;
    })).reversed.toList();
    LocalDataHelper.clearLocalData(key: keyName);
    notifyListeners();
    SyncOnlineLocalHelper.insertNewDataOffline(
        onlineData: dataList.map((e) => e.toJSON()).toList(),
        offlineData: offlineData.map((e) => e.toJSON()).toList(),
        key: keyName,
        callback: () {
          getOffline(isRefresh: true);
        });

    notifyListeners();
  }

  MouvementModel? activeOperation;
  getOneOnline({required String value}) async {
    var response = await AppProviders.appProvider.httpPost(
        url: BaseUrl.transaction,
        body: {"transaction": "searchmouvement", "colisID": value});
    List data = [];
    // print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) return;
      data = jsonDecode(response.body);
    } else {
      return;
    }
    // print('clearing data');
    List<MouvementModel> dataList = List<MouvementModel>.from(data.map((item) {
      // print(item['ref_mouv_entry']);
      MouvementModel data = MouvementModel.fromJSON(item);
      // print(data.outStock?.toJSON());
      return data;
    })).toList();
    activeOperation = dataList.firstOrNull;
    notifyListeners();
  }

  resetOperation() {
    activeOperation = null;
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
    if (isRefresh == true) {
      offlineData.clear();
    }
    if (data.isEmpty) {
      offlineData.clear();
      notifyListeners();
      return;
    }

    offlineData = List<MouvementModel>.from(
        data.map((item) => MouvementModel.fromJSON(item)).toList());
    notifyListeners();
  }

  getOnlineStores({bool? isRefresh = false, String? value}) async {
    if (isRefresh == false && offlineStoreData.isNotEmpty) return;
    var response = await AppProviders.appProvider
        .httpPost(url: BaseUrl.getData, body: {"transaction": "stores"});
    List data = [];
    // print(response.body);
    // return;
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) return;
      data = jsonDecode(response.body);
    } else {
      return;
    }
    List<StoreModel> dataList =
        List<StoreModel>.from(data.map((item) => StoreModel.fromJSON(item)))
            .reversed
            .toList();
    LocalDataHelper.clearLocalData(key: storeKeyName);
    SyncOnlineLocalHelper.insertNewDataOffline(
        mustClearLocalData: true,
        onlineData: dataList.map((e) => e.toJSON()).toList(),
        offlineData: offlineStoreData.map((e) => e.toJSON()).toList(),
        key: storeKeyName,
        callback: () {
          getOfflineStores(isRefresh: true);
        });

    notifyListeners();
  }

  getOfflineStores({bool? isRefresh = false}) async {
    if (isRefresh == false && offlineStoreData.isNotEmpty) return;
    List data = await LocalDataHelper.getData(
      key: storeKeyName,
    );
    if (data.isEmpty) {
      // getOnlineStores(isRefresh: true);
      return;
    }
    offlineStoreData = List<StoreModel>.from(
        data.map((item) => StoreModel.fromJSON(item)).toList());
    // print(offlineStoreData);
    notifyListeners();
  }

  getOnlinePrices({bool? isRefresh = false, String? value}) async {
    if (isRefresh == false && offlinePricesData.isNotEmpty) return;
    var response = await AppProviders.appProvider
        .httpPost(url: BaseUrl.getData, body: {"transaction": "prices"});
    List data = [];
    // print(response.body);
    // return;
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) return;
      data = jsonDecode(response.body);
    } else {
      return;
    }
    List<PriceModel> dataList =
        List<PriceModel>.from(data.map((item) => PriceModel.fromJSON(item)))
            .reversed
            .toList();
    LocalDataHelper.clearLocalData(key: storeKeyName);
    SyncOnlineLocalHelper.insertNewDataOffline(
        mustClearLocalData: true,
        onlineData: dataList.map((e) => e.toJSON()).toList(),
        offlineData: offlinePricesData.map((e) => e.toJSON()).toList(),
        key: priceKeyName,
        callback: () {
          getOfflinePrices(isRefresh: true);
        });

    notifyListeners();
  }

  getOfflinePrices({bool? isRefresh = false}) async {
    if (isRefresh == false && offlinePricesData.isNotEmpty) return;
    List data = await LocalDataHelper.getData(
      key: priceKeyName,
    );
    if (data.isEmpty) {
      // getOnlineStores(isRefresh: true);
      return;
    }
    offlinePricesData = List<PriceModel>.from(
        data.map((item) => PriceModel.fromJSON(item)).toList());
    notifyListeners();
  }
}
