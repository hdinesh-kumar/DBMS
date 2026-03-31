class ReviewModel {
  final String id;
  final String productId;
  final String reviewerName;
  final String title;
  final String comment;
  final double rating;
  final DateTime createdAt;
  final bool verifiedPurchase;
  final int helpfulCount;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.reviewerName,
    required this.title,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.verifiedPurchase = true,
    this.helpfulCount = 0,
  });

  String get initials {
    final parts = reviewerName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || reviewerName.trim().isEmpty) {
      return 'NA';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  ReviewModel copyWith({
    String? id,
    String? productId,
    String? reviewerName,
    String? title,
    String? comment,
    double? rating,
    DateTime? createdAt,
    bool? verifiedPurchase,
    int? helpfulCount,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      reviewerName: reviewerName ?? this.reviewerName,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      verifiedPurchase: verifiedPurchase ?? this.verifiedPurchase,
      helpfulCount: helpfulCount ?? this.helpfulCount,
    );
  }
}
