import 'review_model.dart';

class ProductModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.reviews,
  });

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }
    final total = reviews.fold<double>(
      0,
      (sum, review) => sum + review.rating,
    );
    return total / reviews.length;
  }

  int get reviewCount => reviews.length;

  Map<int, int> get ratingBreakdown {
    final counts = <int, int>{for (var i = 1; i <= 5; i++) i: 0};
    for (final review in reviews) {
      final bucket = review.rating.round().clamp(1, 5);
      counts[bucket] = (counts[bucket] ?? 0) + 1;
    }
    return counts;
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    double? price,
    List<String>? imageUrls,
    List<ReviewModel>? reviews,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      reviews: reviews ?? this.reviews,
    );
  }
}
