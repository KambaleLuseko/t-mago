import '../../../Resources/Components/card.dart';
import '../../../Resources/Components/list_item.dart';
import '../../../Resources/Helpers/date_parser.dart';
import '../../../Resources/Models/Menu/list_item.model.dart';
import 'tracking.widget.dart';

import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Helpers/printer.helper.dart';
import '../../../Resources/Models/cultivator.model.dart';
import '../../../Resources/Models/mouvement.model.dart';
import 'package:flutter/material.dart';

class MouvementItemWidget extends StatelessWidget {
  final MouvementModel data;
  const MouvementItemWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Dialogs.showBottomModalSheet(
            content: Container(
          color: AppColors.kScaffoldColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Dialogs.showChoiceDialog(
                              title: 'Impression',
                              content: Column(
                                children: [
                                  CustomButton(
                                      text: 'Imprimer le recu',
                                      backColor: AppColors.kGreenColor,
                                      textColor: AppColors.kWhiteColor,
                                      callback: () {
                                        printReport(
                                            client: ClientModel(
                                                nom: data.sender?.nom ?? '',
                                                postnom:
                                                    data.sender?.postnom ?? '',
                                                tel: data.sender?.tel ?? '',
                                                adresse: "Unknown"),
                                            data: data);
                                      }),
                                  CustomButton(
                                      text: 'Imprimer les QR Codes',
                                      backColor: AppColors.kRedColor,
                                      textColor: AppColors.kWhiteColor,
                                      callback: () {}),
                                ],
                              ));
                        },
                        icon:
                            Icon(Icons.print, color: AppColors.kPrimaryColor)),
                  )
                ],
              ),
              MouvementDetailsPage(data: data)
            ],
          ),
        ));
      },
      child: Card(
        color: AppColors.kWhiteColor,
        elevation: 1,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(16),
        )),
        // padding: EdgeInsets.zero,
        child: Column(children: [
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Card(
              margin: EdgeInsets.zero,
              color: AppColors.kPrimaryColor,
              elevation: 1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24))),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  child: TextWidgets.text300(
                      title: "ID-" + (data.uuid ?? ''),
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TrackingWidget.buildTrackWidget(
              title: data.storeName ?? '',
              subtitle: data.storeAddress ?? '',
              color: AppColors.kBlackColor,
              isLast: false,
              date: ''),
          TrackingWidget.buildTrackWidget(
              title: data.destStoreName ?? '',
              subtitle: data.destStoreAddress ?? '',
              color: AppColors.kBlackColor,
              isLast: true,
              date: ''),
          // SizedBox(
          //   width: double.maxFinite,
          //   height: 120,
          //   child: Stack(fit: StackFit.expand, children: [
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Image.asset('Assets/Images/logo.png', fit: BoxFit.fitHeight),
          //         Flexible(
          //             child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             TextWidgets.textBold(
          //                 title: 'T-Mago',
          //                 fontSize: 18,
          //                 textColor: AppColors.kBlackColor),
          //             TextWidgets.text500(
          //                 title: 'LOGISTICS+',
          //                 fontSize: 18,
          //                 textColor: AppColors.kBlackColor),
          //           ],
          //         ))
          //       ],
          //     ),
          //     Positioned(
          //         top: 24,
          //         left: 0,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Card(
          //               margin: EdgeInsets.zero,
          //               color: AppColors.kRedColor,
          //               elevation: 1,
          //               shape: const RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.only(
          //                       topRight: Radius.circular(24),
          //                       bottomRight: Radius.circular(24))),
          //               child: Container(
          //                   padding: const EdgeInsets.all(8),
          //                   child: TextWidgets.text300(
          //                       title: "ID-" + (data.uuid ?? ''),
          //                       fontSize: 12,
          //                       textColor: AppColors.kWhiteColor)),
          //             ),
          //             const SizedBox(
          //               height: 16,
          //             ),
          //             Card(
          //               margin: EdgeInsets.zero,
          //               color: AppColors.kRedColor,
          //               elevation: 1,
          //               shape: const RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.only(
          //                       topRight: Radius.circular(24),
          //                       bottomRight: Radius.circular(24))),
          //               child: Container(
          //                   padding: const EdgeInsets.all(8),
          //                   child: TextWidgets.text300(
          //                       title: data.detailsMouvement
          //                               .map((e) =>
          //                                   double.parse(e.totalNetWeight!))
          //                               .fold(
          //                                   0.0,
          //                                   (prev, element) =>
          //                                       double.parse(prev.toString()) +
          //                                       element)
          //                               .toStringAsFixed(3) +
          //                           ' USD',
          //                       fontSize: 12,
          //                       textColor: AppColors.kWhiteColor)),
          //             ),
          //           ],
          //         ))
          //   ]),
          // ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.kRedColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24))),
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          child: TextWidgets.text300(
                              title: 'Pending',
                              fontSize: 12,
                              textColor: AppColors.kWhiteColor)),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.kPrimaryColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24))),
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            data.syncStatus == 1
                                ? Icons.cloud_done_rounded
                                : Icons.watch_later,
                            color: AppColors.kWhiteColor,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgets.text500(
                          title: 'Details',
                          fontSize: 12,
                          textColor: AppColors.kGreyColor),
                      Icon(Icons.arrow_forward_ios,
                          color: AppColors.kGreyColor, size: 16)
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ]),
      ),
    );
  }
}

