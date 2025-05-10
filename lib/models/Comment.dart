import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String uid;
  final String postId;
  final String message;
  final String name;
  final String userName;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.uid,
    required this.postId,
    required this.message,
    required this.name,
    required this.userName,
    required this.timestamp,
  });

  // Firebase to APP(Comment)
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      uid: doc['uid'],
      postId: doc['postId'],
      message: doc['message'],
      name: doc['name'],
      userName: doc['userName'],
      timestamp: doc['timestamp'],
    );
  }

  // Comment to Firebase document(Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'postId': postId,
      'message': message,
      'name': name,
      'userName': userName,
      'timestamp': timestamp,
    };
  }
}