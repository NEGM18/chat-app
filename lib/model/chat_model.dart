import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final String docId;
 

  Message(this.message,this.id,this.docId,);
  factory Message.fromJson(QueryDocumentSnapshot doc) {
    return Message(
      doc['message'] as String,
      doc['id'] as String,
      doc.id,
      
    );
  }
  

  get type => null;

}
