import 'package:chat/screens/chat_page.dart';
import 'package:chat/screens/registerscreen.dart';
import 'package:chat/widgets/custom_butom.dart';
import 'package:chat/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page'; // Set id for route navigation

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? gmail, password;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 10, 1, 0),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 45),
                  Image.asset(
                    "assets/images/aa6u23cge.png",
                    height: 200,
                    alignment: Alignment.center,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Red',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, color: Colors.red),
                      ),
                      Text(
                        ' star',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Row(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 34,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 60)
                    ],
                  ),
                  const SizedBox(height: 0),
                  CustomTextField(
                    labelText: "Gmail",
                    onChangedd: (data) {
                      gmail = data;
                    },
                  ),
                  const SizedBox(height: 7),
                  CustomTextField(
                    labelText: "Password",
                    onChangedd: (data) {
                      password = data;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButom(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await loginUser();
                          Navigator.pushNamed(context, ChatPage.id,arguments:gmail);
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'wrong-password') {
                            showsnackbar(context, "Wrong password");
                          } else if (ex.code == 'user-not-found') {
                            showsnackbar(context, "User not found");
                          } else {
                            showsnackbar(context, "An error occurred: ${ex.message}");
                          }
                        } catch (ex) {
                          showsnackbar(context, "Sorry, there was an error");
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    Textt: "Login",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RegisterScreen();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          " Sign up",
                          style: TextStyle(fontSize: 20, color: Colors.white38),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showsnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: gmail!,
      password: password!,
    );
    print(user.user!.displayName);
  }
}
