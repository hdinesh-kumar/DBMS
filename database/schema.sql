-- =============================================================================
-- Reviewlyyy – Product & Review Management System
-- MySQL 8.0+ Database Schema
--
-- Entities modelled directly from the Flutter application:
--   • ProductModel  (lib/models/product_model.dart)
--   • ReviewModel   (lib/models/review_model.dart)
--   • CatalogProvider metrics & queries (lib/providers/catalog_provider.dart)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS reviewlyyy_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE reviewlyyy_db;

-- -----------------------------------------------------------------------------
-- 1. categories
--    Normalises the product category string used in ProductModel.category.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  id   INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  name VARCHAR(100)    NOT NULL,
  CONSTRAINT pk_categories         PRIMARY KEY (id),
  CONSTRAINT uq_categories_name    UNIQUE      (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 2. products
--    Maps to ProductModel (id, title, category, description, price).
--    created_at is used for the "newest" sort option in CatalogProvider.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id          VARCHAR(100)   NOT NULL,
  title       VARCHAR(255)   NOT NULL,
  category_id INT UNSIGNED   NOT NULL,
  description TEXT           NOT NULL,
  price       DECIMAL(10, 2) NOT NULL,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_products           PRIMARY KEY (id),
  CONSTRAINT fk_products_category  FOREIGN KEY (category_id)
      REFERENCES categories (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 3. product_images
--    Stores ProductModel.imageUrls as an ordered list of URLs per product.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_images (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id    VARCHAR(100) NOT NULL,
  url           TEXT         NOT NULL,
  display_order SMALLINT     NOT NULL DEFAULT 0,
  CONSTRAINT pk_product_images         PRIMARY KEY (id),
  CONSTRAINT fk_product_images_product FOREIGN KEY (product_id)
      REFERENCES products (id) ON DELETE CASCADE,
  INDEX idx_product_images_product (product_id),
  INDEX idx_product_images_order   (product_id, display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 4. reviews
--    Maps to ReviewModel (id, productId, reviewerName, title, comment,
--    rating, createdAt, verifiedPurchase, helpfulCount).
--    rating is constrained to [1.0, 5.0] matching Flutter validation.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  id                VARCHAR(100)  NOT NULL,
  product_id        VARCHAR(100)  NOT NULL,
  reviewer_name     VARCHAR(255)  NOT NULL,
  title             VARCHAR(255)  NOT NULL,
  comment           TEXT          NOT NULL,
  rating            DECIMAL(2, 1) NOT NULL,
  created_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  verified_purchase BOOLEAN       NOT NULL DEFAULT TRUE,
  helpful_count     INT UNSIGNED  NOT NULL DEFAULT 0,
  CONSTRAINT pk_reviews          PRIMARY KEY (id),
  CONSTRAINT fk_reviews_product  FOREIGN KEY (product_id)
      REFERENCES products (id) ON DELETE CASCADE,
  CONSTRAINT chk_reviews_rating  CHECK (rating >= 1.0 AND rating <= 5.0),
  INDEX idx_reviews_product (product_id),
  INDEX idx_reviews_created (created_at),
  INDEX idx_reviews_rating  (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- VIEWS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- v_product_summary
--   Aggregates per-product metrics used by CatalogProvider:
--     averageRating, reviewCount, and the first image URL.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_product_summary AS
SELECT
    p.id,
    p.title,
    c.name                             AS category,
    p.description,
    p.price,
    p.created_at,
    COALESCE(AVG(r.rating), 0)         AS average_rating,
    COUNT(r.id)                        AS review_count,
    (
        SELECT pi.url
        FROM   product_images pi
        WHERE  pi.product_id = p.id
        ORDER  BY pi.display_order
        LIMIT  1
    )                                  AS primary_image_url
FROM       products   p
INNER JOIN categories c ON c.id = p.category_id
LEFT  JOIN reviews    r ON r.product_id = p.id
GROUP BY   p.id, p.title, c.name, p.description, p.price, p.created_at;

-- -----------------------------------------------------------------------------
-- v_top_rated_products
--   Products ordered by descending average rating (used by topRatedProducts()).
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_top_rated_products AS
SELECT *
FROM   v_product_summary
ORDER  BY average_rating DESC, review_count DESC;

-- -----------------------------------------------------------------------------
-- v_rating_breakdown
--   Per-product count of reviews in each integer star bucket 1–5.
--   Mirrors ProductModel.ratingBreakdown.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_rating_breakdown AS
SELECT
    r.product_id,
    ROUND(r.rating)             AS star_bucket,
    COUNT(*)                    AS review_count
FROM   reviews r
GROUP  BY r.product_id, ROUND(r.rating);

-- =============================================================================
-- STORED PROCEDURES
-- =============================================================================

DELIMITER $$

-- -----------------------------------------------------------------------------
-- sp_get_dashboard_metrics
--   Returns the four counters shown on the Flutter Dashboard screen:
--     products, reviews, average (overall rating), helpfulVotes.
-- -----------------------------------------------------------------------------
CREATE PROCEDURE IF NOT EXISTS sp_get_dashboard_metrics()
BEGIN
    SELECT
        (SELECT COUNT(*) FROM products)                     AS products,
        (SELECT COUNT(*) FROM reviews)                      AS reviews,
        COALESCE(
            (SELECT AVG(rating) FROM reviews), 0
        )                                                   AS average,
        COALESCE(
            (SELECT SUM(helpful_count) FROM reviews), 0
        )                                                   AS helpful_votes;
END$$

-- -----------------------------------------------------------------------------
-- sp_get_products_filtered
--   Mirrors CatalogProvider.filteredProducts():
--     p_query      – free-text search (title, category, description)
--     p_category   – exact category name filter (NULL = all)
--     p_min_rating – minimum average rating filter (NULL = all)
--     p_sort       – 'newest' | 'rating' | 'price_low_to_high'
-- -----------------------------------------------------------------------------
CREATE PROCEDURE IF NOT EXISTS sp_get_products_filtered(
    IN p_query      VARCHAR(255),
    IN p_category   VARCHAR(100),
    IN p_min_rating DECIMAL(2,1),
    IN p_sort       VARCHAR(20)
)
BEGIN
    SELECT
        ps.id,
        ps.title,
        ps.category,
        ps.description,
        ps.price,
        ps.created_at,
        ps.average_rating,
        ps.review_count,
        ps.primary_image_url
    FROM v_product_summary ps
    WHERE
        (
            p_query IS NULL
            OR p_query = ''
            OR ps.title       LIKE CONCAT('%', p_query, '%')
            OR ps.category    LIKE CONCAT('%', p_query, '%')
            OR ps.description LIKE CONCAT('%', p_query, '%')
        )
        AND (p_category   IS NULL OR LOWER(ps.category)      = LOWER(p_category))
        AND (p_min_rating IS NULL OR ps.average_rating       >= p_min_rating)
    ORDER BY
        CASE WHEN p_sort = 'rating'            THEN ps.average_rating  END DESC,
        CASE WHEN p_sort = 'price_low_to_high' THEN ps.price           END ASC,
        CASE WHEN p_sort IS NULL
              OR p_sort = ''
              OR p_sort = 'newest'             THEN ps.review_count    END DESC;
END$$

-- -----------------------------------------------------------------------------
-- sp_get_product_detail
--   Returns full product row plus all images and reviews for one product.
--   Mirrors CatalogProvider.productById() + reviewsForProduct().
--
--   p_product_id  – product to fetch
--   p_review_sort – 'most_recent' | 'highest_rating' | 'lowest_rating'
--                   | 'most_helpful'
-- -----------------------------------------------------------------------------
CREATE PROCEDURE IF NOT EXISTS sp_get_product_detail(
    IN p_product_id  VARCHAR(100),
    IN p_review_sort VARCHAR(20)
)
BEGIN
    -- Product core info with aggregates
    SELECT
        ps.id,
        ps.title,
        ps.category,
        ps.description,
        ps.price,
        ps.created_at,
        ps.average_rating,
        ps.review_count
    FROM v_product_summary ps
    WHERE ps.id = p_product_id;

    -- Ordered image list
    SELECT url, display_order
    FROM   product_images
    WHERE  product_id = p_product_id
    ORDER  BY display_order;

    -- Reviews, sorted according to p_review_sort
    SELECT
        id,
        reviewer_name,
        title,
        comment,
        rating,
        created_at,
        verified_purchase,
        helpful_count
    FROM reviews
    WHERE product_id = p_product_id
    ORDER BY
        CASE WHEN p_review_sort = 'highest_rating' THEN rating          END DESC,
        CASE WHEN p_review_sort = 'lowest_rating'  THEN rating          END ASC,
        CASE WHEN p_review_sort = 'most_helpful'   THEN helpful_count   END DESC,
        created_at DESC;
END$$

-- -----------------------------------------------------------------------------
-- sp_add_review
--   Inserts a new review. Mirrors CatalogProvider.addReview().
--
--   p_id                – unique review id (generated by the client/server)
--   p_product_id        – owning product
--   p_reviewer_name     – display name
--   p_title             – review headline
--   p_comment           – review body (min 10 chars enforced by app)
--   p_rating            – star rating 1.0–5.0
--   p_verified_purchase – whether the reviewer purchased the product
-- -----------------------------------------------------------------------------
CREATE PROCEDURE IF NOT EXISTS sp_add_review(
    IN p_id                VARCHAR(100),
    IN p_product_id        VARCHAR(100),
    IN p_reviewer_name     VARCHAR(255),
    IN p_title             VARCHAR(255),
    IN p_comment           TEXT,
    IN p_rating            DECIMAL(2,1),
    IN p_verified_purchase BOOLEAN
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Product not found.';
    END IF;

    INSERT INTO reviews (
        id, product_id, reviewer_name, title, comment,
        rating, verified_purchase
    ) VALUES (
        p_id, p_product_id, p_reviewer_name, p_title, p_comment,
        p_rating, p_verified_purchase
    );

    -- Return the newly inserted review
    SELECT
        id, product_id, reviewer_name, title, comment,
        rating, created_at, verified_purchase, helpful_count
    FROM reviews
    WHERE id = p_id;
END$$

-- -----------------------------------------------------------------------------
-- sp_increment_helpful_count
--   Increments the helpful_count of a review by 1.
-- -----------------------------------------------------------------------------
CREATE PROCEDURE IF NOT EXISTS sp_increment_helpful_count(
    IN p_review_id VARCHAR(100)
)
BEGIN
    UPDATE reviews
    SET    helpful_count = helpful_count + 1
    WHERE  id = p_review_id;
END$$

DELIMITER ;
