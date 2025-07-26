-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 26, 2025 at 11:58 AM
-- Server version: 10.6.22-MariaDB-0ubuntu0.22.04.1
-- PHP Version: 8.1.2-1ubuntu2.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `FILE SYSTEM`
--

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `upload_time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`id`, `filename`, `owner`, `path`, `upload_time`) VALUES
(34, 'test2.txt.enc', 'harry1234', 'uploads/test2.txt.enc', '2025-07-16 09:30:08'),
(37, 'test3.txt.enc', 'gareth47', 'uploads/test3.txt.enc', '2025-07-16 11:17:27'),
(38, 'RedCross.txt.enc', 'nadia23', 'uploads/RedCross.txt.enc', '2025-07-16 18:56:35'),
(39, 'test2.txt.enc', 'nadia23', 'uploads/test2.txt.enc', '2025-07-16 19:17:01'),
(40, 'test3.txt.enc', 'nadia23', 'uploads/test3.txt.enc', '2025-07-16 19:17:10'),
(41, 'test3.txt.enc', 'james19', 'uploads/test3.txt.enc', '2025-07-16 19:17:33'),
(42, 'home.jpeg.enc', 'james19', 'uploads/home.jpeg.enc', '2025-07-16 19:17:42'),
(44, 'RedCross.txt.enc', 'freda43', 'uploads/RedCross.txt.enc', '2025-07-16 19:29:29'),
(45, 'home.jpeg.enc', 'mary77', 'uploads/home.jpeg.enc', '2025-07-17 15:20:24');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `action` enum('upload','download','delete',' attempted access') NOT NULL,
  `username` varchar(255) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('success','failed','permission_denied') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `filename`, `action`, `username`, `ip_address`, `timestamp`, `status`) VALUES
(24, 'test3.txt.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 00:13:34', 'success'),
(25, 'test3.txt', 'download', 'elizabeth', '127.0.0.1', '2025-07-16 00:13:39', 'success'),
(26, 'test3.txt.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 00:13:45', 'success'),
(27, 'test2.txt.enc', 'upload', 'freda43', '127.0.0.1', '2025-07-16 00:28:30', 'success'),
(28, 'test2.txt', 'download', 'freda43', '127.0.0.1', '2025-07-16 00:28:34', 'success'),
(29, 'test3.txt.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 00:30:16', 'success'),
(30, 'test3.txt', 'download', 'elizabeth', '127.0.0.1', '2025-07-16 00:30:20', 'success'),
(31, 'test3.txt.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 00:30:26', 'success'),
(32, 'test3.txt.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 00:43:06', 'success'),
(33, 'test3.txt', 'download', 'elizabeth', '127.0.0.1', '2025-07-16 00:43:11', 'success'),
(34, 'test3.txt.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 00:43:16', 'success'),
(35, 'test3.txt.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 00:43:27', 'success'),
(36, 'test1.txt.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 01:00:00', 'success'),
(37, 'test1.txt', 'download', 'elizabeth', '127.0.0.1', '2025-07-16 01:00:06', 'success'),
(38, 'test3.txt.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 01:02:21', 'success'),
(39, 'test3.txt.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 01:12:06', 'success'),
(40, 'test3.txt', 'download', 'james19', '127.0.0.1', '2025-07-16 01:12:10', 'success'),
(41, 'test3.txt', 'download', 'james19', '127.0.0.1', '2025-07-16 01:14:47', 'success'),
(42, 'test2.txt.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 01:59:33', 'success'),
(43, 'test3.txt', 'download', 'james19', '127.0.0.1', '2025-07-16 01:59:39', 'success'),
(44, 'test1.txt.enc', 'download', 'james19', '127.0.0.1', '2025-07-16 03:37:22', 'permission_denied'),
(45, 'test2.txt.enc', 'delete', 'james19', '127.0.0.1', '2025-07-16 03:37:50', 'success'),
(46, 'test3.txt.enc', 'delete', 'james19', '127.0.0.1', '2025-07-16 03:52:40', 'success'),
(47, 'test2.txt.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 03:53:04', 'success'),
(48, 'test2.txt.enc', 'delete', 'james19', '127.0.0.1', '2025-07-16 03:53:08', 'success'),
(49, 'test2.txt.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 03:54:24', 'success'),
(50, 'test2.txt.enc', 'delete', 'james19', '127.0.0.1', '2025-07-16 03:54:28', 'success'),
(51, 'test3.txt.enc', 'upload', 'harry1234', '127.0.0.1', '2025-07-16 09:06:57', 'success'),
(52, 'test1.txt.enc', 'download', 'harry1234', '127.0.0.1', '2025-07-16 09:09:14', 'permission_denied'),
(53, 'test3.txt.enc', 'delete', 'harry1234', '127.0.0.1', '2025-07-16 09:13:16', 'success'),
(54, 'test2.txt.enc', 'upload', 'harry1234', '127.0.0.1', '2025-07-16 09:30:08', 'success'),
(55, 'test2.txt.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 09:41:55', 'success'),
(56, 'test1.txt.enc', 'delete', 'harry1234', '127.0.0.1', '2025-07-16 09:46:06', 'permission_denied'),
(57, 'test1.txt.enc', 'delete', 'harry1234', '127.0.0.1', '2025-07-16 09:48:34', 'permission_denied'),
(58, 'home.jpeg.enc', 'upload', 'elizabeth', '127.0.0.1', '2025-07-16 09:58:50', 'success'),
(59, 'home.jpeg', 'download', 'elizabeth', '127.0.0.1', '2025-07-16 09:59:50', 'success'),
(60, 'home.jpeg.enc', 'delete', 'elizabeth', '127.0.0.1', '2025-07-16 09:59:55', 'success'),
(61, 'RedCross.txt.enc', 'upload', 'gareth47', '127.0.0.1', '2025-07-16 11:14:38', 'success'),
(62, 'RedCross.txt', 'download', 'gareth47', '127.0.0.1', '2025-07-16 11:14:58', 'success'),
(63, 'RedCross.txt.enc', 'delete', 'gareth47', '127.0.0.1', '2025-07-16 11:15:18', 'success'),
(64, 'test3.txt.enc', 'upload', 'gareth47', '127.0.0.1', '2025-07-16 11:17:27', 'success'),
(65, 'test1.txt.enc', 'download', 'gareth47', '127.0.0.1', '2025-07-16 11:17:44', 'permission_denied'),
(66, 'test2.txt.enc', 'delete', 'penelope556', '127.0.0.1', '2025-07-16 18:52:44', 'success'),
(67, 'RedCross.txt.enc', 'upload', 'nadia23', '127.0.0.1', '2025-07-16 18:56:35', 'success'),
(68, 'test2.txt.enc', 'upload', 'nadia23', '127.0.0.1', '2025-07-16 19:17:01', 'success'),
(69, 'test3.txt.enc', 'upload', 'nadia23', '127.0.0.1', '2025-07-16 19:17:10', 'success'),
(70, 'test3.txt.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 19:17:33', 'success'),
(71, 'home.jpeg.enc', 'upload', 'james19', '127.0.0.1', '2025-07-16 19:17:42', 'success'),
(72, 'test2.txt.enc', 'upload', 'freda43', '127.0.0.1', '2025-07-16 19:18:58', 'success'),
(73, 'RedCross.txt', 'download', 'freda43', '127.0.0.1', '2025-07-16 19:23:15', 'permission_denied'),
(74, 'test1.txt.enc', 'delete', 'harry1234', '127.0.0.1', '2025-07-16 19:26:50', 'permission_denied'),
(75, 'RedCross.txt.enc', 'upload', 'freda43', '127.0.0.1', '2025-07-16 19:29:29', 'success'),
(76, 'test2.txt.enc', 'delete', 'freda43', '127.0.0.1', '2025-07-16 19:29:33', 'success'),
(77, 'RedCross.txt', 'download', 'freda43', '127.0.0.1', '2025-07-16 19:29:35', 'success'),
(78, 'home.jpeg.enc', 'upload', 'mary77', '127.0.0.1', '2025-07-17 15:20:24', 'success'),
(79, 'home.jpeg', 'download', 'mary77', '127.0.0.1', '2025-07-17 15:29:11', 'success');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `passhash` varchar(255) NOT NULL COMMENT 'hashed ',
  `email` varchar(120) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `failed_attempts` int(11) NOT NULL DEFAULT 0,
  `last_failed` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `passhash`, `email`, `created_at`, `failed_attempts`, `last_failed`) VALUES
(4, 'mary', 'scrypt:32768:8:1$gMiVApOhgPfY50tZ$31dfed5a77c27b05038ffdba597993114c70a73054fec5fde9137d11ebdfe8bce589b95cb49af82e126a49a6324cc6e1ff86b4c6f42b9e383709e4ff2612eab0', 'mary@gmail.com', '2025-07-05 15:23:55', 0, NULL),
(5, 'elizabeth', 'scrypt:32768:8:1$uFM9DFTRWmpxHkxk$f3cb1915e3d6ff34a410c72bed5c46fa11df8c74019ab2778d21621f563e2cd9b43910bde8a59a51b6b0bda3aad696cfbde184c36be04eca22e7111a4be1a5eb', 'elizabeth@yahoo.com', '2025-07-08 13:49:35', 0, NULL),
(9, 'stacy', 'scrypt:32768:8:1$Tir1ZsMcVCTAvMbr$bcb2cbd0ce2ba2dee0d2700301bfc77766aeb597fc2cac53962827605e050087a9a61904a5d8bce012f4a2c56eeac3e29ab686b3afb52ce8f4e59ac707b911ad', 'stacy19@gmail.com', '2025-07-08 18:05:11', 0, NULL),
(10, 'tinamay36', 'scrypt:32768:8:1$2MZwaxib91cGJiwI$7d56b8c4e2bf6ee291011e28d87cd10c0f59bc794044a37c9964168a28ff71540e66799a69059d67b5641ee4a50f5140462abab9d9473c72be2cf29fcb42ebdc', 'tinamay@gmail.com', '2025-07-09 15:57:15', 0, NULL),
(11, 'freda43', 'scrypt:32768:8:1$Qz3x5hKZ07MFFnmu$fe6490d81c1be26b9c4a0ce9b64325753f8b6c934a128aa78f5012db61db8e3243581017359355c468ca5144262151dc5d771510a47c80f9fbac5a8b76e85473', 'freda@gmail.com', '2025-07-09 16:07:29', 0, NULL),
(12, 'blessed87wey', 'scrypt:32768:8:1$tqLBuZ184lJrv1q1$d3bf1c0e6e1dd4bf0a0bbca2297a5764469150e21161859cf6ef8afeeb5caefbab235d4cae9d45991c27a094ef03df2b63e7427fdd27e35ca2c9d667056919d5', 'blessedwey@gmail.com', '2025-07-13 00:20:12', 0, NULL),
(13, 'penelope556', 'scrypt:32768:8:1$MOly9Ky74nq2N1o6$16144a7277141910be77cb8f5dbafb990c11cf8ed5e5d540c06c5edb7cce58b379806d5204a1f6a2b3e18de670d708d2373797b52ca32ad55dd932d0b94b0776', 'penelope@gmail.com', '2025-07-15 20:07:40', 0, NULL),
(14, 'james19', 'scrypt:32768:8:1$pkfLDNdOYy8BwoAV$6f574652dd8b0a8b6ece702cfe3b4f059a20a54adc1c763c5476484db5f4b47bb23d7c77a1948053786fa68bcfcf6f3dbcb552187e2cb0625128b5e17cbc242c', 'james@gmail.com', '2025-07-16 01:11:48', 0, NULL),
(15, 'harry1234', 'scrypt:32768:8:1$akUJuBwvTbgX7U6J$610ac29f77dbbe41e5d212d422352adde9812b9c59f135c9df1d96b16f5f35af891a3011ab3977df6832883e069636406911f11ab3ad04086eadc98fcc19d93d', 'harrytrey@gmail.com', '2025-07-16 09:06:14', 0, NULL),
(16, 'gareth47', 'scrypt:32768:8:1$sykU3NbBeXJ5cBOm$63e5b4802c181688ba003833890f6a8b942c3c1ec4f398d62726d35e4fe1b300a3e9f3d21fa1cc314e387c04c5ba40366b66d0a26dd0544aa995b5e2126d195d', 'gareth@gmail.com', '2025-07-16 11:13:57', 0, NULL),
(17, 'nadia23', 'scrypt:32768:8:1$ffX8ztKwAd4EJDRN$af339c4a762188af107586d66a65509d1ab5a6c2c017758430ce9edf0cd747205b749d80c3c5bfb65a50ec38cf07eec288ec442e14bc172ac1e7e6770d29100c', 'nadia@gmail.com', '2025-07-16 18:53:57', 0, NULL),
(19, 'mary77', 'scrypt:32768:8:1$ltrX2ABXzo0HTM1D$48a5be0e3c625eb5f838f9e271a5f30c6029fffdd17a988b7e22ae170c6a52489a1205cb2f03d6d5ecf270a0fad93cb70d79ca5deb713ecd4410767bac4815ef', 'marymay@gmail.com', '2025-07-17 15:19:43', 0, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
