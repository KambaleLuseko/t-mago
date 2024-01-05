import 'package:collection/collection.dart';
import '../../Resources/Components/button.dart';
import '../../Resources/Components/date_picket.dart';
import '../../Resources/Components/searchable_textfield.dart';
import '../../Resources/Components/text_fields.dart';
import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/enums.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/field.model.dart';
import '../../Resources/Providers/cultivator.provider.dart';
import '../../Resources/Providers/fields.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({Key? key}) : super(key: key);

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  final TextEditingController _addressCtrller = TextEditingController(),
      _longitudeCtrller = TextEditingController(),
      _latitudeCtrller = TextEditingController(),
      _surfaceCtrller = TextEditingController(),
      _productCtrller = TextEditingController(),
      _startDateCtrller = TextEditingController(),
      _lastOperationCtrller = TextEditingController(),
      _cultivatorCtrller = TextEditingController();
  String? owner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SizedBox(
        height: 64,
        child: CustomButton(
            canSync: true,
            text: 'Enregistrer',
            backColor: AppColors.kPrimaryColor,
            textColor: AppColors.kWhiteColor,
            callback: () {
              if (owner == null ||
                  _addressCtrller.text.isEmpty ||
                  _surfaceCtrller.text.isEmpty) {
                ToastNotification.showToast(
                    msg: 'Veuillez remplir tous les champs requis',
                    msgType: MessageType.error,
                    title: "Erreur");
                return;
              }
              FieldsModel data = FieldsModel(
                  adresseCh: _addressCtrller.text.trim(),
                  logitude: _longitudeCtrller.text.trim(),
                  latitude: _latitudeCtrller.text.trim(),
                  surfaceCh: _surfaceCtrller.text.trim(),
                  produit: _productCtrller.text.trim(),
                  anneeDebut: _startDateCtrller.text.trim(),
                  anneeLastoOpera: _lastOperationCtrller.text.trim(),
                  refMuku: owner!,
                  owner: context
                      .read<CultivatorProvider>()
                      .offlineData
                      .firstWhereOrNull((item) => item.uuid == owner));
              context.read<FieldsProvider>().addData(
                  data: data,
                  callback: () {
                    Navigator.pop(context);
                    setState(() {});
                  });
            }),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textBold(
                title: 'Propriétaire',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
          SearchableTextFormFieldWidget(
            data: context
                .read<CultivatorProvider>()
                .offlineData
                .map((e) => e.toJSON())
                .toList(),
            displayColumn: 'nom',
            indexColumn: 'uuid',
            secondDisplayColumn: 'postnom',
            editCtrller: _cultivatorCtrller,
            inputType: TextInputType.text,
            maxLines: 1,
            hintText: 'Propriétaire (*)',
            textColor: AppColors.kBlackColor,
            backColor: AppColors.kTextFormBackColor,
            callback: (data) {
              owner = data;
              setState(() {});
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textBold(
                title: 'Reference',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
          TextFormFieldWidget(
              editCtrller: _addressCtrller,
              inputType: TextInputType.text,
              maxLines: 1,
              hintText: 'Adresse (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _longitudeCtrller,
              maxLines: 1,
              hintText: 'Longitude',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _latitudeCtrller,
              maxLines: 1,
              hintText: 'Latitude',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _surfaceCtrller,
              maxLines: 1,
              hintText: 'Surface (*)',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textBold(
                title: 'Production',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
          TextFormFieldWidget(
              editCtrller: _productCtrller,
              maxLines: 1,
              hintText: 'Produits',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          GestureDetector(
            onTap: () {
              showDatePicketCustom(
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 10)),
                  lastDate: DateTime.now(),
                  callback: (value) {
                    if (value == null) return;
                    _startDateCtrller.text = value.toString().substring(0, 4);
                    setState(() {});
                  });
            },
            child: TextFormFieldWidget(
                isEnabled: false,
                editCtrller: _startDateCtrller,
                inputType: TextInputType.number,
                maxLines: 1,
                hintText: 'Annee debut',
                textColor: AppColors.kBlackColor,
                backColor: AppColors.kTextFormBackColor),
          ),
          GestureDetector(
            onTap: () {
              showDatePicketCustom(
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 10)),
                  lastDate: DateTime.now(),
                  callback: (value) {
                    if (value == null) return;
                    _lastOperationCtrller.text =
                        value.toString().substring(0, 10);
                    setState(() {});
                  });
            },
            child: TextFormFieldWidget(
                isEnabled: false,
                editCtrller: _lastOperationCtrller,
                maxLines: 1,
                hintText: 'Date derniere production',
                textColor: AppColors.kBlackColor,
                backColor: AppColors.kTextFormBackColor),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
