import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProteinEntry {
  final String proteinEntryId;
  final Timestamp loggedTime;
  final String userId;
  final String type;
  final String notes;

  ProteinEntry({
    @required this.proteinEntryId,
    @required this.loggedTime,
    @required this.userId,
    @required this.type,
    this.notes,
  });

  factory ProteinEntry.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final Timestamp loggedTime = data['loggedTime'];
    final String userId = data['userId'];
    final String type = data['type'];
    final String notes = data['notes'];

    return ProteinEntry(
      proteinEntryId: documentId,
      loggedTime: loggedTime,
      userId: userId,
      type: type,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loggedTime': loggedTime,
      'userId': userId,
      'type': type,
      'notes': notes,
    };
  }
}
