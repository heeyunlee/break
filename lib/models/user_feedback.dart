import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  UserFeedback({
    required this.userFeedbackId,
    required this.userId,
    required this.username,
    required this.createdDate,
    required this.feedback,
    this.userEmail,
    required this.isResolved,
  });

  final String userFeedbackId;
  final String userId;
  final String username;
  final Timestamp createdDate;
  final String feedback;
  final String? userEmail; // Nullable
  final bool isResolved;

  factory UserFeedback.fromMap(Map<String, dynamic> data, String documentId) {
    final String userId = data['userId'];
    final String username = data['username'];
    final Timestamp createdDate = data['createdDate'];
    final String feedback = data['feedback'];
    final String? userEmail = data['userEmail'];
    final bool isResolved = data['isResolved'];

    return UserFeedback(
      userFeedbackId: documentId,
      userId: userId,
      username: username,
      createdDate: createdDate,
      feedback: feedback,
      userEmail: userEmail,
      isResolved: isResolved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'createdDate': createdDate,
      'feedback': feedback,
      'userEmail': userEmail,
      'isResolved': isResolved,
    };
  }
}
