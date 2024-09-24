import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String userName;
  final String lastMessage;
  final String timeStamp;
  final String status; // Optional for message status (sent, read)

  Chat({
    required this.chatId,
    required this.userName,
    required this.lastMessage,
    required this.timeStamp,
    this.status = 'sent', // Default status
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      chatId: doc.id,
      userName: doc['userName'],
      lastMessage: doc['lastMessage'],
      timeStamp: doc['timeStamp'],
      status: doc['status'] ?? 'sent', // Handle missing status field
    );
  }
}
