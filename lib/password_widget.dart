import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/document_id.dart';
import 'package:password_manager/password_page.dart';

class PasswordWidget extends StatefulWidget {
  final String website;
  final String password;
  final String username;
  final String url;
  PasswordWidget({
    required this.url,
    required this.website,
    required this.username,
    required this.password,
  });

  @override
  State<StatefulWidget> createState() => _PasswordWidget();
}

class _PasswordWidget extends State<PasswordWidget> {
  late final Uri _url = Uri.parse(widget.url);
  bool _obscureText = true;

  void _toggleVisbility() {
    //toggles visibility on passwords
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Future<void> _launchUrl() async {
    //makes urls clickable
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget build(BuildContext context) {
    TextEditingController _password =
        TextEditingController(text: widget.password);
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.02),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 221, 204),
            borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
          width: MediaQuery.of(context).size.width, // Set constraints to expand
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 151, 151),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              )),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the left
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl();
                  },
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 243, 218),
                            fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(
                            text: 'Website: ',
                          ),
                          TextSpan(
                              text: widget.website,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline))
                        ]),
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(DocumentID.of(context).docID)
                            .collection('passwords')
                            .where('website', isEqualTo: widget.website)
                            .where('username', isEqualTo: widget.username)
                            .get();
                        querySnapshot.docs.forEach((document) async {
                          await document.reference.delete();
                        });
                        print('Document deleted successfully');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordPage(
                                    docID: DocumentID.of(context).docID,
                                  )),
                        );
                      } catch (e) {
                        print('Error deleting document: $e');
                      }
                    },
                    color: const Color.fromARGB(255, 255, 243, 218))
              ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text('Username/Email: ${widget.username}',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 243, 218),
                      fontWeight: FontWeight.w600)),
              TextField(
                  decoration: InputDecoration(
                      prefix: const Text('Password: ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 243, 218),
                              fontWeight: FontWeight.w600)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        color: const Color.fromARGB(255, 255, 243, 218),
                        onPressed: () {
                          _toggleVisbility();
                        },
                      )),
                  readOnly: true,
                  obscureText: _obscureText,
                  controller: _password,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 243, 218),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
