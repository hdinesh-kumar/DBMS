import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../models/review_model.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final product = catalog.productById(widget.productId);
        if (product == null) {
          return const _MissingProduct();
        }

        final reviews = catalog.reviewsForProduct(widget.productId).take(3).toList();
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AppScaffoldShell(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: product.title,
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
              child: const Text('Write Review'),
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
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorderLight,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 850;
                    final imageGallery = _ImageGallery(
                      imageUrls: product.imageUrls,
                      selectedImageIndex: _selectedImageIndex,
                      onImageSelected: (index) =>
                          setState(() => _selectedImageIndex = index),
                    );
                    final productInfo = _ProductInfo(productId: product.id);
                    return wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: imageGallery),
                              const SizedBox(width: 24),
                              Expanded(child: productInfo),
                            ],
                          )
                        : Column(
                            children: [
                              imageGallery,
                              const SizedBox(height: 24),
                              productInfo,
                            ],
                          );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _StatsStrip(productId: product.id),
              const SizedBox(height: 20),
              Text(
                'Recent Reviews',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                EmptyStateCard(
                  title: 'No reviews yet',
                  message: 'Be the first person to review this product.',
                  actionLabel: 'Write a Review',
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
                    child: _ReviewPreviewCard(review: review),
                  ),
                ),
              if (reviews.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.reviews,
                      arguments: product.id,
                    ),
                    child: const Text('View all reviews'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MissingProduct extends StatelessWidget {
  const _MissingProduct();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldShell(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: 'Product',
      currentRoute: AppRoutes.products,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: EmptyStateCard(
          title: 'Product not found',
          message: 'This product could not be loaded.',
        ),
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({
    required this.imageUrls,
    required this.selectedImageIndex,
    required this.onImageSelected,
  });

  final List<String> imageUrls;
  final int selectedImageIndex;
  final ValueChanged<int> onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrls[selectedImageIndex],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            imageUrls.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => onImageSelected(index),
                child: Container(
                  margin: EdgeInsets.only(right: index == imageUrls.length - 1 ? 0 : 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? AppColors.primary
                          : AppColors.cardBorderLight,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = context.read<CatalogProvider>().productById(productId)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.category.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            height: 1.6,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.starYellow),
            const SizedBox(width: 6),
            Text(
              product.averageRating.toStringAsFixed(1),
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${product.reviewCount} reviews)',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
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
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.reviews,
                arguments: product.id,
              ),
              child: const Text('Read Reviews'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = context.read<CatalogProvider>().productById(productId)!;
    final items = [
      ('Average Rating', product.averageRating.toStringAsFixed(1)),
      ('Total Reviews', '${product.reviewCount}'),
      ('Category', product.category),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$1, style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ReviewPreviewCard extends StatelessWidget {
  const _ReviewPreviewCard({required this.review});

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
                child: Text(
                  review.reviewerName,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
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
