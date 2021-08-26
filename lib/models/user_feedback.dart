import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String userFeedbackId;
  final String userId;
  final String username;
  final Timestamp createdDate;
  final String feedback;
  final String? userEmail; // Nullable
  final bool isResolved;

  const UserFeedback({
    required this.userFeedbackId,
    required this.userId,
    required this.username,
    required this.createdDate,
    required this.feedback,
    this.userEmail,
    required this.isResolved,
  });

  factory UserFeedback.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'].toString();
      final String username = data['username'].toString();
      final Timestamp createdDate = data['createdDate'] as Timestamp;
      final String feedback = data['feedback'].toString();
      final String? userEmail = data['userEmail']?.toString();
      final bool isResolved = data['isResolved'] as bool;

      return UserFeedback(
        userFeedbackId: documentId,
        userId: userId,
        username: username,
        createdDate: createdDate,
        feedback: feedback,
        userEmail: userEmail,
        isResolved: isResolved,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'createdDate': createdDate,
      'feedback': feedback,
      'userEmail': userEmail,
      'isResolved': isResolved,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFeedback &&
        other.userFeedbackId == userFeedbackId &&
        other.userId == userId &&
        other.username == username &&
        other.createdDate == createdDate &&
        other.feedback == feedback &&
        other.userEmail == userEmail &&
        other.isResolved == isResolved;
  }

  @override
  int get hashCode {
    return userFeedbackId.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        createdDate.hashCode ^
        feedback.hashCode ^
        userEmail.hashCode ^
        isResolved.hashCode;
  }
}
