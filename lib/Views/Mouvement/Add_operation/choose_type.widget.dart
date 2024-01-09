import '../widgets/operation_scan.details.dart';
import '../widgets/scan_input.widget.dart';

import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/card.dart';
import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/enums.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Constants/navigators.dart';
import '../../../Resources/Providers/mouvement.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseOperationTypeWidget extends StatefulWidget {
  const ChooseOperationTypeWidget({Key? key}) : super(key: key);

  @override
  State<ChooseOperationTypeWidget> createState() =>
      _ChooseFuelTypeWidgetState();
}

class _ChooseFuelTypeWidgetState extends State<ChooseOperationTypeWidget> {
  String operationType = 'Envoi';
  List<String> operations = ['Envoi', 'Reception', 'Livraison'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: TextWidgets.textBold(
                  title: 'Type',
                  fontSize: 18,
                  textColor: AppColors.kBlackColor),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                ...List.generate(
                  operations.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        operationType = operations[index];
                        setState(() {});
                      },
                      child: OperationTypeWidget(
                          title: operations[index],
                          icon: index == 0
                              ? Icons.next_week_rounded
                              : index == 1
                                  ? Icons.weekend_rounded
                                  : Icons.local_shipping_rounded,
                          textColor: operations[index].toLowerCase() ==
                                  operationType.toLowerCase()
                              ? AppColors.kWhiteColor
                              : AppColors.kBlackColor,
                          backColor: operations[index].toLowerCase() ==
                                  operationType.toLowerCase()
                              ? AppColors.kPrimaryColor
                              : AppColors.kTextFormBackColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      text: 'Suivant',
                      backColor: AppColors.kPrimaryColor,
                      textColor: AppColors.kWhiteColor,
                      callback: () {
                        if (operationType.toLowerCase().contains('livr') ||
                            operationType.toLowerCase().contains('ship')) {
                          TextEditingController _packCtrller =
                                  TextEditingController(),
                              _receiverCtrller = TextEditingController();
                          Dialogs.showBottomModalSheet(
                              content: CardWidget(
                                  elevation: 0,
                                  title: 'Vérification',
                                  content: Column(
                                    children: [
                                      ScanInputWidget(
                                        editCtrller: _packCtrller,
                                        label: 'ID colis',
                                      ),
                                      ScanInputWidget(
                                        editCtrller: _receiverCtrller,
                                        label: "ID reception",
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: CustomButton(
                                            text: 'Verifier',
                                            backColor: AppColors.kPrimaryColor,
                                            textColor: AppColors.kWhiteColor,
                                            callback: () {
                                              if (_receiverCtrller
                                                      .text.isEmpty ||
                                                  _packCtrller.text.isEmpty) {
                                                ToastNotification.showToast(
                                                    msg:
                                                        'Veuillez fournir toutes les informations requises',
                                                    msgType: MessageType.error,
                                                    title:
                                                        'Valeurs incorrectes');
                                                return;
                                              }
                                              if (_receiverCtrller.text
                                                      .trim() !=
                                                  _packCtrller.text.trim()) {
                                                ToastNotification.showToast(
                                                    msg:
                                                        'Les codes ne correspondent pas',
                                                    msgType: MessageType.error,
                                                    title:
                                                        'Valeurs incorrectes');
                                                return;
                                              }
                                              context
                                                  .read<MouvementProvider>()
                                                  .getOneOnline(
                                                      value: _packCtrller.text
                                                          .trim());
                                              Navigator.pop(context);
                                              Navigation.pushNavigate(
                                                  page: OperationScanPage(
                                                operation: operationType,
                                              ));
                                            }),
                                      ),
                                    ],
                                  )));
                        } else {
                          Navigation.pushNavigate(
                              page: OperationScanPage(
                            operation: operationType,
                          ));
                        }
                      }),
                )
              ],
            )
          ]),
    );
  }
}

class OperationTypeWidget extends StatelessWidget {
  OperationTypeWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.textColor,
      required this.backColor})
      : super(key: key);
  final String title;
  final IconData icon;
  Color textColor, backColor;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(),
            Icon(
              icon,
              color: textColor,
              size: 40,
            ),
            const SizedBox(
              height: 16,
            ),
            TextWidgets.textNormal(
              title: title,
              fontSize: 16,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
