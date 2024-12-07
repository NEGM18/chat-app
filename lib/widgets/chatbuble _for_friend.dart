import 'package:chat/model/chat_model.dart';
import 'package:flutter/material.dart';



class ChatbubleForFriend extends StatelessWidget {
   ChatbubleForFriend({
    Key? key,required this.messageeee 
  }):super(key: key);
final Message messageeee;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16,top: 16,right: 16,bottom: 0.5),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(23),
              topLeft: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            messageeee.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
