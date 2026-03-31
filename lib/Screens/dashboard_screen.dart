import 'package:flutter/material.dart';


class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviewHub Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F6F8),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111621),
      ),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}

// ─── Constants ────────────────────────────────────────────────────────────────

const kPrimary = Color(0xFF2469EB);

// ─── Data Models ─────────────────────────────────────────────────────────────

enum ReviewStatus { published, pending }

class ReviewItem {
  final int id;
  final String product;
  final String category;
  final int rating;
  final String date;
  final ReviewStatus status;

  ReviewItem({
    required this.id,
    required this.product,
    required this.category,
    required this.rating,
    required this.date,
    required this.status,
  });

  ReviewItem copyWith({ReviewStatus? status}) {
    return ReviewItem(
      id: id,
      product: product,
      category: category,
      rating: rating,
      date: date,
      status: status ?? this.status,
    );
  }
}

// ─── Dashboard Page ───────────────────────────────────────────────────────────

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ReviewItem> _reviews = [
    ReviewItem(
      id: 1,
      product: 'Ultra-Noise Cancelling Headphones',
      category: 'Electronics & Audio',
      rating: 5,
      date: 'Oct 12, 2023',
      status: ReviewStatus.published,
    ),
    ReviewItem(
      id: 2,
      product: 'Mechanical Backlit Keyboard',
      category: 'Accessories',
      rating: 4,
      date: 'Sep 25, 2023',
      status: ReviewStatus.published,
    ),
    ReviewItem(
      id: 3,
      product: '4K Ergonomic Monitor',
      category: 'Computing',
      rating: 3,
      date: 'Aug 15, 2023',
      status: ReviewStatus.pending,
    ),
    ReviewItem(
      id: 4,
      product: 'Portable SSD 1TB',
      category: 'Storage',
      rating: 5,
      date: 'Jul 02, 2023',
      status: ReviewStatus.published,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deleteReview(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _reviews.removeWhere((r) => r.id == id));
              Navigator.pop(ctx);
            },
            style:
            TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editReview(ReviewItem review) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing: ${review.product}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: kPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenW = MediaQuery.of(context).size.width;
    final isWide = screenW >= 768;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF111621) : const Color(0xFFF6F6F8),
      body: SafeArea(
        child: Column(
          children: [
            _TopNav(isDark: isDark, isWide: isWide),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 16,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DashboardHeader(isDark: isDark, isWide: isWide),
                          const SizedBox(height: 32),
                          _StatsRow(isDark: isDark, isWide: isWide),
                          const SizedBox(height: 32),
                          _ReviewsCard(
                            isDark: isDark,
                            isWide: isWide,
                            reviews: _reviews,
                            tabController: _tabController,
                            onEdit: _editReview,
                            onDelete: _deleteReview,
                          ),
                          const SizedBox(height: 48),
                          _BottomCards(isDark: isDark, isWide: isWide),
                          const SizedBox(height: 48),
                          _Footer(isDark: isDark, isWide: isWide),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Navigation ───────────────────────────────────────────────────────────

class _TopNav extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _TopNav({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.rate_review_rounded,
                color: kPrimary, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'ReviewHub',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (isWide) ...[
            const SizedBox(width: 32),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search,
                        size: 18,
                        color: isDark ? Colors.white38 : Colors.black38),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          if (isWide) ...[
            _NavLink(label: 'Home', isDark: isDark, isActive: false),
            const SizedBox(width: 20),
            _NavLink(label: 'Reviews', isDark: isDark, isActive: false),
            const SizedBox(width: 20),
            _NavLink(label: 'Categories', isDark: isDark, isActive: false),
            const SizedBox(width: 20),
            _NavLink(label: 'Dashboard', isDark: isDark, isActive: true),
            const SizedBox(width: 20),
          ],
          Container(
            width: 1,
            height: 32,
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              shadowColor: kPrimary.withOpacity(0.3),
            ),
            child: const Text('Logout',
                style:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCBk16sazV-iSgyn0KBAHfgj7u6n2n9i3OfY4BdpIVWFeNNjeK60jtHUFkdGc9ZbGUg-QroLmftAPUSL_V8Oln8UlLMuMU8bvyCgYH0IVDCaBEzlOKZo-px9rcE86wx3Oidq4ncDAs5-k6xSn7Q1hCvejyp_P9-Thjo9ZEylvW6TEVDHjvJu1T71MK3c6tfA8bopm2E7C3pG3KRc-TNp_EbUIIw7ZwGMRp4JtYTmByRoWFF_4zSU-w8BfMStuKK6p24u9a_Q7mFLhQ',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isActive;

  const _NavLink(
      {required this.label,
        required this.isDark,
        required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? kPrimary
                : isDark
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF475569),
            fontWeight:
            isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 3),
            height: 2,
            width: 36,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

// ─── Dashboard Header ─────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _DashboardHeader({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Dashboard',
                style: TextStyle(
                  fontSize: isWide ? 36 : 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Welcome back! Manage your submitted reviews and account activity.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_rounded, size: 18),
          label: Text(isWide ? 'Write a Review' : 'Review'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 20 : 14,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            elevation: 4,
            shadowColor: kPrimary.withOpacity(0.35),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _StatsRow({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
          label: 'Total Reviews',
          value: '24',
          icon: Icons.reviews_rounded,
          iconColor: kPrimary),
      _StatData(
          label: 'Avg Rating',
          value: '4.8',
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFF59E0B)),
      _StatData(
          label: 'Helpful Votes',
          value: '156',
          icon: Icons.thumb_up_rounded,
          iconColor: const Color(0xFF22C55E)),
    ];

    return isWide
        ? Row(
      children: stats
          .map((s) => Expanded(
        child: Padding(
          padding: stats.indexOf(s) < stats.length - 1
              ? const EdgeInsets.only(right: 16)
              : EdgeInsets.zero,
          child: _StatCard(data: s, isDark: isDark),
        ),
      ))
          .toList(),
    )
        : Column(
      children: stats
          .map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _StatCard(data: s, isDark: isDark),
      ))
          .toList(),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatData(
      {required this.label,
        required this.value,
        required this.icon,
        required this.iconColor});
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  final bool isDark;

  const _StatCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          Icon(data.icon, color: data.iconColor, size: 28),
        ],
      ),
    );
  }
}

