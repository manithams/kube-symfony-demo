CREATE TABLE `test_table` (
  `id` int NOT NULL AUTO_INCREMENT,
  `test_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `another_column` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;