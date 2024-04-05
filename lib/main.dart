import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/login_page.dart';
import 'package:password_manager/document_id.dart';
import 'package:password_manager/register_page.dart';
import 'package:password_manager/password_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PasswordManager());
}

class PasswordManager extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DocumentID(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Password Manager',
        home: LoginPage(),
      ),
    );
  }
}
