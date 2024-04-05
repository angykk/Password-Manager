import 'package:flutter/material.dart';

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
