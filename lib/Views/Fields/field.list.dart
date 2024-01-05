import '../../Resources/Components/list_item.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Helpers/date_parser.dart';
import '../../Resources/Models/Menu/list_item.model.dart';
import '../../Resources/Models/field.model.dart';
import '../../Resources/Providers/fields.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FieldsListPage extends StatefulWidget {
  const FieldsListPage({Key? key}) : super(key: key);

  @override
  State<FieldsListPage> createState() => _FieldsListPageState();
}

class _FieldsListPageState extends State<FieldsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FieldsProvider>().getOffline();
    });
  }

  List<Map> printList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        context.read<FieldsProvider>().getOnline(isRefresh: true);
        printList.clear();
        setState(() {});
      },
      child: Selector<FieldsProvider, List<FieldsModel>>(
          builder: (context, offlineData, _) {
            return ListView.builder(
                itemCount: offlineData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // onLongPress: () {
                    //   if (printList
                    //       .map((e) => e['designation'].toString().toLowerCase())
                    //       .contains(dataList[index]['designation']
                    //           .toString()
                    //           .toLowerCase())) {
                    //     printList.remove(dataList[index]);
                    //     setState(() {});
                    //     return;
                    //   }
                    //   printList.add(dataList[index]);
                    //   setState(() {});
                    // },
                    child: ListItem(
                      icon: Icons.fiber_smart_record_outlined,
                      title: offlineData[index].owner?.nom ??
                          offlineData[index].adresseCh.toString().toUpperCase(),
                      subtitle: offlineData[index].surfaceCh.toString(),
                      backColor: AppColors.kWhiteColor,
                      textColor: AppColors.kBlackColor,
                      // hasDelete: printList
                      //         .map((e) =>
                      //             e['designation'].toString().toLowerCase())
                      //         .contains(dataList[index]['designation']
                      //             .toString()
                      //             .toLowerCase())
                      //     ? true
                      //     : false,
                      // deleteIcon: Icons.check_circle_outline_rounded,
                      // deleteCallback: null,
                      keepMidleFields: true,
                      middleFields: ListItemModel(
                          title: 'Status',
                          value: offlineData[index].syncStatus == 1 ? 's' : '',
                          icon: Icon(offlineData[index].syncStatus == 1
                              ? Icons.cloud_done_rounded
                              : Icons.watch_later)),
                      detailsFields: [
                        // if (offlineData[index].owner != null)
                        ListItemModel(
                            displayLabel: true,
                            title: 'Adresse',
                            value: offlineData[index].adresseCh),
                        ListItemModel(
                            displayLabel: true,
                            title: 'Localisation',
                            value:
                                "${offlineData[index].logitude?.toString() ?? ''}-${offlineData[index].latitude?.toString() ?? ''}"),
                        ListItemModel(
                            displayLabel: true,
                            title: 'Produis',
                            value:
                                offlineData[index].produit?.toString() ?? ''),
                        ListItemModel(
                            displayLabel: true,
                            title: 'Annee debut',
                            value: offlineData[index].anneeDebut?.toString() ??
                                ''),
                        ListItemModel(
                            displayLabel: true,
                            title: 'Derniere production',
                            value: parseDate(
                                date: offlineData[index]
                                        .anneeLastoOpera
                                        ?.toString() ??
                                    DateTime.now().toString())),
                      ],
                      hasUpdate: true,
                      updateIcon: Icons.border_color,
                    ),
                  );
                });
          },
          selector: (_, provider) => provider.offlineData),
    ));
  }
}
