import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/Components/list_item.dart';
import '../../Resources/Components/search_textfield.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Helpers/date_parser.dart';
import '../../Resources/Models/Menu/list_item.model.dart';
import '../../Resources/Models/cultivator.model.dart';
import '../../Resources/Providers/cultivator.provider.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key? key}) : super(key: key);

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final TextEditingController _searchCtrller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CultivatorProvider>().getOffline();
    });
  }

  List<Map> printList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        context.read<CultivatorProvider>().getOnline(isRefresh: true);
        printList.clear();
        setState(() {});
      },
      child: Column(
        children: [
          SearchTextFormFieldWidget(
              hintText: 'Recherche',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
              editCtrller: _searchCtrller,
              maxLines: 1),
          Expanded(
            child: Selector<CultivatorProvider, List<ClientModel>>(
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
                            icon: Icons.person,
                            title:
                                "${offlineData[index].nom.toString().toUpperCase()} ${offlineData[index].postnom.toString().toUpperCase()} ${offlineData[index].prenom?.toString().toUpperCase() ?? ''}",
                            subtitle: offlineData[index].tel.toString(),
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
                            detailsFields: [
                              ListItemModel(
                                  displayLabel: true,
                                  title: 'Adresse',
                                  value: offlineData[index].adresse.toString()),
                              ListItemModel(
                                  displayLabel: true,
                                  title: 'Date',
                                  value: parseDate(
                                      date: offlineData[index]
                                          .createdAt!
                                          .toString())),
                            ],
                            keepMidleFields: true,
                            middleFields: ListItemModel(
                                title: 'Status',
                                value: offlineData[index].syncStatus == 1
                                    ? 's'
                                    : '',
                                icon: Icon(offlineData[index].syncStatus == 1
                                    ? Icons.cloud_done_rounded
                                    : Icons.watch_later)),
                            hasUpdate: true,
                            updateIcon: Icons.border_color,
                          ),
                        );
                      });
                },
                selector: (_, provider) => provider.offlineData),
          ),
        ],
      ),
    ));
  }
}
