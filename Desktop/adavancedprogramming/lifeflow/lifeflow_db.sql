-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 20, 2026 at 09:25 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lifeflow_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `blood_requests`
--

CREATE TABLE `blood_requests` (
  `request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `patient_name` varchar(100) DEFAULT NULL,
  `hospital_name` varchar(150) DEFAULT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `urgency_level` varchar(20) DEFAULT NULL,
  `additional_notes` text DEFAULT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_requests`
--

INSERT INTO `blood_requests` (`request_id`, `user_id`, `patient_name`, `hospital_name`, `contact_number`, `urgency_level`, `additional_notes`, `blood_type`, `status`, `request_date`) VALUES
(8, 13, 'harry', 'aranaiko', '9800987788', 'Critical', 'we need urgent', 'A-', 'approved', '2026-05-15 01:46:34'),
(9, 13, 'Ram bahadur', 'Teaching Hospital Kathmandu', '9800000002', 'Urgent', 'Needed urgently for surgery', 'B+', 'pending', '2026-05-17 17:03:39'),
(10, 13, 'panas', 'nepalirika', '9822334455', 'Urgent', 'really needed', 'B+', 'pending', '2026-05-19 15:33:53');

-- --------------------------------------------------------

--
-- Table structure for table `blood_stock`
--

CREATE TABLE `blood_stock` (
  `stock_id` int(11) NOT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `units_available` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_stock`
--

INSERT INTO `blood_stock` (`stock_id`, `blood_type`, `units_available`, `last_updated`) VALUES
(1, 'A+', 30, '2026-05-18 16:47:33'),
(2, 'A-', 10, '2026-05-04 01:09:03'),
(3, 'B+', 50, '2026-05-17 16:44:41'),
(4, 'B-', 13, '2026-05-06 15:17:14'),
(5, 'AB+', 15, '2026-05-04 01:09:03'),
(6, 'AB-', 14, '2026-05-06 15:17:24'),
(7, 'O+', 27, '2026-05-06 15:18:23'),
(8, 'O-', 0, '2026-05-11 13:54:32');

-- --------------------------------------------------------

--
-- Table structure for table `donation_camps`
--

CREATE TABLE `donation_camps` (
  `camp_id` int(11) NOT NULL,
  `camp_name` varchar(150) NOT NULL,
  `location` varchar(255) NOT NULL,
  `camp_date` date NOT NULL,
  `organizer` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `max_capacity` int(11) DEFAULT 100,
  `status` enum('upcoming','ongoing','completed') DEFAULT 'upcoming',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donation_camps`
--

INSERT INTO `donation_camps` (`camp_id`, `camp_name`, `location`, `camp_date`, `organizer`, `description`, `max_capacity`, `status`, `created_at`) VALUES
(1, 'Kathmandu Blood Drive', 'Kathmandu, Nepal', '2026-05-10', 'Red Cross Nepal', 'Annual blood donation camp', 100, 'upcoming', '2026-05-02 11:42:51'),
(2, 'Pokhara Donation Camp', 'Pokhara, Nepal', '2026-05-15', 'LifeFlow Team', 'Community blood drive', 50, 'upcoming', '2026-05-02 11:42:51'),
(3, 'Chitwan Blood Drive', 'Chitwan, Nepal', '2026-05-20', 'City Hospital', 'Emergency blood collection', 75, 'upcoming', '2026-05-02 11:42:51'),
(4, 'Kathmandu Blood Drive', 'Kathmandu, Nepal', '2026-05-10', 'Red Cross Nepal', 'Annual blood donation camp', 100, 'upcoming', '2026-05-02 11:44:53'),
(5, 'Pokhara Donation Camp', 'Pokhara, Nepal', '2026-05-15', 'LifeFlow Team', 'Community blood drive', 50, 'upcoming', '2026-05-02 11:44:53'),
(6, 'Chitwan Blood Drive', 'Chitwan, Nepal', '2026-05-20', 'City Hospital', 'Emergency blood collection', 75, 'upcoming', '2026-05-02 11:44:53'),
(8, 'Biratnagar Blood Drive', 'Biratnagar, Nepal', '2026-06-05', 'Koshi Hospital', 'Emergency blood collection drive', 80, 'upcoming', '2026-05-12 07:50:08'),
(9, 'Dharan Donation Camp', 'Dharan, Nepal', '2026-06-10', 'B.P. Koirala Institute', 'Annual blood donation camp', 120, 'upcoming', '2026-05-12 07:50:08'),
(10, 'Butwal Blood Camp', 'Butwal, Nepal', '2026-06-15', 'Lumbini Medical College', 'Community blood drive', 60, 'upcoming', '2026-05-12 07:50:08'),
(11, 'Janakpur Donation Drive', 'Janakpur, Nepal', '2026-06-20', 'Janakpur Hospital', 'Regional blood donation event', 90, 'upcoming', '2026-05-12 07:50:08'),
(12, 'Hetauda Blood Camp', 'Hetauda, Nepal', '2026-06-25', 'Narayani Hospital', 'Emergency blood collection', 70, 'upcoming', '2026-05-12 07:50:08'),
(13, 'Nepalgunj Blood Drive', 'Nepalgunj, Nepal', '2026-07-01', 'Bheri Hospital', 'Annual blood donation camp', 100, 'upcoming', '2026-05-12 07:50:08'),
(14, 'Birgunj Donation Camp', 'Birgunj, Nepal', '2026-07-05', 'Narayani Sub-Regional Hospital', 'Community blood drive', 85, 'upcoming', '2026-05-12 07:50:08'),
(15, 'Damak Blood Drive', 'Damak, Nepal', '2026-07-10', 'Red Cross Jhapa', 'Blood donation for local community', 50, 'upcoming', '2026-05-12 07:50:08'),
(16, 'Itahari Donation Camp', 'Itahari, Nepal', '2026-07-15', 'Sunsari Health Foundation', 'Emergency blood collection', 65, 'upcoming', '2026-05-12 07:50:08'),
(17, 'Bharatpur Blood Camp', 'Bharatpur, Nepal', '2026-07-20', 'Chitwan Medical College', 'Annual blood donation camp', 110, 'upcoming', '2026-05-12 07:50:08'),
(18, 'itahri', 'damak', '2026-05-22', 'nepal', NULL, 100, 'upcoming', '2026-05-12 07:51:39'),
(20, 'ani', 'urlabari', '2026-05-20', 'anjiii', NULL, 100, 'upcoming', '2026-05-18 16:16:09'),
(21, 'crimson hope camp', 'baneshwor, kathmandu', '2026-05-20', 'LifeFlow team ', NULL, 100, 'upcoming', '2026-05-18 16:22:40'),
(22, 'ani', 'urlabari', '2026-05-21', 'LifeFlow team ', NULL, 100, 'upcoming', '2026-05-19 20:36:39');

-- --------------------------------------------------------

--
-- Table structure for table `donation_records`
--

CREATE TABLE `donation_records` (
  `record_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `camp_id` int(11) DEFAULT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `units_donated` int(11) DEFAULT 1,
  `donation_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donation_records`
--

INSERT INTO `donation_records` (`record_id`, `user_id`, `camp_id`, `blood_type`, `units_donated`, `donation_date`) VALUES
(8, 13, 21, 'A+', 1, '2026-05-18');

-- --------------------------------------------------------

--
-- Table structure for table `donors`
--

CREATE TABLE `donors` (
  `donor_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_donation_date` date DEFAULT NULL,
  `is_eligible` enum('yes','no') DEFAULT 'yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donors`
--

INSERT INTO `donors` (`donor_id`, `user_id`, `last_donation_date`, `is_eligible`) VALUES
(6, 13, '2026-05-18', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `is_approved` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `password`, `phone`, `blood_type`, `role`, `is_approved`, `created_at`, `date_of_birth`, `gender`, `address`) VALUES
(12, 'Admin', 'admin@lifeflow.com', '$2a$12$IUA5SA1cx1qgvq3yB4g15uJ6v43dZAUNh6Y/o0Ng7vRFqDr2PTbzy', '9800980000', 'A-', 'admin', 'approved', '2026-05-12 06:27:44', '1990-03-29', 'Female', 'urlabari'),
(13, 'anjali dhakal', 'dhakalanjali123@gmail.com', '$2a$12$Qwx2mkj6iyh5jo.aLyyc3.4SVOquYz6wplAO7VI0B6EE4S.s7WGgW', '9800980123', 'A+', 'user', 'approved', '2026-05-12 06:36:47', '1999-03-22', 'Other', 'damak'),
(34, 'Ram Sharma', 'ram.sharma@gmail.com', '$2a$12$examplehashedpassword1xxxxxxxxxxxxxxxxxxxxxx', '9801234567', 'A+', 'user', 'approved', '2026-05-15 06:51:52', '1995-06-15', NULL, NULL),
(35, 'Sita Thapa', 'sita.thapa@gmail.com', '$2a$12$examplehashedpassword2xxxxxxxxxxxxxxxxxxxxxx', '9812345678', 'B+', 'user', 'pending', '2026-05-15 06:51:52', '1998-03-22', NULL, NULL),
(36, 'Bikash Rai', 'bikash.rai@gmail.com', '$2a$12$examplehashedpassword3xxxxxxxxxxxxxxxxxxxxxx', '9823456789', 'O+', 'user', 'approved', '2026-05-15 06:51:52', '1993-11-10', NULL, NULL),
(37, 'Priya Gurung', 'priya.gurung@gmail.com', '$2a$12$examplehashedpassword4xxxxxxxxxxxxxxxxxxxxxx', '9834567890', 'AB+', 'user', 'approved', '2026-05-15 06:51:52', '2000-07-04', NULL, NULL),
(38, 'Sunil Karki', 'sunil.karki@gmail.com', '$2a$12$examplehashedpassword5xxxxxxxxxxxxxxxxxxxxxx', '9845678901', 'B-', 'user', 'approved', '2026-05-15 06:51:52', '1990-01-18', NULL, NULL),
(39, 'Anita Shrestha', 'anita.shrestha@gmail.com', '$2a$12$examplehashedpassword6xxxxxxxxxxxxxxxxxxxxxx', '9856789012', 'O-', 'user', 'approved', '2026-05-15 06:51:52', '1997-09-30', NULL, NULL),
(40, 'Deepak Limbu', 'deepak.limbu@gmail.com', '$2a$12$examplehashedpassword7xxxxxxxxxxxxxxxxxxxxxx', '9867890123', 'A-', 'user', 'rejected', '2026-05-15 06:51:52', '1992-05-25', NULL, NULL),
(41, 'Kabita Tamang', 'kabita.tamang@gmail.com', '$2a$12$examplehashedpassword8xxxxxxxxxxxxxxxxxxxxxx', '9878901234', 'AB-', 'user', 'approved', '2026-05-15 06:51:52', '1996-12-08', NULL, NULL),
(42, 'Angely dhakal', 'dhakalangely@gmail.com', '$2a$12$7Ym8e1yhm28LQRgfvM6gdeEWK..gxs4XXoqKL0klP6l2PTrsrmMDm', '9877889900', 'O-', 'user', 'approved', '2026-05-17 15:51:03', '2002-02-08', 'Female', 'damak-7');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `camp_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`wishlist_id`, `user_id`, `camp_id`) VALUES
(5, 13, 1),
(3, 13, 2),
(4, 13, 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_blood_requests_status` (`status`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `blood_stock`
--
ALTER TABLE `blood_stock`
  ADD PRIMARY KEY (`stock_id`),
  ADD UNIQUE KEY `blood_type` (`blood_type`);

--
-- Indexes for table `donation_camps`
--
ALTER TABLE `donation_camps`
  ADD PRIMARY KEY (`camp_id`);

--
-- Indexes for table `donation_records`
--
ALTER TABLE `donation_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `camp_id` (`camp_id`),
  ADD KEY `idx_donation_records_user` (`user_id`),
  ADD KEY `idx_donation_date` (`donation_date`);

--
-- Indexes for table `donors`
--
ALTER TABLE `donors`
  ADD PRIMARY KEY (`donor_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD UNIQUE KEY `unique_phone` (`phone`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_blood_type` (`blood_type`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_blood_type` (`blood_type`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `unique_wishlist` (`user_id`,`camp_id`),
  ADD KEY `camp_id` (`camp_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `blood_stock`
--
ALTER TABLE `blood_stock`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `donation_camps`
--
ALTER TABLE `donation_camps`
  MODIFY `camp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `donation_records`
--
ALTER TABLE `donation_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `donor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD CONSTRAINT `blood_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_records`
--
ALTER TABLE `donation_records`
  ADD CONSTRAINT `donation_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `donation_records_ibfk_2` FOREIGN KEY (`camp_id`) REFERENCES `donation_camps` (`camp_id`) ON DELETE SET NULL;

--
-- Constraints for table `donors`
--
ALTER TABLE `donors`
  ADD CONSTRAINT `donors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`camp_id`) REFERENCES `donation_camps` (`camp_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
