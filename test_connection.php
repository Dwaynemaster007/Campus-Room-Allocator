<?php
// Setup script: command line only, so nobody can run it from a browser.
// Usage: php test_connection.php
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit('Forbidden');
}
require_once 'config/database.php';

echo "<h2>Database Connection Test</h2>";

if (testConnection()) {
    echo "<p style='color: green;'>✅ Database connected successfully!</p>";
    
    // Test: Count users
    $sql = "SELECT COUNT(*) as total FROM users";
    $result = fetchOne($sql);
    echo "<p>Total users in database: <strong>" . $result['total'] . "</strong></p>";
    
    // Test: List room types
    $sql = "SELECT * FROM room_types";
    $roomTypes = fetchAll($sql);
    echo "<h3>Room Types:</h3><ul>";
    foreach ($roomTypes as $type) {
        echo "<li>{$type['type_name']} - Capacity: {$type['capacity']}</li>";
    }
    echo "</ul>";
    
    echo "<p style='color: green;'>✅ Database is working perfectly!</p>";
} else {
    echo "<p style='color: red;'>❌ Database connection failed!</p>";
}
?>
