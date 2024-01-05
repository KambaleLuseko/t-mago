import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/mouvement.model.dart';
import '../../Resources/Providers/app_state_provider.dart';
import '../../Resources/Providers/cultivator.provider.dart';
import '../../Resources/Providers/fields.provider.dart';
import '../../Resources/Providers/mouvement.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidgets.textBold(
                        title: 'Dashboard',
                        fontSize: 24,
                        textColor: AppColors.kBlackColor),
                    IconButton(
                        onPressed: () {
                          if (context.read<AppStateProvider>().isAsync ==
                              true) {
                            return;
                          }
                          context
                              .read<CultivatorProvider>()
                              .getOnline(isRefresh: true);
                          context
                              .read<FieldsProvider>()
                              .getOnline(isRefresh: true);
                          context
                              .read<MouvementProvider>()
                              .getOnline(isRefresh: true);
                          context
                              .read<MouvementProvider>()
                              .getOnlineStores(isRefresh: true);
                          context
                              .read<MouvementProvider>()
                              .getOnlinePrices(isRefresh: true);
                        },
                        icon:
                            Icon(Icons.autorenew, color: AppColors.kBlackColor))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                childAspectRatio: 3 / 2.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 2,
                children: [
                  CountItem(
                    title: 'Clients',
                    value: context
                        .select<CultivatorProvider, int>(
                            (provider) => provider.offlineData.length)
                        .toString(),
                    subtitle: 'Clients enregistrés',
                  ),
                  // CountItem(
                  //   title: 'Champs',
                  //   value: context
                  //       .select<FieldsProvider, int>(
                  //           (provider) => provider.offlineData.length)
                  //       .toString(),
                  //   subtitle: 'Champs enregistrés',
                  // ),
                  CountItem(
                    title: 'Entrées',
                    value: context
                        .select<MouvementProvider, List<MouvementModel>>(
                            (provider) => provider.offlineData)
                        .where((element) =>
                            element.mouvementType.toLowerCase() != 'sortie')
                        .length
                        .toString(),
                    subtitle: 'Mouvements enregistrés',
                  ),
                  CountItem(
                    title: 'Sorties',
                    value: context
                        .select<MouvementProvider, List<MouvementModel>>(
                            (provider) => provider.offlineData)
                        .where((element) =>
                            element.mouvementType.toLowerCase() == 'sortie')
                        .length
                        .toString(),
                    subtitle: 'Mouvements enregistrés',
                  ),
                  CountItem(
                    callback: () {
                      context
                          .read<MouvementProvider>()
                          .getOnlineStores(isRefresh: true);
                    },
                    title: 'Dépôts',
                    value: context
                        .select<MouvementProvider, int>(
                            (provider) => provider.offlineStoreData.length)
                        .toString(),
                    subtitle: 'Dépôts enregistrés',
                  ),
                  CountItem(
                    callback: () {
                      context
                          .read<MouvementProvider>()
                          .getOnlinePrices(isRefresh: true);
                    },
                    title: 'Prix',
                    value: context
                        .select<MouvementProvider, int>(
                            (provider) => provider.offlinePricesData.length)
                        .toString(),
                    subtitle: 'Prix enregistrés',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountItem extends StatelessWidget {
  final String title, value;
  final String? subtitle;
  Function()? callback;
  CountItem(
      {Key? key,
      required this.title,
      required this.value,
      this.subtitle,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppColors.kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets.textBold(
                    title: title,
                    fontSize: 14,
                    textColor: AppColors.kBlackColor),
                if (callback != null)
                  GestureDetector(
                    onTap: () {
                      if (callback == null) return;
                      callback!();
                    },
                    child: Container(
                        color: AppColors.kTransparentColor,
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.autorenew,
                            color: AppColors.kBlackColor)),
                  )
              ],
            ),
            const Spacer(),
            TextWidgets.textBold(
                title: value, fontSize: 40, textColor: AppColors.kBlackColor),
            const Spacer(),
            TextWidgets.text300(
                maxLines: 1,
                title: subtitle ?? '',
                fontSize: 12,
                textColor: AppColors.kBlackColor),
          ],
        ),
      ),
    );
  }
}
