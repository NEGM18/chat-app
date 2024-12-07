import 'dart:io';
import 'package:chat/widgets/chatbuble%20_for_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat/model/chat_model.dart';
import 'package:chat/widgets/chatbubles.dart';
import 'package:chat/widgets/chatpaber.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';

  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CollectionReference messages = FirebaseFirestore.instance.collection('/messages');
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  String? gmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        gmail = ModalRoute.of(context)?.settings.arguments as String?;
      });
    });
  }

  Future<void> sendMessage({String? imageUrl}) async {
    if ((controller.text.trim().isNotEmpty || imageUrl != null) && gmail != null) {
      await messages.add({
        'message': controller.text.trim(),
        'created at': DateTime.now(),
        'id': gmail,
        'imageUrl': imageUrl,
      });
      controller.clear();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('chat_images/$fileName');

        final UploadTask uploadTask = storageRef.putFile(file);
        final TaskSnapshot snapshot = await uploadTask;
        final String imageUrl = await snapshot.ref.getDownloadURL();

        await sendMessage(imageUrl: imageUrl); // Send the message with the image URL
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $error')),
      );
    }
  }

  Future<void> deleteMessage(String docId) async {
    try {
      await messages.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting message'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy("created at").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0XFF0000000),
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/pngegg (2).png',
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'NMU CHAT',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                const Positioned.fill(child: Chatpaber()),
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  bottom: 80,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            final message = messageList[index];
                            return Dismissible(
                              key: Key(message.docId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                              ),
                              onDismissed: (direction) {
                                deleteMessage(message.docId);
                              },
                              child: message.id == gmail
                                  ? Chatbubles(messageeee: message)
                                  : ChatbubleForFriend(messageeee: message),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.image, color: Colors.red),
                              onPressed: pickAndUploadImage,
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                onSubmitted: (data) => sendMessage(),
                                decoration: const InputDecoration(
                                  labelText: "Send message",
                                  labelStyle: TextStyle(fontSize: 20, color: Colors.red),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.red),
                              onPressed: () => sendMessage(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
