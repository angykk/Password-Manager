import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/login_page.dart';
import 'package:password_manager/document_id.dart';

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
