CREATE DATABASE IF NOT EXISTS 'water-monitoring-system-db';
USE 'water-monitoring-system-db';

DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS farm;
DROP TABLE IF EXISTS microcontroller;
DROP TABLE IF EXISTS sensor;
DROP TABLE IF EXISTS sensordata;

CREATE TABLE IF NOT EXISTS user{
    userid INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(125) NOT NULL,
    middlename VARCHAR(125) NOT NULL,
    lastname VARCHAR(125) NOT NULL,
    email VARCHAR(255) NOT NULL,
    pass VARCHAR(64) NOT NULL,
    PRIMARY KEY (userid)
}

CREATE TABLE IF NOT EXISTS account_farm {
    userid INT NOT NULL,
    farmid INT NOT NULL,
    datetime VARCHAR(255) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userid, farmid),
    FOREIGN KEY (userid) REFERENCES user(userid),
    FOREIGN KEY (farmid) REFERENCES farm(farmid)
}

CREATE TABLE IF NOT EXISTS farm {
    farmid INT NOT NULL AUTO_INCREMENT,
    farmname VARCHAR(255) NOT NULL,
    farmaddress VARCHAR(255) NOT NULL,
    PRIMARY KEY (farmid)
}

CREATE TABLE IF NOT EXISTS microcontroller {
    deviceid BINARY(16) NOT NULL,
    farmid INT NOT NULL,
    name VARCHAR(64) NOT NULL,
    PRIMARY KEY (deviceid),
    FOREIGN KEY (farmid) REFERENCES farm(farmid)
}

CREATE TABLE IF NOT EXISTS sensor {
    sensorid INT NOT NULL AUTO_INCREMENT,
    deviceid BINARY(16) NOT NULL,
    sensortype VARCHAR(64) NOT NULL,
    unit VARCHAR(8) NOT NULL,
    PRIMARY KEY (sensorid)
}

CREATE TABLE IF NOT EXISTS sensordata {
    index INT NOT NULL AUTO_INCREMENT,
    sensorid INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sensorid),
    FOREIGN KEY (sensorid) REFERENCES sensor(sensorid)
}   