// To parse this JSON data, do
//
//     final findUser = findUserFromJson(jsonString);

import 'dart:convert';

FindUser findUserFromJson(String str) => FindUser.fromJson(json.decode(str));

String findUserToJson(FindUser data) => json.encode(data.toJson());

class FindUser {
  FindUser({
    this.status,
    this.data,
  });

  Status status;
  List<Datum> data;

  factory FindUser.fromJson(Map<String, dynamic> json) => FindUser(
    status: Status.fromJson(json["status"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.username,
    this.displayName,
    this.avatar,
    this.email,
    this.status,
  });

  String id;
  String username;
  String displayName;
  dynamic avatar;
  String email;
  bool status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    username: json["username"],
    displayName: json["displayName"],
    avatar: json["avatar"],
    email: json["email"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "displayName": displayName,
    "avatar": avatar,
    "email": email,
    "status": status,
  };
}

class Status {
  Status({
    this.code,
    this.message,
  });

  String code;
  String message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
