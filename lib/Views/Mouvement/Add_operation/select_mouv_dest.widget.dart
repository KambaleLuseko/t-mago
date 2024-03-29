import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/Constants/enums.dart';
import '../../../Resources/Constants/global_variables.dart';
import '../../../Resources/Models/store.model.dart';
import '../../../Resources/Providers/mouvement.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

class SelectMouvementDestinationWidget extends StatefulWidget {
  Function callback;
  final Function() backCallback;
  SelectMouvementDestinationWidget(
      {Key? key, required this.callback, required this.backCallback})
      : super(key: key);

  @override
  State<SelectMouvementDestinationWidget> createState() =>
      _SelectMouvementTypeWidgetState();
}

class _SelectMouvementTypeWidgetState
    extends State<SelectMouvementDestinationWidget> {
  final TextEditingController _destinationCtrller = TextEditingController(
      text: navKey.currentContext!
              .read<MouvementProvider>()
              .newMouvement
              .destinationStore
              ?.name ??
          '');
  String? destination;
  StoreModel? destinationStore;
  @override
  void initState() {
    super.initState();
    destination = navKey.currentContext!
        .read<MouvementProvider>()
        .newMouvement
        .destination;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            // const Spacer(),
            Container(
              padding: const EdgeInsets.all(0),
              child: Image.asset(
                'Assets/Illustrations/product.png',
                height: 300,
              ),
            ),
            TextWidgets.text500(
                maxLines: 5,
                align: TextAlign.center,
                title: 'Sélectionnez un dépôt de destination',
                fontSize: 18,
                textColor: AppColors.kBlackColor),
            const SizedBox(
              height: 8,
            ),
            // SearchableTextFormFieldWidget(
            //   data: context
            //       .read<MouvementProvider>()
            //       .offlineStoreData
            //       .map((e) => e.toJSON())
            //       .toList(),
            //   displayColumn: 'designation',
            //   indexColumn: 'id',
            //   editCtrller: _destinationCtrller,
            //   inputType: TextInputType.text,
            //   maxLines: 1,
            //   hintText: 'Destination (*)',
            //   textColor: AppColors.kBlackColor,
            //   backColor: AppColors.kTextFormBackColor,
            //   callback: (data) {
            //     destinationStore = StoreModel.fromJSON(data);
            //     setState(() {});
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...List.generate(
                      context.read<MouvementProvider>().offlineStoreData.length,
                      (index) {
                    StoreModel store = context
                        .read<MouvementProvider>()
                        .offlineStoreData[index];
                    return ActionChip(
                        onPressed: () {
                          destination = store.id?.toString();
                          destinationStore = store;
                          setState(() {});
                        },
                        avatar: TextWidgets.textBold(
                            title: store.name.substring(0, 1).toUpperCase(),
                            fontSize: 18,
                            textColor: destinationStore?.id == store.id
                                ? AppColors.kWhiteColor
                                : AppColors.kBlackColor),
                        backgroundColor: destinationStore?.id == store.id
                            ? AppColors.kPrimaryColor
                            : AppColors.kWhiteColor,
                        elevation: 0,
                        label: TextWidgets.text300(
                          title: store.name,
                          fontSize: 12,
                          textColor: destinationStore?.id == store.id
                              ? AppColors.kWhiteColor
                              : AppColors.kBlackColor,
                        ));
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // const Spacer(),
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
                    child: CustomButton(
                        text: 'Continuer',
                        backColor: AppColors.kPrimaryColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          // print(mouvement);
                          if (destination == null) {
                            ToastNotification.showToast(
                                msg: "Veuillez choisir un depot de destination",
                                msgType: MessageType.error,
                                title: 'Erreur');
                            return;
                          }

                          context.read<MouvementProvider>().newMouvement
                            ..destination = destinationStore!.id!.toString()
                            ..destinationStore = destinationStore;
                          widget.callback();
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
