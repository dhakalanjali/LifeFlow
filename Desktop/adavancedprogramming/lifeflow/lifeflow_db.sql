-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 12, 2026 at 11:31 AM
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
(1, 'A+', 29, '2026-05-06 15:18:12'),
(2, 'A-', 10, '2026-05-04 01:09:03'),
(3, 'B+', 30, '2026-05-04 01:09:03'),
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
(7, 'ani', 'urlabari', '2026-05-14', 'anjiii', NULL, 100, 'upcoming', '2026-05-12 03:32:54'),
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
(18, 'itahri', 'damak', '2026-05-22', 'nepal', NULL, 100, 'upcoming', '2026-05-12 07:51:39');

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
(24, 'Bikash Shrestha', 'bikash@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9801234567', 'A+', 'user', 'approved', '2026-05-12 07:04:57', '1995-06-15', 'Male', 'Kathmandu, Nepal'),
(25, 'Sunita Tamang', 'sunita@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9812345670', 'B+', 'user', 'approved', '2026-05-12 07:04:57', '1997-03-22', 'Female', 'Pokhara, Nepal'),
(26, 'Rajesh Gurung', 'rajesh@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9823456701', 'O+', 'user', 'approved', '2026-05-12 07:04:57', '1993-11-08', 'Male', 'Lalitpur, Nepal'),
(27, 'Anita Karki', 'anita@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9834567012', 'AB+', 'user', 'approved', '2026-05-12 07:04:57', '1999-07-14', 'Female', 'Bhaktapur, Nepal'),
(28, 'Dipesh Adhikari', 'dipesh@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9845670123', 'B-', 'user', 'approved', '2026-05-12 07:04:57', '1996-02-28', 'Male', 'Chitwan, Nepal'),
(29, 'Priya Bhandari', 'priya@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9856701234', 'A-', 'user', 'pending', '2026-05-12 07:04:57', '2000-09-05', 'Female', 'Biratnagar, Nepal'),
(30, 'Suresh Thapa', 'suresh@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9867012345', 'O-', 'user', 'approved', '2026-05-12 07:04:57', '1994-12-19', 'Male', 'Butwal, Nepal'),
(31, 'Manisha Rai', 'manisha@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9878123456', 'AB-', 'user', 'approved', '2026-05-12 07:04:57', '1998-04-30', 'Female', 'Dharan, Nepal'),
(32, 'Nabin Limbu', 'nabin@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9889234567', 'A+', 'user', 'approved', '2026-05-12 07:04:57', '2001-08-11', 'Male', 'Hetauda, Nepal'),
(33, 'Kabita Magar', 'kabita@gmail.com', '482c811da5d5b4bc6d497ffa98491e38', '9890345678', 'B+', 'user', 'pending', '2026-05-12 07:04:57', '2002-01-25', 'Female', 'Janakpur, Nepal');

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `blood_stock`
--
ALTER TABLE `blood_stock`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `donation_camps`
--
ALTER TABLE `donation_camps`
  MODIFY `camp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `donation_records`
--
ALTER TABLE `donation_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `donor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
