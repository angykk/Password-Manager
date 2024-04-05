import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentID extends InheritedWidget {
  //widget that stores document id of user document so that all widgets can access
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
