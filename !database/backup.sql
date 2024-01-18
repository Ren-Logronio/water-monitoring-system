-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.2.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for water-monitoring-system-db
CREATE DATABASE IF NOT EXISTS `water-monitoring-system-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `water-monitoring-system-db`;

-- Dumping structure for procedure water-monitoring-system-db.check_threshold
DELIMITER //
CREATE PROCEDURE `check_threshold`(
	IN `thresholdid` INT,
	IN `readingid` INT
)
BEGIN

DECLARE approximation INT DEFAULT 1.5;

DECLARE thaction TYPE OF sensor_threshold.`action`;
DECLARE thtype TYPE OF sensor_threshold.`type`;
DECLARE target TYPE OF sensor_threshold.target;

DECLARE sensorid TYPE OF sensor.sensor_id; /* selected */
DECLARE sensortype TYPE OF sensor.`type`; /*selected*/
DECLARE sensorunit TYPE OF sensor_type.unit; /*selected*/
DECLARE reading TYPE OF sensor_reading.reading; /*selected*/

DECLARE message VARCHAR (512) DEFAULT 'No Message'; 

/*

Notification

[view_notification]
|WARNING|
|Temperature| sensor From Device of '|POND|'
> reading_id

[Message]
The current |temperature| reading (|12.0| |celcius|) has fallen below the limit of normal |temperature| levels (|25.7| |celcius|).

sensor.type, sensor_reading.reading, sensor_type.unit, threshold.target

> reading_id
> threshold_id

*/

SELECT `type`, reading, unit, sensor_id
INTO sensortype, reading, sensorunit, sensorid
FROM view_sensor_reading
WHERE view_sensor_reading.reading_id = readingid;

SELECT `action`, `type`, target
INTO thaction, thtype, target
FROM sensor_threshold
WHERE sensor_threshold.threshold_id = thresholdid;



IF (thtype = 'GREATER THAN' AND reading > target) THEN
	SELECT CONCAT('');
ELSEIF (thtype = 'LESS THAN' AND reading < target) THEN
	CALL create_threshold_notification(sensorid, thaction, message);
ELSEIF (thtype = 'EQUAL TO' AND ABS(target - reading) <= approximation) THEN
	CALL create_threshold_notification(sensorid, thaction, message);
ELSE
	BEGIN
	END;
END IF;

IF (thtype = 'DO NOTHING') THEN
	BEGIN
	END;
ELSE
	CALL create_threshold_notification(sensorid, thaction, message);
END IF;

END//
DELIMITER ;

-- Dumping structure for procedure water-monitoring-system-db.create_threshold_notification
DELIMITER //
CREATE PROCEDURE `create_threshold_notification`(
	IN `readingid` INT,
	IN `action` VARCHAR(255),
	IN `message` VARCHAR(255)
)
BEGIN
	-- Declare variables for notification level and action
	DECLARE nlevel TYPE OF notification_level.`level`;
	DECLARE farmerid TYPE OF farmer.farmer_id;
	DECLARE sensorid TYPE OF sensor.sensor_id;
	
	DECLARE done INT DEFAULT FALSE;
	DECLARE farmers CURSOR(id INT) FOR SELECT farmer_id FROM view_sensor_farmer WHERE sensor_id = id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	IF ( action = 'WARN') THEN
		SET nlevel = 'WARNING';
	ELSEIF ( action = 'ALERT') THEN
		SET nlevel = 'DANGER';
	ELSEIF ( action = 'INFORM') THEN
		SET nlevel = 'INFORMATION';
	ELSE
		SET nlevel = 'INFORMATION';
	END IF;
	
	SELECT sensor_reading.sensor_id INTO sensorid FROM sensor_reading WHERE sensor_reading.reading_id = readingid LIMIT 1;
	
	OPEN farmers(sensorid);
	
	farmers_notify_loop: LOOP
		FETCH farmers INTO farmerid;
		IF (done) THEN
      	LEAVE farmers_notify_loop;
    	END IF;
		INSERT INTO farmer_threshold_notification(farmer_id, reading_id, `level`, message) VALUES (farmerid, readingid, nlevel, message);
	END LOOP;	
	CLOSE farmers;
	
END//
DELIMITER ;

-- Dumping structure for table water-monitoring-system-db.farm
CREATE TABLE IF NOT EXISTS `farm` (
  `farm_id` int(12) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT 'New Farm',
  `address` varchar(255) NOT NULL DEFAULT 'No Address',
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farm: ~0 rows (approximately)
DELETE FROM `farm`;
INSERT INTO `farm` (`farm_id`, `name`, `address`) VALUES
	(1, 'My Farm', 'General Santos City');

-- Dumping structure for table water-monitoring-system-db.farmer
CREATE TABLE IF NOT EXISTS `farmer` (
  `farmer_id` int(12) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` char(60) NOT NULL,
  `firstname` varchar(128) NOT NULL,
  `middlename` varchar(128) NOT NULL,
  `lastname` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`farmer_id`) USING BTREE,
  UNIQUE KEY `AUTHENTICATION` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farmer: ~2 rows (approximately)
