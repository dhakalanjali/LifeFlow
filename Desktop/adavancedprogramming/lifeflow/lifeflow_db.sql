-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 09, 2026 at 05:56 PM
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
(3, 6, NULL, NULL, NULL, NULL, NULL, 'A+', 'approved', '2026-05-04 01:09:03'),
(4, 7, NULL, NULL, NULL, NULL, NULL, 'B+', 'pending', '2026-05-04 01:09:03'),
(6, 1, 'anji', 'godawari', '9829337200', 'Normal', '', 'B+', 'pending', '2026-05-09 15:51:05'),
(7, 1, 'anji', 'godawari', '9829337200', 'Normal', '', 'B+', 'pending', '2026-05-09 15:51:10');

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
(8, 'O-', 12, '2026-05-04 01:09:03');

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
(6, 'Chitwan Blood Drive', 'Chitwan, Nepal', '2026-05-20', 'City Hospital', 'Emergency blood collection', 75, 'upcoming', '2026-05-02 11:44:53');

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
(5, 6, 1, 'B+', 1, '2026-04-10'),
(6, 7, 2, 'O-', 1, '2026-04-20');

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
(3, 6, '2025-10-15', 'yes'),
(4, 7, '2025-09-20', 'yes');

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
(1, 'Admin', 'admin@lifeflow.com', '4de93544234adffbb681ed60ffcfb941', '9800000000', 'O+', 'admin', 'approved', '2026-04-23 15:11:33', NULL, NULL, NULL),
(6, 'Ram Sharma', 'ram@gmail.com', '1b7b4c38f626766bbdcfc895e2c514f6', '9812345678', 'B+', 'user', 'approved', '2026-05-03 15:09:29', '1998-08-20', 'Male', 'Kathmandu, Nepal'),
(7, 'Sita Thapa', 'sita@gmail.com', '3be106b4d256b572a2a23b46bb245a97', '9823456789', 'O-', 'user', 'approved', '2026-05-03 15:09:29', '1999-03-10', 'Female', 'Lalitpur, Nepal'),
(8, 'Hari Poudel', 'hari@gmail.com', 'c0cd7988346f98068cf05fa94ef1e546', '9834567890', 'AB+', 'user', 'pending', '2026-05-03 15:09:29', '2001-07-25', 'Male', 'Bhaktapur, Nepal'),
(9, 'Gita Rai', 'gita@gmail.com', '854aa010e877910507c7541d0c0f54bb', '9845678901', 'A-', 'user', 'pending', '2026-05-03 15:09:29', '2000-11-30', 'Female', 'Chitwan, Nepal'),
(10, 'Angely dhakal', 'dhakalanjali123@gmail.com', 'e20f517179e9cd52ae29dae43c121b95', '9829337179', 'AB-', 'user', 'approved', '2026-05-04 02:43:38', '2008-09-04', 'Male', 'hi');

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
  MODIFY `camp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
