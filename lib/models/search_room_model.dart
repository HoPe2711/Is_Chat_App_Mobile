// To parse this JSON data, do
//
//     final searchRoom = searchRoomFromJson(jsonString);

import 'dart:convert';

SearchRoom searchRoomFromJson(String str) => SearchRoom.fromJson(json.decode(str));

String searchRoomToJson(SearchRoom data) => json.encode(data.toJson());

class SearchRoom {
  SearchRoom({
    this.status,
    this.data,
  });

  Status status;
  List<Datum> data;

  factory SearchRoom.fromJson(Map<String, dynamic> json) => SearchRoom(
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
  dynamic content;
  dynamic senderName;
  dynamic timestamp;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    roomName: json["roomName"],
    userList: List<Host>.from(json["userList"].map((x) => Host.fromJson(x))),
    host: Host.fromJson(json["host"]),
    content: json["content"],
    senderName: json["senderName"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomName": roomName,
    "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    "host": host.toJson(),
    "content": content,
    "senderName": senderName,
    "timestamp": timestamp,
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
