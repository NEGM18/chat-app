import 'package:chat/model/chat_model.dart';
import 'package:chat/widgets/chatbuble%20_for_friend.dart';

import 'package:chat/widgets/chatbubles.dart';
import 'package:chat/widgets/chatpaber.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';

  ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CollectionReference messages = FirebaseFirestore.instance.collection('/messages');
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? gmail;

  
  List<Message> starredMessages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        gmail = ModalRoute.of(context)?.settings.arguments as String?;
      });
    });

    messages.orderBy('created at').snapshots().listen((snapshot) {
      if (_scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 100)).then((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  void sendMessage() {
    if (controller.text.trim().isNotEmpty && gmail != null) {
      messages.add({
        'message': controller.text.trim(),
        'created at': DateTime.now(),
        'id': gmail,
      });
      controller.clear();

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void deleteMessage(String docId, Message message) async {
    try {
      
      await messages.doc(docId).delete();

      
      setState(() {
        if (starredMessages.contains(message)) {
          starredMessages.remove(message);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting message')),
      );
    }
  }

  
  void starMessage(Message message) {
    setState(() {
      if (!starredMessages.contains(message)) {
        starredMessages.add(message);
      } else {
        starredMessages.remove(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy("created at").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            messageList.add(Message.fromJson(data, doc.id));
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
              actions: [
                
                IconButton(
                  icon: const Icon(Icons.star, color: Colors.yellow),
                  onPressed: () {
                    
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Starred Messages'),
                          content: SizedBox(
                            height: 300,
                            child: ListView(
                              children: starredMessages.map((message) {
                                return ListTile(
                                  title: Text(message.message),
                                  subtitle: Text(message.id),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        starredMessages.remove(message);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                const Positioned.fill(
child: Chatpaber(),
                ),
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
                          reverse: false,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            final message = messageList[index];
                            return Dismissible(
                              key: Key(message.docid), 
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                              ),
                              onDismissed: (direction) {
                                deleteMessage(message.docid, message); 
                              },
                              child: GestureDetector(
                                onTap: () => starMessage(message), 
                                child: message.id == gmail
                                    ? Chatbubles(
                                        messageeee: message,
                                      )
                                    : ChatbubleForFriend(
                                        messageeee: message,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                onSubmitted: (data) => sendMessage(),
                                strutStyle: const StrutStyle(fontSize: 15),
                                style: const TextStyle(color: Colors.white),
                                autocorrect: true,
                                decoration: const InputDecoration(
                                  labelText: "Send message",
                                  labelStyle: TextStyle(fontSize: 20, color: Colors.red),
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.red),
                              onPressed: sendMessage,
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
