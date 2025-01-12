import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:password_manager/document_id.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(PasswordManager());
}

class PasswordManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    print(dotenv.env['WEB_API_KEY']);

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DocumentID(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Password Manager',
              home: LoginPage(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
