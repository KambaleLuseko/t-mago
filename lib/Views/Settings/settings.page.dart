import '../../Resources/Components/dialogs.dart';
import '../../Resources/Components/list_item.dart';
import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Constants/navigators.dart';
import 'ip.config.dart';
import 'sync_dat.page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigation.pushNavigate(
                    page: const SyncDataPage(), isFullDialog: true);
              },
              leading: Icon(Icons.sync_sharp, color: AppColors.kBlackColor),
              title: TextWidgets.textBold(
                  title: 'Synchonisation',
                  fontSize: 18,
                  textColor: AppColors.kBlackColor),
              subtitle: TextWidgets.text300(
                  title: 'Synchroniser les donnees enregistrees hors connexion',
                  fontSize: 14,
                  textColor: AppColors.kBlackColor),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: AppColors.kGreyColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
