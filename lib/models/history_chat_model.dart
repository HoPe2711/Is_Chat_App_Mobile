// To parse this JSON data, do
//
//     final historyChat = historyChatFromJson(jsonString);

import 'dart:convert';

HistoryChat historyChatFromJson(String str) => HistoryChat.fromJson(json.decode(str));

String historyChatToJson(HistoryChat data) => json.encode(data.toJson());

class HistoryChat {
  HistoryChat({
    this.status,
    this.data,
  });

  Status status;
  List<Datum> data;

  factory HistoryChat.fromJson(Map<String, dynamic> json) => HistoryChat(
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
    this.senderId,
    this.senderName,
    this.chatRoomId,
    this.chatRoomName,
    this.content,
    this.timestamp,
    this.status,
  });

  String id;
  String senderId;
  String senderName;
  String chatRoomId;
  String chatRoomName;
  String content;
  int timestamp;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    senderId: json["senderId"],
    senderName: json["senderName"],
    chatRoomId: json["chatRoomId"],
    chatRoomName: json["chatRoomName"],
    content: json["content"],
    timestamp: json["timestamp"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "senderName": senderName,
    "chatRoomId": chatRoomId,
    "chatRoomName": chatRoomName,
    "content": content,
    "timestamp": timestamp,
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
