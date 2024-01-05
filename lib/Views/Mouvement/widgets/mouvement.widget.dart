import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/enums.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Constants/navigators.dart';
import '../../../Resources/Helpers/date_parser.dart';
import '../../../Resources/Helpers/printer.helper.dart';
import '../../../Resources/Models/cultivator.model.dart';
import '../../../Resources/Models/mouvement.model.dart';
import '../../../Resources/Providers/mouvement.provider.dart';
import '../../../Resources/Providers/users_provider.dart';
import '../mouvement.add.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MouvementItemWidget extends StatelessWidget {
  final MouvementModel data;
  const MouvementItemWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Dialogs.showBottomModalSheet(
            content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if ((context
                    .read<MouvementProvider>()
                    .offlineData
                    .where((element) =>
                        element.refMvtEntry?.trim() == data.uuid?.trim() &&
                        element.mouvementType.toLowerCase() ==
                            'sortie'.toLowerCase())
                    .toList()
                    .isEmpty))
                  Expanded(
                    child: CustomButton(
                        text: 'Enregistrer la sortie',
                        backColor: AppColors.kPrimaryColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          // print(offlineData
                          //     .where((element) =>
                          //         element.refMvtEntry
                          //                 ?.trim() ==
                          //             data
                          //                 .uuid
                          //                 ?.trim() &&
                          //         element.mouvementType
                          //                 .toLowerCase() ==
                          //             'sortie'
                          //                 .toLowerCase())
                          //     .toList());
                          Navigator.pop(context);
                          if ((context
                              .read<MouvementProvider>()
                              .offlineData
                              .where((element) =>
                                  element.refMvtEntry?.trim() ==
                                  data.uuid?.trim())
                              .toList()
                              .isNotEmpty)) {
                            ToastNotification.showToast(
                                msg:
                                    'Ce mouvement a deja une sortie et ne peut avoir qu\'une seule sortie de l\'entrepot',
                                title: "Erreur",
                                msgType: MessageType.error);
                            // setState(() {});
                            return;
                          }
                          context.read<MouvementProvider>().newMouvement
                            ..storeID = context
                                .read<UserProvider>()
                                .userLogged!
                                .user
                                .refDepot!
                            ..mouvementType = 'Sortie'.toUpperCase()
                            ..detailsMouvement = data.detailsMouvement
                            ..senderID = data.senderID
                            ..sender = data.sender
                            ..receiverName = data.receiverName
                            ..receiverTel = data.receiverTel
                            ..refMvtEntry = data.uuid
                            ..destination = data.storeName;
                          // Navigator.pop(context);
                          Navigation.pushNavigate(
                              page: AddMouvementPage(
                                  data: data.detailsMouvement, pageIndex: 2));
                        }),
                  ),
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
                      icon: Icon(Icons.print, color: AppColors.kPrimaryColor)),
                )
              ],
            ),
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
            TextWidgets.textHorizontalWithLabel(
                title: 'Expéditeur',
                fontSize: 16,
                textColor: AppColors.kBlackColor,
                value: data.sender?.fullname ?? ''),
            TextWidgets.textHorizontalWithLabel(
                title: 'Contact',
                fontSize: 16,
                textColor: AppColors.kBlackColor,
                value: data.sender?.tel ?? ''),
            const SizedBox(
              height: 16,
            ),
            TextWidgets.textHorizontalWithLabel(
                title: 'Destinataire',
                fontSize: 16,
                textColor: AppColors.kBlackColor,
                value: data.receiverName ?? 'Unknown'),
            TextWidgets.textHorizontalWithLabel(
                title: 'Contact',
                fontSize: 16,
                textColor: AppColors.kBlackColor,
                value: data.receiverTel ?? 'Unknown'),
            TextWidgets.textHorizontalWithLabel(
                title: 'Total à payer',
                fontSize: 16,
                textColor: AppColors.kGreenColor,
                value: data.detailsMouvement
                        .map((e) => double.parse(e.totalNetWeight!))
                        .fold(
                            0.0,
                            (prev, element) =>
                                double.parse(prev.toString()) + element)
                        .toStringAsFixed(3) +
                    ' USD'),
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
                color: AppColors.kScaffoldColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ListTile(
                      title: TextWidgets.textBold(
                          title: detData.storageType,
                          fontSize: 16,
                          textColor: AppColors.kBlackColor),
                      subtitle: TextWidgets.text300(
                          title: "${detData.weights}kg",
                          fontSize: 14,
                          textColor: AppColors.kBlackColor),
                      // trailing: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   crossAxisAlignment:
                      //       CrossAxisAlignment.end,
                      //   children: [
                      //     TextWidgets.text300(
                      //         title:
                      //             "${detData.weights}kg",
                      //         fontSize: 14,
                      //         textColor:
                      //             AppColors.kBlackColor),
                      //     TextWidgets.textBold(
                      //         title:
                      //             "${double.parse(detData.priceValue ?? '0').toStringAsFixed(4)} USD",
                      //         fontSize: 16,
                      //         textColor:
                      //             AppColors.kBlackColor),
                      //   ],
                      // )
                    ),
                    ListTile(
                      title: Wrap(
                        children: [
                          // TextWidgets.textWithLabel(
                          //     title: 'Humidite',
                          //     value:
                          //         "-${detData.decoteHumidite ?? '0'} USD",
                          //     fontSize: 12,
                          //     textColor:
                          //         AppColors.kBlackColor),
                          TextWidgets.textWithLabel(
                              title: 'Poids',
                              value: "${detData.weights}kg",
                              fontSize: 12,
                              textColor: AppColors.kBlackColor),
                          TextWidgets.textWithLabel(
                              title: 'Prix par kg',
                              value: "${double.parse(detData.priceID)} USD",
                              fontSize: 12,
                              textColor: AppColors.kBlackColor),
                          // TextWidgets.textWithLabel(
                          //     title: 'Prix net/kg',
                          //     value:
                          //         "${detData.netPrice} USD",
                          //     fontSize: 12,
                          //     textColor:
                          //         AppColors.kBlackColor),
                          TextWidgets.textWithLabel(
                              title: 'Prix total net a payer',
                              value:
                                  "${double.parse(detData.totalNetWeight ?? '0').toStringAsFixed(4)} USD",
                              fontSize: 12,
                              textColor: AppColors.kRedColor),
                        ],
                      ),
                    )
                  ],
                ),
              );
            })
          ],
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
          SizedBox(
            width: double.maxFinite,
            height: 120,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset('Assets/Illustrations/store.png', fit: BoxFit.cover),
              Positioned(
                  top: 24,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                title: "ID-" + (data.uuid ?? ''),
                                fontSize: 12,
                                textColor: AppColors.kWhiteColor)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                                title: data.detailsMouvement
                                        .map((e) =>
                                            double.parse(e.totalNetWeight!))
                                        .fold(
                                            0.0,
                                            (prev, element) =>
                                                double.parse(prev.toString()) +
                                                element)
                                        .toStringAsFixed(3) +
                                    ' USD',
                                fontSize: 12,
                                textColor: AppColors.kWhiteColor)),
                      ),
                    ],
                  ))
            ]),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidgets.textBold(
                              title: 'Destinataire',
                              fontSize: 10,
                              textColor: AppColors.kBlackColor),
                          TextWidgets.textBold(
                              title: data.receiverName ?? '',
                              fontSize: 14,
                              textColor: AppColors.kBlackColor),
                          TextWidgets.text300(
                              title: data.receiverTel ?? '',
                              fontSize: 14,
                              textColor: AppColors.kGreyColor),
                        ],
                      ),
                    )),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.kRedColor,
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
