import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/screens/models/schatmodel.dart';

class ChatService {
  // Fetch chats from Firestore or any other database
  Future<List<Chat>> fetchChats() async {
    List<Chat> chatList = [];
    
    // Assuming you use Firebase Firestore to store chats
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').get();
    
    for (var doc in querySnapshot.docs) {
      chatList.add(Chat.fromMap(doc.data() as Map<String, dynamic>));
    }

    return chatList;
  }
}
