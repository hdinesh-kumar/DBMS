import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../models/review_model.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewSortOption _sort = ReviewSortOption.mostRecent;

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final product = catalog.productById(widget.productId);
        if (product == null) {
          return AppScaffoldShell(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: 'Reviews',
            currentRoute: AppRoutes.products,
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: EmptyStateCard(
                title: 'Reviews unavailable',
                message: 'This product could not be loaded.',
              ),
            ),
          );
        }

        final reviews = catalog.reviewsForProduct(widget.productId, sort: _sort);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final totalReviews = product.reviewCount == 0 ? 1 : product.reviewCount;

        return AppScaffoldShell(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: 'Reviews',
          currentRoute: AppRoutes.products,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.writeReview,
                arguments: product.id,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Review'),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.averageRating.toStringAsFixed(1)} average from ${product.reviewCount} reviews',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...List.generate(5, (index) {
                      final stars = 5 - index;
                      final count = product.ratingBreakdown[stars] ?? 0;
                      final progress = count / totalReviews;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 60, child: Text('$stars stars')),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor:
                                    isDark ? AppColors.inputBgDark : AppColors.inputBg,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$count'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Sort by: '),
                  const SizedBox(width: 8),
                  DropdownButton<ReviewSortOption>(
                    value: _sort,
                    items: const [
                      DropdownMenuItem(
                        value: ReviewSortOption.mostRecent,
                        child: Text('Most Recent'),
                      ),
                      DropdownMenuItem(
                        value: ReviewSortOption.highestRating,
                        child: Text('Highest Rating'),
                      ),
                      DropdownMenuItem(
                        value: ReviewSortOption.lowestRating,
                        child: Text('Lowest Rating'),
                      ),
                      DropdownMenuItem(
                        value: ReviewSortOption.mostHelpful,
                        child: Text('Most Helpful'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sort = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (reviews.isEmpty)
                EmptyStateCard(
                  title: 'No reviews yet',
                  message: 'This product has not been reviewed yet.',
                  actionLabel: 'Write the first review',
                  onAction: () => Navigator.pushNamed(
                    context,
                    AppRoutes.writeReview,
                    arguments: product.id,
                  ),
                )
              else
                ...reviews.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReviewCard(review: review),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(review.initials)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      review.verifiedPurchase ? 'Verified Purchase' : 'Community Review',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
