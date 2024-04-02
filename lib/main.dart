import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PasswordManager());
}

class PasswordManager extends StatelessWidget  {
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
class DocumentID extends InheritedWidget { //widget that stores document id of user document so that all widgets can access
  late String docID;

  DocumentID({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DocumentID oldWidget) {
    return docID != oldWidget.docID;
  }

  static DocumentID of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DocumentID>()!;
  }
}

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
        title: const Text('Password Manager', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), 
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: "Email",
                hintStyle: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _email.clear();
                  },
                ),
              ),
             style: const TextStyle(fontSize: 18)
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: "Password",
                hintStyle: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _password.clear();
                  },
              )
              ),
              style: const TextStyle(color: Color.fromARGB(255, 255, 161, 185))
              ),
             SizedBox(height:MediaQuery.of(context).size.height * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword( //authorizes sign in
                            email: _email.text,
                            password: _password.text,);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance //checks in firestore if inputted text matches up with previous documents
                          .collection('users')
                          .where('email', isEqualTo: _email.text)
                          .get();
                        if (querySnapshot.docs.isNotEmpty) {
                          for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
                          DocumentID.of(context).docID = documentSnapshot.id;
                          print(DocumentID.of(context).docID);
      }
  }
                        Navigator.push( //redirects to password page
                          context,
                          MaterialPageRoute(builder: (context) => PasswordPage(docID: DocumentID.of(context).docID,)),);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Color.fromARGB(255, 255, 163, 163),
                                    content: Text('User is not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        );
                          }
                          );
                        } else if (e.code == 'wrong-password') {
                          showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Color.fromARGB(255, 255, 163, 163),
                                    content: Text('Wrong password.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        );
                          }
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 151, 151)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),),
                    child: const Text("Login", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color.fromARGB(255, 255, 243, 218))),
                ),
                SizedBox(height:MediaQuery.of(context).size.height * 0.01),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
            );
                },
                 style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 247, 228)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),),
                child: const Text("Create an Account", style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 255, 151, 151), fontWeight: FontWeight.w600)),
                )
              ],
              ),
          ],))
    );
  }
}


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
        title: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), 
      ),
       body: Center(
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                hintText: "Email",
                hintStyle: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _email.clear();
                  },
                ),
              ),
              style: const TextStyle(fontSize: 18,),
              
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: "Password",
                hintStyle: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _password.clear();
                  },
              )
              ),
              style: const TextStyle(color: Color.fromARGB(255, 255, 161, 185))
              ),
            TextField(
              controller: _password2,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: "Retype your Password",
                hintStyle: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 163, 163)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _password2.clear();
                  },
              )
              ),
           style: const TextStyle(color: Color.fromARGB(255, 255, 161, 185))
              ),
              SizedBox(height:MediaQuery.of(context).size.height * 0.02),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 151, 151))),
                onPressed: () async { 
                  if(_password.text == _password2.text){
                        try {
                          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword( //adds user
                            email: _email.text,
                            password: _password.text,
        );
        FirebaseFirestore db = FirebaseFirestore.instance;
                    final user = <String, dynamic>{
                          'email' : _email.text,
                          'pass' : _password.text
                      };
                    String id = '';
                    db.collection("users").add(user).then((DocumentReference doc){ //adds user document
                      DocumentID.of(context).docID = doc.id.toString();
                      id = doc.id.toString();
                      print('register ' + DocumentID.of(context).docID);
                    });
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PasswordPage(docID: id)),
                      );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Color.fromARGB(255, 255, 163, 163),
                                    content: Text('The password provided is too weak.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        );
                          }
                    );
                            } else if (e.code == 'email-already-in-use') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Color.fromARGB(255, 255, 163, 163),
                                    content: Text('The email is already in use', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        );
                          }
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                      }
                  else{
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            backgroundColor: Color.fromARGB(255, 255, 163, 163),
                            content: Text('Passwords do not match', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                );
                  }
                    );
                };
                },
                child: const Text("Create Account", style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 243, 218), fontWeight: FontWeight.w800),
                )
              )
          ],
        ),
    ),
    );
  }
}


class PasswordPage extends StatefulWidget {
  String docID;
  PasswordPage({super.key, required this.docID});

  @override
  State<StatefulWidget> createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  List<PasswordWidget> passwordWidgets = [];
  String docID = '';
  static bool reload = false;

@override
  void initState(){
    docID = widget.docID;
    super.initState();
    loopQuery();
  }
  Future<void> loopQuery () async { //loops through subcollection to find all passwords in firestore under user
     DocumentReference documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(docID);
    QuerySnapshot subSnapshot = await documentRef.collection('passwords').get();

 if (subSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in subSnapshot.docs) {
        // Access document fields here
        passwordWidgets.add(PasswordWidget(password: documentSnapshot['password'], 
        website: documentSnapshot['website'], url: documentSnapshot['url'], username: documentSnapshot['username'],)); //adds to list
        setState((){});
      }
  } 
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 187, 204),
        title: const Text('My Passwords', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), 
      ),
      body: ListView.builder(
        itemCount: passwordWidgets.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              passwordWidgets[index],
              
          ],);
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
              setState((){});
          },
          child: const Icon(Icons.add),)
    );
  }
}

