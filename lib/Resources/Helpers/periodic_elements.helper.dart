import 'dart:convert';

import 'package:flutter/services.dart';

Future<List> loadPeriodicElementsData() async {
  var data = await rootBundle.loadString('Assets/Local/PeriodicTableJSON.json');
  // print(jsonDecode(data));
  return jsonDecode(data)['elements'];
}
