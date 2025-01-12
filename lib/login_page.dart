import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/document_id.dart';
import 'package:password_manager/register_page.dart';
import 'package:password_manager/password_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 252, 247),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 187, 204),
          title: const Text('Password Manager',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: Center(
            child: Column(
          children: [
            TextField(
                controller: _email,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
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
                style: const TextStyle(fontSize: 18)),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        //authorizes sign in
                        email: _email.text,
                        password: _password.text,
                      );
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance //checks in firestore if inputted text matches up with previous documents
                          .collection('users')
                          .where('email', isEqualTo: _email.text)
                          .get();
                      if (querySnapshot.docs.isNotEmpty) {
                        for (DocumentSnapshot documentSnapshot
                            in querySnapshot.docs) {
                          DocumentID.of(context).docID = documentSnapshot.id;
                          print(DocumentID.of(context).docID);
                        }
                      }
                      Navigator.push(
                        //redirects to password page
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordPage(
                                  docID: DocumentID.of(context).docID,
                                )),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 163, 163),
                                content: Text('User is not found',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              );
                            });
                      } else if (e.code == 'wrong-password') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 163, 163),
                                content: Text('Wrong password.',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              );
                            });
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 151, 151)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  child: const Text("Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 243, 218))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 247, 228)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  child: const Text("Create an Account",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 151, 151),
                          fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ],
        )));
  }
}
