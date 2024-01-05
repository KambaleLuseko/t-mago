// import '../../Resources/Helpers/uuid_generator.dart';
import '../../Resources/Models/user_permission.model.dart';

class UserModel {
  final String fullname, username, password;
  final String? refDepot, numPos, phone;
  int? syncStatus, isActive, id;
  List? permissions;

  UserModel(
      {required this.fullname,
      this.phone,
      required this.username,
      required this.password,
      this.refDepot,
      this.numPos,
      this.isActive,
      this.syncStatus,
      this.id,
      this.permissions});

  static fromJSON(json) {
    return UserModel(
      fullname: json['nom_user'],
      phone: json['tel_user'],
      username: json['username'],
      password: json['password'],
      refDepot: json['ref_depot'],
      numPos: json['num_pos'],
      isActive: int.tryParse(json['isActive'].toString()) ?? 1,
      syncStatus: int.tryParse(json['syncStatus'].toString()) ?? 0,
      // uuid: json['uuid'] ?? uuidGenerator(),
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  toJSON() {
    return {
      "nom_user": fullname,
      "tel_user": phone,
      "username": username,
      "password": password,
      "ref_depot": refDepot,
      "num_pos": numPos,
      "isActive": isActive,
      "syncStatus": syncStatus,
      "id": id
    };
  }
}

class AuthModel {
  final UserModel user;
  final String token;
  AuthModel({required this.user, required this.token});

  static fromJSON(json) {
    return AuthModel(
        user: UserModel.fromJSON(json['user']), token: json['token']);
  }

  toJSON() {
    return {"user": user.toJSON(), 'token': token};
  }
}
