import '../Helpers/uuid_generator.dart';

class StoreModel {
  int? id;
  String name;
  String? address, surface, uuid;
  StoreModel(
      {required this.name, this.address, this.surface, this.id, this.uuid});

  static fromJSON(json) {
    return StoreModel(
      name: json['designation'],
      address: json['adresse_depot'],
      surface: json['surface_depot'],
      id: int.tryParse(
        json['id'].toString(),
      ),
      uuid: json['uuid'],
    );
  }

  toJSON() {
    return {
      "designation": name,
      "adresse_depot": address,
      "surface_depot": surface,
      "id": id,
      "uuid": uuid ?? uuidGenerator(),
    };
  }
}

class PriceModel {
  int? id;
  String price, currency;
  PriceModel({required this.price, required this.currency, this.id});

  static fromJSON(json) {
    return PriceModel(
      price: json['prix_kg'],
      currency: json['design_device'],
      id: int.tryParse(
        json['id_prix'].toString(),
      ),
    );
  }

  toJSON() {
    return {
      "prix_kg": price,
      "design_device": currency,
      "id_prix": id,
    };
  }
}
