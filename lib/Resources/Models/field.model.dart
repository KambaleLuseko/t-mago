import 'dart:convert';

import '../Helpers/uuid_generator.dart';
import 'cultivator.model.dart';

class FieldsModel {
  int? idCh, syncStatus;
  String adresseCh;
  String? logitude;
  String? latitude;
  String? surfaceCh;
  String? produit;
  String? anneeDebut;
  String? anneeLastoOpera;
  String? status;
  String refMuku;
  String? createdAt, uuid;
  ClientModel? owner;

  FieldsModel(
      {this.idCh,
      required this.adresseCh,
      this.logitude,
      this.latitude,
      this.surfaceCh,
      this.produit,
      this.anneeDebut,
      this.anneeLastoOpera,
      this.status,
      required this.refMuku,
      this.createdAt,
      this.uuid,
      this.syncStatus,
      this.owner});

  static fromJSON(Map<String, dynamic> json) {
    return FieldsModel(
        idCh: int.tryParse(json['id_ch'].toString()),
        adresseCh: json['adresse_ch'],
        logitude: json['logitude'],
        latitude: json['latitude'],
        surfaceCh: json['surface_ch'],
        produit: json['produit'],
        anneeDebut: json['anneeDebut'],
        anneeLastoOpera: json['anneeLastoOpera'],
        status: json['status'],
        refMuku: json['senderID'],
        createdAt: json['created_at'],
        uuid: json['uuid'] ?? uuidGenerator(),
        syncStatus: int.tryParse(json['syncStatus'].toString()) ?? 0,
        owner: json['owner'] is ClientModel
            ? json['owner']
            : json['owner'] != null
                ? json['owner'] is String
                    ? ClientModel.fromJSON(jsonDecode(json['owner']))
                    : ClientModel.fromJSON((json['owner']))
                : null);
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idCh != null) data['id_ch'] = idCh;
    data['adresse_ch'] = adresseCh.toString();
    data['logitude'] = logitude.toString();
    data['latitude'] = latitude.toString();
    data['surface_ch'] = surfaceCh.toString();
    data['produit'] = produit.toString();
    data['anneeDebut'] = anneeDebut.toString();
    data['anneeLastoOpera'] = anneeLastoOpera.toString();
    data['status'] = status?.toString() ?? 'Actif';
    data['senderID'] = refMuku.toString();
    data['created_at'] = createdAt ?? DateTime.now().toString();
    data['uuid'] = uuid ?? uuidGenerator();
    data['syncStatus'] = syncStatus?.toString() ?? '0';
    if (owner != null) data['owner'] = jsonEncode(owner!.toJSON());
    return data;
  }
}
