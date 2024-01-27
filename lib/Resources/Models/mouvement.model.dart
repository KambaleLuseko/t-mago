import 'dart:convert';

import '../Helpers/uuid_generator.dart';
import 'cultivator.model.dart';
import 'store.model.dart';

class MouvementModel {
  String? storeName,
      storeAddress,
      destStoreName,
      destStoreAddress,
      senderName,
      senderTel,
      receiverName,
      receiverTel,
      uuid,
      image,
      refMvtEntry,
      destination,
      createdAt,
      status;
  int? syncStatus, id;
  String mouvementType, storeID, userID;
  List<MouvementDetailsModel> detailsMouvement;
  List<MouvementTrackingModel>? tracking;
  ClientModel? sender;
  StoreModel? destinationStore;
  MouvementModel? outStock;
  MouvementModel(
      {required this.mouvementType,
      required this.storeID,
      // required this.receiverID,
      // required this.senderID,
      required this.userID,
      this.senderName,
      this.senderTel,
      this.receiverName,
      this.receiverTel,
      this.storeName,
      this.storeAddress,
      this.destStoreName,
      this.destStoreAddress,
      required this.detailsMouvement,
      this.syncStatus,
      this.uuid,
      this.id,
      this.image,
      this.refMvtEntry,
      this.destination,
      this.outStock,
      this.createdAt,
      this.status,
      this.sender,
      this.destinationStore,
      this.tracking});

