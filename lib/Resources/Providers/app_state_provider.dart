import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../main.dart';

class AppStateProvider extends ChangeNotifier {
  bool isAsync = false, isApiReachable = false, needToWorkOffline = false;
  changeAppState() async {
    isAsync = !isAsync;
    notifyListeners();
  }

  checkApiConnectivity() async {
    await httpGet(url: BaseUrl.ip).then((response) {
      if (response.statusCode == 200) {
        isApiReachable = true;
        needToWorkOffline = false;
      } else {
        isApiReachable = false;
        ToastNotification.showToast(
            msg:
                "Vous êtes actuellement en mode hors connexion.\nSi vous voulez basculer de mode, cliquez sur l'icone de connection dans le menu gauche",
            msgType: MessageType.info,
            title: "Information");
        // Dialogs.showDialogWithAction(
        //     title: "Confirmation",
        //     content:
        //         "Voulez-vous continuer de travailler hors connection? Si vous voulez basculer de mode, cliquez sur l'icone de connection dans le menu gauche",
        //     callback: () {
        //       needToWorkOffline = true;
        //     });
      }
    });
    notifyListeners();
  }

  saveIPConfig({required String value}) {
    if (value.isEmpty) {
      return ToastNotification.showToast(
          msg: "Valeur invalide, veuillez réessayer",
          msgType: MessageType.error,
          title: "Erreur");
    }
    prefs.setString('ipConfig', value.toString().trim());
    // print(value);
    BaseUrl.ip = value;
    notifyListeners();
    // print(prefs.getString('ipConfig'));
  }

  int timeOut = 30;

  Future<Response> httpPost({required String url, required Map body}) async {
    // debugPrint("post $body");
    debugPrint("post $url");
    try {
      // print('changing state');
      changeAppState();
      Response response = await http
          .post(Uri.parse(url), body: (body))
          .timeout(Duration(seconds: timeOut));
      isApiReachable = true;
      // print("post" + response.body + "post");
      changeAppState();
      // print('changing state');
      return response;
    } on TimeoutException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message':
                "Echec de connexion, veuillez réessayer. Enregistrement hors connnexion..."
          }),
          500);
    } on SocketException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message':
                "Verifiez votre connexion, enregistrement hors connexion..."
          }),
          500);
    } catch (error) {
      print(error.toString());
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({'data': [], 'message': "Erreur inattendue"}), 503);
    }
  }

  // Future httpPost({required String url, required Map body}) async {
  //   // print(url);
  //   late Response response;
  //   try {
  //     // print('try');
  //     changeAppState();
  //     response = await http
  //         .post(Uri.parse(url), body: (body)
  //             //     , headers: {
  //             //   "Accept": "application/json",
  //             //   "Content-Type": "application/json",
  //             //   'Authorization':
  //             //       'Bearer ${Provider.of<AppStateProvider>(navKey.currentContext!, listen: false).userToken}'
  //             // }
  //             )
  //         .timeout(Duration(seconds: 30));

  //     // print(response.body);
  //     changeAppState();
  //     return response;
  //   } on TimeoutException catch (e) {
  //     print('Timeout');
  //     changeAppState();
  //     return Response("Erreur de connection, veuillez réesayer", 408);
  //   } catch (error) {
  //     print(error.toString());
  //     print('catch');
  //     changeAppState();
  //     return null;
  //   }
  // }

  Future<Response> httpPut({required String url, required Map body}) async {
    // print("put $url");
    try {
      changeAppState();
      Response response = await http
          .put(Uri.parse(url), body: jsonEncode(body), headers: headers)
          .timeout(Duration(seconds: timeOut));
      isApiReachable = true;
      changeAppState();
      return response;
    } on TimeoutException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Echec de connexion, veuillez réessayer"
          }),
          500);
    } on SocketException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({'data': [], 'message': "Verifiez votre connexion"}), 500);
    } catch (error) {
      isApiReachable = false;
      // print(error.toString());
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Une erreur est survenue, veuillez réessayer"
          }),
          503);
    }
  }

  Future<Response> httpDelete({required String url}) async {
    // print("delete $url");
    changeAppState();
    try {
      Response response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeOut));
      // print(response.body);
      isApiReachable = true;
      changeAppState();
      return response;
    } on TimeoutException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Echec de connexion, veuillez réessayer"
          }),
          500);
    } on SocketException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({'data': [], 'message': "Verifiez votre connexion"}), 500);
    } catch (error) {
      isApiReachable = false;
      // print(error.toString());
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Une erreur est survenue, veuillez réessayer"
          }),
          503);
    }
  }

  Future<Response> httpGet({required String url}) async {
    // if (navKey.currentContext!.read<AppStateProvider>().isAsync == true) return;
    // print("get $url");
    changeAppState();
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(Duration(seconds: timeOut));
      isApiReachable = true;
      changeAppState();
      return response;
    } on TimeoutException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Echec de connexion, veuillez réessayer"
          }),
          500);
    } on SocketException {
      isApiReachable = false;
      changeAppState();
      return Response(
          jsonEncode({'data': [], 'message': "Verifiez votre connexion"}), 500);
    } catch (error) {
      isApiReachable = false;
      // print(error.toString());
      changeAppState();
      return Response(
          jsonEncode({
            'data': [],
            'message': "Une erreur est survenue, veuillez réessayer"
          }),
          503);
    }
  }

  Future<bool> syncData() async {
    try {
      // await AppProviders.partnerProvider.syncOfflineData();
      // await AppProviders.analyseToolsProvider.syncOfflineData();
      // await AppProviders.analysesProvider.syncOfflineData();
      // await AppProviders.storesProvider.syncOfflineData();
      // await AppProviders.usersProvider.syncOfflineData();
      // await AppProviders.walletProvider.syncOfflineData();
      // await AppProviders.currencyProvider.syncOfflineData();
      // await AppProviders.sampleProvider.syncOfflineData();
      // await navKey.currentContext!
      //     .read<TransactionProvider>()
      //     .syncOfflineData();
      // await AppProviders.paymentProvider.syncOfflineData();
      // print('sync finished');
      return true;
    } on TimeoutException {
      isApiReachable = false;
      changeAppState();
      return false;
    } on SocketException {
      isApiReachable = false;
      changeAppState();
      return false;
    } catch (error) {
      isApiReachable = false;
      changeAppState();
      return false;
    }
  }
}
