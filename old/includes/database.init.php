<?php

$DATABASE_USERNAME = 'root';
$DATABASE_PASSWORD = 'pass123';
$DATABASE_HOST = 'localhost';
$DATABASE_NAME = 'water-monitoring-system-db';
$DATABASE_CHARSET = 'utf8';

$con = mysqli_connect($DATABASE_HOST, $DATABASE_USERNAME, $DATABASE_PASSWORD, $DATABASE_NAME);
if (mysqli_connect_errno()){
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    die();
}

?>
