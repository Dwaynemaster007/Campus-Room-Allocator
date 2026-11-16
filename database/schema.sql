-- Campus Room Allocation System: core schema (MySQL / MariaDB)
-- Run this first, then add_maintenance.sql and add_notifications.sql.
--
--   mysql -u root -p -e "CREATE DATABASE campus_room_allocation CHARACTER SET utf8mb4"
--   mysql -u root -p campus_room_allocation < database/schema.sql

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(30),
    year_level TINYINT NOT NULL DEFAULT 1,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    program VARCHAR(150),
    user_role ENUM('student', 'admin') NOT NULL DEFAULT 'student',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_role (user_role),
    INDEX idx_year (year_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS room_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    capacity TINYINT NOT NULL,
    description TEXT,
    -- comma-separated year levels, matched with FIND_IN_SET (e.g. '1,2')
    recommended_year_levels VARCHAR(20) NOT NULL DEFAULT '1,2,3,4'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL,
    building VARCHAR(100) NOT NULL,
    floor TINYINT NOT NULL DEFAULT 1,
    type_id INT NOT NULL,
    capacity TINYINT NOT NULL,
    current_occupancy TINYINT NOT NULL DEFAULT 0,
    status ENUM('available', 'full', 'maintenance') NOT NULL DEFAULT 'available',
    amenities TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_room (building, room_number),
    FOREIGN KEY (type_id) REFERENCES room_types(type_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS allocation_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    preferred_building VARCHAR(100),
    preferred_floor TINYINT,
    roommate_preference VARCHAR(255),
    special_needs TEXT,
    request_status ENUM('pending', 'approved', 'rejected', 'cancelled') NOT NULL DEFAULT 'pending',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_request_status (request_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS allocations (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    allocation_date DATE NOT NULL,
    academic_year VARCHAR(20),
    semester VARCHAR(20),
    status ENUM('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled') NOT NULL DEFAULT 'pending',
    check_in_date DATE NULL,
    check_out_date DATE NULL,
    allocated_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (allocated_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_alloc_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS roommate_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    sleep_schedule VARCHAR(50),
    study_habits VARCHAR(100),
    cleanliness VARCHAR(50),
    noise_level VARCHAR(50),
    interests TEXT,
    about_me TEXT,
    looking_for TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS roommate_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'declined') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS activity_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INT,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_log_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed data ---------------------------------------------------------------

INSERT INTO room_types (type_name, capacity, description, recommended_year_levels) VALUES
    ('Common Room', 6, 'Shared six-person room, ideal for first-year students', '1,2'),
    ('Double Room', 2, 'Two-person room for continuing students', '2,3'),
    ('Single Room', 1, 'Private room for senior students', '3,4');

INSERT INTO rooms (room_number, building, floor, type_id, capacity, amenities) VALUES
    ('A101', 'Block A', 1, 1, 6, 'Wi-Fi, study desks, shared bathroom'),
    ('A102', 'Block A', 1, 1, 6, 'Wi-Fi, study desks, shared bathroom'),
    ('B201', 'Block B', 2, 2, 2, 'Wi-Fi, wardrobe, study desks'),
    ('B202', 'Block B', 2, 2, 2, 'Wi-Fi, wardrobe, study desks'),
    ('C301', 'Block C', 3, 3, 1, 'Wi-Fi, en-suite bathroom, desk');
