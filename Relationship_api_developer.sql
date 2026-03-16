CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    program VARCHAR(100) NOT NULL,
    year_level INT NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',

    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

INSERT INTO students (student_number, first_name, last_name, program, year_level)
VALUES
('2023-001','Juan','Dela Cruz','BSCS',2),
('2023-002','Maria','Santos','BSIT',1),
('2023-003','Pedro','Reyes','BSCS',3);

INSERT INTO courses (course_code, course_name, credits, capacity)
VALUES
('CS101','Programming 1',3,40),
('CS202','Data Structures',3,40),
('CS303','Database Systems',3,35);

INSERT INTO enrollments (student_id, course_id, semester, academic_year, status)
VALUES
(1,1,'1st_semester','2025-2026','enrolled'),
(1,2,'1st_semester','2025-2026','enrolled'),
(2,1,'1st_semester','2025-2026','pending'),
(3,3,'2nd_semester','2025-2026','enrolled');

-- Admin Enrollment CRUD
INSERT INTO enrollments
(student_id, course_id, semester, academic_year, status)
VALUES
(2,2,'1st_semester','2025-2026','enrolled');

-- Update enrollment
UPDATE enrollments
SET status = 'completed'
WHERE id = 1;

-- Delete enrollment
DELETE FROM enrollments
WHERE id = 4;


--Self Enrollment API
INSERT INTO enrollments
(student_id, course_id, semester, academic_year, status)
VALUES
(3,1,'1st_semester','2025-2026','pending');


