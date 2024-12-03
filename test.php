<?php
try {
$dsn = "mysql:host=db;dbname=drupal6";
$conn = new PDO($dsn, "drupal", "drupal_password");
echo "Database connection successful! \n";
} catch(PDOException $e) {
echo "Connection failed: " . $e->getMessage();
}