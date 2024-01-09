import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/enums.dart';
import '../../../Resources/Models/store.model.dart';
import '../../../Resources/Providers/users_provider.dart';

import 'mouvement.widget.dart';

import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/empty_model.dart';
import '../../../Resources/Components/shimmer_placeholder.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Models/mouvement.model.dart';
import '../../../Resources/Providers/app_state_provider.dart';
import '../../../Resources/Providers/mouvement.provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
// import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class OperationScanPage extends StatefulWidget {
  final String operation;
  const OperationScanPage({Key? key, required this.operation})
      : super(key: key);

  @override
  State<OperationScanPage> createState() => _SaveSalePageState();
}

class _SaveSalePageState extends State<OperationScanPage> {
  String paymentMode = '';
  List<String> paymentModeList = ['Cash', 'Carte', 'Bonus'];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MouvementProvider>().resetOperation();
    });
  }

  MouvementModel? data;
  StoreModel? destStore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.kWhiteColor,
      floatingActionButton: (widget.operation.toLowerCase().contains('livr') ||
              widget.operation.toLowerCase().contains('ship'))
          ? null
          : FloatingActionButton(
              mini: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.kPrimaryColor,
              child: Icon(
                Icons.nfc_rounded,
                color: AppColors.kWhiteColor,
                size: 24,
              ),
              onPressed: () async {
                if (await Permission.camera.status !=
                    PermissionStatus.granted) {
                  await Permission.camera.request();
                }
                String? result;
                Dialogs.showBottomModalSheet(
                    content: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: QRCodeDartScanView(
                        scanInvertedQRCode:
                            true, // enable scan invert qr code ( default = false)
                        typeScan: TypeScan
                            .live, // if TypeScan.takePicture will try decode when click to take a picture (default TypeScan.live)

                        onCapture: (Result res) {
                          if (result != null) return;
                          // print(res.text);
                          result = res.text;
                          Navigator.pop(context);
                          context
                              .read<MouvementProvider>()
                              .getOneOnline(value: res.text);
                        },
                        typeCamera: TypeCamera.back,
                        resolutionPreset: QRCodeDartScanResolutionPreset.high,
                      ),
                    ),
                  ),
                ));
              },
            ),
      appBar: AppBar(
        title: Text(widget.operation),
      ),
      body: ListView(
        children: [
          context.select<AppStateProvider, bool>(
                      (provider) => provider.isAsync) ==
                  true
              ? ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...List.generate(
                        10,
                        (index) => ListItemPlaceholder(
                              backColor: AppColors.kGreyColor.withOpacity(0.3),
                            ))
                  ],
                )
              : Selector<MouvementProvider, MouvementModel?>(
                  selector: (_, provider) => provider.activeOperation,
                  builder: (_, data, __) {
                    return Align(
                      alignment:
                          data == null ? Alignment.center : Alignment.topCenter,
                      child: data == null
                          ? EmptyModel(
                              color: AppColors.kGreyColor,
                              text: 'Aucun colis trouvé',
                            )
                          : MouvementDetailsPage(data: data),
                    );
                  }),
          if (context.select<MouvementProvider, MouvementModel?>(
                  (provider) => provider.activeOperation) !=
              null)
            if (context
                    .select<MouvementProvider, MouvementModel?>(
                        (provider) => provider.activeOperation)!
                    .tracking!
                    .last
                    .label
                    ?.toLowerCase() !=
                widget.operation.toLowerCase())
              if (!context
                      .select<MouvementProvider, MouvementModel?>(
                          (provider) => provider.activeOperation)!
                      .tracking!
                      .last
                      .label!
                      .toLowerCase()
                      .contains('colis re') ||
                  !widget.operation.toLowerCase().contains('recep'))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                      text: 'Enregistrer',
                      backColor: AppColors.kPrimaryColor,
                      textColor: AppColors.kWhiteColor,
                      callback: () {
                        if (!widget.operation.toLowerCase().contains('env')) {
                          if (widget.operation.toLowerCase().contains('livr') ||
                              widget.operation.toLowerCase().contains('ship')) {
                            if (context
                                    .read<UserProvider>()
                                    .userLogged
                                    ?.user
                                    .refDepot !=
                                context
                                    .read<MouvementProvider>()
                                    .activeOperation
                                    ?.destination) {
                              ToastNotification.showToast(
                                  msg:
                                      "Vous ne faites pas partie de l'entrepot de destination, de ce fait, vous ne pouvez pas livrer le colis au destinataire",
                                  msgType: MessageType.error,
                                  title: 'Erreur');
                              return;
                            }
                            if (!context
                                .read<MouvementProvider>()
                                .activeOperation!
                                .tracking!
                                .last
                                .label!
                                .toLowerCase()
                                .contains('recept')) {
                              ToastNotification.showToast(
                                  msg:
                                      "Le colis n'a pas encore signalé sa réception à la destination et de ce fait il ne peut pas être livré",
                                  msgType: MessageType.error,
                                  title: 'Erreur');
                              return;
                            }
                          }
                          Dialogs.showDialogWithAction(
                              title: 'Confirmation',
                              content:
                                  "Vous êtes sur le point d'ajouter le statut <<${widget.operation}>> sur le parcours de ce colis.\nVoulez-vous continuer?",
                              callback: () {
                                MouvementTrackingModel body =
                                    MouvementTrackingModel(
                                        destDepotId: '0',
                                        sourceDepotId: context
                                            .read<UserProvider>()
                                            .userLogged
                                            ?.user
                                            .refDepot,
                                        label: widget.operation.toUpperCase(),
                                        mouvUuid: context
                                            .read<MouvementProvider>()
                                            .activeOperation
                                            ?.uuid,
                                        userId: context
                                            .read<UserProvider>()
                                            .userLogged
                                            ?.user
                                            .id
                                            ?.toString());
                                context.read<MouvementProvider>().addtracking(
                                    data: body,
                                    callback: () {
                                      context
                                          .read<MouvementProvider>()
                                          .resetOperation();
                                    });
                              });
                          return;
                        }
                        Dialogs.showChoiceDialog(
                            title: 'Choisissez la destination',
                            content: Container(
                              padding: const EdgeInsets.all(8),
                              color: AppColors.kScaffoldColor,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...List.generate(
                                      context
                                          .read<MouvementProvider>()
                                          .offlineStoreData
                                          .length, (index) {
                                    StoreModel store = context
                                        .read<MouvementProvider>()
                                        .offlineStoreData[index];
                                    return ActionChip(
                                        onPressed: () {
                                          destStore = store;
                                          setState(() {});
                                          Navigator.pop(context);
                                          Dialogs.showDialogWithAction(
                                              title: 'Confirmation',
                                              content:
                                                  "Vous êtes sur le point d'ajouter le statut <<${widget.operation}>> sur le parcours de ce colis.\nVoulez-vous continuer?",
                                              callback: () {
                                                MouvementTrackingModel body =
                                                    MouvementTrackingModel(
                                                        destDepotId: destStore
                                                            ?.id
                                                            ?.toString(),
                                                        sourceDepotId: context
                                                            .read<
                                                                UserProvider>()
                                                            .userLogged
                                                            ?.user
                                                            .refDepot,
                                                        label: widget.operation
                                                            .toUpperCase(),
                                                        mouvUuid: context
                                                            .read<
                                                                MouvementProvider>()
                                                            .activeOperation
                                                            ?.uuid,
                                                        userId: context
                                                            .read<
                                                                UserProvider>()
                                                            .userLogged
                                                            ?.user
                                                            .id
                                                            ?.toString());
                                                context
                                                    .read<MouvementProvider>()
                                                    .addtracking(
                                                        data: body,
                                                        callback: () {
                                                          context
                                                              .read<
                                                                  MouvementProvider>()
                                                              .resetOperation();
                                                        });
                                              });
                                        },
                                        avatar: TextWidgets.textBold(
                                            title: store.name
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            fontSize: 18,
                                            textColor: destStore?.id == store.id
                                                ? AppColors.kWhiteColor
                                                : AppColors.kBlackColor),
                                        backgroundColor:
                                            destStore?.id == store.id
                                                ? AppColors.kPrimaryColor
                                                : AppColors.kWhiteColor,
                                        elevation: 0,
                                        label: TextWidgets.text300(
                                          title: store.name,
                                          fontSize: 12,
                                          textColor: destStore?.id == store.id
                                              ? AppColors.kWhiteColor
                                              : AppColors.kBlackColor,
                                        ));
                                  })
                                ],
                              ),
                            ));

                        // context.read<MouvementProvider>().resetOperation();
                      }),
                ),
          if ((context.select<MouvementProvider, MouvementModel?>(
                      (provider) => provider.activeOperation) !=
                  null) &&
              (context
                          .select<MouvementProvider, MouvementModel?>(
                              (provider) => provider.activeOperation)!
                          .tracking!
                          .last
                          .label
                          ?.toLowerCase() ==
                      widget.operation.toLowerCase() ||
                  context
                              .select<MouvementProvider, MouvementModel?>(
                                  (provider) => provider.activeOperation)!
                              .tracking!
                              .length ==
                          1 &&
                      widget.operation.toLowerCase().contains('recep')))
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidgets.textBold(
                    title: 'Aucune action disponible',
                    fontSize: 16,
                    textColor: AppColors.kRedColor),
              ),
            ),
          if ((context.select<MouvementProvider, MouvementModel?>(
                  (provider) => provider.activeOperation) !=
              null))
            Column(
              children: [
                if (context
                            .select<MouvementProvider, MouvementModel?>(
                                (provider) => provider.activeOperation)!
                            .tracking!
                            .length ==
                        1 &&
                    widget.operation.toLowerCase().contains('recep'))
                  Align(
                    alignment: Alignment.center,
                    child: TextWidgets.text300(
                        title: 'Le colis est déjà reçu',
                        fontSize: 16,
                        textColor: AppColors.kRedColor),
                  ),
                if (context
                        .select<MouvementProvider, MouvementModel?>(
                            (provider) => provider.activeOperation)!
                        .tracking!
                        .last
                        .label
                        ?.toLowerCase() ==
                    widget.operation.toLowerCase())
                  Align(
                    alignment: Alignment.center,
                    child: TextWidgets.text300(
                        align: TextAlign.center,
                        title:
                            'Le niveau de progression du colis est identique à l\'opération que vous voulez effectuer',
                        fontSize: 12,
                        textColor: AppColors.kRedColor),
                  ),
                const SizedBox(
                  height: 48,
                )
              ],
            ),
        ],
      ),
    );
  }
}
