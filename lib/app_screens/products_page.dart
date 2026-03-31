import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../models/product_model.dart';
import '../providers/catalog_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  ProductSortOption _sortOption = ProductSortOption.rating;
  String? _selectedCategory;
  bool _onlyTopRated = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final products = catalog.filteredProducts(
          query: _searchController.text,
          category: _selectedCategory,
          sort: _sortOption,
          minRating: _onlyTopRated ? 4 : null,
        );

        final categories = catalog.products
            .map((product) => product.category)
            .toSet()
            .toList()
          ..sort();

        return AppScaffoldShell(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: 'Products',
          currentRoute: AppRoutes.products,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.topRated),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Top Rated'),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: catalog.loadProducts,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderSection(
                  searchController: _searchController,
                  sortOption: _sortOption,
                  selectedCategory: _selectedCategory,
                  onlyTopRated: _onlyTopRated,
                  categories: categories,
                  onQueryChanged: (_) => setState(() {}),
                  onSortChanged: (value) => setState(() => _sortOption = value),
                  onCategoryChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  onToggleTopRated: (value) =>
                      setState(() => _onlyTopRated = value),
                ),
                const SizedBox(height: 20),
                if (catalog.isLoading && catalog.products.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (catalog.errorMessage != null && catalog.products.isEmpty)
                  EmptyStateCard(
                    title: 'Something went wrong',
                    message: catalog.errorMessage!,
                    actionLabel: 'Retry',
                    onAction: catalog.loadProducts,
                  )
                else if (products.isEmpty)
                  EmptyStateCard(
                    title: 'No matching products',
                    message:
                        'Try changing your search, filter, or rating selection.',
                    actionLabel: 'Reset Filters',
                    onAction: () {
                      setState(() {
                        _searchController.clear();
                        _selectedCategory = null;
                        _onlyTopRated = false;
                        _sortOption = ProductSortOption.rating;
                      });
                    },
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width > 1100
                          ? 3
                          : width > 700
                              ? 2
                              : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: crossAxisCount == 1 ? 1.45 : 0.82,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductSummaryCard(
                            product: product,
                            onTap: () => _openDetails(context, product),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, ProductModel product) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetails,
      arguments: product.id,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.searchController,
    required this.sortOption,
    required this.selectedCategory,
    required this.onlyTopRated,
    required this.categories,
    required this.onQueryChanged,
    required this.onSortChanged,
    required this.onCategoryChanged,
    required this.onToggleTopRated,
  });

  final TextEditingController searchController;
  final ProductSortOption sortOption;
  final String? selectedCategory;
  final bool onlyTopRated;
  final List<String> categories;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ProductSortOption> onSortChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onToggleTopRated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            'Explore Products',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse the product catalog, compare ratings, and open any item to read or write reviews.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: searchController,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search by product, category, or keyword',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _DropdownCard<ProductSortOption>(
                value: sortOption,
                hint: 'Sort',
                items: const {
                  ProductSortOption.rating: 'Highest Rating',
                  ProductSortOption.newest: 'Most Reviewed',
                  ProductSortOption.priceLowToHigh: 'Price: Low to High',
                },
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
              _DropdownCard<String?>(
                value: selectedCategory,
                hint: 'All Categories',
                items: {
                  null: 'All Categories',
                  for (final category in categories) category: category,
                },
                onChanged: onCategoryChanged,
              ),
              FilterChip(
                selected: onlyTopRated,
                label: const Text('4+ Stars'),
                onSelected: onToggleTopRated,
                backgroundColor:
                    isDark ? AppColors.inputBgDark : AppColors.inputBg,
                selectedColor: AppColors.primary.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: onlyTopRated
                      ? AppColors.primary
                      : (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownCard<T> extends StatelessWidget {
  const _DropdownCard({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final String hint;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint),
        underline: const SizedBox.shrink(),
        dropdownColor: isDark ? AppColors.cardDark : Colors.white,
        items: items.entries
            .map(
              (entry) => DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
