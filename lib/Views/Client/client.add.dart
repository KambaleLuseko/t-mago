import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/Components/button.dart';
import '../../Resources/Components/text_fields.dart';
import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/global_variables.dart';
import '../../Resources/Models/cultivator.model.dart';
import '../../Resources/Providers/cultivator.provider.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({Key? key}) : super(key: key);

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final TextEditingController _nameCtrller = TextEditingController(),
      _lastnameCtrller = TextEditingController(),
      _surnameCtrller = TextEditingController(),
      _phoneCtrller = TextEditingController(),
      _addressCtrller = TextEditingController();
  String? category, stockage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textBold(
                title: 'Identité',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
          TextFormFieldWidget(
              editCtrller: _nameCtrller,
              inputType: TextInputType.text,
              maxLines: 1,
              hintText: 'Nom',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _lastnameCtrller,
              maxLines: 1,
              hintText: 'Post-nom',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _surnameCtrller,
              maxLines: 1,
              hintText: 'Prénom',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          // CustomDropdownButton(
          //     backColor: AppColors.kTextFormBackColor,
          //     value: category,
          //     hintText: 'Catégorie',
          //     callBack: (value) {
          //       setState(() {
          //         category = value;
          //       });
          //     },
          //     items: const [
          //       "Fruits et légumes",
          //       "Produits céréaliers et légumineuses",
          //       "Produits laitiers",
          //       "Viande",
          //       "Poisson et fruits de mer",
          //       "Matières grasses",
          //       "Produits succrés"
          //     ]),
          // CustomDropdownButton(
          //     backColor: AppColors.kTextFormBackColor,
          //     value: stockage,
          //     hintText: 'Stockqge',
          //     callBack: (value) {
          //       setState(() {
          //         stockage = value;
          //       });
          //     },
          //     items: const ["Sachet", "Carton", "Sac"]),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textBold(
                title: 'Contacts',
                fontSize: 14,
                textColor: AppColors.kBlackColor),
          ),
          TextFormFieldWidget(
              editCtrller: _phoneCtrller,
              inputType: TextInputType.phone,
              maxLines: 1,
              hintText: 'Phone',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          TextFormFieldWidget(
              editCtrller: _addressCtrller,
              inputType: TextInputType.text,
              maxLines: 1,
              hintText: 'Adresse',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
              canSync: true,
              text: 'Enregistrer',
              backColor: AppColors.kPrimaryColor,
              textColor: AppColors.kWhiteColor,
              callback: () {
                ClientModel data = ClientModel.fromJSON({
                  "nom": _nameCtrller.text.trim(),
                  "postnom": _lastnameCtrller.text.trim(),
                  "prenom": _surnameCtrller.text.trim(),
                  "tel": _phoneCtrller.text.trim(),
                  "adresse": _addressCtrller.text.trim()
                });
                context.read<CultivatorProvider>().addData(
                    data: data,
                    callback: () {
                      Navigator.pop(context);
                      setState(() {});
                    });
              })
        ],
      ),
    );
  }
}
