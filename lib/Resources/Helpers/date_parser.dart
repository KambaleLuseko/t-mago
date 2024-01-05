import 'package:date_format/date_format.dart';

parseDate({required String date}) {
  if (date.isEmpty || DateTime.tryParse(date) == null) {
    return "0000-00-00 00:00:00";
  }
  return formatDate(DateTime.parse(date.toString().trim()),
      [dd, '/', mm, '/', yyyy, ' ', HH, '\\h ', nn, 'min ', ss, '\\s']);
}

numberFormat({required double number}) {
  return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2);
}

// amountConversion({required String amount, required String currency}) {
//   if (navKey.currentContext!.read<UserProvider>().defaultCurrency != null) {
//     if (navKey.currentContext!
//             .read<UserProvider>()
//             .defaultCurrency
//             ?.name
//             .toLowerCase() !=
//         'usd') {
//       if (currency.toLowerCase() == 'usd') {
//         return double.parse(amount) *
//             double.parse(navKey.currentContext!
//                 .read<UserProvider>()
//                 .defaultCurrency!
//                 .rateFromUSD);
//       }
//     }
//     if (navKey.currentContext!
//             .read<UserProvider>()
//             .defaultCurrency
//             ?.name
//             .toLowerCase() ==
//         'usd') {
//       if (currency.toLowerCase() != 'usd') {
//         return double.parse(amount) /
//             double.parse(navKey.currentContext!
//                 .read<UserProvider>()
//                 .defaultCurrency!
//                 .rateFromUSD);
//       }
//     }
//     if (navKey.currentContext!
//             .read<UserProvider>()
//             .defaultCurrency
//             ?.name
//             .toLowerCase() ==
//         'usd') {
//       if (currency.toLowerCase() == 'usd') {
//         return double.parse(amount);
//       }
//     }
//   }
//   return double.parse(amount);
// }
