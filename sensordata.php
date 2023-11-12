<?php

$DATABASE_USERNAME = 'root';
$DATABASE_PASSWORD = 'pass123';
$DATABASE_HOST = 'localhost';
$DATABASE_NAME = 'water-monitoring-system-db';
$DATABASE_CHARSET = 'utf8';
const ALL_SENSORS = array("temperature", "ph", "ammonia");

if(isset($_GET['sensors'])) {
    // echo string containing array of sensors dilimited by ,
    echo json_encode($sensors);
    // end
    die();
}

    //check if $_POST is set
if(!isset($_POST)) {
    // end
    die();
}

$con = mysqli_connect($DATABASE_HOST, $DATABASE_USERNAME, $DATABASE_PASSWORD, $DATABASE_NAME);
if (mysqli_connect_errno()){
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    die();
}

// for every sensor in $sensors
foreach($SENSORS as $sensor) {
    // if sensor is set in $_POST
    if(isset($_POST[$sensor])) {
        // get sensor value
        $sensorValue = $_POST[$sensor];
        try {
            // get the id of the sensor
            $result = mysqli_query($con,"SELECT `id` FROM `sensors` WHERE `name` = '".$sensor."'");
            // insert sensor value into database
            $result = mysqli_query($con,"INSERT INTO `sensordata` (`sensorvalue`, `sensorid`) VALUES ('".$sensorValue."', '1')");
        } catch (Exception $e) {
            // close connection
            mysqli_close($con);
            // echo exception message
            echo 'Caught exception: ',  $e->getMessage(), "\n";
            // end
            die();
        }
    }
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