class CreatePassword extends StatelessWidget{
  CreatePassword({super.key});
    final TextEditingController _url = TextEditingController();
    final TextEditingController _web = TextEditingController();
    final TextEditingController _user = TextEditingController();
    final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> addPassword(String website, String user, String url, String password) async {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(DocumentID.of(context).docID);
      CollectionReference postsRef = userRef.collection('passwords');

       try {
            // Add a new document to the "posts" subcollection
          await postsRef.add({
        'website': website,
        'username': user,
        'url': url,
        'password':password
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
        title: const Text('Create Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), 
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * 0.02, horizontal:MediaQuery.of(context).size.width * 0.02 ),
            decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 221, 204),
            borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
                  width: MediaQuery.of(context).size.width,
                 margin: EdgeInsets.only(left:MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02, top:MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.012,),
                  decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 151, 151),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: _web,
                    decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.web),
                    hintText: "Website Name",
                    hintStyle: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 221, 204)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _web.clear();
                      },
                    ),
                  ),
                style: const TextStyle(fontSize: 18))
                  ),
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left:MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02, bottom:MediaQuery.of(context).size.height * 0.02,top: MediaQuery.of(context).size.height * 0.012),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 151, 151),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    autocorrect: false,
                    controller: _url,
                    decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.http),
                    hintText: "Website URL",
                    hintStyle: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 221, 204)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _url.clear();
                      },
                    ),
                  ),
                style: const TextStyle(fontSize: 18))
                  ),
                ],
            )
        ),
        Container(
            margin: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.02, bottom:MediaQuery.of(context).size.width * 0.03, right:MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 221, 204),
            borderRadius: BorderRadius.circular(12)),
            child:Column(
              children: [
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
                  width: MediaQuery.of(context).size.width,
                 margin: EdgeInsets.only(left:MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02, top:MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.012,),
                  decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 151, 151),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: _user,
                    decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.supervised_user_circle),
                    hintText: "Username/Email",
                    hintStyle: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 221, 204)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _user.clear();
                      },
                    ),
                  ),
                style: const TextStyle(fontSize: 18))
                  ),
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left:MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02, bottom:MediaQuery.of(context).size.height * 0.02,top: MediaQuery.of(context).size.height * 0.012),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 151, 151),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    autocorrect: false,
                    controller: _password,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      hintText: "Password",
                      hintStyle: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 221, 204)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _password.clear();
                        },
                      ),
                  ),
                style: const TextStyle(fontSize: 18))
                  ),
                ],),
              ),
       ElevatedButton(
        onPressed: (){
          PasswordWidget a = PasswordWidget(password: _password.text, website: _web.text, url: _url.text, username: _user.text,);
          addPassword(_web.text, _user.text, _url.text, _password.text);
          Navigator.pop(context,a); //returns to password page
        }, 
        style: ButtonStyle(
          backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 151, 151)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),),
          child: const Text("Create", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color.fromARGB(255, 255, 243, 218))),)
        ],)
    );
  }
}


class PasswordWidget extends StatefulWidget {
  final String website;
  final String password;
  final String username;
  final String url;
  PasswordWidget({required this.url, required this.website, required this.username, required this.password,});
  
  @override
  State<StatefulWidget> createState() => _PasswordWidget();
}
class _PasswordWidget extends State<PasswordWidget> {
  late final Uri _url = Uri.parse(widget.url);
  bool _obscureText = true;
  
  void _toggleVisbility(){ //toggles visibility on passwords
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override

  Future<void> _launchUrl() async { //makes urls clickable
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  Widget build(BuildContext context){
    TextEditingController _password = TextEditingController(text: widget.password);
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * 0.02, horizontal:MediaQuery.of(context).size.width * 0.02 ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 221, 204),
          borderRadius: BorderRadius.circular(12)),
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
            width:MediaQuery.of(context).size.width, // Set constraints to expand
            decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 151, 151),
            borderRadius: BorderRadius.all(Radius.circular(12),)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                SizedBox(height:MediaQuery.of(context).size.height*0.001),
                Row(
                  children: [
                    GestureDetector(
                    onTap:(){
                      _launchUrl();
                    },
                    child: RichText(
                      text: TextSpan(
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 243, 218), fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(
                            text: 'Website: ',
                          ),
                          TextSpan(
                            text:  widget.website,
                            style: const TextStyle(decoration: TextDecoration.underline)
                          )
                        ]
                    ),
                  ),
                  ),
                  Expanded(child:Container()),
                  IconButton(
                    icon:const Icon(Icons.delete), 
                    onPressed:() async {
                        try {
                          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(DocumentID.of(context).docID)
                            .collection('passwords')
                            .where('website', isEqualTo: widget.website)
                            .where( 'username', isEqualTo: widget.username)
                            .get();
                          querySnapshot.docs.forEach((document) async {
                            await document.reference.delete();
                            }); 
                            print('Document deleted successfully'); 
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => PasswordPage(docID: DocumentID.of(context).docID,)),
                            );
                        } catch (e) {
                          print('Error deleting document: $e');
                        }
                    }, 
                    color: const Color.fromARGB(255, 255, 243, 218))]
                ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.01),
                Text(
                  'Username/Email: ${widget.username}', 
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 243, 218), fontWeight: FontWeight.w600)),
                TextField(
                  decoration: InputDecoration(
                    prefix: const Text('Password: ', style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 243, 218), fontWeight: FontWeight.w600)),
                    suffixIcon: IconButton(icon: const Icon(Icons.remove_red_eye),color: const Color.fromARGB(255, 255, 243, 218), onPressed: () {_toggleVisbility();},)),
                  readOnly: true,
                  obscureText:_obscureText,
                  controller: _password,
                
                style: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 255, 243, 218), fontWeight: FontWeight.w600)),
            ],
            ),
            ),
        ),
      );
}
}