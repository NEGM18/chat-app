import 'package:chat/widgets/custom_butom.dart';
import 'package:chat/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen'; 
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? gmail;
  String? password;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(31, 148, 141, 141),
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
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        ' star',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Row(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 34,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                  const SizedBox(height: 0),
                  CustomTextField(
                    onChangedd: (data) {
                      gmail = data;
                    },
                    labelText: "E mail",
                  ),
                  const SizedBox(height: 7),
                  CustomTextField(
                    onChangedd: (data) {
                      password = data;
                    },
                    labelText: "Password",
                  ),
                  const SizedBox(height: 20),
                  CustomButom(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await registerUser();
                          showsnackbar(context, "All done, you are ready to Login");
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'weak-password') {
                            showsnackbar(context, "Weak password");
                          } else if (ex.code == 'email-already-in-use') {
                            showsnackbar(context, "Email already in use");
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
                    Textt: 'Register',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          " LOGIN",
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

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: gmail!, password: password!);
    print(user.user!.displayName);
  }
}
