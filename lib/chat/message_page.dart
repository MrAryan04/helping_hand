import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../call/call_page.dart';
import '../constants/constants.dart';

class MessagePage extends StatefulWidget {
  final String recipientUserId;

  const MessagePage({super.key, required this.recipientUserId});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _recipientUserName;

  @override
  void initState() {
    super.initState();
    fetchRecipientUserName();
  }

  Future<void> fetchRecipientUserName() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Register')
        .doc(widget.recipientUserId)
        .get();

    final Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    final String recipientUserName = userData['name'] ?? '';

    setState(() {
      _recipientUserName = recipientUserName;
    });
  }

  void sendMessage(String message) {
    _firestore
        .collection('messages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'messages': FieldValue.arrayUnion([
        {
          'message': message,
          'senderUserId': FirebaseAuth.instance.currentUser!.uid,
          'recipientUserId': widget.recipientUserId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      ]),
    }, SetOptions(merge: true));

    _messageController.clear();

    setState(() {});

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  // get Own messages from firebase return a list of messages
  Future<List<Map<String, dynamic>>> getOwnMessages() async {
    // check if the document exists
    final DocumentSnapshot documentSnapshot = await _firestore
        .collection('messages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!documentSnapshot.exists) {
      return [];
    }

    final Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> messages = userData['messages'] as List<dynamic>;

    return messages
        .map((message) => message as Map<String, dynamic>)
        .where(
            (message) => message['recipientUserId'] == widget.recipientUserId)
        .toList();
  }

  // get recipient messages from firebase return a list of messages
  Future<List<Map<String, dynamic>>> getRecipientMessages() async {
    final DocumentSnapshot documentSnapshot = await _firestore
        .collection('messages')
        .doc(widget.recipientUserId)
        .get();

    if (!documentSnapshot.exists) {
      return [];
    }

    final Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> messages = userData['messages'] as List<dynamic>;

    return messages
        .map((message) => message as Map<String, dynamic>)
        .where((message) =>
            message['recipientUserId'] ==
            FirebaseAuth.instance.currentUser!.uid)
        .toList();
  }

  // get all messages from firebase return a list of messages
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final List<Map<String, dynamic>> ownMessages = await getOwnMessages();
    final List<Map<String, dynamic>> recipientMessages =
        await getRecipientMessages();

    final List<Map<String, dynamic>> allMessages = [];
    allMessages.addAll(ownMessages);
    allMessages.addAll(recipientMessages);

    allMessages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

    return allMessages;
  }

  Future<void> sendAndroidNotification({required String type}) async {
    print('sendAndroidNotification');
    String username = FirebaseAuth.instance.currentUser!.displayName!;
    String authorizedSupplierTokenId = await _firestore
        .collection('Register')
        .doc(widget.recipientUserId)
        .get()
        .then((value) => value.data()!['fcmToken'] as String);
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Constants.firebaseMessagingAuthorization
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$username is calling',
              'title': 'Incoming $type Call',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': authorizedSupplierTokenId,
            'token': authorizedSupplierTokenId
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }

  void call({required String type}) {
    String callId = const Uuid().v4();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String userName = FirebaseAuth.instance.currentUser!.displayName!;
    sendAndroidNotification(type: type).then((value) async {
      await FirebaseFirestore.instance
          .collection('Call')
          .doc(widget.recipientUserId)
          .set({
        'callId': callId,
        'from': FirebaseAuth.instance.currentUser!.uid,
        'to': widget.recipientUserId,
        'type': type,
      }).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              recipientUserId: widget.recipientUserId,
              callID: callId,
              callType: type,
              userID: userId,
              userName: userName,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _recipientUserName ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      call(type: 'voice');
                    }),
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {
                    call(type: 'video');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getAllMessages(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<Map<String, dynamic>> messages = snapshot.data!;

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> message = messages[index];
                      final bool isOwnMessage = message['senderUserId'] ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return MessageCard(
                        text: message['message'],
                        isOwnMessage: isOwnMessage,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  suffixIcon: _messageController.text.trim().isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () => sendMessage(_messageController.text),
                        ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 5.0,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// message card
class MessageCard extends StatelessWidget {
  final String text;
  final bool isOwnMessage;
  const MessageCard({
    super.key,
    required this.text,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: isOwnMessage ? Colors.purple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isOwnMessage ? Colors.white : Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
