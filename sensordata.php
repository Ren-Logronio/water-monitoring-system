<?php

require_once('includes/database.init.php');

    //check if $_POST is set
if(!isset($_POST)) {
    // end
    die();
}
/*
{ 'deviceid': 'your_device_id', 'name': 'your_device_name', 'ammonia': 'ammonia_concentration_value', 'ph': 'ph_value', 'temperature': 'temperature_value', 'sensors': 'ammonia|ph|temperature'}
*/

$sensors = explode('|', $_POST['sensors']);

// for every sensor in $sensors
foreach($sensors as $sensor) {
    // if sensor is set in $_POST
    if(isset($_POST[$sensor])) {
        // get sensor value
        $sensorvalue = $_POST[$sensor];
        $deviceid = $_POST['deviceid'];
        $datetime = $_POST['datetime'];
        // check if sensor exists
        $sensorquery = mysqli_query($con,"SELECT `sensorid` FROM `sensor` WHERE `deviceid` = UUID_TO_BIN('".$deviceid."') AND `sensortype` = '".$sensor."'");
        // if sensor does not exist
        if(mysqli_num_rows($sensorquery) == 0) {
            // insert sensor into database
            mysqli_query($con,"INSERT INTO `sensor` (`deviceid`, `sensortype`) VALUES (UUID_TO_BIN('".$deviceid."'), '".$sensor."')");
        }
        try {
            // get id of sensor from device id
            $sensoridquery = mysqli_query($con,"SELECT `sensorid` FROM `sensor` WHERE `deviceid` = UUID_TO_BIN('".$deviceid."') AND `sensortype` = '".$sensor."'");
            // get sensorid from query
            $sensoridresult = mysqli_fetch_assoc($sensoridquery);
            $sensorid = $sensoridresult['sensorid'];
            // insert sensor value into database
            mysqli_query($con,"INSERT INTO `sensordata` (`sensorid`, `value`, `datetime`) VALUES ('".$sensorid."', '".$sensorvalue."', '".$datetime."')");
        } catch (Exception $e) {
            // close connection and print error
            mysqli_close($con);
            echo 'Caught exception: ',  $e->getMessage(), "\n";
            die();
        }
    }
}

?>