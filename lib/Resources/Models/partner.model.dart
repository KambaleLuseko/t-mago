// import '../../Resources/Helpers/uuid_generator.dart';

class PartnerModel {
  int? id;
  final String fullname, phone, category;
  final String? address, email, created_at, uuid;
  int isActive;
  int? syncStatus;

  PartnerModel(
      {this.uuid,
      required this.fullname,
      required this.category,
      required this.phone,
      this.id,
      this.address,
      this.email,
      required this.isActive,
      this.created_at,
      this.syncStatus});

  static fromJSON(json) {
    return PartnerModel(
      // uuid: json['uuid'] ?? uuidGenerator(),
      fullname: json['fullname'] ?? '',
      category: json['category'] ?? 'Client',
      phone: json['phone'] ?? '',
      id: int.tryParse(json['id'].toString()) ?? 0,
      address: json['address'],
      email: json['email'],
      isActive: int.tryParse(json['isActive'].toString()) ?? 0,
      syncStatus: int.tryParse(json['syncStatus'].toString()) ?? 0,
      created_at: DateTime.now().toString(),
    );
  }

  toJSON() {
    return {
      "uuid": uuid,
      "fullname": fullname,
      "category": category,
      "phone": phone,
      if (id != null && id != 0) "id": id,
      "address": address,
      "email": email,
      "isActive": isActive,
      "syncStatus": syncStatus,
      "created_at": created_at
    };
  }
}
