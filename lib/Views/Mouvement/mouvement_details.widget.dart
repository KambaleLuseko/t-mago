import 'dart:io';

import 'package:t_mago/Views/Mouvement/widgets/product_details.widget.dart';

import '../../Resources/Components/button.dart';
import '../../Resources/Components/dialogs.dart';
import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/mouvement.model.dart';
import '../../Resources/Providers/humidity.provider.dart';
import '../../Resources/Providers/mouvement.provider.dart';
import '../../Resources/Providers/users_provider.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MouvementDetailsWidget extends StatefulWidget {
  final Function() backCallback;
  List<MouvementDetailsModel>? data;
  MouvementDetailsWidget(
      {Key? key, required this.backCallback, this.data = const []})
      : super(key: key);

  @override
  State<MouvementDetailsWidget> createState() => _MouvementDetailsWidgetState();
}

class _MouvementDetailsWidgetState extends State<MouvementDetailsWidget> {
  // String? uom;
  List<MouvementDetailsModel> data = [];
  Future<File>? file;
  String? base64Image;
  File? tmpFile;
  @override
  void initState() {
    super.initState();
    if (widget.data != null && widget.data!.isNotEmpty) {
      data = widget.data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextWidgets.textHorizontalWithLabel(
                    title: 'Mouvement',
                    fontSize: 16,
                    textColor: AppColors.kBlackColor,
                    value: context
                        .select<MouvementProvider, MouvementModel>(
                            (provider) => provider.newMouvement)
                        .mouvementType),
                TextWidgets.textHorizontalWithLabel(
                    title: 'Expéditeur',
                    fontSize: 16,
                    textColor: AppColors.kBlackColor,
                    value: context
                            .select<MouvementProvider, MouvementModel>(
                                (provider) => provider.newMouvement)
                            .senderName ??
                        ''),
                TextWidgets.textHorizontalWithLabel(
                    title: 'Destinataire',
                    fontSize: 16,
                    textColor: AppColors.kBlackColor,
                    value: context
                            .select<MouvementProvider, MouvementModel>(
                                (provider) => provider.newMouvement)
                            .receiverName ??
                        ''),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextWidgets.textBold(
                title: "Contenu",
                fontSize: 16,
                textColor: AppColors.kBlackColor),
          ),
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        if (widget.data == null || widget.data!.isEmpty)
          ListTile(
            onTap: () {
              Dialogs.showChoiceDialog(
                title: 'Nouveau produit',
                content: ProductDetailsWidget(
                  callback: (item) {
                    data.add(item);
                    setState(() {});
                  },
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: AppColors.kTextFormBackColor,
              child: Icon(Icons.add, color: AppColors.kBlackColor),
            ),
            title: TextWidgets.textBold(
                title: 'Nouveau colis',
                fontSize: 18,
                textColor: AppColors.kBlackColor),
            subtitle: TextWidgets.text300(
                title: 'Ajouter un colis à stocker',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<HumidityPricesProvider>()
                  .getOnlineHumidity(isRefresh: true);
            },
            child: ListView(
              children: [
                ...List.generate(
                    data.length,
                    (index) => Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.kTextFormBackColor,
                                  child: Icon(Icons.shopping_basket,
                                      color: AppColors.kBlackColor),
                                ),
                                title: TextWidgets.textBold(
                                    title: data[index].storageType,
                                    fontSize: 18,
                                    textColor: AppColors.kBlackColor),
                                subtitle: TextWidgets.text300(
                                    title: "${data[index].weights} kg",
                                    fontSize: 14,
                                    textColor: AppColors.kBlackColor),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // TextWidgets.text300(
                                    //     title: "${data[index].weights} kg",
                                    //     fontSize: 14,
                                    //     textColor: AppColors.kBlackColor),
                                    // const SizedBox(
                                    //   height: 8,
                                    // ),
                                    TextWidgets.textBold(
                                        title:
                                            "${double.parse(data[index].netPrice ?? '0')} USD",
                                        fontSize: 14,
                                        textColor: AppColors.kBlackColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                    text: 'Retour',
                    backColor: Colors.grey.shade400,
                    textColor: AppColors.kBlackColor,
                    callback: () {
                      widget.backCallback();
                    }),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: CustomButton(
                    canSync: true,
                    text: 'Enregistrer',
                    backColor: AppColors.kPrimaryColor,
                    textColor: AppColors.kWhiteColor,
                    callback: () {
                      if (data.isEmpty) {
                        ToastNotification.showToast(
                            msg: 'Aucun contenu spécifié',
                            msgType: MessageType.error,
                            title: 'Erreur');
                        return;
                      }
                      context.read<MouvementProvider>().newMouvement.userID =
                          context
                              .read<UserProvider>()
                              .userLogged!
                              .user
                              .id!
                              .toString();

                      context
                          .read<MouvementProvider>()
                          .newMouvement
                          .detailsMouvement = data;
                      // print(context
                      //     .read<MouvementProvider>()
                      //     .newMouvement
                      //     .toJSON());
                      // return;
                      context.read<MouvementProvider>().addData(
                          data: context.read<MouvementProvider>().newMouvement,
                          callback: () {
                            Navigator.pop(context);
                            Dialogs.showChoiceDialog(
                                title: 'Impression',
                                content: Column(
                                  children: [
                                    CustomButton(
                                        text: 'Imprimer le recu',
                                        backColor: AppColors.kWhiteColor,
                                        textColor: AppColors.kBlackColor,
                                        callback: () {}),
                                    CustomButton(
                                        text: 'Imprimer les QR Codes',
                                        backColor: AppColors.kRedColor,
                                        textColor: AppColors.kWhiteColor,
                                        callback: () {}),
                                  ],
                                ));
                          });
                      // print(jsonEncode(context
                      //     .read<MouvementProvider>()
                      //     .newMouvement
                      //     .toJSON()));
                      // widget.callback();
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
