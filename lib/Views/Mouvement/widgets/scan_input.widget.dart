import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

import '../../../Resources/Components/dialogs.dart';
import '../../../Resources/Components/text_fields.dart';
import '../../../Resources/Constants/global_variables.dart';

class ScanInputWidget extends StatelessWidget {
  const ScanInputWidget(
      {Key? key, required this.editCtrller, required this.label})
      : super(key: key);
  final TextEditingController editCtrller;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            editCtrller: editCtrller,
            inputType: TextInputType.text,
            maxLines: 1,
            hintText: '$label (*)',
            isEnabled: false,
            textColor: AppColors.kBlackColor,
            backColor: AppColors.kTextFormBackColor,
          ),
        ),
        IconButton(
            onPressed: () async {
              if (await Permission.camera.status != PermissionStatus.granted) {
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
                        editCtrller.text = result ?? '';
                        Navigator.pop(context);
                      },
                      typeCamera: TypeCamera.back,
                      resolutionPreset: QRCodeDartScanResolutionPreset.high,
                    ),
                  ),
                ),
              ));
            },
            icon: Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.kBlackColor,
            ))
      ],
    );
  }
}
