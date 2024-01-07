import '../../Resources/Components/button.dart';
import '../../Resources/Components/text_fields.dart';
import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/cultivator.model.dart';
import '../../Resources/Providers/mouvement.provider.dart';
import '../../Resources/Providers/users_provider.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SelectMouvementStoreWidget extends StatefulWidget {
  Function callback;
  SelectMouvementStoreWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<SelectMouvementStoreWidget> createState() =>
      _SelectMouvementStoreWidgetState();
}

class _SelectMouvementStoreWidgetState
    extends State<SelectMouvementStoreWidget> {
  final TextEditingController _receiverCtrller = TextEditingController(),
      _receiverPhoneCtrller = TextEditingController(),
      _senderCtrller = TextEditingController(),
      _senderPhoneCtrller = TextEditingController();
  String? store, senderUUID, receiverUUID;
  @override
  void initState() {
    super.initState();
    store =
        navKey.currentContext!.read<UserProvider>().userLogged!.user.refDepot!;
    senderUUID =
        navKey.currentContext!.read<MouvementProvider>().newMouvement.senderID;
    // receiverUUID = navKey.currentContext!
    //     .read<MouvementProvider>()
    //     .newMouvement
    //     .receiverID;
  }

  ClientModel? sender, receiver;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'Assets/Illustrations/farmer.png',
                height: 200,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextWidgets.text500(
                    maxLines: 5,
                    align: TextAlign.center,
                    title: 'Expéditeur',
                    fontSize: 14,
                    textColor: AppColors.kBlackColor),
              ),
            ),
            // SearchableTextFormFieldWidget(
            //   data: context
            //       .read<CultivatorProvider>()
            //       .offlineData
            //       .map((e) => e.toJSON())
            //       .toList(),
            //   displayColumn: 'nom',
            //   secondDisplayColumn: 'postnom',
            //   indexColumn: 'uuid',
            //   editCtrller: _senderCtrller,
            //   inputType: TextInputType.text,
            //   maxLines: 1,
            //   hintText: 'Expéditeur (*)',
            //   textColor: AppColors.kBlackColor,
            //   backColor: AppColors.kTextFormBackColor,
            //   callback: (data) {
            //     if (data == null) return;
            //     sender = ClientModel.fromJSON(data);
            //     if (sender?.uuid == null) return;
            //     senderUUID = sender?.uuid;
            //     setState(() {});
            //   },
            // ),
            TextFormFieldWidget(
              editCtrller: _senderCtrller,
              inputType: TextInputType.text,
              maxLines: 1,
              hintText: 'Nom expéditeur (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
            TextFormFieldWidget(
              editCtrller: _senderPhoneCtrller,
              inputType: TextInputType.phone,
              maxLines: 1,
              hintText: 'N°tel expéditeur (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextWidgets.text500(
                    maxLines: 5,
                    align: TextAlign.center,
                    title: 'Destinataire',
                    fontSize: 14,
                    textColor: AppColors.kBlackColor),
              ),
            ),
            TextFormFieldWidget(
              editCtrller: _receiverCtrller,
              inputType: TextInputType.text,
              maxLines: 1,
              hintText: 'Nom destinataire (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
            TextFormFieldWidget(
              editCtrller: _receiverPhoneCtrller,
              inputType: TextInputType.phone,
              maxLines: 1,
              hintText: 'N°tel destinataire (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
            // SearchableTextFormFieldWidget(
            //   data: context
            //       .read<CultivatorProvider>()
            //       .offlineData
            //       .map((e) => e.toJSON())
            //       .toList(),
            //   displayColumn: 'nom',
            //   secondDisplayColumn: 'postnom',
            //   indexColumn: 'uuid',
            //   editCtrller: _receiverCtrller,
            //   inputType: TextInputType.text,
            //   maxLines: 1,
            //   hintText: 'Destinataire (*)',
            //   textColor: AppColors.kBlackColor,
            //   backColor: AppColors.kTextFormBackColor,
            //   callback: (data) {
            //     if (data == null) return;
            //     receiver = ClientModel.fromJSON(data);
            //     if (receiver?.uuid == null) return;
            //     receiverUUID = receiver?.uuid;
            //     setState(() {});
            //   },
            // ),

            // const Spacer(),
            const SizedBox(
              height: 16,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                        text: 'Continuer',
                        backColor: AppColors.kPrimaryColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          store = navKey.currentContext!
                              .read<UserProvider>()
                              .userLogged!
                              .user
                              .refDepot!;
                          if (store == null ||
                              store!.isEmpty ||
                              store == 'null' ||
                              _senderPhoneCtrller.text.isEmpty ||
                              _receiverCtrller.text.isEmpty ||
                              _senderCtrller.text.isEmpty) {
                            ToastNotification.showToast(
                                msg: "Veuillez remplir tous les champs",
                                msgType: MessageType.error,
                                title: 'Erreur');
                            return;
                          }
                          if (_senderCtrller.text.split(' ').length < 2) {
                            ToastNotification.showToast(
                                msg:
                                    "Veuillez saisir le nom et post-nom de l'expéditeur separé par un espace",
                                msgType: MessageType.error,
                                title: 'Erreur');
                            return;
                          }
                          if (_receiverCtrller.text.split(' ').length < 2) {
                            ToastNotification.showToast(
                                msg:
                                    "Veuillez saisir le nom et post-nom du destinataire separé par un espace",
                                msgType: MessageType.error,
                                title: 'Erreur');
                            return;
                          }
                          context.read<MouvementProvider>().newMouvement
                            ..storeID = store!
                            // ..receiverID = ''
                            ..senderID = ''
                            ..destination = ''
                            ..senderName = _senderCtrller.text.trim()
                            ..senderTel = _senderPhoneCtrller.text.trim()
                            ..receiverName = _receiverCtrller.text.trim()
                            ..receiverTel = _receiverPhoneCtrller.text.trim();
                          widget.callback();
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // TextWidgets.text500(
            //     maxLines: 5,
            //     align: TextAlign.center,
            //     title: 'Ou',
            //     fontSize: 14,
            //     textColor: AppColors.kBlackColor),
            // CustomButton(
            //     text: 'Enregistrer un client',
            //     backColor: AppColors.kTextFormBackColor,
            //     textColor: AppColors.kBlackColor,
            //     callback: () {
            //       Navigation.pushNavigate(page: const AddClientPage());
            //     }),
          ],
        ),
      ),
    );
  }
}
