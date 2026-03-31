import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final metrics = catalog.dashboardMetrics();
        final recentProducts = catalog.topRatedProducts(limit: 3);

        return AppScaffoldShell(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: 'Dashboard',
          currentRoute: AppRoutes.dashboard,
          actions: [
            FilledButton(
              onPressed: () {
                if (catalog.products.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.writeReview,
                    arguments: catalog.products.first.id,
                  );
                }
              },
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
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'These cards update from the same provider used by products, details, and review pages.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(label: 'Products', value: '${metrics['products'] as num}'),
                  _MetricCard(label: 'Reviews', value: '${metrics['reviews'] as num}'),
                  _MetricCard(
                    label: 'Avg Rating',
                    value: (metrics['average'] as num).toStringAsFixed(1),
                  ),
                  _MetricCard(
                    label: 'Helpful Votes',
                    value: '${metrics['helpfulVotes'] as num}',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Top Products Right Now',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              ...recentProducts.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductSummaryCard(
                    product: product,
                    buttonLabel: 'Open',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.productDetails,
                      arguments: product.id,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
