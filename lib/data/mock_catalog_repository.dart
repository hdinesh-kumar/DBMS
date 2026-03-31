import 'dart:async';

import '../models/product_model.dart';
import '../models/review_model.dart';

class MockCatalogRepository {
  Future<List<ProductModel>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockProducts;
  }
}

final List<ProductModel> _mockProducts = [
  ProductModel(
    id: 'pro-audio-gen-2',
    title: 'Pro Audio Gen-2',
    category: 'Electronics',
    description:
        'Noise-cancelling wireless headphones with 40-hour battery life and spatial audio support.',
    price: 299,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBnh6NNvw0ublTnYkUqAsA-pT27xv1RXAn9JSe2ncgXuhoH-Z2wksSVzYmqrjsfResSfzcYL-T5mSsizKB_JyK9XjTWXSW5WFmXy1MiaKcPijZHNS-oM8yi-Y15i-Z90AuM9PVLznDIlATuhIxjBcMpPWm1xzNIHeY6Cnh0QXxKSW-rK3ta49yaWi36ihtoR8RorwZNbDbXg0IgIxwS6jBh_CYuCqDb3hJi1fk61SenTDCsO7o7EFYpo-UjrgsXVxFtD9Kf3i9uh2s',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBYWu0L4mkb0ZuFeBhHwAh_3EhCGPIvZN5k6nm_47f6E4LG9soJtyYDnbyk0sVD_zXI6iip4J7cvi_4r6XBhcyDsEhe9x_cPxY6YNxvuVOeeO6hCay-1JzoWWF02nyw5bzCklLwd7Ra6qnDtY0WLZQlIzcDwFFafCNp1yCbcW686a3O0ClCy7zdOkj4lGVDujR7rRQJxDoP2eYDay1DSGE4kmUUN_sw4ZYxNV8YYorTcxfHL3kzwDStk4xc3qult-PLUE-l2yJE6kA',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBp3Qr-4gSupq-tMCHEBuBO-qS3AZlsizQ_g5WdTKDtUhgtJOVofiMlqDUrbL6Dvq5GiyVVcXYGxNAS3qqBon8782mulLaUk84mm6doZHy0eZXm3juyoZhsOP8NrHq_sU09ZMGvfG7kvacoq-AMWr8Uln5HL-LvrVAmObpXViw-6EADd4jLPVCWM9K4q033ayCogZj3viheW8mptAeKBRM3ICGPLvOzKMXMsnTPe2XkR5qlnL-iMfnz_molCWSRK2PvNDfk6JUSJBk',
    ],
    reviews: [
      ReviewModel(
        id: 'r1',
        productId: 'pro-audio-gen-2',
        reviewerName: 'John Doe',
        title: 'Exceeded my expectations!',
        comment:
            'The sound profile is balanced, the ANC is strong, and the fit is comfortable for long sessions.',
        rating: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        helpfulCount: 24,
      ),
      ReviewModel(
        id: 'r2',
        productId: 'pro-audio-gen-2',
        reviewerName: 'Sarah Adams',
        title: 'Great but pricey',
        comment:
            'Excellent audio quality and battery life. I only wish the carrying case was smaller.',
        rating: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        helpfulCount: 12,
      ),
    ],
  ),
  ProductModel(
    id: 'lunar-watch',
    title: 'Lunar Minimalist Watch',
    category: 'Accessories',
    description:
        'A timeless piece featuring sapphire glass and an Italian leather strap for everyday elegance.',
    price: 185,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBV2eiSjxRs4HEkLnKWr3z4nDULdGDHijArCK1cWRWWfExFeirRAWeiJFxIkqHns4QjydJWRxNW6tGYW2tNdOuvw-3ZOmgZ9Zflohz4UkbTO0EyCpdO_Y1xRKeQvVVb5AIFc8kcSkK6I8VdmmWSRV-szCFQNImgIygqkfk172PpzcAnK88wp4rnYkotzlheDhBLzXqxRtUQQljqTu9W4Q-3jlxHIkJ-JfCIgwakuUYOc9my9jyfDmTghfkTHBvQkJPkP_0dbwDa550',
    ],
    reviews: [
      ReviewModel(
        id: 'r3',
        productId: 'lunar-watch',
        reviewerName: 'Alicia Brown',
        title: 'Stylish and lightweight',
        comment:
            'Looks premium and feels comfortable all day. Great choice if you like understated design.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        helpfulCount: 7,
      ),
    ],
  ),
  ProductModel(
    id: 'velo-sprint-trainers',
    title: 'Velo Sprint Trainers',
    category: 'Footwear',
    description:
        'Ultra-lightweight performance shoes designed for professional athletes and daily runners.',
    price: 140,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCmmoCLCY-P6NdCLmRMBK83dCmo8CSjgW76Lbqne9c6b1yKXmOswCZDRvtYvsbfjuwpFiblN2q8cVpa8_ze1zUD51khonT5qGbR2-lEGwAyKkZKSjo5_49URYTOTFJ26MTwAapYE6GzhiaBzmTI3HX-_PZqHeTVmQUwMB5Sd_6Toakv7zfcDTLYiP26cLTixIZiWAMswRfgSdWfAiXGbV2QHbFVi7ssI_AwQJYRcXL8dnPaEklX8FpgDJo9-9yelenDSmSDRdtQCOY',
    ],
    reviews: [
      ReviewModel(
        id: 'r4',
        productId: 'velo-sprint-trainers',
        reviewerName: 'Marcus Lee',
        title: 'Very responsive',
        comment:
            'The cushioning feels great for tempo runs and the grip is excellent on wet roads.',
        rating: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        helpfulCount: 11,
      ),
    ],
  ),
  ProductModel(
    id: 'apex-ergo-pro',
    title: 'Apex Ergo Pro',
    category: 'Furniture',
    description:
        'Premium lumbar support and breathable mesh for the ultimate work-from-home comfort.',
    price: 450,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAJpbZeDTwgUiipCxC2kracPLvEZ4kCAml1784mzF70SWgjZbv9Pbo5PdonInK-xqRAxQMyNKOL3S3Qq2XfLndXpM0QI91Pz3YXS7tWTXnL4d1prqmNGXGx-PgaQtPI5wwdgoHy4YnLfzCS2rtbwsG05FZxXfcO8VYNNKTsjwf25BVXGycG4C_ErEpiEAxb1BZwtb19ocG3RFFlOLTcAhWp0m0Uzb8pdybr7Nu--hL1DGLXRXFTp1Q_Xnu282v9KjkinD9zKlbpaR4',
    ],
    reviews: const [],
  ),
  ProductModel(
    id: 'novabook-14-air',
    title: 'NovaBook 14 Air',
    category: 'Tech',
    description:
        'Ultra-portable laptop with 4K OLED display and a high-efficiency processor.',
    price: 1199,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVvzSRjUcjYH25z4Glihf5ZZgmkcgtmf7Mglc84cu40wJwHbbVA8IeqXG0z_IXJN46DNZ6pqIA1lGAdpoEHXo-vE-60V-G_JwlztbP6X2Opz21adsQrIKrGXPopoKdx-EAoZ1cfQ_0dN8lmhzra_kVcqCTjCbJJcPAQSevPqIdASIoj5rRH1PfEG1_ckX6DdZcXg4v02f5zVHlQm9NTakbhbLjYzmM3OIexrfeipWqLdedmfxdWlWP5BODJfePv3_qtj3CxOt4Ng',
    ],
    reviews: [
      ReviewModel(
        id: 'r5',
        productId: 'novabook-14-air',
        reviewerName: 'Priya Sharma',
        title: 'Excellent display',
        comment:
            'The OLED panel is vibrant and battery life holds up well for office work.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        helpfulCount: 5,
      ),
    ],
  ),
  ProductModel(
    id: 'retrosnap-instant',
    title: 'RetroSnap Instant',
    category: 'Photography',
    description:
        'The classic instant camera experience with modern auto-focus and a built-in flash.',
    price: 89,
    imageUrls: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB5kZoq2ozwems5mZiVGwMMmTKZ3zGPYx03Hy4fFQs3bya0rQ1SaH-GJXx0pTUA9peSjbAiLkCU5Stx_7JdtEcdZFRk382aurPLjXUPXjR8FTmrFSHHxBc1v-9rnHcTxVgAD_Ei7GawTszXZiZq_vjA0LGC66LpTTe1yOr_R4qZIrkbf33lxNjEkqD8OE-53hXg6uWEXxkFtVKxcXlM18plKjq8lfLfyflce-yjqNqNw2FacOTyBdysHTtqGFTlagneKpOxfmtwMtk',
    ],
    reviews: [
      ReviewModel(
        id: 'r6',
        productId: 'retrosnap-instant',
        reviewerName: 'Emma Jones',
        title: 'Fun for weekends',
        comment:
            'Easy to use and the prints have a charming retro look, though film can be expensive.',
        rating: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        helpfulCount: 8,
      ),
    ],
  ),
];
