class MessageModel {
  final String role;
  final List<ChatPartModel> parts;

  MessageModel({required this.role, required this.parts});
}

class ChatPartModel {
  final String text;
  ChatPartModel({required this.text});
}
