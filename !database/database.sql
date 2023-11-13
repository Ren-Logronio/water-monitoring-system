CREATE DATABASE IF NOT EXISTS 'water-monitoring-system-db';
USE 'water-monitoring-system-db';

DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS farm;
DROP TABLE IF EXISTS microcontroller;
DROP TABLE IF EXISTS sensor;
DROP TABLE IF EXISTS sensordata;

CREATE TABLE IF NOT EXISTS user(
    userid INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(125) NOT NULL,
    middlename VARCHAR(125) NOT NULL,
    lastname VARCHAR(125) NOT NULL,
    email VARCHAR(255) NOT NULL,
    pass VARCHAR(64) NOT NULL,
    PRIMARY KEY (userid)
)

CREATE TABLE IF NOT EXISTS user_farm (
    userid INT NOT NULL,
    farmid INT NOT NULL,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userid, farmid),
    FOREIGN KEY (userid) REFERENCES user(userid),
    FOREIGN KEY (farmid) REFERENCES farm(farmid)
)

CREATE TABLE IF NOT EXISTS farm (
    farmid INT NOT NULL AUTO_INCREMENT,
    farmname VARCHAR(255) NOT NULL,
    farmaddress VARCHAR(255) NOT NULL,
    PRIMARY KEY (farmid)
)

CREATE TABLE IF NOT EXISTS device (
    deviceid BINARY(16) NOT NULL,
    farmid INT NOT NULL,
    name VARCHAR(64) NOT NULL,
    PRIMARY KEY (deviceid),
    FOREIGN KEY (farmid) REFERENCES farm(farmid)
)

CREATE TABLE IF NOT EXISTS sensor (
    sensorid INT NOT NULL AUTO_INCREMENT,
    deviceid BINARY(16) NOT NULL,
    sensortype VARCHAR(64) NOT NULL,
    unit VARCHAR(8) NOT NULL,
    PRIMARY KEY (sensorid)
    FOREIGN KEY (deviceid) REFERENCES device(deviceid)
)

CREATE TABLE IF NOT EXISTS sensordata (
    entry INT NOT NULL AUTO_INCREMENT,
    sensorid INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sensorid),
    FOREIGN KEY (sensorid) REFERENCES sensor(sensorid)
)

create view user_view as select userid, firstname, middlename, lastname, email from user;

create view user_farm_view as
select u.userid, u.email, farm.farmid, farm.farmname, farm.farmaddress from user as u
join user_farm on u.userid = user_farm.userid
join farm on user_farm.farmid = farm.farmid;

create view farm_device_view as
select farm.farmid, farm.farmname, farm.farmaddress, bin_to_uuid(device.deviceid) as deviceid, device.name from farm
join device on farm.farmid = device.farmid;

create view device_sensor_data_view as
select bin_to_uuid(device.deviceid) as deviceid, sensor.sensortype, coalesce(sensor.unit, 'none') as unit, sensordata.datetime, sensordata.value
from device join sensor on device.deviceid = sensor.deviceid join sensordata on sensor.sensorid = sensordata.sensorid;