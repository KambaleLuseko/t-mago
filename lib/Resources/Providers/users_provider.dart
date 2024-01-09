import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Resources/Constants/app_providers.dart';
import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Helpers/LocalData/local_data.helper.dart';
import '../../Resources/Models/user.model.dart';
import '../../Views/login.dart';
import '../../main.dart';
import '../Constants/navigators.dart';

class UserProvider extends ChangeNotifier {
  String keyName = 'users';
  List<UserModel> users = [], filteredData = [], offlineData = [];

  save(
      {required UserModel data,
      EnumActions? action = EnumActions.SAVE,
      required Function callback}) async {
    if (data.fullname.isEmpty ||
        data.username.isEmpty ||
        data.password.isEmpty) {
      ToastNotification.showToast(
          msg: "Veuillez remplir tous les champs",
          msgType: MessageType.error,
          title: "Erreur");
      return;
    }
    if (action == EnumActions.UPDATE && data.id == null) {
      ToastNotification.showToast(
          msg: "Données invalides", msgType: MessageType.error, title: "Error");
      return;
    }
    Response res;
    if (action == EnumActions.UPDATE) {
      res = await AppProviders.appProvider
          .httpPut(url: "${BaseUrl.user}${data.id}", body: data.toJSON());
    } else {
      res = await AppProviders.appProvider
          .httpPost(url: BaseUrl.user, body: data.toJSON());
    }
    if (res.statusCode == 200) {
      data.syncStatus = 1;
      LocalDataHelper.saveData(key: keyName, value: data.toJSON());
      ToastNotification.showToast(
          msg: jsonDecode(res.body)['message'] ??
              "Informations sauvegardées avec succès",
          msgType: MessageType.success,
          title: "Success");
    }
    if (res.statusCode == 500) {
      LocalDataHelper.saveData(key: keyName, value: data.toJSON());
      ToastNotification.showToast(
          msg: jsonDecode(res.body)['message'] ??
              'Une erreur est survenue, sauvegarde hors connexion en cours...',
          msgType: MessageType.info,
          title: "Information");
    }
    if (res.statusCode != 200 && res.statusCode != 500) {
      ToastNotification.showToast(
          msg: jsonDecode(res.body)['message'] ??
              'Une erreur est survenue, Veuillez réessayer',
          msgType: MessageType.error,
          title: "Erreur");
      return;
    }
    notifyListeners();
    callback();
  }

  login({required Map data, required Function callback}) async {
    if (data['username'].isEmpty || data['password'].isEmpty) {
      ToastNotification.showToast(
          msg: "Veuillez remplir tous les champs",
          msgType: MessageType.error,
          title: "Erreur");
      return;
    }
    Response res;

    res = await AppProviders.appProvider.httpPost(
        url: BaseUrl.getData, body: {"transaction": "login", ...data});

    if (res.statusCode == 200) {
      if (jsonDecode(res.body) is List && jsonDecode(res.body).length > 1) {
        ToastNotification.showToast(
            align: Alignment.center,
            msg: jsonDecode(res.body)['message'] ??
                "Impossible d'identifier l'utilisateur",
            msgType: MessageType.error,
            title: "Error");
        return;
      }

      if (jsonDecode(res.body) is List && jsonDecode(res.body).length == 1) {
        Map userData = jsonDecode(res.body)[0];
        if (userData['ref_depot'] == null || userData['ref_depot'].isEmpty) {
          ToastNotification.showToast(
              align: Alignment.center,
              msg:
                  "Ce compte n'a aucune affectation, contacter votre administrateur",
              msgType: MessageType.error,
              title: "Error");
          return;
        }
        userData = {"user": userData};
        // print(userData);

        prefs.setString("loggedUser", jsonEncode(userData));
        ToastNotification.showToast(
            msg: "Connexion effectuée avec succès",
            msgType: MessageType.success,
            title: "Success");
        notifyListeners();
        callback();
      } else {
        ToastNotification.showToast(
            align: Alignment.center,
            msg: "Username ou mot de passe incorrect",
            msgType: MessageType.error,
            title: "Error");
        return;
      }
    }
    print(res.body);
    // print(jsonDecode(res.body));
    ToastNotification.showToast(
        align: Alignment.center,
        msg: jsonDecode(res.body) ?? "Username ou mot de passe incorrect",
        msgType: MessageType.error,
        title: "Error");
  }

  AuthModel? userLogged;
  // WalletModel? userWallet;
  // CurrencyModel? defaultCurrency;

  ConnectedUser connectedUser = ConnectedUser.guest;
  getUserData() async {
    String? loggedUser = prefs.getString('loggedUser');
    userLogged =
        loggedUser != null ? AuthModel.fromJSON(jsonDecode(loggedUser)) : null;

    notifyListeners();
  }

  reset() {
    users.clear();
    userLogged = null;
    // userWallet = null;
    offlineData.clear();
    filteredData.clear();
  }

  logOut() {
    prefs.clear();
    // key = ValueKey(DateTime.now().toString());
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalDataHelper.resetLocalData();
      Navigation.pushRemove(page: LoginPage());
      // Navigator.pushReplacement(navKey.currentContext!, MaterialPageRoute(builder: (_) => LoginPage()));
    });
    // Navigation.pushRemove(page: const LoginPage());
  }
}
