import '../Components/dialogs.dart';
import 'date_parser.dart';
import '../Models/cultivator.model.dart';
import '../Models/mouvement.model.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';

printReport({required ClientModel client, required MouvementModel data}) {
  // print(data);
  Dialogs.showDialogWithAction(
      context: navKey.currentContext!,
      title: "Confirmation",
      content: "Voulez-vous imprimer un reçu?",
      callback: () async {
        double total = 0;
        for (var i = 0; i < data.detailsMouvement.length; i++) {
          total +=
              double.parse(data.detailsMouvement[i].totalNetWeight.toString());
        }
        SunmiPrinter.text(
          'Rep. Dem. du Congo',
          styles: const SunmiStyles(
              align: SunmiAlign.left, size: SunmiSize.md, bold: true),
        );
        // SunmiPrinter.text(
        //   'Province du Nord Ubangi',
        //   styles: const SunmiStyles(
        //       align: SunmiAlign.left, size: SunmiSize.md, bold: true),
        // );
        SunmiPrinter.hr();
        SunmiPrinter.text(
          'Entrepot',
          styles: const SunmiStyles(
              align: SunmiAlign.left, size: SunmiSize.xl, bold: true),
        );

        // ByteData bytes = await rootBundle.load('Assets/Images/qr_mago.png');
        // final buffer = bytes.buffer;
        // final imgData = base64.encode(Uint8List.view(buffer));
        // SunmiPrinter.image(imgData, align: SunmiAlign.left);
        // SunmiPrinter.row(
        //   cols: [
        //     SunmiCol(text: 'Plaque', width: 4,align: SunmiAlign.left),
        //     SunmiCol(
        //         text: data['numPlaque'].toString(),
        //         width: 8,
        //         align: SunmiAlign.center),
        //   ],
        // );

        SunmiPrinter.hr();
        SunmiPrinter.text(
          'ID ${data.uuid ?? "-"}',
          styles: const SunmiStyles(
              underline: true,
              align: SunmiAlign.center,
              size: SunmiSize.md,
              bold: true),
        );
        SunmiPrinter.emptyLines(1);

        SunmiPrinter.row(
          cols: [
            SunmiCol(text: 'Mouv', width: 4, align: SunmiAlign.left),
            SunmiCol(
              text: data.mouvementType.toString(),
              width: 8,
              align: SunmiAlign.left,
            ),
          ],
        );
        SunmiPrinter.row(
          cols: [
            SunmiCol(text: 'Date', width: 4, align: SunmiAlign.left),
            SunmiCol(
                text: parseDate(
                        date: data.createdAt?.toString() ??
                            DateTime.now().toString())
                    .toString()
                    .substring(0, 10),
                width: 8,
                align: SunmiAlign.left),
          ],
        );
        SunmiPrinter.hr();
        SunmiPrinter.text(
          'Client',
          styles: const SunmiStyles(
            align: SunmiAlign.left,
            size: SunmiSize.md,
          ),
        );
        SunmiPrinter.text(
          client.nom,
          styles: const SunmiStyles(
              align: SunmiAlign.left, size: SunmiSize.md, bold: true),
        );
        SunmiPrinter.text(
          'Contact',
          styles: const SunmiStyles(
            align: SunmiAlign.left,
            size: SunmiSize.md,
          ),
        );
        SunmiPrinter.text(
          client.tel,
          styles: const SunmiStyles(
              align: SunmiAlign.left, size: SunmiSize.md, bold: true),
        );
        SunmiPrinter.hr();
        SunmiPrinter.emptyLines(1);
        SunmiPrinter.row(
          bold: true,
          underline: true,
          cols: [
            SunmiCol(
                text: "Design".toString(), width: 4, align: SunmiAlign.left),
            SunmiCol(text: "Prix".toString(), width: 3, align: SunmiAlign.left),
            SunmiCol(text: "Qte".toString(), width: 2, align: SunmiAlign.left),
            SunmiCol(
                text: "Total".toString(), width: 3, align: SunmiAlign.left),
          ],
        );
        for (var i = 0; i < data.detailsMouvement.length; i++) {
          SunmiPrinter.row(
            // textSize: SunmiSize.sm,
            cols: [
              SunmiCol(
                  text: data.detailsMouvement[i].product.toString(),
                  width: 4,
                  align: SunmiAlign.left),
              SunmiCol(
                  text: data.detailsMouvement[i].netPrice.toString(),
                  width: 3,
                  align: SunmiAlign.left),
              SunmiCol(
                  text: (double.parse(
                              data.detailsMouvement[i].weights.toString()) -
                          double.parse(data.detailsMouvement[i].storageWeight
                              .toString()))
                      .toStringAsFixed(1),
                  width: 2,
                  align: SunmiAlign.left),
              SunmiCol(
                  text: (double.parse(
                          data.detailsMouvement[i].totalNetWeight.toString()))
                      .toStringAsFixed(1),
                  width: 3,
                  align: SunmiAlign.left),
            ],
          );
          // SunmiPrinter.row(
          //   // textSize: SunmiSize.sm,
          //   cols: [
          //     SunmiCol(text: "", width: 4, align: SunmiAlign.left),
          //     SunmiCol(
          //         text: data.detailsMouvement[i].netPrice.toString(),
          //         width: 3,
          //         align: SunmiAlign.left),
          //     SunmiCol(
          //         text: (double.parse(
          //                     data.detailsMouvement[i].weights.toString()) -
          //                 double.parse(data.detailsMouvement[i].storageWeight
          //                     .toString()))
          //             .toStringAsFixed(1),
          //         width: 2,
          //         align: SunmiAlign.left),
          //     SunmiCol(
          //         text: (double.parse(
          //                 data.detailsMouvement[i].totalNetWeight.toString()))
          //             .toStringAsFixed(1),
          //         width: 3,
          //         align: SunmiAlign.left),
          //   ],
          // );
          SunmiPrinter.hr();
        }
        SunmiPrinter.emptyLines(1);
        SunmiPrinter.row(
          bold: true,
          cols: [
            SunmiCol(
                text: "Total".toString(), width: 4, align: SunmiAlign.left),
            SunmiCol(text: "".toString(), width: 2, align: SunmiAlign.center),
            SunmiCol(text: "".toString(), width: 2, align: SunmiAlign.center),
            SunmiCol(
                text: total.toStringAsFixed(1),
                width: 4,
                align: SunmiAlign.right),
          ],
        );
        SunmiPrinter.hr();
        SunmiPrinter.emptyLines(1);
        SunmiPrinter.text(
          'Contact: +243 997 039 243',
          styles: const SunmiStyles(
              align: SunmiAlign.center, size: SunmiSize.md, bold: false),
        );
        SunmiPrinter.text(
          'From Applicatoryx',
          styles: const SunmiStyles(
              align: SunmiAlign.center, size: SunmiSize.md, bold: false),
        );
        SunmiPrinter.emptyLines(3);
        Navigator.pop(navKey.currentContext!);
      });
}
