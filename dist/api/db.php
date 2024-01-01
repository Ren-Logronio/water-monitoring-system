<?php

## to be modified
$user = 'root'; # enter the username of mariadb
$password = 'pass12345'; # enter the password of mariadb
$host = 'localhost:3306'; # enter the host of mariadb

## DO NOT MODIFY
$dsn = "mysql:host=" . $host . ";dbname=water-monitoring-system-db;charset=utf8mb4";

$options = [
  PDO::ATTR_EMULATE_PREPARES   => false, // Disable emulation mode for "real" prepared statements
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Disable errors in the form of exceptions
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, // Make the default fetch be an associative array
];

try {
    $pdo = new PDO($dsn, $user, $password, $options);
} 
catch (Exception $e) {
    error_log($e->getMessage());
    exit('Something bad happened'); 
}

/*

# SELECT

// PHP class 
class Contact {
      public $id;
      public $name;
      public $age;
      public $email;
}

// Fetch contacts (in descending order)
$contacts = $pdo->query( "SELECT * FROM contacts ORDER BY id DESC")->fetchAll(PDO::FETCH_CLASS, 'Contact');

# INSERT 

$stmt = $pdo->prepare("INSERT INTO contacts (name,age,email) VALUES(?, ?, ?)");
$stmt->execute([$name, $age, $email]);

# UPDATE

$stmt = $pdo->prepare("UPDATE contacts SET name = ?, age = ?, email = ? WHERE id = ?");
$stmt->execute([$name, $age, $email, $id]);

# DELETE 

$stmt = $pdo->prepare("DELETE FROM contacts WHERE id = ?");
$stmt->execute([$id]);


*/





?>
