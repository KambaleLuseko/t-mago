import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/card.dart';
import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/empty_model.dart';
import '../../../Resources/Components/list_item.dart';
import '../../../Resources/Components/shimmer_placeholder.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Models/Menu/list_item.model.dart';
import '../../../Resources/Models/mouvement.model.dart';
import '../../../Resources/Providers/app_state_provider.dart';
import '../../../Resources/Providers/mouvement.provider.dart';
import 'tracking.widget.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.kWhiteColor,
      floatingActionButton: (widget.operation.toLowerCase().contains('livr') ||
              widget.operation.toLowerCase().contains('ship'))
          ? null
          : FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.kPrimaryColor,
              child: Icon(
                Icons.nfc_rounded,
                color: AppColors.kWhiteColor,
                size: 32,
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
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  ListItem(
                                    icon: Icons.person,
                                    title: data.senderName ?? '',
                                    subtitle: data.senderTel ?? '',
                                    middleFields: ListItemModel(
                                        displayLabel: true,
                                        title: 'Exp',
                                        value: 'Exp'),
                                    keepMidleFields: true,
                                    backColor: AppColors.kWhiteColor,
                                    textColor: AppColors.kBlackColor,
                                    detailsFields: const [],
                                  ),
                                  ListItem(
                                    icon: Icons.person,
                                    title: data.receiverName ?? '',
                                    subtitle: data.receiverTel ?? '',
                                    middleFields: ListItemModel(
                                        displayLabel: true,
                                        title: 'Dest',
                                        value: 'Dest'),
                                    keepMidleFields: true,
                                    backColor: AppColors.kWhiteColor,
                                    textColor: AppColors.kBlackColor,
                                    detailsFields: const [],
                                  ),
                                  Card(
                                    margin: const EdgeInsets.all(8.0),
                                    elevation: 0,
                                    // color: AppColors.kScaffoldColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 16),
                                      child: Column(
                                        children: [
                                          TrackingWidget.buildTrackWidget(
                                              title: 'Source',
                                              subtitle: 'Goma, Himbi',
                                              color: AppColors.kBlackColor,
                                              isLast: false,
                                              date: ''),
                                          TrackingWidget.buildTrackWidget(
                                              title: 'Destination',
                                              subtitle: 'Bukavu, Nyawera',
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
                                                      .map((e) => double.parse(
                                                          e.netPrice!))
                                                      .fold(
                                                          0.0,
                                                          (prev, element) =>
                                                              double.parse(prev
                                                                  .toString()) +
                                                              element)
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
                                  ...List.generate(data.detailsMouvement.length,
                                      (indexDet) {
                                    MouvementDetailsModel detData =
                                        data.detailsMouvement[indexDet];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      elevation: 0,
                                      color: AppColors.kWhiteColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 8),
                                            child: TextWidgets.textBold(
                                                title: detData.storageType,
                                                fontSize: 16,
                                                textColor:
                                                    AppColors.kBlackColor),
                                          ),
                                          ListTile(
                                            title: Wrap(
                                              children: [
                                                TextWidgets.textWithLabel(
                                                    title: 'Description',
                                                    value: detData.product,
                                                    fontSize: 12,
                                                    textColor:
                                                        AppColors.kBlackColor),
                                                TextWidgets.textWithLabel(
                                                    title: 'Poids',
                                                    value:
                                                        "${detData.weights}kg",
                                                    fontSize: 12,
                                                    textColor:
                                                        AppColors.kBlackColor),
                                                TextWidgets.textWithLabel(
                                                    title:
                                                        'Prix total net a payer',
                                                    value:
                                                        "${double.parse(detData.netPrice ?? '0').toStringAsFixed(4)} USD",
                                                    fontSize: 12,
                                                    textColor:
                                                        AppColors.kRedColor),
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
                                            ...List.generate(
                                                data.tracking!.length, (index) {
                                              MouvementTrackingModel trackData =
                                                  data.tracking![index];
                                              return TrackingWidget
                                                  .buildTrackWidget(
                                                      date:
                                                          trackData.createdAt ??
                                                              '',
                                                      title: trackData.label ??
                                                          'Unknown',
                                                      subtitle:
                                                          trackData.storeName ??
                                                              '',
                                                      color:
                                                          AppColors.kBlackColor,
                                                      isLast: data.tracking!
                                                                  .length ==
                                                              1
                                                          ? true
                                                          : index ==
                                                                  data.tracking!
                                                                          .length -
                                                                      1
                                                              ? true
                                                              : false);
                                            })
                                          ],
                                        )),
                                  )
                                ]),
                    );
                  }),
          if (context.select<MouvementProvider, MouvementModel?>(
                  (provider) => provider.activeOperation) !=
              null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                  text: 'Enregistrer',
                  backColor: AppColors.kPrimaryColor,
                  textColor: AppColors.kWhiteColor,
                  callback: () {
                    // context.read<MouvementProvider>().resetOperation();
                  }),
            )
        ],
      ),
    );
  }
}
