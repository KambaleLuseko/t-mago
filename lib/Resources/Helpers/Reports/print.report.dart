// import 'package:t_mago/Resources/Components/dialogs.dart';
// import 'package:t_mago/Resources/Constants/enums.dart';
// import 'package:t_mago/Resources/Helpers/uuid_generator.dart';
// import 'package:t_mago/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';

// printReport({required List data, String? uuid = "", required Map clientData}) {
//   if (uuid == '') {
//     uuid = uuidGenerator();
//   }
//   Dialogs.showDialogWithAction(
//       context: navKey.currentContext!,
//       dialogType: MessageType.info,
//       title: "Confirmation",
//       content: "Voulez-vous imprimer un reçu?",
//       callback: () async {
//         SunmiPrinter.text(
//           'Rep. Dem. du Congo',
//           styles: SunmiStyles(
//               align: SunmiAlign.left, size: SunmiSize.md, bold: true),
//         );
//         SunmiPrinter.text(
//           'Province du Nord Kivu',
//           styles: SunmiStyles(
//               align: SunmiAlign.left, size: SunmiSize.md, bold: true),
//         );
//         SunmiPrinter.hr();
//         SunmiPrinter.text(
//           appName,
//           styles: SunmiStyles(
//               align: SunmiAlign.left, size: SunmiSize.xl, bold: true),
//         );

//         // ByteData bytes = await rootBundle.load('Assets/Images/qr_mago.png');
//         // final buffer = bytes.buffer;
//         // final imgData = base64.encode(Uint8List.view(buffer));
//         // SunmiPrinter.image(imgData, align: SunmiAlign.left);
//         // SunmiPrinter.row(
//         //   cols: [
//         //     SunmiCol(text: 'Plaque', width: 4,align: SunmiAlign.left),
//         //     SunmiCol(
//         //         text: data['numPlaque'].toString(),
//         //         width: 8,
//         //         align: SunmiAlign.center),
//         //   ],
//         // );

//         SunmiPrinter.hr();
//         SunmiPrinter.text(
//           'Facture N° $uuid',
//           styles: SunmiStyles(
//               underline: true,
//               align: SunmiAlign.center,
//               size: SunmiSize.md,
//               bold: true),
//         );
//         SunmiPrinter.emptyLines(1);

//         SunmiPrinter.row(
//           cols: [
//             SunmiCol(text: 'Nom :', width: 4),
//             SunmiCol(
//                 text: clientData['name'] ?? 'Unknown',
//                 width: 8,
//                 align: SunmiAlign.right),
//           ],
//         );
//         SunmiPrinter.row(
//           cols: [
//             SunmiCol(text: 'Tel :', width: 4),
//             SunmiCol(
//                 text: clientData['phone'] ?? 'Unknown',
//                 width: 8,
//                 align: SunmiAlign.right),
//           ],
//         );
//         // SunmiPrinter.row(
//         //   cols: [
//         //     SunmiCol(text: 'Plaque :', width: 4),
//         //     SunmiCol(
//         //         text: data['numPlaque'] ?? 'Unknown',
//         //         width: 8,
//         //         align: SunmiAlign.right),
//         //   ],
//         // );
//         SunmiPrinter.emptyLines(1);
//         SunmiPrinter.row(
//           cols: [
//             SunmiCol(text: '#', width: 1),
//             SunmiCol(
//                 text: "Designation".toString(),
//                 width: 6,
//                 align: SunmiAlign.center),
//             SunmiCol(
//                 text: "Stock".toString(), width: 3, align: SunmiAlign.center),
//             SunmiCol(
//                 text: "Qte".toString(), width: 2, align: SunmiAlign.center),
//           ],
//         );
//         for (var i = 0; i < data.length; i++) {
//           SunmiPrinter.row(
//             cols: [
//               SunmiCol(text: "${i + 1}", width: 1),
//               SunmiCol(
//                   text: "${data[i]['designation'] ?? ''}".toString(),
//                   width: 6,
//                   align: SunmiAlign.center),
//               SunmiCol(
//                   text: "${data[i]['stockage'] ?? ''}".toString(),
//                   width: 3,
//                   align: SunmiAlign.center),
//               SunmiCol(
//                   text: "${data[i]['quantite'] ?? ''}".toString(),
//                   width: 2,
//                   align: SunmiAlign.center),
//             ],
//           );
//         }
//         SunmiPrinter.hr();
//         SunmiPrinter.row(
//           cols: [
//             SunmiCol(text: '', width: 1),
//             SunmiCol(
//                 text: "Total".toString(), width: 6, align: SunmiAlign.center),
//             SunmiCol(text: "".toString(), width: 3, align: SunmiAlign.center),
//             SunmiCol(
//                 text: "${data.length}".toString(),
//                 width: 2,
//                 align: SunmiAlign.center),
//           ],
//         );
//         SunmiPrinter.emptyLines(1);

//         SunmiPrinter.hr();
//         SunmiPrinter.text(
//           'Contact: +243 997 039 243',
//           styles: SunmiStyles(
//               align: SunmiAlign.center, size: SunmiSize.md, bold: false),
//         );
//         SunmiPrinter.text(
//           'From company name',
//           styles: SunmiStyles(
//               align: SunmiAlign.center, size: SunmiSize.md, bold: false),
//         );
//         SunmiPrinter.emptyLines(3);
//         // Navigator.pop(navKey.currentContext!);
//       });
// }
