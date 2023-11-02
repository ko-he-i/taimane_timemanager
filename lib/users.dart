import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;

  User({
    required this.email,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      email: data['email'],
    );
  }
}
