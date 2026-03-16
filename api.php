<?php
header('Content-Type: application/json');
require 'config.php';

// Get the request method and path
$method = $_SERVER['REQUEST_METHOD'];
$path = $_GET['path'] ?? '';

// Parse URL
$segments = explode('/', trim($path, '/'));

if ($segments[0] === 'enrollments') {
    if ($method === 'GET') {
        // List all enrollments (admin)
        listEnrollments($pdo);
    } elseif ($method === 'POST' && $segments[1] === 'me') {
        // Student self-enroll
        selfEnroll($pdo);
    } elseif ($method === 'POST') {
        // Admin create enrollment
        createEnrollment($pdo);
    }
} elseif ($segments[0] === 'students' && isset($segments[1]) && $segments[2] === 'courses') {
    getStudentCourses($pdo, $segments[1]);
} elseif ($segments[0] === 'courses' && isset($segments[1]) && $segments[2] === 'students') {
    getCourseStudents($pdo, $segments[1]);
} else {
    http_response_code(404);
    echo json_encode(['error' => 'Endpoint not found']);
}
