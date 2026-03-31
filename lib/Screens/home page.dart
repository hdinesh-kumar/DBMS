import 'package:flutter/material.dart';

// ─── App Theme Constants ────────────────────────────────────────────────────

class AppColors {
  static const primary = Color(0xFF2469EB);
  static const backgroundLight = Color(0xFFF6F6F8);
  static const backgroundDark = Color(0xFF111621);
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF1E2433);
  static const cardBorderLight = Color(0xFFF1F5F9);
  static const cardBorderDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);
  static const starYellow = Color(0xFFFACC15);
}

class AppTextStyles {
  static const displayFont = 'Manrope';

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.backgroundLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.backgroundDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: _HomeBody(isDark: _isDark, onToggleTheme: _toggleTheme),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _HomeBody({required this.isDark, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeroSection(),
            const _FeaturedProductsSection(),
            const _TopCategoriesSection(),
            const _FooterSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.cardBorderDark : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                const _ReviewPulseLogo(),
                if (isWide) ...[
                  const SizedBox(width: 40),
                  const _NavLink(label: 'Home', isActive: true),
                  const _NavLink(label: 'Products'),
                  const _NavLink(label: 'Top Rated'),
                  const _NavLink(label: 'Reviews'),
                  const _NavLink(label: 'Dashboard'),
                ],
                const Spacer(),
                if (isWide)
                  Container(
                    width: 240,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.search,
                              size: 20, color: AppColors.textMuted),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                fontFamily: 'Manrope',
                              ),
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: TextStyle(
                                fontSize: 13, fontFamily: 'Manrope'),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Manrope',
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAiUw9gBwxpYXNSJ1Elu2S7YIVHOvhysaIN_eQg23Ggslv46yH33DqB3pC2Oq34fSoT_jV4FDNNkJJOOjDM9zEvvEOvwghmhloQe5_6jTcd1JVDcX9jQ2VA1GKAepo_4I0U9gXv5hw1NSjpnI_pN3LfiTRz29QxvVj__jVSm16wr7hhsfiU-MQhPQ8ZQmo_bsxzDQeZiJDJtFd8Sr2Hpek9danQ7ybQN21STocAk4kJFRdmNUkge12la0txqOI6Qs1kpqJq8_UAzlA',
                  ),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Logo Widget ──────────────────────────────────────────────────────────────

class _ReviewPulseLogo extends StatelessWidget {
  const _ReviewPulseLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rate_rounded, color: AppColors.primary, size: 28),
        const SizedBox(width: 8),
        Text(
          'ReviewPulse',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ─── Nav Link Widget ──────────────────────────────────────────────────────────

class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;

  const _NavLink({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: isWide ? 80 : 16, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            SizedBox(
              height: 480,
              width: double.infinity,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCZYrAJWJ723NYyvla_tN0yXIr9fo_1TEyqA8Vo6_-uPKdqZz5Qi94R5zk4uPsG8kMUr2lNm96UCpVGp-sbKhXBHV7orYZTIpIqHRWm1L55zwm7AMNBa28TorV5SFx7NaESIOXcQlJhemhSyBOqzsE2wj9w95jXMD51TCiCurk2qzJbEeKyAEJFFf-yel0IjyeVNo6n6iGso7atDvpV8CzqpG54wyK_uuDqIVBR3-5pHZD7PoS81VK2EfzEGPSt3pfNUwvFFMN9TfA',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade800),
              ),
            ),
            Container(
              height: 480,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x80000000), Color(0xCC000000)],
                ),
              ),
            ),
            SizedBox(
              height: 480,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Discover Honest Reviews\nBefore You Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: isWide ? 56 : 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Join thousands of users sharing real feedback on the latest tech, gadgets, and lifestyle products.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE2E8F0),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Manrope',
                          ),
                          elevation: 4,
                        ),
                        child: const Text('Explore Products'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Manrope',
                          ),
                        ),
                        child: const Text('Write a Review'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Featured Products Section ────────────────────────────────────────────────

class _FeaturedProductsSection extends StatelessWidget {
  const _FeaturedProductsSection();

  static const _products = [
    ProductData(
      title: 'Audio-Technica M50x',
      price: '\$149.00',
      rating: 4.8,
      reviewCount: '1,240',
      badge: "Editor's Choice",
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAlC64bIv1tyexxML8sbBOESfVEerFol0i5iHgWvzbJzPae8lT1OGhZDbC9_YKyCELABGiNMbfd5hdpMu9SfHaFGMokvEy02ZPYEUFyOJYmFGFXuX790sG0c2h6TOPdZeFwUgME3c0W6Ux1CDWwalCurA09BOFx7kbtMr6cJ0LQKrkeH7SVtCLFo62djC_srHuJ3ySTRYvIHOw_KsbgigpViWgqv9sTOqYrx8Xo8lu55-aPl_hQsDJxIUGe9r-CGTycZPCHHSJyDLU',
    ),
    ProductData(
      title: 'Apple Watch Series 9',
      price: '\$399.00',
      rating: 4.9,
      reviewCount: '856',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBo6NQWLsbOj9TFhYwZqVbB-ZQ_XndC2JcpxYeoA-1ut38PJO8U-DMR71ItHbsK2tSLvZJdFjX6YjHgahQax2APLCJ73RLMSXesMBnvky4yzb7k9izXp4yaArSyaNbqTeDRG6fP5KxNfTQAkZJLJYj5ViCMSRGSXI7MTFu6dxCWbGEjzzaW3gYLsAad_0hokw5a9In1nueFmPfSsprd6ToRa4whm0GbDDKG27BKeZsIzFJj7qGhSmCLWEPGb4OsF3eJNREtU0EtsDw',
    ),
    ProductData(
      title: 'Sony Alpha A7 IV',
      price: '\$2,499.00',
      rating: 4.0,
      reviewCount: '432',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCCLnNx48JCP2-iXupsV8WrLth94P9dRM3nSfnuRTLpJJdVIv4w1JY3GfDaFtKDHLEff1h4JX6iGSaoC4OcvjEzywUdk5nUzOsNwtYsAlGQNOhmkqQXqeh-NK5rdKZF41Hz8L136N_cJH4oFOjLdEw-ymojgArib5ajNbC6OBm7xjbu3apMkukrpKTGSvVlmKRp3TQwX7mVV3UaVyAPi9ixDo3-yewVGVBbdK1y3AWOfuhph2s7JfzYYly6BxbMi6QionqWX676R0A',
    ),
    ProductData(
      title: 'MacBook Air M2',
      price: '\$1,099.00',
      rating: 4.7,
      reviewCount: '2,105',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDhLP8UvcGhuoOM2NN33W-Tmrshzk1nPmRZAnyXV6ddd2FR10ykWK6VNobbM3eK-u9j0dLhfQrLyP3ayFcqWk6h1lgygGhb8glJdaLHl2eRWRzFhOp3UswLSH1CAAxtm1TmSiIjLBlfrXGhyA4-BQ7miEJaVnQtFRngesx--RErZ7u4Fm6P6WzTX1_DJ9m20h4T8WSB5oFbg5R9qoY_2oFjQpoSmHdlExaRCBpwvoAPhlxX-Z7n5y2WNU3ALlrkVNO_haAhbEsmp-4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final isMedium = MediaQuery.of(context).size.width > 600;
    final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: isWide ? 80 : 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: AppTextStyles.heading2(context)
                    .copyWith(fontSize: 26),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: _products[index]),
          ),
        ],
      ),
    );
  }
}

