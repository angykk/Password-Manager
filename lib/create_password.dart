import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/document_id.dart';
import 'package:password_manager/password_widget.dart';

class CreatePassword extends StatelessWidget {
  CreatePassword({super.key});
  final TextEditingController _url = TextEditingController();
  final TextEditingController _web = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> addPassword(
        String website, String user, String url, String password) async {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(DocumentID.of(context).docID);
      CollectionReference postsRef = userRef.collection('passwords');

      try {
        // Add a new document to the "posts" subcollection
        await postsRef.add({
          'website': website,
          'username': user,
          'url': url,
          'password': password
        });

        print('Post added to subcollection successfully');
      } catch (e) {
        print('Error adding post to subcollection: $e');
      }
    }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 252, 247),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 187, 204),
          title: const Text('Create Password',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: ListView(
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 221, 204),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.013),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.012,
                        ),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 151, 151),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: TextField(
                            controller: _web,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.web),
                              hintText: "Website Name",
                              hintStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 221, 204)),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _web.clear();
                                },
                              ),
                            ),
                            style: const TextStyle(fontSize: 18))),
                    Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.013),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02,
                            top: MediaQuery.of(context).size.height * 0.012),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 151, 151),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: TextField(
                            autocorrect: false,
                            controller: _url,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.http),
                              hintText: "Website URL",
                              hintStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 221, 204)),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _url.clear();
                                },
                              ),
                            ),
                            style: const TextStyle(fontSize: 18))),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  bottom: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.02),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 221, 204),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.013),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.02,
                        right: MediaQuery.of(context).size.height * 0.02,
                        top: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.012,
                      ),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 151, 151),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: TextField(
                          controller: _user,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.supervised_user_circle),
                            hintText: "Username/Email",
                            hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 255, 221, 204)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _user.clear();
                              },
                            ),
                          ),
                          style: const TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.013),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.012),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 151, 151),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: TextField(
                          autocorrect: false,
                          controller: _password,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 255, 221, 204)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _password.clear();
                              },
                            ),
                          ),
                          style: const TextStyle(fontSize: 18))),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                PasswordWidget a = PasswordWidget(
                  password: _password.text,
                  website: _web.text,
                  url: _url.text,
                  username: _user.text,
                );
                addPassword(_web.text, _user.text, _url.text, _password.text);
                Navigator.pop(context, a); //returns to password page
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 151, 151)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              child: const Text("Create",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 243, 218))),
            )
          ],
        ));
  }
}
