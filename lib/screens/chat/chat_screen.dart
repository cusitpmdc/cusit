import 'package:flutter/material.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/dashboard/drawer_screen.dart';
import 'package:cusit/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': _controller.text,
          'isMe': true, // Indicates that the message is sent by the user
        });
        // Simulate receiving a message for demonstration purposes
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            messages.add({
              'text': 'This is a reply from the other user.',
              'isMe': false,
            });
          });
        });
        _controller.clear();
      });
    }
  }

  Widget buildMessage(Map<String, dynamic> message) {
    final bool isMe = message['isMe'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(
          maxWidth: context.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.cusitclr : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15.0).copyWith(
            topRight: isMe ? Radius.zero : const Radius.circular(15.0),
            topLeft: isMe ? const Radius.circular(15.0) : Radius.zero,
          ),
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(context.width * 0.03),
                    child: Image.asset(
                      'assets/icons/city.png',
                      width: context.width * 0.2,
                      height: context.height * 0.2,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => buildMessage(messages[index]),
                    childCount: messages.length,
                  ),
                ),
              ],
            ),
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
                  color: AppColors.cusitclr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
