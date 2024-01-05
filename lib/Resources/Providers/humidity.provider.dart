import 'dart:convert';
import '../Constants/app_providers.dart';
import '../Constants/global_variables.dart';
import '../Helpers/LocalData/local_data.helper.dart';
import '../Helpers/sync_online_local.dart';
import 'package:flutter/material.dart';

class HumidityPricesProvider extends ChangeNotifier {
  String humidityKeyName = 'humidites';
  List<Map> offlineHumidity = [];

  getOnlineHumidity({bool? isRefresh = false, String? value}) async {
    if (isRefresh == false && offlineHumidity.isNotEmpty) return;
    var response = await AppProviders.appProvider
        .httpPost(url: BaseUrl.getData, body: {"transaction": "humidite"});
    List data = [];
    // print(response.body);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {
      return;
    }
    List<Map> dataList = List<Map>.from(data.map((item) => item)).toList();
    LocalDataHelper.clearLocalData(key: humidityKeyName);
    SyncOnlineLocalHelper.insertNewDataOffline(
        mustClearLocalData: true,
        onlineData: dataList,
        offlineData: offlineHumidity,
        key: humidityKeyName,
        callback: () {
          getOfflineHumidity(isRefresh: true);
        });
    notifyListeners();
  }

  getOfflineHumidity({bool? isRefresh = false}) async {
    if (isRefresh == false && offlineHumidity.isNotEmpty) return;
    List data = await LocalDataHelper.getData(
      key: humidityKeyName,
    );
    if (data.isEmpty && isRefresh == false) {
      getOnlineHumidity();
      return;
    }
    offlineHumidity = List<Map>.from(data.map((item) => item)).toList();
    notifyListeners();
  }
}
