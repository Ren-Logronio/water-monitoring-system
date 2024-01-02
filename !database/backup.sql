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

-- Dumping structure for table water-monitoring-system-db.farm
CREATE TABLE IF NOT EXISTS `farm` (
  `farm_id` int(12) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '"New Farm"',
  `address` varchar(255) NOT NULL DEFAULT '"No Address"',
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farm: ~1 rows (approximately)
DELETE FROM `farm`;
INSERT INTO `farm` (`farm_id`, `name`, `address`) VALUES
	(1, 'My Farm', '"No Address"');

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

-- Dumping data for table water-monitoring-system-db.farmer: ~1 rows (approximately)
DELETE FROM `farmer`;
INSERT INTO `farmer` (`farmer_id`, `email`, `password`, `firstname`, `middlename`, `lastname`) VALUES
	(1, 'reinhart.logronio@gmail.com', '$2a$12$Ob4JqGa/ygOmR7xx4EcHO.meXx8Mlz0OsCi7kGKecRdZknObiW2B6', 'REINHART', 'FERRER', 'LOGRONIO');

-- Dumping structure for table water-monitoring-system-db.farmer_notification
CREATE TABLE IF NOT EXISTS `farmer_notification` (
  `notification_id` int(12) NOT NULL AUTO_INCREMENT,
  `farmer_id` int(12) DEFAULT NULL,
  `level` varchar(12) NOT NULL DEFAULT 'INFORMATION',
  `message` varchar(255) NOT NULL DEFAULT 'No Message',
  `is_flagged` tinyint(2) NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`notification_id`),
  KEY `FK farmer_notification farmer_id` (`farmer_id`),
  KEY `FK farmer_notification level` (`level`),
  CONSTRAINT `FK farmer_notification farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`farmer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK farmer_notification level` FOREIGN KEY (`level`) REFERENCES `notification_level` (`level`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.farmer_notification: ~1 rows (approximately)
DELETE FROM `farmer_notification`;
INSERT INTO `farmer_notification` (`notification_id`, `farmer_id`, `level`, `message`, `is_flagged`, `date_added`) VALUES
	(1, 1, 'INFORMATION', 'Hello, this is a dummy notification for Reinhart Logronio', 0, '2024-01-02 10:31:38');

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

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~1 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `date_added`, `date_modified`) VALUES
	(1, 1, 'OWNER', '2024-01-02 10:23:25', '2024-01-02 10:23:41');

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
  `mac` char(12) DEFAULT NULL,
  `is_online` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`device_id`),
  KEY `FK arduino pond_id` (`pond_id`),
  CONSTRAINT `FK arduino pond_id` FOREIGN KEY (`pond_id`) REFERENCES `farm_pond` (`pond_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.pond_arduino: ~0 rows (approximately)
DELETE FROM `pond_arduino`;

-- Dumping structure for table water-monitoring-system-db.sensor
CREATE TABLE IF NOT EXISTS `sensor` (
  `sensor_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` uuid DEFAULT NULL,
  `type` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`sensor_id`),
  KEY `FK sensor device_id` (`device_id`),
  KEY `FK sensor type` (`type`),
  CONSTRAINT `FK sensor device_id` FOREIGN KEY (`device_id`) REFERENCES `pond_arduino` (`device_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK sensor type` FOREIGN KEY (`type`) REFERENCES `sensor_type` (`type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor: ~0 rows (approximately)
DELETE FROM `sensor`;

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

-- Dumping data for table water-monitoring-system-db.sensor_reading: ~0 rows (approximately)
DELETE FROM `sensor_reading`;

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

-- Dumping data for table water-monitoring-system-db.sensor_threshold: ~0 rows (approximately)
DELETE FROM `sensor_threshold`;

-- Dumping structure for table water-monitoring-system-db.sensor_type
CREATE TABLE IF NOT EXISTS `sensor_type` (
  `type` varchar(12) NOT NULL DEFAULT 'NSENSORTYPE',
  `unit` varchar(12) NOT NULL DEFAULT 'NSENSORUNIT',
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.sensor_type: ~5 rows (approximately)
DELETE FROM `sensor_type`;
INSERT INTO `sensor_type` (`type`, `unit`) VALUES
	('AMMONIA', 'NSENSORUNIT'),
	('DO', 'NSENSORUNIT'),
	('PH', 'NSENSORUNIT'),
	('SALINITY', 'NSENSORUNIT'),
	('TEMPERATURE', 'NSENSORUNIT');

-- Dumping structure for table water-monitoring-system-db.threshold_action
CREATE TABLE IF NOT EXISTS `threshold_action` (
  `action` varchar(12) NOT NULL DEFAULT 'NEW ACTION',
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table water-monitoring-system-db.threshold_action: ~3 rows (approximately)
DELETE FROM `threshold_action`;
INSERT INTO `threshold_action` (`action`) VALUES
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
	('EQUAL'),
	('GREATER THAN'),
	('LESS THAN');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
