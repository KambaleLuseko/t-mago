import '../../Resources/Constants/navigators.dart';
import 'client.add.dart';
import 'client.list.dart';
import '../parent.page.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentPage(
        title: 'Clients',
        listWidget: const ClientListPage(),
        callback: () {
          Navigation.pushNavigate(
              page: const AddClientPage(), isFullDialog: true);
        });
  }
}
