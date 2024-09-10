class Chat {
  final String chatId;
  final String userName;
  final String lastMessage;
  final String timeStamp;

  Chat({
    required this.chatId,
    required this.userName,
    required this.lastMessage,
    required this.timeStamp,
  });

  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      chatId: data['chatId'] ?? '',
      userName: data['userName'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      timeStamp: data['timeStamp'] ?? '',
    );
  }
}
