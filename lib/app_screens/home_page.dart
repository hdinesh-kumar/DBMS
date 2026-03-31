import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final featured = catalog.topRatedProducts(limit: 4);

        return AppScaffoldShell(
          title: 'Home',
          currentRoute: AppRoutes.home,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.products),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Explore Products'),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeroCard(
                onExplore: () =>
                    Navigator.pushNamed(context, AppRoutes.products),
                onWriteReview: () {
                  if (catalog.products.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.writeReview,
                      arguments: catalog.products.first.id,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Featured Products',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              if (catalog.isLoading && featured.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width > 1100
                        ? 4
                        : width > 700
                            ? 2
                            : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 1 ? 1.45 : 0.82,
                      ),
                      itemCount: featured.length,
                      itemBuilder: (context, index) => ProductSummaryCard(
                        product: featured[index],
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.productDetails,
                          arguments: featured[index].id,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.onExplore,
    required this.onWriteReview,
  });

  final VoidCallback onExplore;
  final VoidCallback onWriteReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2469EB), Color(0xFF0F3FB4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover honest product reviews before you buy',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Reviewlyy now has working navigation, live mock data, rating calculations, and review submission flow across the frontend.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              height: 1.6,
              color: Color(0xFFE2E8F0),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: onExplore,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Explore Products'),
              ),
              OutlinedButton(
                onPressed: onWriteReview,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                child: const Text('Write a Review'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
