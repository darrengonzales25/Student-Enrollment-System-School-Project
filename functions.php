<?php
function listEnrollments($pdo) {
    $stmt = $pdo->query('SELECT * FROM enrollments');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function createEnrollment($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    $sql = "INSERT INTO enrollments (student_id, course_id, academic_year, semester, status) 
            VALUES (:student_id, :course_id, :academic_year, :semester, :status)";
    $stmt = $pdo->prepare($sql);
    try {
        $stmt->execute([
            ':student_id' => $data['student_id'],
            ':course_id' => $data['course_id'],
            ':academic_year' => $data['academic_year'],
            ':semester' => $data['semester'],
            ':status' => $data['status'] ?? 'pending'
        ]);
        echo json_encode(['success' => true]);
    } catch (PDOException $e) {
        http_response_code(400);
        echo json_encode(['error' => $e->getMessage()]);
    }
}

function selfEnroll($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    $student_id = $data['student_id']; 
    createEnrollment($pdo); // reuse function
}

function getStudentCourses($pdo, $student_id) {
    $stmt = $pdo->prepare('
        SELECT c.* 
        FROM courses c
        JOIN enrollments e ON c.id = e.course_id
        WHERE e.student_id = :student_id
    ');
    $stmt->execute([':student_id' => $student_id]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function getCourseStudents($pdo, $course_id) {
    $stmt = $pdo->prepare('
        SELECT s.* 
        FROM students s
        JOIN enrollments e ON s.id = e.student_id
        WHERE e.course_id = :course_id
    ');
    $stmt->execute([':course_id' => $course_id]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}
?>