  static fromJSON(json) {
    var detailsMvt = json['detailsMouvement'] is String
        ? jsonDecode(json['detailsMouvement'])
        : json['detailsMouvement'];

    var track = json['tracking'] is String
        ? jsonDecode(json['tracking'])
        : json['tracking'] ?? [];
    return MouvementModel(
      mouvementType: json['type_mvt'],
      storeID: json['ref_depot'],
      userID: json['ref_user'],
      // receiverID: json['receiverID'].toString(),
      // senderID: json['senderID'].toString(),
      storeName: json['storeName'],
      detailsMouvement: json['detailsMouvement'] is List<MouvementDetailsModel>
          ? json['detailsMouvement']
          : json['detailsMouvement'] != null
              ? List<MouvementDetailsModel>.from(
                  detailsMvt.map((e) => MouvementDetailsModel.fromJSON(e)))
              : [],
      syncStatus: int.tryParse(json['syncStatus'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
      uuid: json['uuid'],
      // image: json['image'],
      refMvtEntry: json['ref_mouv_entry'] ?? '',
      destination: json['destination'] ?? '',
      outStock: json['outStock'] is List && json['outStock'].isNotEmpty
          ? MouvementModel.fromJSON(json['outStock'][0])
          : json['outStock'] is MouvementModel
              ? json['outStock']
              : json['outStock'] is Map
                  ? MouvementModel.fromJSON(json['outStock'])
                  : null,
      createdAt: json['created_at'] ?? DateTime.now().toString(),
      status: json['status'] ?? 'Pending',
      sender:
          json['sender'] != null ? ClientModel.fromJSON(json['sender']) : null,
      destinationStore: json['destinationStore'] != null
          ? StoreModel.fromJSON(json['destinationStore'])
          : null,
      receiverName: json['receiver_name'] ?? '',
      receiverTel: json['receiver_phone'] ?? '',
      senderName: json['senderName'] ?? '',
      senderTel: json['senderTel'] ?? '',
      tracking: json['tracking'] is List<MouvementTrackingModel>
          ? json['tracking']
          : (json['tracking'] != null && json['tracking'] is List) ||
                  track != null
              ? List<MouvementTrackingModel>.from(
                  track.map((e) => MouvementTrackingModel.fromJson(e)))
              : [],
    )
      ..storeAddress = json['storeAddress']
      ..destStoreName = json['destStoreName']
      ..destStoreAddress = json['destStoreAddress'];
  }

  toJSON() {
    return {
      "type_mvt": mouvementType,
      "ref_depot": storeID.toString(),
      // "senderID": senderID.toString(),
      "ref_user": userID.toString(),
      "storeName": storeName ?? '',
      'storeAddress': storeAddress,
      "destStoreName": destStoreName,
      "destStoreAddress": destStoreAddress,
      "receiver_name": receiverName ?? '',
      "receiver_phone": receiverTel ?? '',
      "senderName": senderName ?? '',
      "senderTel": senderTel ?? '',
      "detailsMouvement":
          jsonEncode(detailsMouvement.map((e) => e.toJSON()).toList()),
      "syncStatus": syncStatus?.toString() ?? '0',
      "id": id?.toString() ?? '0',
      "uuid": uuid ?? uuidGenerator(),
      // "image": image,
      "ref_mouv_entry": refMvtEntry ?? '',
      "destination": destination ?? '',
      if (outStock != null) "outStock": outStock?.toJSON(),
      'created_at': createdAt ?? DateTime.now().toString(),
      'status': status ?? 'Pending',
      'sender': sender?.toJSON(),
      'destinationStore': destinationStore?.toJSON(),
      "tracking": jsonEncode(tracking?.map((e) => e.toJson()).toList()),
    };
  }
}

class MouvementDetailsModel {
  String product, storageType, weights, priceID;
  String? priceValue,
      uuid,
      mouvementUUID,
      decoteHumidite,
      storageWeight,
      netPrice,
      totalNetWeight;
  MouvementDetailsModel({
    required this.product,
    required this.storageType,
    required this.weights,
    required this.priceID,
    required this.priceValue,
    this.uuid,
    this.mouvementUUID,
    this.decoteHumidite,
    this.storageWeight,
    this.netPrice,
    this.totalNetWeight,
  });

  static fromJSON(json) {
    return MouvementDetailsModel(
      product: json['product'],
      storageType: json['entreposage'],
      weights: json['kg'].toString(),
      priceID: json['prix_kg'].toString(),
      priceValue: json['total_kg'].toString(),
      uuid: json['uuid'],
      mouvementUUID: json['mouvement_uuid'],
      decoteHumidite: json['decote_humidite'].toString(),
      storageWeight: json['kg_sac'].toString(),
      netPrice: json['prix_net'].toString(),
      totalNetWeight: json['total_kg_net'].toString(),
    );
  }

  toJSON() {
    return {
      "product": product,
      "entreposage": storageType,
      "kg": weights.toString(),
      "prix_kg": priceID.toString(),
      "total_kg": priceValue.toString(),
      "uuid": uuid ?? uuidGenerator(),
      "mouvement_uuid": mouvementUUID ?? '',
      "decote_humidite": decoteHumidite ?? '',
      "kg_sac": storageWeight ?? '',
      "prix_net": netPrice ?? '',
      "total_kg_net": totalNetWeight ?? '',
    };
  }
}

class MouvementTrackingModel {
  String? id;
  String? uuid;
  String? mouvUuid;
  String? userId;
  String? sourceDepotId;
  String? destDepotId;
  String? label;
  String? createdAt, storeName, storeAddress, destStoreName, destStoreAddress;

  MouvementTrackingModel(
      {this.id,
      this.uuid,
      this.mouvUuid,
      this.userId,
      this.sourceDepotId,
      this.destDepotId,
      this.label,
      this.createdAt,
      this.storeName,
      this.storeAddress,
      this.destStoreName,
      this.destStoreAddress});

  static fromJson(Map<String, dynamic> json) {
    // print(json['label']);
    MouvementTrackingModel data = MouvementTrackingModel()
      ..id = json['id']
      ..uuid = json['uuid']
      ..mouvUuid = json['mouv_uuid']
      ..userId = json['user_id']?.toString()
      ..sourceDepotId = json['source_depot_id']?.toString()
      ..destDepotId = json['dest_depot_id']?.toString()
      ..label = json['label']?.toString()
      ..createdAt = json['created_at']
      ..storeName = json['storeName']
      ..storeAddress = json['storeAddress']
      ..destStoreName = json['destStoreName']
      ..destStoreAddress = json['destStoreAddress'];
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid ?? uuidGenerator();
    data['mouv_uuid'] = mouvUuid;
    data['user_id'] = userId;
    data['source_depot_id'] = sourceDepotId;
    data['dest_depot_id'] = destDepotId;
    data['label'] = label;
    data['created_at'] = createdAt;
    data['storeName'] = storeName;
    data['storeAddress'] = storeAddress;
    data['destStoreName'] = destStoreName;
    data['destStoreAddress'] = destStoreAddress;
    return data;
  }
}
