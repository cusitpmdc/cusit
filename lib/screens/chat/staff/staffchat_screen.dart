import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class StaffChatScreen extends StatefulWidget {
  final String chatId;
  final String staffId;

  const StaffChatScreen({Key? key, required this.chatId, required this.staffId}) : super(key: key);

  @override
  _StaffChatScreenState createState() => _StaffChatScreenState();
}

class _StaffChatScreenState extends State<StaffChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _firestore
          .collection('chats')
          .doc(widget.chatId) // Chat document for specific chatId
          .collection('messages')
          .add({
        'text': _controller.text,
        'isMe': false, // Assuming staff is not the sender
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': widget.staffId,
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Guest'),
      ),
      body: Column(
        children: [
          Expanded(
            child:StreamBuilder<QuerySnapshot>(
  stream: _firestore
      .collection('chats')
      .doc(widget.chatId) // Ensure staff uses the same chatId as guest
      .collection('messages')
      .orderBy('timestamp')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    final messages = snapshot.data!.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['senderId'] == widget.staffId; // Check if message is from staff
        return ListTile(
          title: Text(message['text']),
          subtitle: Text(isMe ? 'Me' : 'Guest'), // Correctly label the sender
        );
      },
    );
  },
)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
