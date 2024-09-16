import 'dart:convert';

class MessageModel {
  final String role;
  final List<ChatPartModel> parts;

  MessageModel({required this.role, required this.parts});

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      role: map['role'] ?? '',
      parts: List<ChatPartModel>.from(
          map['parts']?.map((x) => ChatPartModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}

class ChatPartModel {
  final String text;
  ChatPartModel({required this.text});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory ChatPartModel.fromMap(Map<String, dynamic> map) {
    return ChatPartModel(
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatPartModel.fromJson(String source) =>
      ChatPartModel.fromMap(json.decode(source));
}
