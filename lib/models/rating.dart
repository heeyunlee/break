class Rating {
  final String ratingId;
  final num rating;
  final String ratingOwnerId;

  Rating({
    required this.ratingId,
    required this.rating,
    required this.ratingOwnerId,
  });

  factory Rating.fromMap(Map<String, dynamic> data, String documentId) {
    final num rating = data['rating'];
    final String ratingOwnerId = data['ratingOwnerId'];

    return Rating(
      ratingId: documentId,
      rating: rating,
      ratingOwnerId: ratingOwnerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'ratingOwnerId': ratingOwnerId,
    };
  }
}
