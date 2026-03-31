-- =============================================================================
-- Reviewlyyy – Product & Review Management System
-- MySQL 8.0+ Seed Data
--
-- Mirrors the complete mock catalogue in:
--   lib/data/mock_catalog_repository.dart
--
-- Run AFTER schema.sql:
--   mysql -u <user> -p reviewlyyy_db < seed.sql
-- =============================================================================

USE reviewlyyy_db;

-- -----------------------------------------------------------------------------
-- Categories
-- -----------------------------------------------------------------------------
INSERT INTO categories (name) VALUES
    ('Electronics'),
    ('Accessories'),
    ('Footwear'),
    ('Furniture'),
    ('Tech'),
    ('Photography')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- -----------------------------------------------------------------------------
-- Products
-- -----------------------------------------------------------------------------
INSERT INTO products (id, title, category_id, description, price) VALUES
(
    'pro-audio-gen-2',
    'Pro Audio Gen-2',
    (SELECT id FROM categories WHERE name = 'Electronics'),
    'Noise-cancelling wireless headphones with 40-hour battery life and spatial audio support.',
    299.00
),
(
    'lunar-watch',
    'Lunar Minimalist Watch',
    (SELECT id FROM categories WHERE name = 'Accessories'),
    'A timeless piece featuring sapphire glass and an Italian leather strap for everyday elegance.',
    185.00
),
(
    'velo-sprint-trainers',
    'Velo Sprint Trainers',
    (SELECT id FROM categories WHERE name = 'Footwear'),
    'Ultra-lightweight performance shoes designed for professional athletes and daily runners.',
    140.00
),
(
    'apex-ergo-pro',
    'Apex Ergo Pro',
    (SELECT id FROM categories WHERE name = 'Furniture'),
    'Premium lumbar support and breathable mesh for the ultimate work-from-home comfort.',
    450.00
),
(
    'novabook-14-air',
    'NovaBook 14 Air',
    (SELECT id FROM categories WHERE name = 'Tech'),
    'Ultra-portable laptop with 4K OLED display and a high-efficiency processor.',
    1199.00
),
(
    'retrosnap-instant',
    'RetroSnap Instant',
    (SELECT id FROM categories WHERE name = 'Photography'),
    'The classic instant camera experience with modern auto-focus and a built-in flash.',
    89.00
)
ON DUPLICATE KEY UPDATE
    title       = VALUES(title),
    category_id = VALUES(category_id),
    description = VALUES(description),
    price       = VALUES(price);

-- -----------------------------------------------------------------------------
-- Product images
-- (display_order matches the list index in ProductModel.imageUrls)
-- -----------------------------------------------------------------------------
INSERT INTO product_images (product_id, url, display_order) VALUES
-- Pro Audio Gen-2 (3 images)
(
    'pro-audio-gen-2',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnh6NNvw0ublTnYkUqAsA-pT27xv1RXAn9JSe2ncgXuhoH-Z2wksSVzYmqrjsfResSfzcYL-T5mSsizKB_JyK9XjTWXSW5WFmXy1MiaKcPijZHNS-oM8yi-Y15i-Z90AuM9PVLznDIlATuhIxjBcMpPWm1xzNIHeY6Cnh0QXxKSW-rK3ta49yaWi36ihtoR8RorwZNbDbXg0IgIxwS6jBh_CYuCqDb3hJi1fk61SenTDCsO7o7EFYpo-UjrgsXVxFtD9Kf3i9uh2s',
    0
),
(
    'pro-audio-gen-2',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBYWu0L4mkb0ZuFeBhHwAh_3EhCGPIvZN5k6nm_47f6E4LG9soJtyYDnbyk0sVD_zXI6iip4J7cvi_4r6XBhcyDsEhe9x_cPxY6YNxvuVOeeO6hCay-1JzoWWF02nyw5bzCklLwd7Ra6qnDtY0WLZQlIzcDwFFafCNp1yCbcW686a3O0ClCy7zdOkj4lGVDujR7rRQJxDoP2eYDay1DSGE4kmUUN_sw4ZYxNV8YYorTcxfHL3kzwDStk4xc3qult-PLUE-l2yJE6kA',
    1
),
(
    'pro-audio-gen-2',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBp3Qr-4gSupq-tMCHEBuBO-qS3AZlsizQ_g5WdTKDtUhgtJOVofiMlqDUrbL6Dvq5GiyVVcXYGxNAS3qqBon8782mulLaUk84mm6doZHy0eZXm3juyoZhsOP8NrHq_sU09ZMGvfG7kvacoq-AMWr8Uln5HL-LvrVAmObpXViw-6EADd4jLPVCWM9K4q033ayCogZj3viheW8mptAeKBRM3ICGPLvOzKMXMsnTPe2XkR5qlnL-iMfnz_molCWSRK2PvNDfk6JUSJBk',
    2
),
-- Lunar Minimalist Watch (1 image)
(
    'lunar-watch',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBV2eiSjxRs4HEkLnKWr3z4nDULdGDHijArCK1cWRWWfExFeirRAWeiJFxIkqHns4QjydJWRxNW6tGYW2tNdOuvw-3ZOmgZ9Zflohz4UkbTO0EyCpdO_Y1xRKeQvVVb5AIFc8kcSkK6I8VdmmWSRV-szCFQNImgIygqkfk172PpzcAnK88wp4rnYkotzlheDhBLzXqxRtUQQljqTu9W4Q-3jlxHIkJ-JfCIgwakuUYOc9my9jyfDmTghfkTHBvQkJPkP_0dbwDa550',
    0
),
-- Velo Sprint Trainers (1 image)
(
    'velo-sprint-trainers',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCmmoCLCY-P6NdCLmRMBK83dCmo8CSjgW76Lbqne9c6b1yKXmOswCZDRvtYvsbfjuwpFiblN2q8cVpa8_ze1zUD51khonT5qGbR2-lEGwAyKkZKSjo5_49URYTOTFJ26MTwAapYE6GzhiaBzmTI3HX-_PZqHeTVmQUwMB5Sd_6Toakv7zfcDTLYiP26cLTixIZiWAMswRfgSdWfAiXGbV2QHbFVi7ssI_AwQJYRcXL8dnPaEklX8FpgDJo9-9yelenDSmSDRdtQCOY',
    0
),
-- Apex Ergo Pro (1 image)
(
    'apex-ergo-pro',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAJpbZeDTwgUiipCxC2kracPLvEZ4kCAml1784mzF70SWgjZbv9Pbo5PdonInK-xqRAxQMyNKOL3S3Qq2XfLndXpM0QI91Pz3YXS7tWTXnL4d1prqmNGXGx-PgaQtPI5wwdgoHy4YnLfzCS2rtbwsG05FZxXfcO8VYNNKTsjwf25BVXGycG4C_ErEpiEAxb1BZwtb19ocG3RFFlOLTcAhWp0m0Uzb8pdybr7Nu--hL1DGLXRXFTp1Q_Xnu282v9KjkinD9zKlbpaR4',
    0
),
-- NovaBook 14 Air (1 image)
(
    'novabook-14-air',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVvzSRjUcjYH25z4Glihf5ZZgmkcgtmf7Mglc84cu40wJwHbbVA8IeqXG0z_IXJN46DNZ6pqIA1lGAdpoEHXo-vE-60V-G_JwlztbP6X2Opz21adsQrIKrGXPopoKdx-EAoZ1cfQ_0dN8lmhzra_kVcqCTjCbJJcPAQSevPqIdASIoj5rRH1PfEG1_ckX6DdZcXg4v02f5zVHlQm9NTakbhbLjYzmM3OIexrfeipWqLdedmfxdWlWP5BODJfePv3_qtj3CxOt4Ng',
    0
),
-- RetroSnap Instant (1 image)
(
    'retrosnap-instant',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB5kZoq2ozwems5mZiVGwMMmTKZ3zGPYx03Hy4fFQs3bya0rQ1SaH-GJXx0pTUA9peSjbAiLkCU5Stx_7JdtEcdZFRk382aurPLjXUPXjR8FTmrFSHHxBc1v-9rnHcTxVgAD_Ei7GawTszXZiZq_vjA0LGC66LpTTe1yOr_R4qZIrkbf33lxNjEkqD8OE-53hXg6uWEXxkFtVKxcXlM18plKjq8lfLfyflce-yjqNqNw2FacOTyBdysHTtqGFTlagneKpOxfmtwMtk',
    0
);

