import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.productId});

  final String productId;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 0;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

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
            title: 'Write Review',
            currentRoute: AppRoutes.products,
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: EmptyStateCard(
                title: 'Product unavailable',
                message: 'Pick a product before writing a review.',
              ),
            ),
          );
        }

        return AppScaffoldShell(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: 'Write Review',
          currentRoute: AppRoutes.products,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.cardDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviewing ${product.title}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _submitted
                    ? _SuccessCard(
                        onBackToReviews: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.reviews,
                          arguments: product.id,
                        ),
                        onWriteAnother: _resetForm,
                      )
                    : _ReviewForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        titleController: _titleController,
                        commentController: _commentController,
                        rating: _rating,
                        isSubmitting: _isSubmitting,
                        onRatingChanged: (value) =>
                            setState(() => _rating = value),
                        onSubmit: () => _submit(catalog, product.id),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(CatalogProvider catalog, String productId) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await catalog.addReview(
      productId,
      ReviewDraft(
        reviewerName: _nameController.text,
        title: _titleController.text,
        comment: _commentController.text,
        rating: _rating,
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

  void _resetForm() {
    setState(() {
      _submitted = false;
      _rating = 0;
      _nameController.clear();
      _titleController.clear();
      _commentController.clear();
    });
  }
}

class _ReviewForm extends StatelessWidget {
  const _ReviewForm({
    required this.formKey,
    required this.nameController,
    required this.titleController,
    required this.commentController,
    required this.rating,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController titleController;
  final TextEditingController commentController;
  final double rating;
  final bool isSubmitting;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Rating',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => onRatingChanged((index + 1).toDouble()),
                  icon: Icon(
                    rating >= index + 1
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.starYellow,
                    size: 34,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Review Title'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Review title is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: commentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Your Review'),
              validator: (value) => value == null || value.trim().length < 10
                  ? 'Please enter at least 10 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(isSubmitting ? 'Submitting...' : 'Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({
    required this.onBackToReviews,
    required this.onWriteAnother,
  });

  final VoidCallback onBackToReviews;
  final VoidCallback onWriteAnother;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('success'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.successGreen, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Your review has been submitted',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The product details, reviews list, and dashboard metrics will all reflect the new review immediately.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: onBackToReviews,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Back to Reviews'),
              ),
              OutlinedButton(
                onPressed: onWriteAnother,
                child: const Text('Write Another'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
