import '../../Resources/Constants/navigators.dart';
import 'field.add.dart';
import 'field.list.dart';
import '../parent.page.dart';
import 'package:flutter/material.dart';

class FieldsPage extends StatelessWidget {
  const FieldsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentPage(
        title: 'Champs',
        listWidget: const FieldsListPage(),
        callback: () {
          Navigation.pushNavigate(
              page: const AddFieldPage(), isFullDialog: true);
        });
  }
}
