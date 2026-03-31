import 'package:flutter/material.dart';

import '../app_screens/dashboard_page.dart';
import '../app_screens/home_page.dart';
import '../app_screens/product_details_page.dart';
import '../app_screens/products_page.dart';
import '../app_screens/reviews_page.dart';
import '../app_screens/top_rated_page.dart';
import '../app_screens/write_review_page.dart';

class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const productDetails = '/product-details';
  static const reviews = '/reviews';
  static const writeReview = '/write-review';
  static const topRated = '/top-rated';
  static const dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomeScreen(), settings);
      case products:
        return _buildRoute(const ProductsScreen(), settings);
      case productDetails:
        final productId = settings.arguments as String?;
        return _buildRoute(
          ProductDetailsScreen(productId: productId ?? ''),
          settings,
        );
      case reviews:
        final productId = settings.arguments as String?;
        return _buildRoute(
          ReviewsScreen(productId: productId ?? ''),
          settings,
        );
      case writeReview:
        final productId = settings.arguments as String?;
        return _buildRoute(
          WriteReviewScreen(productId: productId ?? ''),
          settings,
        );
      case topRated:
        return _buildRoute(const TopRatedScreen(), settings);
      case dashboard:
        return _buildRoute(const DashBoardScreen(), settings);
      default:
        return _buildRoute(const HomeScreen(), settings);
    }
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
