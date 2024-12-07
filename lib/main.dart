import 'dart:ui';

import 'package:chat/screens/chat_page.dart';
import 'package:chat/screens/chats.dart';
import 'package:chat/screens/images_show.dart';
import 'package:chat/screens/login_page.dart';
import 'package:chat/screens/registerscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatPage.id: (context) => ChatPage(),
        ImagesShow.id:(context)=>ImagesShow()
       
      },
      initialRoute: LoginPage.id,
    );
  }
}
