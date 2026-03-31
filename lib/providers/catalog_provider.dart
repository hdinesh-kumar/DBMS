import 'package:flutter/foundation.dart';

import '../data/mock_catalog_repository.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

enum ProductSortOption { newest, rating, priceLowToHigh }

enum ReviewSortOption { mostRecent, highestRating, lowestRating, mostHelpful }

class ReviewDraft {
  final String reviewerName;
  final String title;
  final String comment;
  final double rating;

  const ReviewDraft({
    required this.reviewerName,
    required this.title,
    required this.comment,
    required this.rating,
  });
}

class CatalogProvider extends ChangeNotifier {
  CatalogProvider({MockCatalogRepository? repository})
      : _repository = repository ?? MockCatalogRepository();

  final MockCatalogRepository _repository;

  final List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  List<ProductModel> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedProducts = await _repository.fetchProducts();
      _products
        ..clear()
        ..addAll(loadedProducts);
    } catch (_) {
      _errorMessage = 'Unable to load products right now.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ProductModel? productById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ProductModel> filteredProducts({
    String query = '',
    String? category,
    ProductSortOption sort = ProductSortOption.newest,
    double? minRating,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final list = _products.where((product) {
      final matchesQuery = normalizedQuery.isEmpty ||
          product.title.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          category == null || product.category.toLowerCase() == category.toLowerCase();
      final matchesRating = minRating == null || product.averageRating >= minRating;
      return matchesQuery && matchesCategory && matchesRating;
    }).toList();

    switch (sort) {
      case ProductSortOption.newest:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case ProductSortOption.rating:
        list.sort((a, b) => b.averageRating.compareTo(a.averageRating));
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
    }
    return list;
  }

  List<ProductModel> topRatedProducts({int limit = 5}) {
    final list = [..._products];
    list.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return list.take(limit).toList();
  }

  List<ReviewModel> reviewsForProduct(
    String productId, {
    ReviewSortOption sort = ReviewSortOption.mostRecent,
  }) {
    final product = productById(productId);
    if (product == null) {
      return [];
    }
    final reviews = [...product.reviews];
    switch (sort) {
      case ReviewSortOption.mostRecent:
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case ReviewSortOption.highestRating:
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
      case ReviewSortOption.lowestRating:
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
      case ReviewSortOption.mostHelpful:
        reviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
    }
    return reviews;
  }

  Future<void> addReview(String productId, ReviewDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _products.indexWhere((product) => product.id == productId);
    if (index == -1) {
      throw StateError('Product not found.');
    }

    final product = _products[index];
    final review = ReviewModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      productId: productId,
      reviewerName: draft.reviewerName.trim(),
      title: draft.title.trim(),
      comment: draft.comment.trim(),
      rating: draft.rating,
      createdAt: DateTime.now(),
    );

    _products[index] = product.copyWith(
      reviews: [review, ...product.reviews],
    );
    notifyListeners();
  }

  Map<String, num> dashboardMetrics() {
    final allReviews = _products.expand((product) => product.reviews).toList();
    final average = allReviews.isEmpty
        ? 0.0
        : allReviews.fold<double>(0, (sum, review) => sum + review.rating) /
            allReviews.length;
    final helpfulVotes = allReviews.fold<int>(
      0,
      (sum, review) => sum + review.helpfulCount,
    );
    return {
      'products': _products.length,
      'reviews': allReviews.length,
      'average': average,
      'helpfulVotes': helpfulVotes,
    };
  }
}
