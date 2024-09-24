import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/chat/staff/staffchat_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/screens/models/schatmodel.dart';
import 'package:cusit/services/chatservice.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/drawer_screen.dart';

class StaffDashBoardScreen extends StatefulWidget {
  static const String id = 'staffdash_screen';

  const StaffDashBoardScreen({super.key});

  @override
  State<StaffDashBoardScreen> createState() => _StaffDashBoardScreenState();
}

class _StaffDashBoardScreenState extends State<StaffDashBoardScreen> {
  late Stream<List<Chat>> _chatsStream;

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        Navigator.pushReplacementNamed(context, DashboardScreen.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout. Please try again. Error: $e'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _chatsStream = ChatService().fetchChatsRealTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey.shade100,
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: AppColors.cusitclr,
        elevation: 0,
        foregroundColor: AppColors.white,
        title: Image.asset(
          'assets/icons/Logowb.png',
          width: context.width * 0.3,
          height: context.height * 0.2,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.width * 0.03),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _logout();
              },
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _chatsStream,
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
                    // Mark messages as read when the chat is opened
                    _markMessagesAsRead(chat.chatId);

                    // Navigate to individual chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaffChatScreen(
                          chatId: chat.chatId,
                          staffId: '', // Pass the staff ID if needed
                        ),
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

  void _markMessagesAsRead(String chatId) {
    ChatService().markMessagesAsRead(chatId);
  }
}
