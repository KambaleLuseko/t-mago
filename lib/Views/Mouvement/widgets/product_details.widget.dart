import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_mago/Resources/Components/button.dart';
import 'package:t_mago/Resources/Components/searchable_textfield.dart';
import 'package:t_mago/Resources/Components/text_fields.dart';
import 'package:t_mago/Resources/Constants/enums.dart';
import 'package:t_mago/Resources/Constants/global_variables.dart';
import 'package:t_mago/Resources/Models/mouvement.model.dart';
import 'package:t_mago/Resources/Models/store.model.dart';
import 'package:t_mago/Resources/Providers/mouvement.provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  Function(MouvementDetailsModel) callback;
  ProductDetailsWidget({Key? key, required this.callback}) : super(key: key);

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final TextEditingController _productCtrller = TextEditingController(),
      _storeTypeCtrller = TextEditingController(),
      _weightCtrller = TextEditingController(),
      // _storageWeightCtrller = TextEditingController(),
      _priceCtrller = TextEditingController(),
      _manualPriceCtrller = TextEditingController();
  PriceModel? price;
  MouvementDetailsModel? data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchableTextFormFieldWidget(
          data: context
              .read<MouvementProvider>()
              .offlinePricesData
              .map((e) => e.toJSON())
              .toList(),
          displayColumn: 'design_device',
          // secondDisplayColumn: 'prix_kg',
          indexColumn: 'prix_kg',
          editCtrller: _storeTypeCtrller,
          inputType: TextInputType.text,
          maxLines: 1,
          hintText: 'Catégorie (*)',
          textColor: AppColors.kBlackColor,
          backColor: AppColors.kTextFormBackColor,
          callback: (data) {
            if (data == null) return;
            price = PriceModel.fromJSON(data);
            setState(() {});
          },
        ),
        TextFormFieldWidget(
            editCtrller: _productCtrller,
            inputType: TextInputType.text,
            maxLines: 2,
            hintText: 'Description',
            textColor: AppColors.kBlackColor,
            backColor: AppColors.kTextFormBackColor),
        if (price != null)
          TextFormFieldWidget(
              editCtrller: _manualPriceCtrller,
              inputType: TextInputType.number,
              maxLines: 1,
              hintText:
                  'Prix(*) (entre ${price?.price} et ${price?.maxPrice}) ',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
        Row(
          children: [
            Expanded(
              child: TextFormFieldWidget(
                  editCtrller: _weightCtrller,
                  inputType: TextInputType.number,
                  maxLines: 1,
                  hintText: 'Poids en kg (*)',
                  textColor: AppColors.kBlackColor,
                  backColor: AppColors.kTextFormBackColor),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                  text: 'Annuler',
                  backColor: AppColors.kScaffoldColor,
                  textColor: AppColors.kBlackColor,
                  callback: () {
                    Navigator.pop(context);
                  }),
            ),
            Expanded(
              child: CustomButton(
                  text: 'Confirmer',
                  backColor: AppColors.kPrimaryColor,
                  textColor: AppColors.kWhiteColor,
                  callback: () {
                    Navigator.pop(context);
                    if (_weightCtrller.text.isEmpty ||
                        price == null ||
                        _productCtrller.text.isEmpty) {
                      ToastNotification.showToast(
                          msg: "Veuillez remplir tous les champs",
                          msgType: MessageType.error,
                          title: 'Error');
                      return;
                    }
                    if (_manualPriceCtrller.text.isEmpty ||
                        double.tryParse(_manualPriceCtrller.text.trim()) ==
                            null) {
                      ToastNotification.showToast(
                          msg: "Veuillez saisir un prix valide",
                          msgType: MessageType.error,
                          title: 'Error');
                      return;
                    }
                    if (double.parse(_manualPriceCtrller.text.trim()) <
                            double.parse(price!.price) ||
                        double.parse(_manualPriceCtrller.text.trim()) >
                            double.parse(price!.maxPrice)) {
                      ToastNotification.showToast(
                          msg: "L'intervale des prix n'est pas respecté",
                          msgType: MessageType.error,
                          title: 'Error');
                      return;
                    }
                    data = (MouvementDetailsModel.fromJSON({
                      "product": _productCtrller.text.trim(),
                      "kg": _weightCtrller.text.trim(),
                      "entreposage": _storeTypeCtrller.text.trim(),
                      "prix_kg": _manualPriceCtrller.text.trim(),
                      "total_kg":
                          (double.tryParse(_weightCtrller.text.trim()) ?? 0)
                              .toStringAsFixed(4),
                      "decote_humidite": '0',
                      "kg_sac": '0',
                      "prix_net": _manualPriceCtrller.text.trim(),
                      "total_kg_net": (double.parse(_weightCtrller.text.trim()))
                          .toStringAsFixed(4),
                    }));
                    // setState(() {});
                    widget.callback(data!);
                  }),
            ),
          ],
        )
      ],
    );
  }
}
