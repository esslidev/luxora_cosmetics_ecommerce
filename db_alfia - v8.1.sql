-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db_alfia
-- Generation Time: Jan 16, 2025 at 08:27 AM
-- Server version: 9.1.0
-- PHP Version: 8.2.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_alfia`
--

-- --------------------------------------------------------

--
-- Table structure for table `Author`
--

CREATE TABLE `Author` (
  `id` int NOT NULL,
  `firstName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `coverImageUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `authorOfMonth` tinyint(1) NOT NULL DEFAULT '0',
  `featuredAuthor` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Author`
--

INSERT INTO `Author` (`id`, `firstName`, `lastName`, `coverImageUrl`, `createdAt`, `updatedAt`, `authorOfMonth`, `featuredAuthor`) VALUES
(1, 'George', 'Orwell', NULL, '2024-12-31 05:45:41.194', '2025-01-11 04:40:58.587', 0, 0),
(2, 'Harper', 'Lee', NULL, '2024-12-31 05:46:34.873', '2024-12-31 05:46:34.873', 0, 1),
(3, 'Alaa', 'Al aswany', NULL, '2024-12-31 05:47:35.011', '2024-12-31 05:47:35.011', 0, 1),
(4, 'Khalil', 'Gibran', NULL, '2024-12-31 05:48:09.765', '2025-01-11 04:40:58.587', 0, 0),
(5, 'Scott', 'Fitzgerald', NULL, '2025-01-01 03:07:50.175', '2025-01-11 04:40:58.587', 0, 0),
(6, 'Tayeb', 'Salih', NULL, '2025-01-01 03:08:14.335', '2025-01-11 04:40:58.587', 0, 0),
(7, 'Driss', 'Chraïbi', NULL, '2025-01-01 03:08:36.362', '2025-01-11 04:40:58.587', 0, 0),
(8, 'Nawal', 'El Saadawi', NULL, '2025-01-01 03:08:43.964', '2025-01-11 04:40:58.587', 1, 0),
(9, 'Mohammed', 'Berrada', NULL, '2025-01-01 03:08:57.255', '2025-01-11 04:40:58.587', 0, 0),
(10, 'Thomas', 'Mann', NULL, '2025-01-01 03:09:12.661', '2025-01-11 04:40:58.587', 0, 0),
(11, 'Tahar', 'Ben Jelloun', NULL, '2025-01-01 03:09:25.831', '2025-01-11 04:41:29.438', 0, 0),
(12, 'George', 'Orwell', NULL, '2025-01-01 03:09:41.825', '2025-01-01 03:09:41.825', 0, 1),
(13, 'Abdellah', 'Taïa', NULL, '2025-01-01 03:09:56.779', '2025-01-11 04:41:29.438', 0, 0),
(14, 'Naguib', 'Mahfouz', NULL, '2025-01-01 03:10:15.969', '2025-01-01 03:10:15.969', 0, 1),
(15, 'Abdelhak', 'Serhane', NULL, '2025-01-01 03:10:33.559', '2025-01-11 04:41:29.438', 0, 0),
(16, 'Khaled', 'Hosseini', NULL, '2025-01-01 03:11:11.988', '2025-01-01 03:11:15.697', 0, 1),
(17, 'Ahmed', 'Toufiq', NULL, '2025-01-01 03:11:32.777', '2025-01-01 03:11:32.777', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Cart`
--

CREATE TABLE `Cart` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Cart`
--

INSERT INTO `Cart` (`id`, `userId`, `createdAt`, `updatedAt`) VALUES
(185, 9, '2024-12-12 18:01:22.165', '2024-12-12 18:01:22.165'),
(186, 10, '2024-12-12 18:03:11.112', '2024-12-12 18:03:11.112'),
(187, 11, '2024-12-24 18:21:00.073', '2024-12-24 18:21:00.073'),
(188, 12, '2024-12-24 18:27:18.349', '2024-12-24 18:27:18.349');

-- --------------------------------------------------------

--
-- Table structure for table `CartItem`
--

CREATE TABLE `CartItem` (
  `id` int NOT NULL,
  `cartId` int NOT NULL,
  `productId` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CartItem`
--

INSERT INTO `CartItem` (`id`, `cartId`, `productId`, `quantity`, `createdAt`, `updatedAt`) VALUES
(270, 185, 64, 1, '2024-12-25 14:57:57.513', '2024-12-25 14:57:57.513'),
(272, 185, 41, 1, '2024-12-25 15:43:01.836', '2024-12-25 15:43:01.836'),
(273, 185, 42, 1, '2024-12-25 15:43:01.836', '2024-12-25 15:43:01.836'),
(275, 185, 52, 2, '2025-01-06 19:19:07.560', '2025-01-06 19:19:07.560'),
(289, 186, 24, 1, '2025-01-11 16:27:09.054', '2025-01-11 16:27:09.054'),
(290, 186, 27, 1, '2025-01-11 16:27:09.054', '2025-01-11 16:27:09.054'),
(291, 186, 52, 2, '2025-01-11 16:27:09.054', '2025-01-11 16:27:09.054');

-- --------------------------------------------------------

--
-- Table structure for table `Category`
--

CREATE TABLE `Category` (
  `id` int NOT NULL,
  `parentId` int DEFAULT NULL,
  `categoryNumber` int NOT NULL,
  `isPublic` tinyint(1) NOT NULL DEFAULT '1',
  `promoPercent` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Category`
--

INSERT INTO `Category` (`id`, `parentId`, `categoryNumber`, `isPublic`, `promoPercent`, `createdAt`, `updatedAt`) VALUES
(1, NULL, 100, 1, NULL, '2024-11-05 23:59:46.308', '2025-01-10 08:58:23.205'),
(2, NULL, 101, 1, NULL, '2024-11-07 20:43:48.048', '2024-11-07 20:43:48.048'),
(3, NULL, 102, 1, NULL, '2024-11-07 20:43:54.154', '2024-11-07 20:43:54.154'),
(4, NULL, 103, 1, NULL, '2024-11-07 20:43:59.396', '2024-11-07 20:43:59.396'),
(5, NULL, 104, 1, NULL, '2024-11-07 20:44:05.256', '2024-11-07 20:44:05.256'),
(6, NULL, 105, 1, NULL, '2024-11-07 20:44:15.579', '2024-11-07 20:44:15.579'),
(14, 54, 100100, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-10 09:00:10.277'),
(15, 54, 100101, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-10 09:00:10.277'),
(16, 54, 100102, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-10 09:00:10.277'),
(17, NULL, 100103, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-16 08:26:28.409'),
(18, 54, 100104, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-10 09:00:10.277'),
(19, 54, 100105, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-10 09:00:10.277'),
(20, NULL, 100106, 1, NULL, '2024-11-16 05:46:49.344', '2025-01-16 08:26:28.409'),
(21, 1, 100107, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(22, 1, 100108, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(23, 1, 100109, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(24, 1, 100110, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(25, 1, 100111, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(26, 1, 100112, 1, NULL, '2024-11-16 05:46:49.344', '2024-11-16 06:01:07.278'),
(27, 21, 100107100, 1, NULL, '2024-11-16 06:03:58.962', '2024-11-16 06:08:13.218'),
(28, 21, 100107101, 1, NULL, '2024-11-16 06:03:58.962', '2024-11-16 06:08:13.218'),
(29, 21, 100107102, 1, NULL, '2024-11-16 06:03:58.962', '2024-11-16 06:08:13.218'),
(30, 21, 100107103, 1, NULL, '2024-11-16 06:03:58.962', '2024-11-16 06:08:13.218'),
(31, 22, 100108100, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(32, 22, 100108101, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(33, 22, 100108102, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(34, 22, 100108103, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(35, 23, 100109100, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(36, 23, 100109101, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(37, 23, 100109102, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(38, 23, 100109103, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(39, 23, 100109104, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(40, 24, 100110100, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(41, 24, 100110101, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(42, 24, 100110102, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(43, 49, 100110103, 1, NULL, '2024-11-16 06:13:54.386', '2025-01-10 08:58:23.205'),
(44, 24, 100110104, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(45, 49, 100111100, 1, NULL, '2024-11-16 06:13:54.386', '2025-01-10 08:58:23.205'),
(46, 49, 100111101, 1, NULL, '2024-11-16 06:13:54.386', '2025-01-10 08:58:23.205'),
(47, 49, 100111102, 1, NULL, '2024-11-16 06:13:54.386', '2025-01-10 08:58:23.205'),
(48, 25, 100111103, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(49, 25, 100111104, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:41:42.265'),
(50, 26, 100112100, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(51, 26, 100112101, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(52, 26, 100112102, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(53, 26, 100112103, 1, NULL, '2024-11-16 06:13:54.386', '2024-11-16 06:15:40.474'),
(54, 27, 100112104, 1, NULL, '2024-11-16 06:13:54.386', '2025-01-10 08:37:37.644');

-- --------------------------------------------------------

--
-- Table structure for table `CategoryTranslation`
--

CREATE TABLE `CategoryTranslation` (
  `id` int NOT NULL,
  `isDefault` tinyint(1) DEFAULT NULL,
  `languageCode` enum('en','fr','de','ar') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'en',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoryNumber` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CategoryTranslation`
--

INSERT INTO `CategoryTranslation` (`id`, `isDefault`, `languageCode`, `name`, `categoryNumber`) VALUES
(1, 1, 'fr', 'Livre en français', 100),
(2, 0, 'ar', 'كتب باللغة الفرنسية', 100),
(3, 0, 'de', 'Bücher auf Französisch', 100),
(4, 0, 'en', 'French Books', 100),
(5, 0, 'en', 'Arabic Books', 101),
(6, 0, 'fr', 'Livres en arabe', 101),
(7, 0, 'de', 'Bücher auf Arabisch', 101),
(8, 1, 'ar', 'كتب بالعربية', 101),
(9, 1, 'en', 'English Books', 102),
(10, 0, 'fr', 'Livres en anglais', 102),
(11, 0, 'de', 'Bücher auf Englisch', 102),
(12, 0, 'ar', 'كتب باللغة الإنجليزية', 102),
(13, NULL, 'en', 'Stationery & Supplies', 103),
(14, NULL, 'fr', 'Papeteries & Fournitures', 103),
(15, NULL, 'de', 'Schreibwaren & Bürobedarf', 103),
(16, NULL, 'ar', 'أدوات مكتبية ولوازم', 103),
(17, NULL, 'en', 'Luggage & Accessories', 104),
(18, NULL, 'fr', 'Bagageries & Accessoires', 104),
(19, NULL, 'de', 'Gepäck & Zubehör', 104),
(20, NULL, 'ar', 'حقائب وإكسسوارات', 104),
(21, NULL, 'en', 'Art Books / Coffee Table Books', 105),
(22, NULL, 'fr', 'Beaux livres', 105),
(23, NULL, 'de', 'Bildbände / Kunstbücher', 105),
(24, NULL, 'ar', 'كتب فنية', 105),
(53, NULL, 'en', 'New Arrivals', 100100),
(54, NULL, 'fr', 'Nouveautés', 100100),
(55, NULL, 'de', 'Neuheiten', 100100),
(56, NULL, 'ar', 'الإصدارات الجديدة', 100100),
(57, NULL, 'en', 'Best Sellers', 100101),
(58, NULL, 'fr', 'Best-sellers', 100101),
(59, NULL, 'de', 'Bestseller', 100101),
(60, NULL, 'ar', 'الأكثر مبيعاً', 100101),
(61, NULL, 'en', 'Pre-orders', 100102),
(62, NULL, 'fr', 'Précommandes', 100102),
(63, NULL, 'de', 'Vorbestellungen', 100102),
(64, NULL, 'ar', 'الطلبات المسبقة', 100102),
(65, NULL, 'en', 'Monthly Selection', 100103),
(66, NULL, 'fr', 'Sélection du mois', 100103),
(67, NULL, 'de', 'Monatliche Auswahl', 100103),
(68, NULL, 'ar', 'اختيار الشهر', 100103),
(69, NULL, 'en', 'Great Deals', 100104),
(70, NULL, 'fr', 'Bonnes affaires', 100104),
(71, NULL, 'de', 'Gute Angebote', 100104),
(72, NULL, 'ar', 'عروض مميزة', 100104),
(73, NULL, 'en', 'Favorites', 100105),
(74, NULL, 'fr', 'Coups de coeur', 100105),
(75, NULL, 'de', 'Lieblinge', 100105),
(76, NULL, 'ar', 'المفضلات', 100105),
(77, NULL, 'en', 'Literary Awards', 100106),
(78, NULL, 'fr', 'Prix littéraires', 100106),
(79, NULL, 'de', 'Literaturpreise', 100106),
(80, NULL, 'ar', 'الجوائز الأدبية', 100106),
(81, NULL, 'en', 'Literature', 100107),
(82, NULL, 'fr', 'Littérature', 100107),
(83, NULL, 'de', 'Literatur', 100107),
(84, NULL, 'ar', 'الأدب', 100107),
(85, NULL, 'en', 'Fundamental Sciences', 100108),
(86, NULL, 'fr', 'Sciences fondamentales', 100108),
(87, NULL, 'de', 'Grundlagenwissenschaften', 100108),
(88, NULL, 'ar', 'العلوم الأساسية', 100108),
(89, NULL, 'en', 'Children / Youth', 100109),
(90, NULL, 'fr', 'Enfant / Jeunesse', 100109),
(91, NULL, 'de', 'Kinder / Jugend', 100109),
(92, NULL, 'ar', 'أطفال / شباب', 100109),
(93, NULL, 'en', 'Humanities & Social Sciences', 100110),
(94, NULL, 'fr', 'Sciences humaines & sociales', 100110),
(95, NULL, 'de', 'Geistes- und Sozialwissenschaften', 100110),
(96, NULL, 'ar', 'العلوم الإنسانية والاجتماعية', 100110),
(97, NULL, 'en', 'Economics & Legal Sciences', 100111),
(98, NULL, 'fr', 'Sciences Economiques & Juridiques', 100111),
(99, NULL, 'de', 'Wirtschafts- und Rechtswissenschaften', 100111),
(100, NULL, 'ar', 'العلوم الاقتصادية والقانونية', 100111),
(101, NULL, 'en', 'Practical Life', 100112),
(102, NULL, 'fr', 'Vie pratique', 100112),
(103, NULL, 'de', 'Alltagsleben', 100112),
(104, NULL, 'ar', 'الحياة العملية', 100112),
(105, NULL, 'en', 'Novel', 100107100),
(106, NULL, 'fr', 'Roman', 100107100),
(107, NULL, 'de', 'Roman', 100107100),
(108, NULL, 'ar', 'رواية', 100107100),
(109, NULL, 'en', 'Literary Studies', 100107101),
(110, NULL, 'fr', 'Etudes littéraires', 100107101),
(111, NULL, 'de', 'Literaturwissenschaften', 100107101),
(112, NULL, 'ar', 'الدراسات الأدبية', 100107101),
(113, NULL, 'en', 'Other Literary Genres', 100107102),
(114, NULL, 'fr', 'Autres genres littéraires', 100107102),
(115, NULL, 'de', 'Andere literarische Genres', 100107102),
(116, NULL, 'ar', 'أنواع أدبية أخرى', 100107102),
(117, NULL, 'en', 'Moroccan and Arab Literature', 100107103),
(118, NULL, 'fr', 'Littérature Marocaine et Arabe', 100107103),
(119, NULL, 'de', 'Marokkanische und arabische Literatur', 100107103),
(120, NULL, 'ar', 'الأدب المغربي والعربي', 100107103),
(121, NULL, 'en', 'Chemistry', 100108100),
(122, NULL, 'fr', 'Chimie', 100108100),
(123, NULL, 'de', 'Chemie', 100108100),
(124, NULL, 'ar', 'الكيمياء', 100108100),
(125, NULL, 'en', 'Physics', 100108101),
(126, NULL, 'fr', 'Physique', 100108101),
(127, NULL, 'de', 'Physik', 100108101),
(128, NULL, 'ar', 'الفيزياء', 100108101),
(129, NULL, 'en', 'Mathematics', 100108102),
(130, NULL, 'fr', 'Mathématiques', 100108102),
(131, NULL, 'de', 'Mathematik', 100108102),
(132, NULL, 'ar', 'الرياضيات', 100108102),
(133, NULL, 'en', 'Earth Sciences', 100108103),
(134, NULL, 'fr', 'Sciences de la Terre', 100108103),
(135, NULL, 'de', 'Geowissenschaften', 100108103),
(136, NULL, 'ar', 'علوم الأرض', 100108103),
(137, NULL, 'en', 'History', 100109100),
(138, NULL, 'fr', 'Histoire', 100109100),
(139, NULL, 'de', 'Geschichte', 100109100),
(140, NULL, 'ar', 'التاريخ', 100109100),
(141, NULL, 'en', 'Encyclopedia', 100109101),
(142, NULL, 'fr', 'Encyclopédie', 100109101),
(143, NULL, 'de', 'Enzyklopädie', 100109101),
(144, NULL, 'ar', 'موسوعة', 100109101),
(145, NULL, 'en', 'Youth Comics', 100109102),
(146, NULL, 'fr', 'BD - jeunesse', 100109102),
(147, NULL, 'de', 'Jugendcomics', 100109102),
(148, NULL, 'ar', 'قصص مصورة للأطفال', 100109102),
(149, NULL, 'en', 'Youth Novel', 100109103),
(150, NULL, 'fr', 'Roman - Jeunesse', 100109103),
(151, NULL, 'de', 'Jugendroman', 100109103),
(152, NULL, 'ar', 'رواية للأطفال', 100109103),
(153, NULL, 'en', 'Islamic Book for Youth', 100109104),
(154, NULL, 'fr', 'Livre islamique - jeunesse', 100109104),
(155, NULL, 'de', 'Islamisches Buch für Jugendliche', 100109104),
(156, NULL, 'ar', 'كتاب إسلامي للأطفال', 100109104),
(157, NULL, 'en', 'Philosophy', 100110100),
(158, NULL, 'fr', 'Philosophie', 100110100),
(159, NULL, 'de', 'Philosophie', 100110100),
(160, NULL, 'ar', 'الفلسفة', 100110100),
(161, NULL, 'en', 'Psychology', 100110101),
(162, NULL, 'fr', 'Psychologie', 100110101),
(163, NULL, 'de', 'Psychologie', 100110101),
(164, NULL, 'ar', 'علم النفس', 100110101),
(165, NULL, 'en', 'Language Studies', 100110102),
(166, NULL, 'fr', 'Etude de la langue', 100110102),
(167, NULL, 'de', 'Sprachstudien', 100110102),
(168, NULL, 'ar', 'دراسات اللغة', 100110102),
(169, NULL, 'en', 'Social Sciences', 100110103),
(170, NULL, 'fr', 'Sciences sociales	', 100110103),
(171, NULL, 'de', 'Sozialwissenschaften', 100110103),
(172, NULL, 'ar', 'العلوم الاجتماعية', 100110103),
(173, NULL, 'en', 'History', 100110104),
(174, NULL, 'fr', 'Histoire', 100110104),
(175, NULL, 'de', 'Geschichte', 100110104),
(176, NULL, 'ar', 'التاريخ', 100110104),
(177, NULL, 'en', 'Law', 100111100),
(178, NULL, 'fr', 'Droit', 100111100),
(179, NULL, 'de', 'Recht', 100111100),
(180, NULL, 'ar', 'القانون', 100111100),
(181, NULL, 'en', 'Finance', 100111101),
(182, NULL, 'fr', 'Finance', 100111101),
(183, NULL, 'de', 'Finanzen', 100111101),
(184, NULL, 'ar', 'المالية', 100111101),
(185, NULL, 'en', 'Economics', 100111102),
(186, NULL, 'fr', 'Economie', 100111102),
(187, NULL, 'de', 'Wirtschaft', 100111102),
(188, NULL, 'ar', 'الاقتصاد', 100111102),
(189, NULL, 'en', 'Accounting & Auditing', 100111103),
(190, NULL, 'fr', 'Comptabilité & Audit', 100111103),
(191, NULL, 'de', 'Buchhaltung & Prüfung', 100111103),
(192, NULL, 'ar', 'المحاسبة والتدقيق', 100111103),
(193, NULL, 'en', 'Business & Marketing', 100111104),
(194, NULL, 'fr', 'Commerce & Marketing', 100111104),
(195, NULL, 'de', 'Handel & Marketing', 100111104),
(196, NULL, 'ar', 'التجارة والتسويق', 100111104),
(197, NULL, 'en', 'Sports & Leisure', 100112100),
(198, NULL, 'fr', 'Sport & loisirs', 100112100),
(199, NULL, 'de', 'Sport & Freizeit', 100112100),
(200, NULL, 'ar', 'الرياضة والترفيه', 100112100),
(201, NULL, 'en', 'Personal Development', 100112101),
(202, NULL, 'fr', 'Développement Personnel', 100112101),
(203, NULL, 'de', 'Persönlichkeitsentwicklung', 100112101),
(204, NULL, 'ar', 'التنمية الشخصية', 100112101),
(205, NULL, 'en', 'Tourism & Travel', 100112102),
(206, NULL, 'fr', 'Tourisme & Voyage', 100112102),
(207, NULL, 'de', 'Tourismus & Reisen', 100112102),
(208, NULL, 'ar', 'السياحة والسفر', 100112102),
(209, NULL, 'en', 'Health & Well-being', 100112103),
(210, NULL, 'fr', 'Santé & Bien-être', 100112103),
(211, NULL, 'de', 'Gesundheit & Wohlbefinden', 100112103),
(212, NULL, 'ar', 'الصحة والعافية', 100112103),
(213, NULL, 'en', 'Cooking & Gastronomy', 100112104),
(214, NULL, 'fr', 'Cuisine & Gastronomie', 100112104),
(215, NULL, 'de', 'Kochen & Gastronomie', 100112104),
(216, NULL, 'ar', 'الطهي وفن الطهو', 100112104);

-- --------------------------------------------------------

--
-- Table structure for table `DefaultShowcase`
--

CREATE TABLE `DefaultShowcase` (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `DeliveryTerms`
--

CREATE TABLE `DeliveryTerms` (
  `id` int NOT NULL,
  `magasinId` int NOT NULL,
  `deliveryTime` int NOT NULL DEFAULT '2',
  `cost` double NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `DeliveryTerms`
--

INSERT INTO `DeliveryTerms` (`id`, `magasinId`, `deliveryTime`, `cost`, `createdAt`, `updatedAt`) VALUES
(1, 8, 2, 500, '2024-11-05 13:20:35.214', '2024-12-03 12:41:09.445');

-- --------------------------------------------------------

--
-- Table structure for table `Magasin`
--

CREATE TABLE `Magasin` (
  `id` int NOT NULL,
  `magasinId` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `isDefaultMagasin` tinyint(1) NOT NULL DEFAULT '0',
  `magasinName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `magasinEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `magasinHoraire` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `magasinAddress` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `magasinPhone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `mapUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Magasin`
--

INSERT INTO `Magasin` (`id`, `magasinId`, `isDefaultMagasin`, `magasinName`, `magasinEmail`, `magasinHoraire`, `magasinAddress`, `magasinPhone`, `createdAt`, `updatedAt`, `mapUrl`) VALUES
(7, '1213216510', 0, 'Irshad', 'example@gmail.com', '', '', '', '2024-11-05 13:11:13.388', '2024-11-05 13:11:13.388', NULL),
(8, '', 0, 'ikhlass', 'ikhlass@gmail.com', '', '', '', '2024-12-03 12:41:09.445', '2024-12-03 12:41:09.445', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `NewsletterSubscription`
--

CREATE TABLE `NewsletterSubscription` (
  `id` int NOT NULL,
  `encryptedEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Order`
--

CREATE TABLE `Order` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `magasinId` int NOT NULL,
  `transactionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total` double DEFAULT NULL,
  `deliveryAddress` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estimatedDeliveryDate` datetime(3) DEFAULT NULL,
  `transactionInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('CREATED','PAID','PREPARING','DELIVERING','PARTLY_DELIVERED','DELIVERED','ERRORED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'CREATED',
  `Synchronise` int DEFAULT '0',
  `Order_Elesoft` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `EntFac_Num` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `FileInvoice` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `Suivi` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En cours',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `tax` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Order`
--

INSERT INTO `Order` (`id`, `userId`, `magasinId`, `transactionId`, `total`, `deliveryAddress`, `estimatedDeliveryDate`, `transactionInfo`, `status`, `Synchronise`, `Order_Elesoft`, `EntFac_Num`, `FileInvoice`, `Suivi`, `createdAt`, `updatedAt`, `tax`) VALUES
(4, 9, 7, NULL, NULL, NULL, NULL, NULL, 'PAID', 0, '', '', '', 'En cours', '2025-01-04 19:39:01.511', '2025-01-10 16:46:45.151', 0),
(5, 11, 8, NULL, NULL, NULL, NULL, NULL, 'PAID', 0, '', '', '', 'En cours', '2025-01-10 16:48:42.848', '2025-01-10 16:48:42.848', 0);

-- --------------------------------------------------------

--
-- Table structure for table `OrderItem`
--

CREATE TABLE `OrderItem` (
  `id` int NOT NULL,
  `orderId` int NOT NULL,
  `productId` int NOT NULL,
  `RecidNum` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `tax` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `OrderItem`
--

INSERT INTO `OrderItem` (`id`, `orderId`, `productId`, `RecidNum`, `quantity`, `price`, `createdAt`, `updatedAt`, `tax`) VALUES
(12, 4, 35, NULL, 300, 150, '2025-01-04 19:39:40.334', '2025-01-10 16:54:52.306', 0),
(13, 4, 51, NULL, 15, 10, '2025-01-10 16:46:28.293', '2025-01-10 16:46:28.293', 0),
(14, 5, 63, NULL, 200, 10, '2025-01-10 16:49:09.001', '2025-01-10 16:49:09.001', 0);

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

CREATE TABLE `Product` (
  `id` int NOT NULL,
  `Art_Ean13` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isPublic` tinyint(1) NOT NULL DEFAULT '1',
  `Art_Titre` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Art_Image_Url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Art_Editeur` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Art_EtatCom` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Art_Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `Art_Prix` double NOT NULL,
  `Art_Prix_Promo` double DEFAULT NULL,
  `Art_DateDPromo` datetime(3) DEFAULT NULL,
  `Art_DateFPromo` datetime(3) DEFAULT NULL,
  `Art_NmbrPages` int DEFAULT NULL,
  `Art_Poids` double DEFAULT NULL,
  `Art_Hauteur` decimal(10,0) DEFAULT NULL,
  `Art_Largeur` decimal(10,0) DEFAULT NULL,
  `Art_Epaisseur` decimal(10,0) DEFAULT NULL,
  `Art_Points` int NOT NULL DEFAULT '0',
  `formatType` enum('none','compact','grand','paperback','hardcover','ebook','audio') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'none',
  `deletedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `primaryCategoryNumber` int DEFAULT NULL,
  `primaryFormatIsbn` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorId` int DEFAULT NULL,
  `tax` double DEFAULT '0',
  `isPreorder` tinyint(1) NOT NULL DEFAULT '0',
  `Art_DateParu` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Product`
--

INSERT INTO `Product` (`id`, `Art_Ean13`, `isPublic`, `Art_Titre`, `Art_Image_Url`, `Art_Editeur`, `Art_EtatCom`, `Art_Description`, `Art_Prix`, `Art_Prix_Promo`, `Art_DateDPromo`, `Art_DateFPromo`, `Art_NmbrPages`, `Art_Poids`, `Art_Hauteur`, `Art_Largeur`, `Art_Epaisseur`, `Art_Points`, `formatType`, `deletedAt`, `createdAt`, `updatedAt`, `primaryCategoryNumber`, `primaryFormatIsbn`, `authorId`, `tax`, `isPreorder`, `Art_DateParu`) VALUES
(16, '9780743273565', 1, 'The Great Gatsby', 'https://m.media-amazon.com/images/I/71zNHngqfPL._SL1500_.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 10.99, 8.99, '2024-01-01 00:00:00.000', '2026-01-15 00:00:00.000', 180, 0.5, 23, 15, 2, 0, 'hardcover', NULL, '2024-12-09 16:31:56.790', '2025-01-10 02:50:50.534', 100, NULL, 9, 0, 0, NULL),
(17, '9780684830421', 1, 'The Great Gatsby', 'https://m.media-amazon.com/images/I/81mgBMQO02L._SL1500_.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 8.99, NULL, NULL, NULL, 180, 0.45, 20, 14, 1, 0, 'paperback', NULL, '2024-12-09 16:31:56.790', '2025-01-06 00:59:46.798', 100, '9780743273565', 1, 0, 0, NULL),
(18, '9781440687226', 1, 'The Great Gatsby', 'https://example.com/the-great-gatsby.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 6.99, NULL, NULL, NULL, 180, 0.3, 18, 11, 1, 0, 'compact', NULL, '2024-12-09 16:31:56.790', '2025-01-02 02:57:30.290', 100, '9780743273565', 9, 0, 0, NULL),
(19, '9780808519196', 1, 'The Great Gatsby', 'https://m.media-amazon.com/images/I/81nMi3eBgGL._SL1500_.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 14.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'audio', NULL, '2024-12-09 16:31:56.790', '2025-01-02 02:57:30.290', 100, '9780743273565', 4, 0, 0, NULL),
(20, '9781234567890', 1, 'The Great Gatsby', 'https://m.media-amazon.com/images/I/61EtTpQI3vL._SL1360_.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 4.99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'ebook', NULL, '2024-12-09 16:31:56.790', '2025-01-02 02:57:30.290', 100, '9780743273565', 16, 0, 0, NULL),
(21, '9780987654321', 1, 'The Great Gatsby', 'https://m.media-amazon.com/images/I/81Q6WkLhX4L._SL1500_.jpg', 'Charles Scribner\'s Sons', NULL, 'The Great Gatsby is a timeless American classic set during the Roaring Twenties, exploring themes of ambition, love, and the elusive nature of the American Dream. The novel follows the enigmatic Jay Gatsby, a wealthy and mysterious man, as he pursues his unfulfilled love for Daisy Buchanan. With its richly drawn characters and sharp critique of social norms, The Great Gatsby remains a poignant reflection on the cost of dreams and the emptiness of excess.', 12.99, 10.99, '2024-02-01 00:00:00.000', '2026-01-15 00:00:00.000', 180, 0.6, 25, 20, 2, 0, 'grand', NULL, '2024-12-09 16:31:56.790', '2025-01-02 02:57:30.290', 100, '9780743273565', 11, 0, 0, NULL),
(22, '9781400079988', 1, 'The Kite Runner', 'https://m.media-amazon.com/images/I/81LVEH25iJL._SL1500_.jpg', 'Riverhead Books', NULL, 'The Kite Runner is a powerful and emotionally gripping novel that follows the life of Amir, a young boy from Kabul, and his complex relationship with his loyal friend and servant, Hassan. Set against the backdrop of Afghanistan\'s tumultuous history, the story explores themes of betrayal, redemption, and the enduring impact of past actions. A deeply moving tale of friendship and forgiveness, The Kite Runner remains a timeless masterpiece.', 12.99, 10.99, '2024-03-01 00:00:00.000', '2026-01-15 00:00:00.000', 372, 0.6, 22, 14, 2, 0, 'paperback', NULL, '2024-12-09 16:32:28.342', '2025-01-02 02:57:30.290', 100, NULL, 9, 0, 0, NULL),
(23, '9781594631931', 1, 'The Kite Runner', 'https://m.media-amazon.com/images/I/81LVEH25iJL._SL1500_.jpg', 'Riverhead Books', NULL, 'The Kite Runner is a powerful and emotionally gripping novel that follows the life of Amir, a young boy from Kabul, and his complex relationship with his loyal friend and servant, Hassan. Set against the backdrop of Afghanistan\'s tumultuous history, the story explores themes of betrayal, redemption, and the enduring impact of past actions. A deeply moving tale of friendship and forgiveness, The Kite Runner remains a timeless masterpiece.', 7.99, NULL, NULL, NULL, 372, 0.45, 20, 13, 2, 0, 'compact', NULL, '2024-12-09 16:32:28.342', '2025-01-02 02:57:30.290', 100, '9781400079988', 17, 0, 0, NULL),
(24, '9780451524935', 1, '1984', 'https://m.media-amazon.com/images/I/71rpa1-kyvL._SL1500_.jpg', 'Secker & Warburg', NULL, 'A dystopian novel set in a totalitarian society under constant surveillance by Big Brother. It explores the consequences of oppressive government, propaganda, and loss of individuality through the story of Winston Smith, a man who dares to think freely. Orwell masterfully portrays a bleak world where freedom of thought is a dangerous crime, making it a chilling reflection on power and control.', 10.99, 8.99, '2024-02-01 00:00:00.000', '2026-01-15 00:00:00.000', 328, 0.6, 21, 14, 2, 0, 'none', NULL, '2025-01-09 16:43:07.929', '2025-01-10 16:11:57.139', 100, NULL, 10, 0, 1, NULL),
(25, '9780151010264', 1, '1984', 'https://m.media-amazon.com/images/I/612ADI+BVlL._SL1500_.jpg', 'Secker & Warburg', NULL, 'A dystopian novel set in a totalitarian society under constant surveillance by Big Brother. It explores the consequences of oppressive government, propaganda, and loss of individuality through the story of Winston Smith, a man who dares to think freely. Orwell masterfully portrays a bleak world where freedom of thought is a dangerous crime, making it a chilling reflection on power and control.', 15.99, NULL, NULL, NULL, 328, 0.8, 24, 16, 3, 0, 'hardcover', NULL, '2024-12-09 16:43:07.929', '2025-01-02 02:57:30.290', 100, '9780451524935', 11, 0, 0, NULL),
(26, '9780547249643', 1, '1984', 'https://m.media-amazon.com/images/I/612ADI+BVlL._SL1500_.jpg', 'Secker & Warburg', NULL, 'A dystopian novel set in a totalitarian society under constant surveillance by Big Brother. It explores the consequences of oppressive government, propaganda, and loss of individuality through the story of Winston Smith, a man who dares to think freely. Orwell masterfully portrays a bleak world where freedom of thought is a dangerous crime, making it a chilling reflection on power and control.', 7.99, NULL, NULL, NULL, 328, NULL, NULL, NULL, NULL, 0, 'ebook', NULL, '2024-12-09 16:43:07.929', '2025-01-02 02:58:14.896', 100, '9780451524935', 5, 0, 0, NULL),
(27, '9780316769488', 1, 'The Catcher in the Rye', 'https://m.media-amazon.com/images/I/71nXPGovoTL._SL1500_.jpg', 'Little, Brown and Company', NULL, 'A timeless classic that captures the alienation of youth through the eyes of Holden Caulfield, a teenager who wanders New York City after being expelled from his prep school. The novel explores themes of innocence, identity, and belonging, resonating deeply with generations of readers through its candid portrayal of a troubled and questioning soul.', 9.99, NULL, NULL, NULL, 214, 0.4, 21, 14, 2, 0, 'none', NULL, '2024-12-09 16:45:42.808', '2025-01-02 02:58:14.896', 100, NULL, 12, 0, 0, NULL),
(28, '9780316769174', 1, 'The Catcher in the Rye', 'https://m.media-amazon.com/images/I/71nXPGovoTL._SL1500_.jpg', 'Little, Brown and Company', NULL, 'A timeless classic that captures the alienation of youth through the eyes of Holden Caulfield, a teenager who wanders New York City after being expelled from his prep school. The novel explores themes of innocence, identity, and belonging, resonating deeply with generations of readers through its candid portrayal of a troubled and questioning soul.', 12.99, 10.99, '2024-03-01 00:00:00.000', '2026-01-15 00:00:00.000', 214, 0.5, 21, 14, 2, 0, 'paperback', NULL, '2024-12-09 16:45:42.808', '2025-01-02 02:58:14.896', 100, '9780316769488', 13, 0, 0, NULL),
(29, '9780316769006', 1, 'The Catcher in the Rye', 'https://m.media-amazon.com/images/I/71nXPGovoTL._SL1500_.jpg', 'Little, Brown and Company', NULL, 'A timeless classic that captures the alienation of youth through the eyes of Holden Caulfield, a teenager who wanders New York City after being expelled from his prep school. The novel explores themes of innocence, identity, and belonging, resonating deeply with generations of readers through its candid portrayal of a troubled and questioning soul.', 14.99, NULL, NULL, NULL, 214, 0.6, 22, 15, 3, 0, 'hardcover', NULL, '2024-12-09 16:45:42.808', '2025-01-02 02:58:14.896', 100, '9780316769488', 12, 0, 0, NULL),
(30, '9780061120084', 1, 'To Kill a Mockingbird', 'https://m.media-amazon.com/images/I/81aY1lxk+9L._SL1500_.jpg', 'J.B. Lippincott & Co.', NULL, 'This Pulitzer Prize-winning novel tells the story of Scout Finch, a young girl growing up in the racially charged American South during the 1930s. Through the eyes of Scout and her brother Jem, the novel explores themes of racial injustice, moral growth, and the loss of innocence as their father, Atticus Finch, defends a black man accused of raping a white woman.', 8.99, NULL, NULL, NULL, 281, 0.5, 20, 13, 2, 0, 'none', NULL, '2024-12-09 16:46:40.873', '2025-01-02 02:58:14.896', 100, NULL, 3, 0, 0, NULL),
(31, '9780060935467', 1, 'To Kill a Mockingbird', 'https://m.media-amazon.com/images/I/81aY1lxk+9L._SL1500_.jpg', 'J.B. Lippincott & Co.', NULL, 'This Pulitzer Prize-winning novel tells the story of Scout Finch, a young girl growing up in the racially charged American South during the 1930s. Through the eyes of Scout and her brother Jem, the novel explores themes of racial injustice, moral growth, and the loss of innocence as their father, Atticus Finch, defends a black man accused of raping a white woman.', 11.99, 9.99, '2024-02-01 00:00:00.000', '2026-01-15 00:00:00.000', 281, 0.6, 20, 14, 2, 0, 'paperback', NULL, '2024-12-09 16:46:40.873', '2025-01-02 02:58:14.896', 100, '9780061120084', 7, 0, 0, NULL),
(32, '9780062794923', 1, 'To Kill a Mockingbird', 'https://m.media-amazon.com/images/I/61zxX3+G+tL._SL1192_.jpg', 'J.B. Lippincott & Co.', NULL, 'This Pulitzer Prize-winning novel tells the story of Scout Finch, a young girl growing up in the racially charged American South during the 1930s. Through the eyes of Scout and her brother Jem, the novel explores themes of racial injustice, moral growth, and the loss of innocence as their father, Atticus Finch, defends a black man accused of raping a white woman.', 19.99, NULL, NULL, NULL, 281, 0.7, 22, 14, 3, 0, 'hardcover', NULL, '2024-12-09 16:46:40.873', '2025-01-02 03:01:49.972', 100, '9780061120084', 7, 0, 0, NULL),
(33, '9780140449137', 1, 'The Odyssey', 'https://m.media-amazon.com/images/I/71I9il-sk2L._SL1400_.jpg', 'Penguin Classics', NULL, 'A cornerstone of ancient Greek literature, The Odyssey tells the story of Odysseus\'s journey home after the Trojan War. The epic explores themes of adventure, loyalty, and the struggle against fate as Odysseus faces numerous challenges, both mortal and divine, to reunite with his family.', 12.99, NULL, NULL, NULL, 541, 0.7, 23, 15, 3, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 3, 0, 0, NULL),
(35, '9780143127797', 1, 'Sapiens: A Brief History of Humankind', 'https://m.media-amazon.com/images/I/81nQ+oGgI3L._SL1500_.jpg', 'Harper Perennial', NULL, 'Harari explores the history of humankind, from the earliest days of Homo sapiens to modern society, touching on the evolution of culture, technology, and human consciousness. This thought-provoking work challenges readers to reconsider the path of civilization.', 14.99, NULL, NULL, NULL, 443, 0.6, 21, 14, 2, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 4, 0, 0, NULL),
(36, '9780062315008', 1, 'Becoming', 'https://m.media-amazon.com/images/I/81jfDTSLQ9L._SL1500_.jpg', 'Crown Publishing Group', NULL, 'The memoir of the former First Lady of the United States, Becoming chronicles Michelle Obama\'s journey from her childhood in Chicago to her time in the White House. She shares intimate reflections on race, identity, and her personal evolution.', 18.99, NULL, NULL, NULL, 448, 0.8, 23, 16, 3, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 6, 0, 0, NULL),
(37, '9780399590505', 1, 'Educated: A Memoir', 'https://m.media-amazon.com/images/I/81Om0n+pfyL._SL1500_.jpg', 'Random House', NULL, 'Educated tells the story of Tara Westover, a woman who grows up in a strict, survivalist family in rural Idaho, and her eventual escape from her upbringing to pursue education. The memoir explores themes of family loyalty, personal transformation, and the power of knowledge.', 16.99, NULL, NULL, NULL, 352, 0.7, 21, 14, 3, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 6, 0, 0, NULL),
(38, '9780735219091', 1, 'The Silent Patient', 'https://m.media-amazon.com/images/I/91BbLCJOruL._SL1500_.jpg', 'Celadon Books', NULL, 'A psychological thriller about Alicia Berenson, a celebrated artist who brutally murders her husband and then stops speaking altogether. A psychotherapist becomes obsessed with uncovering the truth behind her silence.', 13.99, NULL, NULL, NULL, 325, 0.6, 22, 15, 2, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 7, 0, 0, NULL),
(39, '9780062457715', 1, 'Where the Crawdads Sing', 'https://m.media-amazon.com/images/I/81lbmz5t2sL._SL1500_.jpg', 'Putnam', NULL, 'A mystery and coming-of-age novel set in the swamps of North Carolina, Where the Crawdads Sing follows Kya Clark, the mysterious ‘Marsh Girl,’ as she navigates loneliness and her complex relationship with nature and society.', 14.99, NULL, NULL, NULL, 370, 0.6, 22, 15, 2, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 11, 0, 0, NULL),
(40, '9780525536292', 1, 'The Dutch House', 'https://example.com/the-dutch-house.jpg', 'Harper', NULL, 'The Dutch House follows the lives of siblings Danny and Maeve, who grow up in a grand estate known as the Dutch House. Spanning five decades, the novel explores themes of family, memory, and the ties that bind.', 15.99, NULL, NULL, NULL, 336, 0.6, 22, 15, 2, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-02 03:01:49.972', 100, NULL, 3, 0, 0, NULL),
(41, '9780452295296', 1, 'The Help', 'https://m.media-amazon.com/images/I/61taK-2tICL._SL1200_.jpg', 'Putnam', NULL, 'Set in 1960s Mississippi, The Help tells the story of three women—Aibileen, a black maid; Minny, a fiery housekeeper; and Skeeter, a young white journalist—who unite to expose the injustices of segregation and racism in the American South.', 12.99, NULL, NULL, NULL, 444, 0.7, 23, 15, 2, 0, 'none', NULL, '2024-12-09 16:54:10.331', '2025-01-13 03:11:21.000', 100, NULL, 5, 0, 0, '2025-01-09 12:00:00.000'),
(42, '9789776532160', 1, 'The Yacoubian Building', 'https://m.media-amazon.com/images/I/71r7wijxWqL._SL1360_.jpg', 'American University in Cairo Press', NULL, 'A gripping tale of love, politics, and corruption set in modern Cairo, The Yacoubian Building explores the lives of a variety of characters in Egypt\'s rapidly changing society.', 14.99, NULL, NULL, NULL, 476, 0.8, 23, 15, 3, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-13 03:11:55.623', 100, NULL, 15, 0, 0, '2025-01-09 12:00:00.000'),
(43, '9789953872791', 1, 'The Cairo Trilogy', 'https://m.media-amazon.com/images/I/71LTvL4rW7L._SL1200_.jpg', 'Anchor Books', NULL, 'Naguib Mahfouz’s epic trilogy portrays the history of Egypt through the lives of a family in Cairo, covering themes of politics, family, and social change.', 19.99, NULL, NULL, NULL, 1340, 1.3, 23, 16, 5, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-13 03:11:55.623', 100, NULL, 7, 0, 0, '1902-01-09 12:00:00.000'),
(44, '9789776481811', 1, 'The Prophet', 'https://m.media-amazon.com/images/I/61+8wwQ2JsL._SL1200_.jpg', 'Alfred A. Knopf', NULL, 'A philosophical and spiritual work by Khalil Gibran, The Prophet is a collection of poetic essays on various aspects of life, such as love, freedom, and work, offering timeless wisdom.', 12.99, NULL, NULL, NULL, 128, 0.3, 18, 13, 1, 0, 'none', NULL, '2025-01-08 16:56:33.030', '2025-01-13 03:11:55.623', 100, NULL, 12, 0, 0, '1905-01-09 12:00:00.000'),
(45, '9789773191415', 1, 'Season of Migration to the North', 'https://example.com/season-of-migration.jpg', 'Heinemann', NULL, 'Season of Migration to the North is a seminal work of Arabic literature that explores the post-colonial experience of a Sudanese man returning home after studying in England.', 15.99, NULL, NULL, NULL, 142, 0.4, 21, 14, 2, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-13 03:11:55.623', 100, NULL, 6, 0, 0, '2025-02-09 12:00:00.000'),
(46, '9789774053727', 1, 'Palace Walk', 'https://m.media-amazon.com/images/I/611aUF+nucL._SL1200_.jpg', 'Anchor Books', NULL, 'Palace Walk, the first novel in Naguib Mahfouz\'s Cairo Trilogy, follows a family in Cairo as they navigate the complexities of political and social change in early 20th-century Egypt.', 18.99, NULL, NULL, NULL, 464, 0.7, 22, 16, 3, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-06 01:12:29.157', 100, NULL, 7, 0, 1, NULL),
(47, '9789960541394', 1, 'The Thousand and One Nights', 'https://m.media-amazon.com/images/I/713HD74rUFL._SL1400_.jpg', 'Penguin Classics', NULL, 'The Thousand and One Nights is a collection of Middle Eastern folk tales compiled in Arabic during the Islamic Golden Age, filled with stories of adventure, magic, and romance.', 24.99, NULL, NULL, NULL, 704, 1.5, 24, 17, 6, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-13 03:11:55.623', 100, NULL, 2, 0, 0, '2025-03-09 12:00:00.000'),
(48, '9789774277579', 1, 'The Book of Khalid', 'https://example.com/book-of-khalid.jpg', 'Alfred A. Knopf', NULL, 'The Book of Khalid is a novel by Ameen Rihani, considered to be the first Arabic-American novel. It explores the journey of a Lebanese immigrant to America and his quest for identity.', 17.99, NULL, NULL, NULL, 320, 0.7, 22, 15, 3, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-02 03:01:49.972', 100, NULL, 14, 0, 0, NULL),
(49, '9789773645072', 1, 'In the Eye of the Sun', 'https://m.media-amazon.com/images/I/41T7eemGKTL.jpg', 'American University in Cairo Press', NULL, 'In the Eye of the Sun is a sprawling novel that follows the life of a young Egyptian woman as she navigates the complexities of love, career, and societal expectations.', 21.99, NULL, NULL, NULL, 634, 1, 23, 16, 4, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-02 03:01:49.972', 100, NULL, 12, 0, 0, NULL),
(50, '9789773133202', 1, 'The Hidden Face of Eve', 'https://m.media-amazon.com/images/I/81B-tnbuWcL._SL1500_.jpg', 'Zed Books', NULL, 'In this groundbreaking feminist work, Nawal El Saadawi explores the oppression of women in Arab societies, drawing on her own experiences and research to expose gender inequality.', 19.99, NULL, NULL, NULL, 295, 0.6, 21, 14, 3, 0, 'none', NULL, '2024-12-09 16:56:33.030', '2025-01-02 03:01:49.972', 100, NULL, 12, 0, 0, NULL),
(51, '9789981844747', 1, 'The Araba', 'https://example.com/the-araba.jpg', 'Editions Afrique Orient', NULL, 'A classic Moroccan novel, The Araba explores themes of tradition, modernity, and the clash between Western and Moroccan cultures.', 13.99, NULL, NULL, NULL, 180, 0.4, 22, 15, 2, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:01:49.972', 100, NULL, 14, 0, 0, NULL),
(52, '9789954620889', 1, 'Street of the Dead', 'https://example.com/street-of-the-dead.jpg', 'Albin Michel', NULL, 'This book reflects on the themes of life, death, and social change, set against the backdrop of Casablanca\'s streets.', 15.99, NULL, NULL, NULL, 230, 0.5, 22, 15, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 6, 0, 0, NULL),
(53, '9789953891113', 1, 'In the Land of the Pharaohs', 'https://m.media-amazon.com/images/I/51HD6f8VkzL._SL1360_.jpg', 'Editions Seuil', NULL, 'This novel explores the relationship between Morocco and Egypt, bridging two North African cultures and examining the tensions between them.', 17.99, NULL, NULL, NULL, 360, 0.8, 23, 16, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 1, 0, 0, NULL),
(54, '9789995881213', 1, 'The Sand Child', 'https://m.media-amazon.com/images/I/71e9Iw0TFuL._SL1360_.jpg', 'Editions La Croisée des Chemins', NULL, 'A compelling story about childhood, innocence, and tradition, set in the context of Moroccan society.', 12.99, NULL, NULL, NULL, 200, 0.5, 21, 15, 2, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 3, 0, 0, NULL),
(55, '9789954128583', 1, 'The Eternal Return', 'https://example.com/eternal-return.jpg', 'Editions Actes Sud', NULL, 'A philosophical novel that touches on the theme of repetition and the cyclical nature of life.', 16.99, NULL, NULL, NULL, 250, 0.6, 22, 15, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 15, 0, 0, NULL),
(56, '9789773191033', 1, 'The Peasants', 'https://m.media-amazon.com/images/I/61LCJH9lDlL._SL1500_.jpg', 'Editions Syndicat National des Editeurs', NULL, 'A novel that paints a vivid picture of rural Morocco and the challenges faced by the peasant class.', 14.99, NULL, NULL, NULL, 320, 0.7, 24, 16, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-10 02:50:50.534', 100, NULL, 13, 0, 1, NULL),
(57, '9789994475249', 1, 'Fighting the Injustice', 'https://m.media-amazon.com/images/I/41845XA78ML.jpg', 'Editions Alif', NULL, 'A powerful novel that examines corruption and the fight against injustice in Moroccan society.', 18.99, NULL, NULL, NULL, 400, 0.9, 24, 16, 4, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 10, 0, 0, NULL),
(58, '9789961564833', 1, 'The Olive Grove', 'https://m.media-amazon.com/images/I/91J5bt85SjL._SL1500_.jpg', 'Editions La Croisée des Chemins', NULL, 'A novel about life in a small Moroccan village, exploring themes of land, heritage, and personal identity.', 14.99, NULL, NULL, NULL, 270, 0.6, 23, 16, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 17, 0, 0, NULL),
(59, '9789997441458', 1, 'Echoes of the Past', 'https://m.media-amazon.com/images/I/81mjoLANm0L._SL1500_.jpg', 'Editions Fayard', NULL, 'A heartfelt narrative that delves into the personal and political issues of the Moroccan diaspora, drawing on themes of identity, love, and social change.', 21.99, NULL, NULL, NULL, 320, 0.8, 23, 16, 4, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 1, 0, 0, NULL),
(60, '9789954238826', 1, 'Tales of a Moroccan Woman', 'https://m.media-amazon.com/images/I/7108uGM-yWL._SL1360_.jpg', 'Editions Le Fennec', NULL, 'A collection of short stories reflecting the voices and struggles of Moroccan women in a rapidly changing society.', 13.99, NULL, NULL, NULL, 190, 0.5, 21, 14, 2, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 13, 0, 0, NULL),
(61, '9789953885297', 1, 'Moroccan Tales of Old', 'https://m.media-amazon.com/images/I/81MqsqCWQ9L._SL1500_.jpg', 'Editions Imane', NULL, 'A collection of traditional Moroccan folktales, passed down through generations, capturing the essence of Moroccan culture and mythology.', 16.99, NULL, NULL, NULL, 300, 0.7, 22, 15, 3, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 3, 0, 0, NULL),
(62, '9789953439112', 1, 'Journey Through the Atlas Mountains', 'https://example.com/journey-atlas.jpg', 'Editions Anoual', NULL, 'An evocative travelogue recounting the experiences and adventures through Morocco\'s stunning Atlas Mountains.', 18.99, NULL, NULL, NULL, 350, 0.8, 24, 16, 4, 0, 'none', NULL, '2024-12-09 16:58:37.343', '2025-01-02 03:00:06.120', 100, NULL, 1, 0, 0, NULL),
(63, '9783596313011', 1, 'Der Steppenwolf', 'https://m.media-amazon.com/images/I/71JI9Ij+HhL._SL1500_.jpg', 'Suhrkamp Verlag', NULL, 'A novel exploring the duality of human nature through the character of Harry Haller, who feels torn between his civilized persona and his wild, animalistic side.', 14.99, 12.99, '2024-01-01 00:00:00.000', '2026-01-15 00:00:00.000', 271, 0.4, 22, 15, 2, 0, 'paperback', NULL, '2024-12-09 17:10:18.288', '2025-01-10 02:50:50.534', 100, NULL, 8, 0, 1, NULL),
(64, '9783596900567', 1, 'Die Verwandlung', 'https://m.media-amazon.com/images/I/61i1VGp9ShL._SL1500_.jpg', 'S. Fischer Verlag', NULL, 'A short story about Gregor Samsa, a man who wakes up one morning to find himself transformed into a giant insect.', 8.99, 7.5, '2024-02-01 00:00:00.000', '2026-01-15 00:00:00.000', 99, 0.25, 19, 13, 1, 0, 'hardcover', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 8, 0, 0, NULL),
(65, '9783423120618', 1, 'Der Prozess', 'https://m.media-amazon.com/images/I/91jyfLHGcVL._SL1500_.jpg', 'Rowohlt Verlag', NULL, 'A novel about Josef K., a man who is arrested and put on trial for an unspecified crime, navigating a bizarre and oppressive legal system.', 12.99, 10.99, '2024-03-01 00:00:00.000', '2024-03-15 00:00:00.000', 300, 0.5, 21, 14, 2, 0, 'hardcover', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 9, 0, 0, NULL),
(66, '9783103810209', 1, 'Der Zauberberg', 'https://m.media-amazon.com/images/I/61LcGOtkXGL._SL1500_.jpg', 'Verlag C.H. Beck', NULL, 'A philosophical novel set in a tuberculosis sanatorium, where the protagonist Hans Castorp confronts questions about life, death, and the meaning of time.', 19.99, 17.5, '2024-04-01 00:00:00.000', '2024-04-15 00:00:00.000', 752, 1.2, 22, 16, 3, 0, 'paperback', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 10, 0, 0, NULL),
(67, '9783596506121', 1, 'Die Buddenbrooks', 'https://m.media-amazon.com/images/I/81n-b3GzKgL._SL1500_.jpg', 'Fischer Verlag', NULL, 'A family saga depicting the decline of the Buddenbrook family over several generations, exploring themes of societal change and individual destiny.', 16.99, 14.99, '2024-05-01 00:00:00.000', '2024-05-15 00:00:00.000', 800, 1.5, 23, 15, 4, 0, 'hardcover', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 13, 0, 0, NULL),
(68, '9783868203135', 1, 'Der Vorleser', 'https://m.media-amazon.com/images/I/81bPjt+WDAL._SL1500_.jpg', 'Diogenes Verlag', NULL, 'A gripping novel about a teenager\'s love affair with an older woman, which later reveals deep moral and historical consequences.', 14.99, 12.99, '2024-06-01 00:00:00.000', '2026-01-15 00:00:00.000', 220, 0.4, 21, 14, 2, 0, 'audio', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 14, 0, 0, NULL),
(69, '9783596528598', 1, 'Siddhartha', 'https://example.com/siddhartha.jpg', 'Suhrkamp Verlag', NULL, 'A philosophical novel that explores the journey of a man named Siddhartha as he seeks enlightenment, drawing from Eastern philosophy.', 11.99, 9.99, '2024-07-01 00:00:00.000', '2024-07-15 00:00:00.000', 152, 0.3, 19, 13, 2, 0, 'ebook', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 15, 0, 0, NULL),
(70, '9783423216571', 1, 'Die Physiker', 'https://m.media-amazon.com/images/I/71Jf8UBkk5L._SL1360_.jpg', 'Verlag der Autoren', NULL, 'A darkly comedic play that critiques science, ethics, and the responsibilities of individuals in the face of technological progress.', 13.5, 11.99, '2024-08-01 00:00:00.000', '2026-01-15 00:00:00.000', 120, 0.25, 21, 14, 1, 0, 'paperback', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 16, 0, 0, NULL),
(71, '9783884171513', 1, 'Momo', 'https://m.media-amazon.com/images/I/61QfbiHLQGL._SL1200_.jpg', 'Thienemann Verlag', NULL, 'A fantasy novel about a young girl, Momo, who fights against time-thieves who steal people\'s time and create a society obsessed with efficiency.', 14.5, 12, '2024-09-01 00:00:00.000', '2024-09-15 00:00:00.000', 350, 0.6, 22, 15, 2, 0, 'hardcover', NULL, '2024-12-09 17:10:18.288', '2025-01-02 03:00:06.120', 100, NULL, 17, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ProductStock`
--

CREATE TABLE `ProductStock` (
  `id` int NOT NULL,
  `magasinId` int NOT NULL,
  `Art_Stock` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `productIsbn` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ProductStock`
--

INSERT INTO `ProductStock` (`id`, `magasinId`, `Art_Stock`, `createdAt`, `updatedAt`, `productIsbn`) VALUES
(23, 7, 6, '2025-01-05 16:11:16.669', '2025-01-05 16:28:48.661', '9780743273565'),
(25, 8, 200, '2025-01-05 16:12:33.246', '2025-01-05 16:33:23.995', '9780743273565'),
(26, 7, 155, '2025-01-05 16:33:49.457', '2025-01-05 16:33:49.457', '9781400079988'),
(27, 8, 13, '2025-01-06 00:43:26.351', '2025-01-06 00:44:08.218', '9780525536292'),
(28, 8, 65, '2025-01-10 02:34:51.170', '2025-01-10 02:34:51.170', '9789995881213');

-- --------------------------------------------------------

--
-- Table structure for table `PromoShowcase`
--

CREATE TABLE `PromoShowcase` (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `startDate` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  `endDate` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Review`
--

CREATE TABLE `Review` (
  `id` int NOT NULL,
  `productId` int NOT NULL,
  `userId` int NOT NULL,
  `text` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` int NOT NULL DEFAULT '0',
  `isPublic` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Sessions`
--

CREATE TABLE `Sessions` (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `accessToken` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `renewToken` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `accessTokenExpiryTime` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  `renewTokenExpiryTime` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Sessions`
--

INSERT INTO `Sessions` (`id`, `userId`, `accessToken`, `renewToken`, `accessTokenExpiryTime`, `renewTokenExpiryTime`, `createdAt`, `updatedAt`) VALUES
('6111bc3c-0718-4896-b1f9-c62abb226f87', 10, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwLCJpc0FkbWluIjp0cnVlLCJpc1ZlcmlmaWVkIjpmYWxzZSwiaWF0IjoxNzM2OTY4NDgwLCJleHAiOjE3MzY5NzAyODB9.YGwWiRW4p2mTkXcWIakPAJMIQEjNLOk9Ct3tfMMNLag', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwLCJpc0FkbWluIjp0cnVlLCJpc1ZlcmlmaWVkIjpmYWxzZSwiaWF0IjoxNzM2OTY4NDgwLCJleHAiOjE3MzcwNTQ4ODB9.VHlnuX8lHlJn7opu1Q_6uvSvsQHWNXsDTasJWvmZDX8', '2025-01-16 08:44:24.531', '2025-01-17 08:14:24.531', '2025-01-15 19:14:40.866', '2025-01-16 08:14:24.531');

-- --------------------------------------------------------

--
-- Table structure for table `ShowcaseItem`
--

CREATE TABLE `ShowcaseItem` (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `imageUrl` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `SystemMessage`
--

CREATE TABLE `SystemMessage` (
  `id` int NOT NULL,
  `isPublic` tinyint(1) DEFAULT '1',
  `startDate` datetime(3) DEFAULT NULL,
  `endDate` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `SystemMessage`
--

INSERT INTO `SystemMessage` (`id`, `isPublic`, `startDate`, `endDate`, `createdAt`, `updatedAt`) VALUES
(1, 1, NULL, NULL, '2024-11-23 18:20:19.406', '2024-11-23 18:20:19.406');

-- --------------------------------------------------------

--
-- Table structure for table `SystemMessageTranslation`
--

CREATE TABLE `SystemMessageTranslation` (
  `id` int NOT NULL,
  `systemMessageId` int NOT NULL,
  `languageCode` enum('en','fr','de','ar') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'en',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `SystemMessageTranslation`
--

INSERT INTO `SystemMessageTranslation` (`id`, `systemMessageId`, `languageCode`, `message`) VALUES
(1, 1, 'en', 'hello world'),
(2, 1, 'fr', 'hello world'),
(3, 1, 'de', 'hello world'),
(4, 1, 'ar', 'hello world');

-- --------------------------------------------------------

--
-- Table structure for table `SystemPreferences`
--

CREATE TABLE `SystemPreferences` (
  `id` int NOT NULL,
  `showcaseType` enum('TRIPLE','SINGLE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'TRIPLE',
  `showMessages` tinyint(1) DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `SystemPreferences`
--

INSERT INTO `SystemPreferences` (`id`, `showcaseType`, `showMessages`, `createdAt`, `updatedAt`) VALUES
(1, 'TRIPLE', 1, '2024-11-04 16:19:21.806', '2024-11-04 16:19:21.806');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int NOT NULL,
  `Elesoft_ID` int DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `isVerified` tinyint(1) NOT NULL DEFAULT '0',
  `Synchronise` int DEFAULT '0',
  `encryptedEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `encryptedPhone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hashedPassword` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `encryptedFirstName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `encryptedLastName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `encryptedAddressMain` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `encryptedAddressSecond` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deletedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `Elesoft_ID`, `isAdmin`, `isVerified`, `Synchronise`, `encryptedEmail`, `encryptedPhone`, `hashedPassword`, `encryptedFirstName`, `encryptedLastName`, `encryptedAddressMain`, `encryptedAddressSecond`, `city`, `state`, `zip`, `country`, `deletedAt`, `createdAt`, `updatedAt`) VALUES
(9, NULL, 0, 0, 0, 'ea5ee7dee14349980e71caebafa1d7987d2ec501866cbf53ea8779985745af63', '3665ecbae2a4ed7fe3a128dd3517741c', '$2b$10$7arIPYOvaRV4pXzFhDR9duy0.WNot37Hhwe4PmNfipu4bGqU9Tqm.', 'c56ca3095bbbf8ffd979116f1d826705', 'fc3190d874180439ebaa4c975aec2da3', '1566844416e8112d61722a620ee551b9a1ebea2c43960a38f95cbcf887d14799', NULL, 'Casablanca', NULL, '9000', NULL, NULL, '2024-12-12 16:43:51.430', '2024-12-26 14:39:33.031'),
(10, NULL, 1, 0, 0, '23296daeada070dd3addee9a12036a17', '9afc833828f957d2350ec09b2b489260', '$2b$10$zT1XczhKD1NWsDLPEZ.n6.itc50NOVw22IkQqNrhTK16BteLRn1rC', 'c295571af1403c2dd0b723e5a63a5d06', 'c295571af1403c2dd0b723e5a63a5d06', 'ba7594f57971e4f971762580eea93c0d92c114bf337d97a072fc1b88064b3297', NULL, 'Casablanca', NULL, '70010sdads', NULL, NULL, '2024-12-12 18:03:10.744', '2025-01-05 11:30:33.358'),
(11, NULL, 0, 0, 0, 'acf96d41c5d70dd55fb718b756ba15e0', '3665ecbae2a4ed7fe3a128dd3517741c', '$2b$10$b7Ngyah7zYhNJ6rrlEI.MOJgbBeAM0CogRQMZc34YClB7m4ygv3Ba', '868e7f90439ced08e3be5a0e8e020727', '2fc7f243f1a761da10327139f9a6f734', '805893c4741b4efb713c7ca981f3e2bb99d3439f63d291259b9ac2b1b8583cd9', '2c347db3b64d0f46af9e88bf435d7aab2e32803b595e665b4c6dce547becc741', 'Al Hoceima', NULL, '70010', NULL, NULL, '2024-12-24 18:20:59.972', '2024-12-24 18:20:59.972'),
(12, NULL, 0, 0, 0, '613fe8dfda9b91e4670d044933ff1dfe1efa026b9cfa59f2443b91fb943e0d5d', '3665ecbae2a4ed7fe3a128dd3517741c', '$2b$10$9C3THR6jMeIW5nkUM9P5cuJxivOIimnI6.yHCIdatQz511hZcBXJu', '48680a50bdd0b00b9d8c334f8e0b603e', '07c21c3e271530d395445febb3d545f8', '2e11868b059e60a4107a09aa890cb2efa490fc097b2e11ecaddc98c7d972d3f0', '1e859c42f1265954704e23297bde955b', 'Sebt Gzoula', NULL, '70010', NULL, NULL, '2024-12-24 18:27:18.237', '2024-12-24 18:52:33.198');

-- --------------------------------------------------------

--
-- Table structure for table `UserPreferences`
--

CREATE TABLE `UserPreferences` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `emailNotifications` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `UserPreferences`
--

INSERT INTO `UserPreferences` (`id`, `userId`, `emailNotifications`, `createdAt`, `updatedAt`) VALUES
(9, 9, 1, '2024-12-12 16:43:51.430', '2024-12-12 16:43:51.430'),
(10, 10, 1, '2024-12-12 18:03:10.744', '2024-12-12 18:03:10.744'),
(11, 11, 1, '2024-12-24 18:20:59.972', '2024-12-24 18:20:59.972'),
(12, 12, 1, '2024-12-24 18:27:18.237', '2024-12-24 18:27:18.237');

-- --------------------------------------------------------

--
-- Table structure for table `Wishlist`
--

CREATE TABLE `Wishlist` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Wishlist`
--

INSERT INTO `Wishlist` (`id`, `userId`, `createdAt`, `updatedAt`) VALUES
(186, 9, '2024-12-12 18:01:22.153', '2024-12-12 18:01:22.153'),
(187, 10, '2024-12-12 18:03:11.098', '2024-12-12 18:03:11.098'),
(188, 11, '2024-12-24 18:21:00.068', '2024-12-24 18:21:00.068'),
(189, 12, '2024-12-24 18:27:18.293', '2024-12-24 18:27:18.293');

-- --------------------------------------------------------

--
-- Table structure for table `WishlistItem`
--

CREATE TABLE `WishlistItem` (
  `id` int NOT NULL,
  `wishlistId` int NOT NULL,
  `productId` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `WishlistItem`
--

INSERT INTO `WishlistItem` (`id`, `wishlistId`, `productId`, `quantity`, `createdAt`, `updatedAt`) VALUES
(178, 188, 63, 1, '2024-12-24 18:23:56.211', '2024-12-24 18:23:56.211'),
(191, 186, 41, 1, '2024-12-25 14:11:42.888', '2024-12-25 14:11:42.888'),
(194, 186, 66, 1, '2024-12-25 14:57:57.443', '2024-12-25 14:57:57.443'),
(195, 186, 67, 1, '2024-12-25 14:57:57.444', '2024-12-25 14:57:57.444'),
(196, 186, 65, 1, '2024-12-25 14:57:57.444', '2024-12-25 14:57:57.444'),
(197, 186, 64, 1, '2024-12-25 14:57:57.444', '2024-12-25 14:57:57.444'),
(216, 187, 71, 1, '2025-01-12 17:56:34.854', '2025-01-12 17:56:34.854'),
(217, 187, 51, 1, '2025-01-15 19:14:41.083', '2025-01-15 19:14:41.083'),
(218, 187, 33, 1, '2025-01-15 19:14:41.083', '2025-01-15 19:14:41.083');

-- --------------------------------------------------------

--
-- Table structure for table `_CategoryProducts`
--

CREATE TABLE `_CategoryProducts` (
  `A` int NOT NULL,
  `B` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_CategoryProducts`
--

INSERT INTO `_CategoryProducts` (`A`, `B`) VALUES
(1, 16),
(2, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(2, 43),
(1, 44),
(1, 45),
(1, 46),
(2, 46),
(1, 47),
(1, 48),
(2, 48),
(1, 49),
(1, 50),
(2, 50),
(1, 51),
(1, 52),
(2, 52),
(1, 53),
(1, 54),
(1, 55),
(2, 55),
(1, 56),
(2, 56),
(1, 57),
(1, 58),
(2, 58),
(1, 59),
(1, 60),
(2, 60),
(1, 61),
(1, 62),
(2, 62),
(1, 63),
(1, 64),
(1, 65),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71);

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('ce52e6b2-7ac5-4268-baaf-dff78b14eb94', '132f6aef95224f17d827ea6d191e0bf83a490a895ea236e5ed162e3083edc220', '2024-11-04 16:18:45.247', '20241104161844_migrate1', NULL, NULL, '2024-11-04 16:18:44.179', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Author`
--
ALTER TABLE `Author`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Cart`
--
ALTER TABLE `Cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Cart_userId_key` (`userId`);

--
-- Indexes for table `CartItem`
--
ALTER TABLE `CartItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `CartItem_cartId_productId_key` (`cartId`,`productId`),
  ADD KEY `CartItem_productId_fkey` (`productId`);

--
-- Indexes for table `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Category_categoryNumber_key` (`categoryNumber`),
  ADD KEY `Category_parentId_fkey` (`parentId`);

--
-- Indexes for table `CategoryTranslation`
--
ALTER TABLE `CategoryTranslation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `CategoryTranslation_categoryNumber_fkey` (`categoryNumber`);

--
-- Indexes for table `DefaultShowcase`
--
ALTER TABLE `DefaultShowcase`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `DefaultShowcase_itemId_key` (`itemId`);

--
-- Indexes for table `DeliveryTerms`
--
ALTER TABLE `DeliveryTerms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `DeliveryTerms_magasinId_key` (`magasinId`);

--
-- Indexes for table `Magasin`
--
ALTER TABLE `Magasin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Magasin_magasinId_key` (`magasinId`);

--
-- Indexes for table `NewsletterSubscription`
--
ALTER TABLE `NewsletterSubscription`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `NewsletterSubscription_encryptedEmail_key` (`encryptedEmail`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Order_userId_fkey` (`userId`),
  ADD KEY `Order_magasinId_fkey` (`magasinId`);

--
-- Indexes for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `OrderItem_orderId_productId_key` (`orderId`,`productId`),
  ADD KEY `OrderItem_productId_fkey` (`productId`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Product_Art_Ean13_key` (`Art_Ean13`),
  ADD KEY `Product_primaryFormatIsbn_fkey` (`primaryFormatIsbn`),
  ADD KEY `Product_primaryCategoryNumber_fkey` (`primaryCategoryNumber`),
  ADD KEY `Product_authorId_fkey` (`authorId`);

--
-- Indexes for table `ProductStock`
--
ALTER TABLE `ProductStock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ProductStock_productIsbn_magasinId_key` (`productIsbn`,`magasinId`),
  ADD KEY `ProductStock_magasinId_fkey` (`magasinId`);

--
-- Indexes for table `PromoShowcase`
--
ALTER TABLE `PromoShowcase`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `PromoShowcase_itemId_key` (`itemId`);

--
-- Indexes for table `Review`
--
ALTER TABLE `Review`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Review_productId_userId_key` (`productId`,`userId`),
  ADD KEY `Review_userId_fkey` (`userId`);

--
-- Indexes for table `Sessions`
--
ALTER TABLE `Sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Sessions_userId_key` (`userId`);

--
-- Indexes for table `ShowcaseItem`
--
ALTER TABLE `ShowcaseItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `SystemMessage`
--
ALTER TABLE `SystemMessage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `SystemMessageTranslation`
--
ALTER TABLE `SystemMessageTranslation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `SystemMessageTranslation_systemMessageId_languageCode_key` (`systemMessageId`,`languageCode`);

--
-- Indexes for table `SystemPreferences`
--
ALTER TABLE `SystemPreferences`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `User_encryptedEmail_key` (`encryptedEmail`),
  ADD UNIQUE KEY `User_Elesoft_ID_key` (`Elesoft_ID`);

--
-- Indexes for table `UserPreferences`
--
ALTER TABLE `UserPreferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UserPreferences_userId_key` (`userId`);

--
-- Indexes for table `Wishlist`
--
ALTER TABLE `Wishlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Wishlist_userId_key` (`userId`);

--
-- Indexes for table `WishlistItem`
--
ALTER TABLE `WishlistItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `WishlistItem_wishlistId_productId_key` (`wishlistId`,`productId`),
  ADD KEY `WishlistItem_productId_fkey` (`productId`);

--
-- Indexes for table `_CategoryProducts`
--
ALTER TABLE `_CategoryProducts`
  ADD UNIQUE KEY `_CategoryProducts_AB_unique` (`A`,`B`),
  ADD KEY `_CategoryProducts_B_index` (`B`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Author`
--
ALTER TABLE `Author`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `Cart`
--
ALTER TABLE `Cart`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;

--
-- AUTO_INCREMENT for table `CartItem`
--
ALTER TABLE `CartItem`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=296;

--
-- AUTO_INCREMENT for table `Category`
--
ALTER TABLE `Category`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `CategoryTranslation`
--
ALTER TABLE `CategoryTranslation`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT for table `DeliveryTerms`
--
ALTER TABLE `DeliveryTerms`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Magasin`
--
ALTER TABLE `Magasin`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `NewsletterSubscription`
--
ALTER TABLE `NewsletterSubscription`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Order`
--
ALTER TABLE `Order`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `OrderItem`
--
ALTER TABLE `OrderItem`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `Product`
--
ALTER TABLE `Product`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `ProductStock`
--
ALTER TABLE `ProductStock`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `Review`
--
ALTER TABLE `Review`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `SystemMessage`
--
ALTER TABLE `SystemMessage`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `SystemMessageTranslation`
--
ALTER TABLE `SystemMessageTranslation`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `SystemPreferences`
--
ALTER TABLE `SystemPreferences`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `UserPreferences`
--
ALTER TABLE `UserPreferences`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Wishlist`
--
ALTER TABLE `Wishlist`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=190;

--
-- AUTO_INCREMENT for table `WishlistItem`
--
ALTER TABLE `WishlistItem`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=219;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Cart`
--
ALTER TABLE `Cart`
  ADD CONSTRAINT `Cart_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `CartItem`
--
ALTER TABLE `CartItem`
  ADD CONSTRAINT `CartItem_cartId_fkey` FOREIGN KEY (`cartId`) REFERENCES `Cart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CartItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Category`
--
ALTER TABLE `Category`
  ADD CONSTRAINT `Category_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `CategoryTranslation`
--
ALTER TABLE `CategoryTranslation`
  ADD CONSTRAINT `CategoryTranslation_categoryNumber_fkey` FOREIGN KEY (`categoryNumber`) REFERENCES `Category` (`categoryNumber`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `DefaultShowcase`
--
ALTER TABLE `DefaultShowcase`
  ADD CONSTRAINT `DefaultShowcase_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `ShowcaseItem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `DeliveryTerms`
--
ALTER TABLE `DeliveryTerms`
  ADD CONSTRAINT `DeliveryTerms_magasinId_fkey` FOREIGN KEY (`magasinId`) REFERENCES `Magasin` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `Order_magasinId_fkey` FOREIGN KEY (`magasinId`) REFERENCES `Magasin` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `Order_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD CONSTRAINT `OrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `OrderItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `Product_authorId_fkey` FOREIGN KEY (`authorId`) REFERENCES `Author` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Product_primaryCategoryNumber_fkey` FOREIGN KEY (`primaryCategoryNumber`) REFERENCES `Category` (`categoryNumber`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Product_primaryFormatIsbn_fkey` FOREIGN KEY (`primaryFormatIsbn`) REFERENCES `Product` (`Art_Ean13`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ProductStock`
--
ALTER TABLE `ProductStock`
  ADD CONSTRAINT `ProductStock_magasinId_fkey` FOREIGN KEY (`magasinId`) REFERENCES `Magasin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ProductStock_productIsbn_fkey` FOREIGN KEY (`productIsbn`) REFERENCES `Product` (`Art_Ean13`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `PromoShowcase`
--
ALTER TABLE `PromoShowcase`
  ADD CONSTRAINT `PromoShowcase_itemId_fkey` FOREIGN KEY (`itemId`) REFERENCES `ShowcaseItem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Review`
--
ALTER TABLE `Review`
  ADD CONSTRAINT `Review_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Review_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Sessions`
--
ALTER TABLE `Sessions`
  ADD CONSTRAINT `Sessions_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `SystemMessageTranslation`
--
ALTER TABLE `SystemMessageTranslation`
  ADD CONSTRAINT `SystemMessageTranslation_systemMessageId_fkey` FOREIGN KEY (`systemMessageId`) REFERENCES `SystemMessage` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserPreferences`
--
ALTER TABLE `UserPreferences`
  ADD CONSTRAINT `UserPreferences_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Wishlist`
--
ALTER TABLE `Wishlist`
  ADD CONSTRAINT `Wishlist_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `WishlistItem`
--
ALTER TABLE `WishlistItem`
  ADD CONSTRAINT `WishlistItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `WishlistItem_wishlistId_fkey` FOREIGN KEY (`wishlistId`) REFERENCES `Wishlist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `_CategoryProducts`
--
ALTER TABLE `_CategoryProducts`
  ADD CONSTRAINT `_CategoryProducts_A_fkey` FOREIGN KEY (`A`) REFERENCES `Category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `_CategoryProducts_B_fkey` FOREIGN KEY (`B`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
