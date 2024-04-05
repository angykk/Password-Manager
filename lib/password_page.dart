import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/password_widget.dart';
import 'package:password_manager/create_password.dart';

class PasswordPage extends StatefulWidget {
  String docID;
  PasswordPage({super.key, required this.docID});

  @override
  State<StatefulWidget> createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  List<PasswordWidget> passwordWidgets = [];
  String docID = '';

  @override
  void initState() {
    docID = widget.docID;
    super.initState();
    loopQuery();
  }

  Future<void> loopQuery() async {
    //loops through subcollection to find all passwords in firestore under user
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('users').doc(docID);
    QuerySnapshot subSnapshot = await documentRef.collection('passwords').get();
    if (subSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in subSnapshot.docs) {
        // Access document fields here
        passwordWidgets.add(PasswordWidget(
          password: documentSnapshot['password'],
          website: documentSnapshot['website'],
          url: documentSnapshot['url'],
          username: documentSnapshot['username'],
        ));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 252, 247),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 187, 204),
          title: const Text('My Passwords',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: ListView.builder(
          itemCount: passwordWidgets.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                passwordWidgets[index],
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 255, 161, 185),
          onPressed: () async {
            final pass = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePassword()),
            );
            if (!context.mounted) return;

            passwordWidgets.add(pass);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ));
  }
}
