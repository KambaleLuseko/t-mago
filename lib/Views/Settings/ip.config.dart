import 'package:t_mago/Resources/Components/button.dart';
import 'package:t_mago/Resources/Components/dropdown_button.dart';
import 'package:t_mago/Resources/Components/text_fields.dart';
import 'package:t_mago/Resources/Components/texts.dart';
import 'package:t_mago/Resources/Constants/global_variables.dart';
import 'package:t_mago/Resources/Providers/app_state_provider.dart';
import 'package:t_mago/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IPConfigPage extends StatefulWidget {
  const IPConfigPage({Key? key}) : super(key: key);

  @override
  State<IPConfigPage> createState() => _IPConfigPageState();
}

class _IPConfigPageState extends State<IPConfigPage> {
  final TextEditingController _ipCtrller = TextEditingController();
  String? protocol;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets.textWithLabel(
                title: 'IP',
                fontSize: 16,
                textColor: AppColors.kBlackColor,
                value: prefs.getString('ipConfig') ?? 'Unknown'),
            Divider(color: AppColors.kGreyColor, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextWidgets.textNormal(
                  title: 'Configuration',
                  fontSize: 14,
                  textColor: AppColors.kBlackColor),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomDropdownButton(
                      backColor: AppColors.kTextFormBackColor,
                      value: protocol,
                      hintText: 'Protocol',
                      callBack: (value) {
                        protocol = value;
                        setState(() {});
                      },
                      items: const ['http', 'https']),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormFieldWidget(
                      editCtrller: _ipCtrller,
                      inputType: TextInputType.text,
                      maxLines: 1,
                      hintText: 'IP Address',
                      textColor: AppColors.kBlackColor,
                      backColor: AppColors.kTextFormBackColor),
                ),
              ],
            ),
            CustomButton(
                text: 'Enregistrer',
                backColor: AppColors.kPrimaryColor,
                textColor: AppColors.kWhiteColor,
                callback: () {
                  context
                      .read<AppStateProvider>()
                      .saveIPConfig(value: _ipCtrller.text.trim());
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
