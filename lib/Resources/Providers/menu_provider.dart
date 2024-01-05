import '../../Views/Client/client.page.dart';
import '../../Views/Mouvement/mouvement.page.dart';
import '../../Views/Settings/settings.page.dart';
import 'package:flutter/material.dart';

import '../../Resources/Models/Menu/menu.model.dart';
import '../../Views/Home/home.page.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuModel> menus = [
    MenuModel(
        title: "Accueil", page: const HomePage(), icon: Icons.home_filled),
    // MenuModel(
    //     title: "Marchandise", page: const GoodsPage(), icon: Icons.category),
    MenuModel(title: "Clients", page: const ClientPage(), icon: Icons.person),
    // MenuModel(
    //     title: "Champs",
    //     page: const FieldsPage(),
    //     icon: Icons.fiber_smart_record_outlined),
    MenuModel(
        title: "Mouvement",
        page: const MouvementPage(),
        icon: Icons.transfer_within_a_station),
    MenuModel(
        title: "Settings", page: const SettingsPage(), icon: Icons.settings),
  ];

  MenuModel activePage = MenuModel(
      title: "Accueil", page: const HomePage(), icon: Icons.home_filled);
  reset() {
    activePage = MenuModel(
        title: "Accueil", page: const HomePage(), icon: Icons.home_filled);
    menus.clear();
  }

  getActivePage() => activePage;

  setActivePage({required MenuModel newPage}) {
    activePage = newPage;
    notifyListeners();
  }
}
