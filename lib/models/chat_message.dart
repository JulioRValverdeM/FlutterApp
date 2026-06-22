class ChatMessage {

  final int id;
  final String username;
  final String text;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(
      Map<String, dynamic> json) {

    return ChatMessage(
      id: json['id'],
      username: json['username'],
      text: json['text'],
      createdAt: json['created_at'],
    );
  }
}