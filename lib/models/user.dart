import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  User({
    @required this.userId,
    @required this.userName,
    @required this.userEmail,
    @required this.signUpDate,
    @required this.signUpProvider,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final Timestamp signUpDate;
  final String signUpProvider;

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userName = data['userName'];
    final String userEmail = data['userEmail'];
    final Timestamp signUpDate = data['signUpDate'];
    final String signUpProvider = data['signUpProvider'];

    return User(
      userId: documentId,
      userName: userName,
      userEmail: userEmail,
      signUpDate: signUpDate,
      signUpProvider: signUpProvider,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'signUpDate': signUpDate,
      'signUpProvider': signUpProvider,
    };
  }
}
