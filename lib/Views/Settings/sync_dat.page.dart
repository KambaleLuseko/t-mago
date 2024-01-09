import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Providers/sync.provider.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({Key? key}) : super(key: key);

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<SyncProvider>().getData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Synchronisation')),
      floatingActionButton: (context.watch<SyncProvider>().isSynching == false)
          ? FloatingActionButton(
              backgroundColor: AppColors.kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                context.read<SyncProvider>().syncData();
              },
              child: Icon(Icons.sync, color: AppColors.kWhiteColor),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3 / 2,
                crossAxisCount: 2,
                children: [
                  SyncItem(
                    title: 'Clients',
                    icon: Icons.person,
                    description: context
                            .select<SyncProvider, int>(
                                (provider) => provider.cultivatorData.length)
                            .toString() +
                        ' enregistrés',
                  ),
                  SyncItem(
                    title: 'Champs',
                    icon: Icons.fiber_smart_record_outlined,
                    description: context
                            .watch<SyncProvider>()
                            .fieldData
                            .length
                            .toString() +
                        ' enregistrés',
                  ),
                  SyncItem(
                    title: 'Entres',
                    icon: Icons.call_missed,
                    description: context
                            .watch<SyncProvider>()
                            .mouvementData
                            .where((element) =>
                                element.mouvementType
                                    .toString()
                                    .toLowerCase() !=
                                'sortie')
                            .toList()
                            .length
                            .toString() +
                        ' enregistrés',
                  ),
                  SyncItem(
                    title: 'Sorties',
                    icon: Icons.call_missed_outgoing,
                    description: context
                            .watch<SyncProvider>()
                            .mouvementData
                            .where((element) =>
                                element.mouvementType
                                    .toString()
                                    .toLowerCase() ==
                                'sortie')
                            .toList()
                            .length
                            .toString() +
                        ' enregistrés',
                  ),
                ],
              ),
              if (context.watch<SyncProvider>().isSynching == true)
                Selector<SyncProvider, double>(
                    builder: (_, syncPercent, __) {
                      return Column(
                        children: [
                          TextWidgets.textBold(
                              title: 'Synchronisation en cours...',
                              fontSize: 16,
                              textColor: AppColors.kBlackColor),
                          // TextWidgets.text300(
                          //     title: syncPercent.toString() + '%',
                          //     fontSize: 16,
                          //     textColor: AppColors.kBlackColor)
                        ],
                      );
                    },
                    selector: (_, provider) => provider.syncPercent)
            ],
          ),
        ),
      ),
    );
  }
}

class SyncItem extends StatelessWidget {
  String title, description;
  IconData icon;
  SyncItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.kBlackColor, size: 40),
            const Spacer(),
            TextWidgets.textBold(
                title: title, fontSize: 22, textColor: AppColors.kBlackColor),
            const SizedBox(
              height: 8,
            ),
            TextWidgets.text300(
                title: description,
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ],
        ),
      ),
    );
  }
}