DELETE FROM `farmer`;
INSERT INTO `farmer` (`farmer_id`, `email`, `password`, `firstname`, `middlename`, `lastname`) VALUES
	(1, 'reinhart.logronio@gmail.com', '$2a$12$Ob4JqGa/ygOmR7xx4EcHO.meXx8Mlz0OsCi7kGKecRdZknObiW2B6', 'REINHART', 'FERRER', 'LOGRONIO'),
	(2, 'juandela.cruz@gmail.com', '$2a$12$HL.W9dPKhf54ejnCw9QHm.cN4gXAktORwGVeSF1BZiHxW5mvY0JFO', 'JUAN DELA', 'MORVIE', 'CRUZ');

-- Dumping structure for table water-monitoring-system-db.farmer_notification
CREATE TABLE IF NOT EXISTS `farmer_notification` (
  `notification_id` int(12) NOT NULL AUTO_INCREMENT,
  `farmer_id` int(12) DEFAULT NULL,
  `level` varchar(12) NOT NULL DEFAULT 'INFORMATION',
  `message` varchar(512) NOT NULL DEFAULT 'No Message',
  `is_flagged` tinyint(2) NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_modified` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`notification_id`) USING BTREE,
  KEY `FK farmer_notification farmer_id` (`farmer_id`) USING BTREE,
  KEY `FK farmer_notification level` (`level`) USING BTREE,
  CONSTRAINT `farmer_notification_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`farmer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_notification_ibfk_2` FOREIGN KEY (`level`) REFERENCES `notification_level` (`level`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table water-monitoring-system-db.farmer_notification: ~1 rows (approximately)
DELETE FROM `farmer_notification`;
INSERT INTO `farmer_notification` (`notification_id`, `farmer_id`, `level`, `message`, `is_flagged`, `date_added`, `date_modified`) VALUES
	(1, 1, 'INFORMATION', 'Hello, this is a dummy notification for Reinhart Logronio', 0, '2024-01-02 10:31:38', '2024-01-03 00:48:08');

-- Dumping structure for table water-monitoring-system-db.farmer_role
CREATE TABLE IF NOT EXISTS `farmer_role` (
  `role` char(5) NOT NULL DEFAULT 'NROLE',
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farmer_role: ~2 rows (approximately)
DELETE FROM `farmer_role`;
INSERT INTO `farmer_role` (`role`) VALUES
	('OWNER'),
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.farmer_threshold_notification
CREATE TABLE IF NOT EXISTS `farmer_threshold_notification` (
  `notification_id` int(12) NOT NULL AUTO_INCREMENT,
  `farmer_id` int(12) DEFAULT NULL,
  `reading_id` int(12) DEFAULT NULL,
  `level` varchar(12) NOT NULL DEFAULT 'INFORMATION',
  `message` varchar(512) NOT NULL DEFAULT 'No Message',
  `is_flagged` tinyint(2) NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_modified` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`notification_id`),
  KEY `FK farmer_notification farmer_id` (`farmer_id`),
  KEY `FK farmer_notification level` (`level`),
  KEY `FK farmer_notification reading_id` (`reading_id`),
  CONSTRAINT `FK farmer_notification farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`farmer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK farmer_notification level` FOREIGN KEY (`level`) REFERENCES `notification_level` (`level`) ON UPDATE CASCADE,
  CONSTRAINT `FK farmer_notification reading_id` FOREIGN KEY (`reading_id`) REFERENCES `sensor_reading` (`reading_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farmer_threshold_notification: ~1 rows (approximately)
DELETE FROM `farmer_threshold_notification`;

-- Dumping structure for table water-monitoring-system-db.farm_farmer
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int(12) NOT NULL,
  `farmer_id` int(12) NOT NULL,
  `role` char(5) NOT NULL DEFAULT 'STAFF',
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_modified` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`farm_id`,`farmer_id`),
  KEY `FK farm_farmer farmer_id` (`farmer_id`),
  KEY `FK farm_farmer role` (`role`),
  KEY `FK farm_farmer farm_id` (`farm_id`),
  CONSTRAINT `FK farm_farmer farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farm` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK farm_farmer farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`farmer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK farm_farmer role` FOREIGN KEY (`role`) REFERENCES `farmer_role` (`role`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~2 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `date_added`, `date_modified`) VALUES
	(1, 1, 'OWNER', '2024-01-02 10:23:25', '2024-01-02 10:23:41'),
	(1, 2, 'OWNER', '2024-01-02 16:48:34', '2024-01-02 16:48:37');

-- Dumping structure for table water-monitoring-system-db.farm_pond
CREATE TABLE IF NOT EXISTS `farm_pond` (
  `pond_id` int(12) NOT NULL AUTO_INCREMENT,
  `farm_id` int(11) DEFAULT NULL,
  `name` varchar(16) NOT NULL DEFAULT 'New Pond',
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_modified` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pond_id`),
  KEY `FK pond farm_id` (`farm_id`),
  CONSTRAINT `FK pond farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farm` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farm_pond: ~1 rows (approximately)
DELETE FROM `farm_pond`;
INSERT INTO `farm_pond` (`pond_id`, `farm_id`, `name`, `date_added`, `date_modified`) VALUES
	(1, 1, 'My Pond', '2024-01-02 10:32:17', '2024-01-02 10:32:17');

-- Dumping structure for table water-monitoring-system-db.notification_level
CREATE TABLE IF NOT EXISTS `notification_level` (
  `level` varchar(12) NOT NULL DEFAULT 'NEW LEVEL',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.notification_level: ~3 rows (approximately)
DELETE FROM `notification_level`;
INSERT INTO `notification_level` (`level`) VALUES
	('DANGER'),
	('INFORMATION'),
	('WARNING');

-- Dumping structure for table water-monitoring-system-db.pond_arduino
CREATE TABLE IF NOT EXISTS `pond_arduino` (
  `device_id` uuid NOT NULL DEFAULT uuid(),
  `pond_id` int(12) DEFAULT NULL,
  `mac` char(17) DEFAULT NULL,
  `is_online` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`device_id`),
  UNIQUE KEY `mac` (`mac`),
  UNIQUE KEY `pond_id` (`pond_id`),
  CONSTRAINT `FK arduino pond_id` FOREIGN KEY (`pond_id`) REFERENCES `farm_pond` (`pond_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.pond_arduino: ~1 rows (approximately)
DELETE FROM `pond_arduino`;
INSERT INTO `pond_arduino` (`device_id`, `pond_id`, `mac`, `is_online`) VALUES
	('cd7ab565-a929-11ee-be20-d45d64a926d8', 1, '02:1A:3F:4B:7E:9D', 1);

-- Dumping structure for table water-monitoring-system-db.sensor
CREATE TABLE IF NOT EXISTS `sensor` (
  `sensor_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(12) DEFAULT NULL,
  `device_id` uuid DEFAULT NULL,
  PRIMARY KEY (`sensor_id`),
  KEY `FK sensor type` (`type`),
  KEY `FK sensor device_id` (`device_id`),
  CONSTRAINT `FK sensor device_id` FOREIGN KEY (`device_id`) REFERENCES `pond_arduino` (`device_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK sensor type` FOREIGN KEY (`type`) REFERENCES `sensor_type` (`type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor: ~5 rows (approximately)
DELETE FROM `sensor`;
INSERT INTO `sensor` (`sensor_id`, `type`, `device_id`) VALUES
	(1, 'TEMPERATURE', 'cd7ab565-a929-11ee-be20-d45d64a926d8'),
	(2, 'AMMONIA', 'cd7ab565-a929-11ee-be20-d45d64a926d8'),
	(3, 'DO', 'cd7ab565-a929-11ee-be20-d45d64a926d8'),
	(4, 'SALINITY', 'cd7ab565-a929-11ee-be20-d45d64a926d8'),
	(5, 'PH', 'cd7ab565-a929-11ee-be20-d45d64a926d8');

-- Dumping structure for table water-monitoring-system-db.sensor_reading
CREATE TABLE IF NOT EXISTS `sensor_reading` (
  `reading_id` int(12) NOT NULL AUTO_INCREMENT,
  `sensor_id` int(12) DEFAULT NULL,
  `reading` double NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_modified` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`reading_id`),
  KEY `FK sensor_reading sensor_id` (`sensor_id`),
  CONSTRAINT `FK sensor_reading sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor_reading: ~1 rows (approximately)
DELETE FROM `sensor_reading`;
INSERT INTO `sensor_reading` (`reading_id`, `sensor_id`, `reading`, `date_added`, `date_modified`) VALUES
	(1, 3, 20, '2024-01-03 00:35:26', '2024-01-03 00:35:28');

-- Dumping structure for table water-monitoring-system-db.sensor_threshold
CREATE TABLE IF NOT EXISTS `sensor_threshold` (
  `threshold_id` int(12) NOT NULL AUTO_INCREMENT,
  `sensor_id` int(12) DEFAULT NULL,
  `type` varchar(12) NOT NULL DEFAULT 'EQUAL',
  `action` varchar(12) NOT NULL DEFAULT 'DO NOTHING',
  `target` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`threshold_id`),
  KEY `FK sensor_threshold sensor_id` (`sensor_id`),
  KEY `FK sensor_threshold type` (`type`),
  KEY `FK sensor_threshold action` (`action`),
  CONSTRAINT `FK sensor_threshold action` FOREIGN KEY (`action`) REFERENCES `threshold_action` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `FK sensor_threshold sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK sensor_threshold type` FOREIGN KEY (`type`) REFERENCES `threshold_type` (`type`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor_threshold: ~2 rows (approximately)
DELETE FROM `sensor_threshold`;
INSERT INTO `sensor_threshold` (`threshold_id`, `sensor_id`, `type`, `action`, `target`) VALUES
	(1, 5, 'LESS THAN', 'WARN', 5),
	(2, 5, 'GREATER THAN', 'WARN', 8);

-- Dumping structure for table water-monitoring-system-db.sensor_type
CREATE TABLE IF NOT EXISTS `sensor_type` (
  `type` varchar(12) NOT NULL DEFAULT 'NSENSORTYPE',
  `unit` varchar(12) NOT NULL DEFAULT 'NSENSORUNIT',
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor_type: ~5 rows (approximately)
DELETE FROM `sensor_type`;
INSERT INTO `sensor_type` (`type`, `unit`) VALUES
	('AMMONIA', 'ppm'),
	('DO', 'mG/L'),
	('PH', 'pH'),
	('SALINITY', 'ppt'),
	('TEMPERATURE', 'celcius');

-- Dumping structure for table water-monitoring-system-db.threshold_action
CREATE TABLE IF NOT EXISTS `threshold_action` (
  `action` varchar(12) NOT NULL DEFAULT 'NEW ACTION',
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.threshold_action: ~4 rows (approximately)
DELETE FROM `threshold_action`;
INSERT INTO `threshold_action` (`action`) VALUES
	('ALERT'),
	('DO NOTHING'),
	('INFORM'),
	('WARN');

-- Dumping structure for table water-monitoring-system-db.threshold_type
CREATE TABLE IF NOT EXISTS `threshold_type` (
  `type` varchar(12) NOT NULL DEFAULT 'NEW TYPE',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.threshold_type: ~3 rows (approximately)
DELETE FROM `threshold_type`;
INSERT INTO `threshold_type` (`type`) VALUES
	('EQUAL TO'),
	('GREATER THAN'),
	('LESS THAN');

-- Dumping structure for view water-monitoring-system-db.view_sensors
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_sensors` (
	`type` VARCHAR(12) NULL COLLATE 'utf8mb4_general_ci',
	`pond_name` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_general_ci',
	`farm_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`is_online` TINYINT(2) NOT NULL,
	`mac` CHAR(17) NULL COLLATE 'utf8mb4_general_ci',
	`sensor_id` INT(11) NOT NULL,
	`device_id` UUID NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_sensor_farmer
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_sensor_farmer` (
	`sensor_id` INT(11) NOT NULL,
	`farmer_id` INT(12) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_sensor_reading
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_sensor_reading` (
	`date_added` DATETIME NOT NULL,
	`reading` DOUBLE NOT NULL,
	`unit` VARCHAR(12) NOT NULL COLLATE 'utf8mb4_general_ci',
	`type` VARCHAR(12) NULL COLLATE 'utf8mb4_general_ci',
	`pond_name` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_general_ci',
	`farm_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`address` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`date_modified` DATETIME NOT NULL,
	`reading_id` INT(12) NOT NULL,
	`sensor_id` INT(11) NOT NULL,
	`pond_id` INT(12) NOT NULL,
	`farm_id` INT(12) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_sensors
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_sensors`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_sensors` AS select `sensor`.`type` AS `type`,`farm_pond`.`name` AS `pond_name`,`farm`.`name` AS `farm_name`,`pond_arduino`.`is_online` AS `is_online`,`pond_arduino`.`mac` AS `mac`,`sensor`.`sensor_id` AS `sensor_id`,`pond_arduino`.`device_id` AS `device_id` from ((((`sensor` join `sensor_type` on(`sensor`.`type` = `sensor_type`.`type`)) join `pond_arduino` on(`sensor`.`device_id` = `pond_arduino`.`device_id`)) join `farm_pond` on(`pond_arduino`.`pond_id` = `farm_pond`.`pond_id`)) join `farm` on(`farm`.`farm_id` = `farm_pond`.`farm_id`));

-- Dumping structure for view water-monitoring-system-db.view_sensor_farmer
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_sensor_farmer`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_sensor_farmer` AS select `sensor`.`sensor_id` AS `sensor_id`,`farm_farmer`.`farmer_id` AS `farmer_id` from ((((`sensor` join `pond_arduino` on(`pond_arduino`.`device_id` = `sensor`.`device_id`)) join `farm_pond` on(`farm_pond`.`pond_id` = `pond_arduino`.`pond_id`)) join `farm` on(`farm`.`farm_id` = `farm_pond`.`farm_id`)) join `farm_farmer` on(`farm_farmer`.`farm_id` = `farm`.`farm_id`));

-- Dumping structure for view water-monitoring-system-db.view_sensor_reading
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_sensor_reading`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_sensor_reading` AS select `sensor_reading`.`date_added` AS `date_added`,`sensor_reading`.`reading` AS `reading`,`sensor_type`.`unit` AS `unit`,`sensor`.`type` AS `type`,`farm_pond`.`name` AS `pond_name`,`farm`.`name` AS `farm_name`,`farm`.`address` AS `address`,`sensor_reading`.`date_modified` AS `date_modified`,`sensor_reading`.`reading_id` AS `reading_id`,`sensor`.`sensor_id` AS `sensor_id`,`farm_pond`.`pond_id` AS `pond_id`,`farm`.`farm_id` AS `farm_id` from (((((`sensor_reading` join `sensor` on(`sensor_reading`.`sensor_id` = `sensor`.`sensor_id`)) join `sensor_type` on(`sensor_type`.`type` = `sensor`.`type`)) join `pond_arduino` on(`pond_arduino`.`device_id` = `sensor`.`device_id`)) join `farm_pond` on(`farm_pond`.`pond_id` = `pond_arduino`.`pond_id`)) join `farm` on(`farm`.`farm_id` = `farm_pond`.`farm_id`));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