class MouvementDetailsPage extends StatelessWidget {
  MouvementModel data;
  MouvementDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidgets.textHorizontalWithLabel(
            title: 'ID',
            fontSize: 16,
            textColor: AppColors.kBlackColor,
            value: data.uuid ?? ''),
        TextWidgets.textHorizontalWithLabel(
            title: 'Date',
            fontSize: 16,
            textColor: AppColors.kBlackColor,
            value: parseDate(date: data.createdAt ?? '')
                .toString()
                .substring(0, 10)),
        ListItem(
          icon: Icons.person,
          title: data.senderName ?? '',
          subtitle: data.senderTel ?? '',
          middleFields:
              ListItemModel(displayLabel: true, title: 'Exp', value: 'Exp'),
          keepMidleFields: true,
          backColor: AppColors.kWhiteColor,
          textColor: AppColors.kBlackColor,
          detailsFields: const [],
        ),
        ListItem(
          icon: Icons.person,
          title: data.receiverName ?? '',
          subtitle: data.receiverTel ?? '',
          middleFields:
              ListItemModel(displayLabel: true, title: 'Dest', value: 'Dest'),
          keepMidleFields: true,
          backColor: AppColors.kWhiteColor,
          textColor: AppColors.kBlackColor,
          detailsFields: const [],
        ),
        Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 0,
          // color: AppColors.kScaffoldColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Column(
              children: [
                TrackingWidget.buildTrackWidget(
                    title: data.storeName ?? '',
                    subtitle: data.storeAddress ?? '',
                    color: AppColors.kBlackColor,
                    isLast: false,
                    date: ''),
                TrackingWidget.buildTrackWidget(
                    title: data.destStoreName ?? '',
                    subtitle: data.destStoreAddress ?? '',
                    color: AppColors.kBlackColor,
                    isLast: true,
                    date: ''),
                const SizedBox(
                  height: 0,
                ),
                TextWidgets.textHorizontalWithLabel(
                    title: 'Total à payer',
                    fontSize: 16,
                    textColor: AppColors.kGreenColor,
                    value: data.detailsMouvement
                            .map((e) => double.parse(e.netPrice!))
                            .fold(
                                0.0,
                                (prev, element) =>
                                    double.parse(prev.toString()) + element)
                            .toStringAsFixed(3) +
                        ' USD'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextWidgets.textBold(
            title: 'Contenu',
            fontSize: 16,
            textColor: AppColors.kBlackColor,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ...List.generate(data.detailsMouvement.length, (indexDet) {
          MouvementDetailsModel detData = data.detailsMouvement[indexDet];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: 0,
            color: AppColors.kWhiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextWidgets.textBold(
                      title: detData.storageType,
                      fontSize: 16,
                      textColor: AppColors.kBlackColor),
                ),
                ListTile(
                  title: Wrap(
                    children: [
                      TextWidgets.textWithLabel(
                          title: 'Description',
                          value: detData.product,
                          fontSize: 12,
                          textColor: AppColors.kBlackColor),
                      TextWidgets.textWithLabel(
                          title: 'Poids',
                          value: "${detData.weights}kg",
                          fontSize: 12,
                          textColor: AppColors.kBlackColor),
                      TextWidgets.textWithLabel(
                          title: 'Prix total net a payer',
                          value:
                              "${double.parse(detData.netPrice ?? '0').toStringAsFixed(4)} USD",
                          fontSize: 12,
                          textColor: AppColors.kRedColor),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardWidget(
              elevation: 0,
              title: 'Tracking',
              content: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  ...List.generate(data.tracking!.length, (index) {
                    MouvementTrackingModel trackData = data.tracking![index];
                    return Column(
                      children: [
                        TrackingWidget.buildTrackWidget(
                            date: trackData.createdAt ?? '',
                            title: trackData.label ?? 'Unknown',
                            subtitle: trackData.storeName ?? '',
                            color: AppColors.kBlackColor,
                            isLast: trackData.destDepotId != '0' &&
                                    trackData.destDepotId != null
                                ? false
                                : data.tracking!.length == 1
                                    ? true
                                    : index == data.tracking!.length - 1
                                        ? true
                                        : false),
                        if (trackData.destDepotId != '0' &&
                            trackData.destDepotId != null)
                          Row(
                            children: [
                              const SizedBox(
                                width: 48,
                              ),
                              Expanded(
                                child: TrackingWidget.buildTrackWidget(
                                    date: '',
                                    title: trackData.destStoreName ?? '',
                                    subtitle: 'Destination',
                                    color: AppColors.kRedColor,
                                    isLast: data.tracking!.length == 1
                                        ? true
                                        : index == data.tracking!.length - 1
                                            ? true
                                            : false),
                              )
                            ],
                          )
                      ],
                    );
                  })
                ],
              )),
        )
      ],
    );
  }
}