-- -----------------------------------------------------------------------------
-- Reviews
-- (created_at values approximate the Duration offsets from the Dart mock data)
-- -----------------------------------------------------------------------------
INSERT INTO reviews (
    id, product_id, reviewer_name, title, comment,
    rating, created_at, verified_purchase, helpful_count
) VALUES
-- Pro Audio Gen-2
(
    'r1',
    'pro-audio-gen-2',
    'John Doe',
    'Exceeded my expectations!',
    'The sound profile is balanced, the ANC is strong, and the fit is comfortable for long sessions.',
    5.0,
    DATE_SUB(NOW(), INTERVAL 2 DAY),
    TRUE,
    24
),
(
    'r2',
    'pro-audio-gen-2',
    'Sarah Adams',
    'Great but pricey',
    'Excellent audio quality and battery life. I only wish the carrying case was smaller.',
    4.0,
    DATE_SUB(NOW(), INTERVAL 8 DAY),
    TRUE,
    12
),
-- Lunar Minimalist Watch
(
    'r3',
    'lunar-watch',
    'Alicia Brown',
    'Stylish and lightweight',
    'Looks premium and feels comfortable all day. Great choice if you like understated design.',
    4.5,
    DATE_SUB(NOW(), INTERVAL 5 DAY),
    TRUE,
    7
),
-- Velo Sprint Trainers
(
    'r4',
    'velo-sprint-trainers',
    'Marcus Lee',
    'Very responsive',
    'The cushioning feels great for tempo runs and the grip is excellent on wet roads.',
    5.0,
    DATE_SUB(NOW(), INTERVAL 3 DAY),
    TRUE,
    11
),
-- NovaBook 14 Air
(
    'r5',
    'novabook-14-air',
    'Priya Sharma',
    'Excellent display',
    'The OLED panel is vibrant and battery life holds up well for office work.',
    4.5,
    DATE_SUB(NOW(), INTERVAL 10 DAY),
    TRUE,
    5
),
-- RetroSnap Instant
(
    'r6',
    'retrosnap-instant',
    'Emma Jones',
    'Fun for weekends',
    'Easy to use and the prints have a charming retro look, though film can be expensive.',
    4.0,
    DATE_SUB(NOW(), INTERVAL 15 DAY),
    TRUE,
    8
)
ON DUPLICATE KEY UPDATE
    reviewer_name     = VALUES(reviewer_name),
    title             = VALUES(title),
    comment           = VALUES(comment),
    rating            = VALUES(rating),
    verified_purchase = VALUES(verified_purchase),
    helpful_count     = VALUES(helpful_count);
