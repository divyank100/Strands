import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String userName;
  final String bio;
  final String email;

  UserProfile({
    required this.uid,
    required this.name,
    required this.userName,
    required this.bio,
    required this.email,
  });

  // Firebase document to UserProfile
  factory UserProfile.fromDocument(DocumentSnapshot doc) {

    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      userName: doc['userName'],
      bio: doc['bio'],
      email: doc['email'],
    );
  }

  // UserProfile to Firebase document(Map)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'userName': userName,
      'bio': bio,
      'email': email,
    };
  }
}