// ─── Product Data Model ───────────────────────────────────────────────────────

class ProductData {
  final String title;
  final String price;
  final double rating;
  final String reviewCount;
  final String imageUrl;
  final String? badge;

  const ProductData({
    required this.title,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.badge,
  });
}

// ─── Reusable Product Card ────────────────────────────────────────────────────

class ProductCard extends StatefulWidget {
  final ProductData product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(_hovered ? 0.12 : 0.04),
              blurRadius: _hovered ? 24 : 4,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _hovered ? 1.06 : 1.0,
                        duration: const Duration(milliseconds: 400),
                        child: Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade200),
                        ),
                      ),
                      if (widget.product.badge != null)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.product.badge!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              StarRating(rating: widget.product.rating),
              const SizedBox(height: 4),
              Text(
                widget.product.title,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _hovered
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.product.price,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hovered
                        ? AppColors.primary
                        : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9)),
                    foregroundColor: _hovered
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  child:
                  Text('View ${widget.product.reviewCount} Reviews'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Star Rating Widget ──────────────────────────────────────────────

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating;
          return Icon(
            filled
                ? Icons.star_rounded
                : (half
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded),
            color: AppColors.starYellow,
            size: size,
          );
        }),
        const SizedBox(width: 4),
        Text(
          '(${rating.toStringAsFixed(1)})',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            fontFamily: 'Manrope',
          ),
        ),
      ],
    );
  }
}