// ─── Reviews Card ─────────────────────────────────────────────────────────────

class _ReviewsCard extends StatelessWidget {
  final bool isDark;
  final bool isWide;
  final List<ReviewItem> reviews;
  final TabController tabController;
  final ValueChanged<ReviewItem> onEdit;
  final ValueChanged<int> onDelete;

  const _ReviewsCard({
    required this.isDark,
    required this.isWide,
    required this.reviews,
    required this.tabController,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: kPrimary,
              labelColor: kPrimary,
              unselectedLabelColor:
              isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.list_alt_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('My Reviews'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.draw_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Drafts'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.settings_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Table
          isWide
              ? _ReviewTable(
            reviews: reviews,
            isDark: isDark,
            onEdit: onEdit,
            onDelete: onDelete,
          )
              : _ReviewListMobile(
            reviews: reviews,
            isDark: isDark,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
          // Footer
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withOpacity(0.5)
                  : const Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${reviews.length} of 24 reviews',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                Row(
                  children: [
                    _PaginationBtn(
                        icon: Icons.chevron_left_rounded,
                        isDark: isDark,
                        enabled: false),
                    const SizedBox(width: 8),
                    _PaginationBtn(
                        icon: Icons.chevron_right_rounded,
                        isDark: isDark,
                        enabled: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final bool enabled;

  const _PaginationBtn(
      {required this.icon, required this.isDark, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        borderRadius: BorderRadius.circular(8),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
      ),
      child: IconButton(
        onPressed: enabled ? () {} : null,
        icon: Icon(icon, size: 18),
        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
        disabledColor: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}

// ─── Review Table (Wide) ──────────────────────────────────────────────────────

class _ReviewTable extends StatelessWidget {
  final List<ReviewItem> reviews;
  final bool isDark;
  final ValueChanged<ReviewItem> onEdit;
  final ValueChanged<int> onDelete;

  const _ReviewTable({
    required this.reviews,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 80,
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A).withOpacity(0.5)
                    : const Color(0xFFF8FAFC),
              ),
              children: [
                _TH(text: 'Product', style: headerStyle),
                _TH(text: 'Rating', style: headerStyle),
                _TH(text: 'Date', style: headerStyle),
                _TH(text: 'Status', style: headerStyle),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Text(
                    'ACTIONS',
                    textAlign: TextAlign.right,
                    style: headerStyle.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            ...reviews.map(
                  (r) => TableRow(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.product,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: _StarRow(rating: r.rating, size: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Text(
                      r.date,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: _StatusBadge(status: r.status),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _ActionBtn(
                          label: 'Edit',
                          icon: Icons.edit_rounded,
                          color: kPrimary,
                          onTap: () => onEdit(r),
                        ),
                        const SizedBox(width: 12),
                        _ActionBtn(
                          label: 'Delete',
                          icon: Icons.delete_rounded,
                          color: Colors.red,
                          onTap: () => onDelete(r.id),
                        ),
                      ],
                    ),
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

class _TH extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _TH({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Text(text.toUpperCase(), style: style),
    );
  }
}

// ─── Review List (Mobile) ─────────────────────────────────────────────────────

class _ReviewListMobile extends StatelessWidget {
  final List<ReviewItem> reviews;
  final bool isDark;
  final ValueChanged<ReviewItem> onEdit;
  final ValueChanged<int> onDelete;

  const _ReviewListMobile({
    required this.reviews,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews.map((r) {
        return Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.product,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: r.status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StarRow(rating: r.rating, size: 14),
                  Text(
                    r.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionBtn(
                    label: 'Edit',
                    icon: Icons.edit_rounded,
                    color: kPrimary,
                    onTap: () => onEdit(r),
                  ),
                  const SizedBox(width: 12),
                  _ActionBtn(
                    label: 'Delete',
                    icon: Icons.delete_rounded,
                    color: Colors.red,
                    onTap: () => onDelete(r.id),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final int rating;
  final double size;

  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (i) => Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: const Color(0xFFF59E0B),
          size: size,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReviewStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPublished = status == ReviewStatus.published;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublished
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPublished ? 'Published' : 'Pending Review',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isPublished
              ? const Color(0xFF15803D)
              : const Color(0xFFA16207),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Cards ─────────────────────────────────────────────────────────────

class _BottomCards extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _BottomCards({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return isWide
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _ReviewerStatusCard(isDark: isDark)),
        const SizedBox(width: 24),
        Expanded(child: _TipsCard(isDark: isDark)),
      ],
    )
        : Column(
      children: [
        _ReviewerStatusCard(isDark: isDark),
        const SizedBox(height: 20),
        _TipsCard(isDark: isDark),
      ],
    );
  }
}

class _ReviewerStatusCard extends StatelessWidget {
  final bool isDark;

  const _ReviewerStatusCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark
            ? kPrimary.withOpacity(0.08)
            : kPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded,
                  color: kPrimary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Reviewer Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Silver Reviewer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.65,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor:
              const AlwaysStoppedAnimation<Color>(kPrimary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
              children: [
                const TextSpan(
                    text: 'Write 6 more reviews to reach '),
                TextSpan(
                  text: 'Gold Reviewer',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const TextSpan(text: ' status and unlock badges.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final bool isDark;

  const _TipsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: kPrimary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Tips for Top Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TipItem(
            isDark: isDark,
            text:
            'Add photos to increase helpfulness votes by up to 50%.',
          ),
          const SizedBox(height: 12),
          _TipItem(
            isDark: isDark,
            text:
            'Mention both pros and cons for a more balanced perspective.',
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final bool isDark;
  final String text;

  const _TipItem({required this.isDark, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded,
            color: Color(0xFF22C55E), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _Footer({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2, child: _FooterBrand(isDark: isDark)),
              Expanded(
                  child: _FooterLinks(
                      title: 'Quick Links',
                      items: const [
                        'Home',
                        'All Reviews',
                        'Categories'
                      ],
                      isDark: isDark)),
              Expanded(
                  child: _FooterLinks(
                      title: 'Support',
                      items: const [
                        'Help Center',
                        'Community Rules',
                        'Privacy Policy'
                      ],
                      isDark: isDark)),
              Expanded(
                  child: _FooterNewsletter(isDark: isDark)),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterBrand(isDark: isDark),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _FooterLinks(
                          title: 'Quick Links',
                          items: const [
                            'Home',
                            'All Reviews',
                            'Categories'
                          ],
                          isDark: isDark)),
                  Expanded(
                      child: _FooterLinks(
                          title: 'Support',
                          items: const [
                            'Help Center',
                            'Community Rules',
                            'Privacy Policy'
                          ],
                          isDark: isDark)),
                ],
              ),
              const SizedBox(height: 24),
              _FooterNewsletter(isDark: isDark),
            ],
          ),
          const SizedBox(height: 24),
          Divider(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2023 ReviewHub. All rights reserved.',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  final bool isDark;

  const _FooterBrand({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.rate_review_rounded,
                color: kPrimary, size: 18),
            const SizedBox(width: 6),
            Text(
              'ReviewHub',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'The most trusted platform for real product reviews from real people.',
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isDark;

  const _FooterLinks(
      {required this.title, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
              (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterNewsletter extends StatelessWidget {
  final bool isDark;

  const _FooterNewsletter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Newsletter',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Your email',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : Colors.black87,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 12),
            ),
            child: const Text('Subscribe'),
          ),
        ),
      ],
    );
  }
}