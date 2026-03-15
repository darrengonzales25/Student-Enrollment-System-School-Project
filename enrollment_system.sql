-- 1. Create the Database

CREATE DATABASE enrollment_system;

-- 2. Create Custom ENUM Types
-- These lock down specific fields to only accept these exact values.
CREATE TYPE user_role_enum AS ENUM ('student', 'registrar');
CREATE TYPE semester_enum AS ENUM ('1st_semester', '2nd_semester');
CREATE TYPE enrollment_status_enum AS ENUM ('pending', 'enrolled', 'dropped', 'completed');

-- 3. Create 'users' Table (Authentication & Roles)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role user_role_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create 'students' Table (Profile Data)
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    program VARCHAR(100) NOT NULL,
    year_level INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 5. Create 'courses' Table (Academic Catalog)
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL,
    capacity INT NOT NULL
);

-- 6. Create 'enrollments' Table (Many-to-Many Pivot)
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_year VARCHAR(9) NOT NULL, -- Format: YYYY-YYYY
    semester semester_enum NOT NULL,
    status enrollment_status_enum DEFAULT 'pending',
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    -- Prevent a student from enrolling in the exact same course twice in the same semester
    UNIQUE (student_id, course_id, academic_year, semester)
);