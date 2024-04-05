import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/document_id.dart';
import 'package:password_manager/password_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 255, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 187, 204),
        title: const Text('Register',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                hintText: "Email",
                hintStyle: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _email.clear();
                  },
                ),
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: "Password",
                    hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 163, 163)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _password.clear();
                      },
                    )),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 161, 185))),
            TextField(
                controller: _password2,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: "Retype your Password",
                    hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 163, 163)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _password2.clear();
                      },
                    )),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 161, 185))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 151, 151))),
                onPressed: () async {
                  if (_password.text == _password2.text) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        //adds user
                        email: _email.text,
                        password: _password.text,
                      );
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      final user = <String, dynamic>{
                        'email': _email.text,
                        'pass': _password.text
                      };
                      String id = '';
                      db
                          .collection("users")
                          .add(user)
                          .then((DocumentReference doc) {
                        //adds user document
                        DocumentID.of(context).docID = doc.id.toString();
                        id = doc.id.toString();
                        print('register ' + DocumentID.of(context).docID);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordPage(
                                  docID: id,
                                )),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 163, 163),
                                content: Text(
                                    'The password provided is too weak.',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              );
                            });
                      } else if (e.code == 'email-already-in-use') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 163, 163),
                                content: Text('The email is already in use',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              );
                            });
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            backgroundColor: Color.fromARGB(255, 255, 163, 163),
                            content: Text('Passwords do not match',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          );
                        });
                  }
                  ;
                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 243, 218),
                      fontWeight: FontWeight.w800),
                ))
          ],
        ),
      ),
    );
  }
}
