<?php

class Device {

    private $deviceId;
    private $baudRate;
    private $port;
    private $connection;

    public function __construct($deviceId, $baudRate, $port) {
        $this->deviceId = $deviceId;
        $this->port = $port;
        $this->baudRate = $baudRate;
        $this->connect();
    }

    public function connect(){
        $this->connection = null; // establish connection to arduino
    }

    public function readOut($pin){}

    public function writeOut($pin, $value){}

    public function readSensor($sensor){}

    public function sensorStatus($sensor){}

    public function disconnect(){
        unset($this->connection);
    }

}


?>