import 'package:cusit/screens/chat/staff/staffchat_screen.dart';
import 'package:cusit/screens/models/schatmodel.dart';
import 'package:cusit/services/chatservice.dart';
import 'package:flutter/material.dart';

class StaffDashBoardScreen extends StatefulWidget {
  static const String id = 'staffdash_screen';

  const StaffDashBoardScreen({super.key});

  @override
  State<StaffDashBoardScreen> createState() => _StaffDashBoardScreenState();
}

class _StaffDashBoardScreenState extends State<StaffDashBoardScreen> {
  late Future<List<Chat>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = ChatService().fetchChats(); // Fetch chats for staff (students/guests)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
      ),
      body: FutureBuilder<List<Chat>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching chats"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats available"));
          } else {
            List<Chat> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                Chat chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(chat.userName[0]), // Show the first letter of the username
                  ),
                  title: Text(chat.userName),
                  subtitle: Text(chat.lastMessage),
                  trailing: Text(chat.timeStamp),
                  onTap: () {
                    // Navigate to individual chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaffChatScreen(chatId: chat.chatId, staffId: '',),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
