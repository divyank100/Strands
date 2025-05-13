import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String message;
  final List<String> likedBy;
  final String name;
  final String userName;
  final Timestamp timestamp;
  final int likeCount;

  Post({
    required this.id,
    required this.uid,
    required this.message,
    required this.likedBy,
    required this.name,
    required this.userName,
    required this.timestamp,
    required this.likeCount,
  });

  // Firebase to APP(Post)
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      message: doc['message'],
      likedBy: List<String>.from(doc['likedBy'] ?? []),
      name: doc['name'],
      userName: doc['userName'],
      timestamp: doc['timestamp'],
      likeCount: doc['likeCount'],
    );
  }

  // Post to Firebase document(Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'message': message,
      'likedBy': likedBy,
      'name': name,
      'userName': userName,
      'timestamp': timestamp,
      'likeCount': likeCount,
    };
  }

  @override
  String toString() {
    return 'Post(id: $id, uid: $uid, message: $message, likedBy: $likedBy, name: $name, userName: $userName, timestamp: $timestamp, likeCount: $likeCount)';
  }
}
