/*  
*   WATER MONITORING SYSTEM DATABASE For Mysql Database
*/

CREATE DATABASE IF NOT EXISTS 'water-monitoring-system-db';
USE 'water-monitoring-system-db';

/* Note - Table blocks are indented to signify parent-child relations */

DROP TABLE IF EXISTS user;
    DROP TABLE IF EXISTS farmowner;
        DROP TABLE IF EXISTS farm;
            DROP TABLE IF EXISTS pond;
        DROP TABLE IF EXISTS microcontroller;
            DROP TABLE IF EXISTS sensor;
                DROP TABLE IF EXISTS sensordata;
        DROP TABLE IF EXISTS owned_microcontroller;

CREATE TABLE IF NOT EXISTS user{
    userid INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(125) NOT NULL,
    middlename VARCHAR(125) NOT NULL,
    lastname VARCHAR(125) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
    PRIMARY KEY (userid)
}

    CREATE TABLE IF NOT EXISTS farmowner{
        farmownerid INT NOT NULL AUTO_INCREMENT,
        userid INT NOT NULL,
        PRIMARY KEY (farmownerid),
        FOREIGN KEY (userid) REFERENCES user(userid)
    }

        CREATE TABLE IF NOT EXISTS farm {
            farmid INT NOT NULL AUTO_INCREMENT,
            farmname VARCHAR(255) NOT NULL,
            farmaddress VARCHAR(255) NOT NULL,
            PRIMARY KEY (farmid)
        }

        CREATE TABLE IF NOT EXISTS microcontroller {
            microcontrollerid INT NOT NULL AUTO_INCREMENT,
            ssid VARCHAR(255) NOT NULL,
            pkey VARCHAR(255) NOT NULL,
            ipv4address INT UNSIGNED NOT NULL,
            ipv6address BINARY(16),
            port INT NOT NULL,
            status VARCHAR(10) NOT NULL,
            PRIMARY KEY (microcontrollerid)
        }

            CREATE TABLE IF NOT EXISTS pond {
                pondid INT NOT NULL AUTO_INCREMENT,
                farmid INT NOT NULL,
                microcontrollerid INT NOT NULL,
                width DOUBLE PRECISION NOT NULL,
                height DOUBLE PRECISION NOT NULL,
                depth DOUBLE PRECISION NOT NULL,
                PRIMARY KEY (pondid),
                FOREIGN KEY (farmid) REFERENCES farm(farmid),
                FOREIGN KEY (microcontrollerid) REFERENCES microcontroller(microcontrollerid)
            }

            CREATE TABLE IF NOT EXISTS sensor {
                sensorid INT NOT NULL AUTO_INCREMENT,
                microcontrollerid INT NOT NULL,
                unitdescription VARCHAR(125) NOT NULL,
                unit VARCHAR(10) NOT NULL,
                status VARCHAR(10) NOT NULL,
                PRIMARY KEY (sensorid),
                FOREIGN KEY (microcontrollerid) REFERENCES microcontroller(microcontrollerid)
            }
        
                CREATE TABLE IF NOT EXISTS sensordata {
                    entryno INT NOT NULL AUTO_INCREMENT,
                    sensorid INT NOT NULL,
                    ismanuallyencoded BOOLEAN NOT NULL DEFAULT FALSE,
                    dateandtime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    datemodified DATETIME ON UPDATE CURRENT_TIMESTAMP,
                    sensorvalue DOUBLE PRECISION NOT NULL DEFAULT 0,
                    PRIMARY KEY (entryno, sensorid),
                    FOREIGN KEY (sensorid) REFERENCES sensor(sensorid)
                }
        
        CREATE TABLE IF NOT EXISTS owned_microcontroller {
            farmownerid INT NOT NULL,
            microcontrollerid INT NOT NULL,
            PRIMARY KEY (farmownerid, microcontrollerid),
            FOREIGN KEY (farmownerid) REFERENCES farmowner(farmownerid),
            FOREIGN KEY (microcontrollerid) REFERENCES microcontroller(microcontrollerid)
        }