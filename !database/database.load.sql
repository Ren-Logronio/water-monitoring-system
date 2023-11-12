/*

CREATE TABLE IF NOT EXISTS user{
    userid INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(125) NOT NULL,
    middlename VARCHAR(125) NOT NULL,
    lastname VARCHAR(125) NOT NULL,
    email VARCHAR(255) NOT NULL,
    pass VARCHAR(64) NOT NULL,
    PRIMARY KEY (userid)
}

CREATE TABLE IF NOT EXISTS user_farm {
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

CREATE TABLE IF NOT EXISTS device {
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

*/



INSERT INTO user (firstname, middlename, lastname, email, pass) VALUES ('Juan Dela', 'Pangalan', 'Cruz', 'juandela.cruz@msugensan.edu.ph', '$2y$10$HgkAD5nuDnn8U28YTbg3oeyWCPHVpzdRkDyCbNjLrYzNeVoFIC1lK');
INSERT INTO user_farm (userid, farmid) VALUES (1, 1);
INSERT INTO farm (farmname, farmaddress) VALUES ('MSU-Gensan Campus Research Station', 'Makar-Siguel Rd, General Santos City, South Cotabato');
INSERT INTO microcontroller (deviceid, farmid, name) VALUES ('3b26008c-ac0b-576d-9d0c-2cda7dc0fb3d', 1, 'TestingDevice');
