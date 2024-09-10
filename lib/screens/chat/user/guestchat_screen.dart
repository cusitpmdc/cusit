import 'package:cusit/screens/models/schatmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/dashboard/drawer_screen.dart';
import 'package:cusit/utils/app_colors.dart';

class GuestChatScreen extends StatefulWidget {
  static const String id = 'gchat_Screen';

  final String staffId; // Add the staffId parameter to the constructor

  const GuestChatScreen({Key? key, required this.staffId, required Chat chat}) : super(key: key);

  @override
  State<GuestChatScreen> createState() => _GuestChatScreenState();
}

class _GuestChatScreenState extends State<GuestChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? guestId;

  @override
  void initState() {
    super.initState();
    _loadGuestId();
  }

  Future<void> _loadGuestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('guestId');
    if (id == null) {
      // Generate a new UUID
      id = const Uuid().v4();
      await prefs.setString('guestId', id);
    }
    setState(() {
      guestId = id;
    });
  }

  void sendMessage() async {
    if (_controller.text.isNotEmpty && guestId != null) {
      await _firestore
          .collection('chats')
          .doc(widget.staffId) // Chat document for specific staff member
          .collection('messages')
          .add({
        'text': _controller.text,
        'isMe': true,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': 'guest_$guestId',
      });

      _controller.clear();
    }
  }

  Widget buildMessage(Map<String, dynamic> message) {
    final bool isMe = message['senderId'] == 'guest_$guestId';
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
    if (guestId == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.staffId)
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

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(context.width * 0.03),
                        child: Image.asset(
                          'assets/icons/city.png',
                          width: context.width * 0.1,
                          height: context.height * 0.1,
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
                );
              },
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