// ─── Top Categories Section ───────────────────────────────────────────────────

class _TopCategoriesSection extends StatelessWidget {
  const _TopCategoriesSection();

  static const _categories = [
    CategoryData(label: 'Laptops', icon: Icons.laptop_mac_rounded),
    CategoryData(label: 'Smartphones', icon: Icons.smartphone_rounded),
    CategoryData(label: 'Audio', icon: Icons.headphones_rounded),
    CategoryData(label: 'Wearables', icon: Icons.watch_rounded),
    CategoryData(label: 'Cameras', icon: Icons.photo_camera_rounded),
    CategoryData(label: 'Gaming', icon: Icons.sports_esports_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 900;
    final isMedium = MediaQuery.of(context).size.width > 600;
    final crossAxisCount = isWide ? 6 : (isMedium ? 3 : 2);

    return Container(
      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF1F5F9),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 16,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Rated Categories',
            style: AppTextStyles.heading2(context).copyWith(fontSize: 26),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) =>
                CategoryCard(category: _categories[index]),
          ),
        ],
      ),
    );
  }
}

// ─── Category Data Model ──────────────────────────────────────────────────────

class CategoryData {
  final String label;
  final IconData icon;

  const CategoryData({required this.label, required this.icon});
}

// ─── Reusable Category Card ───────────────────────────────────────────────────

class CategoryCard extends StatefulWidget {
  final CategoryData category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary
                  : (isDark
                  ? AppColors.cardBorderDark
                  : AppColors.cardBorderLight),
              width: _hovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.category.icon,
                  color: AppColors.primary, size: 32),
              const SizedBox(height: 8),
              Text(
                widget.category.label,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Footer Section ───────────────────────────────────────────────────────────

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  static const _platformLinks = [
    'Home',
    'All Products',
    'Top Rated',
    'Recent Reviews'
  ];
  static const _companyLinks = [
    'About Us',
    'Careers',
    'Privacy Policy',
    'Terms of Service'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      color: isDark ? AppColors.backgroundDark : Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 16,
        vertical: 48,
      ),
      child: Column(
        children: [
          isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: _FooterBrand()),
              Expanded(
                  child: _FooterLinks(
                      title: 'Platform', links: _platformLinks)),
              Expanded(
                  child: _FooterLinks(
                      title: 'Company', links: _companyLinks)),
              const Expanded(child: _FooterSubscribe()),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FooterBrand(),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _FooterLinks(
                          title: 'Platform',
                          links: _platformLinks)),
                  Expanded(
                      child: _FooterLinks(
                          title: 'Company',
                          links: _companyLinks)),
                ],
              ),
              const SizedBox(height: 32),
              const _FooterSubscribe(),
            ],
          ),
          const SizedBox(height: 40),
          Divider(
            color: isDark
                ? AppColors.cardBorderDark
                : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 20),
          const Text(
            '© 2024 ReviewPulse Inc. All rights reserved.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontFamily: 'Manrope',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rate_rounded,
                color: AppColors.primary, size: 22),
            SizedBox(width: 6),
            Text(
              'ReviewPulse',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Helping you make better purchasing decisions through community-driven reviews and expert analysis.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontFamily: 'Manrope',
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterLinks({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
              (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                link,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterSubscribe extends StatelessWidget {
  const _FooterSubscribe();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUBSCRIBE',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Get weekly review summaries.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontFamily: 'Manrope',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontFamily: 'Manrope',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'Manrope'),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
