import 'package:flutter/material.dart';

class DocumentID extends InheritedWidget {
  //widget that stores document id of user document so that all widgets can access
  late String docID;

  DocumentID({
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(DocumentID oldWidget) {
    return docID != oldWidget.docID;
  }

  static DocumentID of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DocumentID>()!;
  }
}
