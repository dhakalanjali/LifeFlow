-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS lifeflow_db;
USE lifeflow_db;

-- Table for Donation Camps (Angel's Task)
CREATE TABLE IF NOT EXISTS donation_camp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    camp_date DATE NOT NULL,
    organizer VARCHAR(255) NOT NULL
);

-- Table for Donation Records (Angel's Task)
CREATE TABLE IF NOT EXISTS donation_record (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    camp_id INT,
    blood_group VARCHAR(10) NOT NULL,
    quantity INT NOT NULL, -- Quantity in ml
    donation_date DATE NOT NULL,
    FOREIGN KEY (camp_id) REFERENCES donation_camp(id) ON DELETE SET NULL
);

-- Insert some dummy data for testing manageCamps.jsp
INSERT INTO donation_camp (name, location, camp_date, organizer) VALUES
('City Hospital Drive', 'Central Park Plaza', '2024-05-15', 'Red Cross Society'),
('University Blood Camp', 'Main Campus Gym', '2024-06-02', 'Student Union');

-- Insert some dummy data for Donation Records
INSERT INTO donation_record (donor_id, camp_id, blood_group, quantity, donation_date) VALUES
(1, 1, 'A+', 450, '2024-05-15'),
(2, 1, 'O-', 450, '2024-05-15'),
(3, 2, 'B+', 450, '2024-06-02');
