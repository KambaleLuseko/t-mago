import '../Helpers/uuid_generator.dart';

class ClientModel {
  String nom;
  String postnom;
  String? prenom, fullname;
  String tel;
  String adresse;
  String? createdAt, uuid;
  int? id, syncStatus;

  ClientModel(
      {required this.nom,
      required this.postnom,
      this.prenom,
      required this.tel,
      required this.adresse,
      this.createdAt,
      this.id,
      this.syncStatus,
      this.uuid,
      this.fullname});

  static fromJSON(Map<String, dynamic> json) {
    return ClientModel(
      id: int.tryParse(json['id'].toString()),
      nom: json['nom'],
      postnom: json['postnom'],
      prenom: json['prenom'],
      fullname:
          json['nom'] + ' ' + json['postnom'] + ' ' + json['prenom'] ?? '',
      tel: json['tel'],
      adresse: json['adresse'],
      createdAt: json['created_at'] ?? DateTime.now().toString(),
      syncStatus: int.tryParse(json['syncStatus'].toString()) ?? 0,
      uuid: json['uuid'] ?? uuidGenerator(),
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['postnom'] = postnom;
    data['prenom'] = prenom;
    data['tel'] = tel;
    data['adresse'] = adresse;
    data['created_at'] = createdAt ?? DateTime.now().toString();
    data['syncStatus'] = syncStatus?.toString() ?? '0';
    if (id != null) data['id'] = id?.toString();
    data['uuid'] = uuid ?? uuidGenerator();
    return data;
  }
}
