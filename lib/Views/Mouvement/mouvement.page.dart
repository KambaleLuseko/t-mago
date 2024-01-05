import '../../Resources/Constants/navigators.dart';
import '../../Resources/Providers/mouvement.provider.dart';
import 'mouvement.add.dart';
import 'mouvement.list.dart';
import '../parent.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MouvementPage extends StatelessWidget {
  const MouvementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentPage(
        title: 'Mouvements',
        listWidget: const MouvementListPage(),
        callback: () {
          context.read<MouvementProvider>().newMouvement.mouvementType =
              "Entree".toUpperCase();
          Navigation.pushNavigate(page: AddMouvementPage(), isFullDialog: true);
        });
  }
}
