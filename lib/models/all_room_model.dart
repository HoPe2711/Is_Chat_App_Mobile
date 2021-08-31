// To parse this JSON data, do
//
//     final allRoom = allRoomFromJson(jsonString);

import 'dart:convert';

AllRoom allRoomFromJson(String str) => AllRoom.fromJson(json.decode(str));

String allRoomToJson(AllRoom data) => json.encode(data.toJson());

class AllRoom {
  AllRoom({
    this.status,
    this.data,
  });

  Status status;
  List<Datum> data;

  factory AllRoom.fromJson(Map<String, dynamic> json) => AllRoom(
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
    this.roomName,
    this.userList,
    this.host,
    this.content,
    this.senderName,
    this.timestamp,
  });

  String id;
  String roomName;
  List<Host> userList;
  Host host;
  String content;
  String senderName;
  int timestamp;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    roomName: json["roomName"],
    userList: List<Host>.from(json["userList"].map((x) => Host.fromJson(x))),
    host: Host.fromJson(json["host"]),
    content: json["content"] == null ? null : json["content"],
    senderName: json["senderName"] == null ? null : json["senderName"],
    timestamp: json["timestamp"] == null ? null : json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomName": roomName,
    "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    "host": host.toJson(),
    "content": content == null ? null : content,
    "senderName": senderName == null ? null : senderName,
    "timestamp": timestamp == null ? null : timestamp,
  };
}

class Host {
  Host({
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

  factory Host.fromJson(Map<String, dynamic> json) => Host(
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
