import 'package:cusit/screens/chat/user/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/utils/app_colors.dart';

class StaffChatScreen extends StatefulWidget {
  const StaffChatScreen({super.key});

  @override
  State<StaffChatScreen> createState() => _StaffChatScreenState();
}

class _StaffChatScreenState extends State<StaffChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cusitclr,
        elevation: 0,
        foregroundColor: AppColors.white,
        title: const Text('Staff Chats'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final guestChatId = chats[index].id;

              return ListTile(
                title: Text('Chat with Guest $guestChatId'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestChatScreen(staffId: guestChatId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
