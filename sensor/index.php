<?php

$DATABASE_USERNAME = 'root';
$DATABASE_PASSWORD = 'pass123';
$DATABASE_HOST = 'localhost';
$DATABASE_NAME = 'water-monitoring-system-db';
$DATABASE_CHARSET = 'utf8';

if(isset($_POST['temperature'])){
    $temperature = $_POST['temperature'];
    //connect to mysql database
    $con = mysqli_connect($DATABASE_HOST, $DATABASE_USERNAME, $DATABASE_PASSWORD, $DATABASE_NAME);
    // Check connection
    if (mysqli_connect_errno()){
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        die();
    }
    try {
        $result = mysqli_query($con,"INSERT INTO `sensordata` (`sensorvalue`, `sensorid`) VALUES ('".$temperature."', '1')");
    } catch (Exception $e) {
        mysqli_close($con);
        echo 'Caught exception: ',  $e->getMessage(), "\n";
        die();
    }
    mysqli_close($con);
}

?>