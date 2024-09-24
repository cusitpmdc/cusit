import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/screens/models/schatmodel.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Real-time chat fetching for staff
  Stream<List<Chat>> fetchChatsRealTime() {
    return _firestore.collection('chats').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList();
    });
  }

  // Mark messages as read when a staff opens the chat
  void markMessagesAsRead(String chatId) async {
    final chatMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('status', isEqualTo: 'sent')
        .get();

    for (var message in chatMessages.docs) {
      message.reference.update({'status': 'read'});
    }
  }
}
