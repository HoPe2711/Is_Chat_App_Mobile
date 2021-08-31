// To parse this JSON data, do
//
//     final eachRoom = eachRoomFromJson(jsonString);

import 'dart:convert';

EachRoom eachRoomFromJson(String str) => EachRoom.fromJson(json.decode(str));

String eachRoomToJson(EachRoom data) => json.encode(data.toJson());

class EachRoom {
  EachRoom({
    this.status,
    this.data,
  });

  Status status;
  Data data;

  factory EachRoom.fromJson(Map<String, dynamic> json) => EachRoom(
    status: Status.fromJson(json["status"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.roomName,
    this.userList,
    this.host,
  });

  String id;
  String roomName;
  List<Host> userList;
  Host host;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    roomName: json["roomName"],
    userList: List<Host>.from(json["userList"].map((x) => Host.fromJson(x))),
    host: Host.fromJson(json["host"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomName": roomName,
    "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    "host": host.toJson(),
  };
}

class Host {
  Host({
    this.id,
    this.username,
    this.password,
    this.displayName,
    this.avatar,
    this.email,
    this.status,
  });

  String id;
  String username;
  String password;
  String displayName;
  dynamic avatar;
  String email;
  bool status;

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    displayName: json["displayName"],
    avatar: json["avatar"],
    email: json["email"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
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
