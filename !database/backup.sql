-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.36 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
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
CREATE DATABASE IF NOT EXISTS `water-monitoring-system-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `water-monitoring-system-db`;

-- Dumping structure for table water-monitoring-system-db.farms
CREATE TABLE IF NOT EXISTS `farms` (
  `farm_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `address` varchar(128) NOT NULL,
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.farms: ~0 rows (approximately)
DELETE FROM `farms`;

-- Dumping structure for table water-monitoring-system-db.farm_farmer
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int NOT NULL,
  `farmer_id` int NOT NULL,
  `role` char(5) NOT NULL DEFAULT 'STAFF',
  KEY `farmer_farm_id` (`farm_id`),
  KEY `farm_farmer_id` (`farmer_id`),
  KEY `farm_farmer_role` (`role`),
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~0 rows (approximately)
DELETE FROM `farm_farmer`;

-- Dumping structure for table water-monitoring-system-db.ponds
CREATE TABLE IF NOT EXISTS `ponds` (
  `device_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `farm_id` int NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'My Pond',
  PRIMARY KEY (`device_id`) USING BTREE,
  KEY `pond_farm_id` (`farm_id`),
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.ponds: ~0 rows (approximately)
DELETE FROM `ponds`;

-- Dumping structure for table water-monitoring-system-db.readings
CREATE TABLE IF NOT EXISTS `readings` (
  `reading_id` int NOT NULL AUTO_INCREMENT,
  `sensor_id` int DEFAULT NULL,
  `value` double NOT NULL DEFAULT (0.0),
  `created_at` datetime NOT NULL DEFAULT (now()),
  `modified_at` datetime NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reading_id`),
  KEY `reading_sensor_id` (`sensor_id`),
  CONSTRAINT `reading_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`sensor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.readings: ~0 rows (approximately)
DELETE FROM `readings`;

-- Dumping structure for table water-monitoring-system-db.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `role` char(5) NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.roles: ~2 rows (approximately)
DELETE FROM `roles`;
INSERT INTO `roles` (`role`) VALUES
	('OWNER'),
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.sensors
CREATE TABLE IF NOT EXISTS `sensors` (
  `sensor_id` int NOT NULL AUTO_INCREMENT,
  `device_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parameter` varchar(3) NOT NULL,
  PRIMARY KEY (`sensor_id`),
  KEY `sensor_device_id` (`device_id`),
  KEY `sensor_parameter` (`parameter`),
  CONSTRAINT `sensor_parameter` FOREIGN KEY (`parameter`) REFERENCES `sensor_parameters` (`parameter`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.sensors: ~0 rows (approximately)
DELETE FROM `sensors`;

-- Dumping structure for table water-monitoring-system-db.sensor_notifications
CREATE TABLE IF NOT EXISTS `sensor_notifications` (
  `sensor_notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reading_id` int NOT NULL,
  `threshold_id` int NOT NULL,
  PRIMARY KEY (`sensor_notification_id`),
  KEY `sensor_notification_threshold_id` (`threshold_id`),
  KEY `sensor_notification_reading_id` (`reading_id`),
  KEY `sensor_notification_user_id` (`user_id`),
  CONSTRAINT `sensor_notification_reading_id` FOREIGN KEY (`reading_id`) REFERENCES `readings` (`reading_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_threshold_id` FOREIGN KEY (`threshold_id`) REFERENCES `thresholds` (`threshold_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.sensor_notifications: ~0 rows (approximately)
DELETE FROM `sensor_notifications`;

-- Dumping structure for table water-monitoring-system-db.sensor_parameters
CREATE TABLE IF NOT EXISTS `sensor_parameters` (
  `parameter` varchar(3) NOT NULL,
  `name` varchar(16) NOT NULL,
  `unit` varchar(16) NOT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.sensor_parameters: ~5 rows (approximately)
DELETE FROM `sensor_parameters`;
INSERT INTO `sensor_parameters` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', '---'),
	('DO', 'Dissolved Oxygen', '---'),
	('PH', 'pH', 'pH'),
	('SAL', 'Salinity', '--'),
	('TMP', 'Temperature', '*C');

-- Dumping structure for table water-monitoring-system-db.thresholds
CREATE TABLE IF NOT EXISTS `thresholds` (
  `threshold_id` int NOT NULL AUTO_INCREMENT,
  `sensor_id` int NOT NULL,
  `type` char(2) NOT NULL,
  `action` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `target` double NOT NULL DEFAULT (0.0),
  `error` double NOT NULL DEFAULT (0.0),
  PRIMARY KEY (`threshold_id`),
  KEY `threshold_sensor_id` (`sensor_id`),
  KEY `threshold_type` (`type`),
  KEY `threshold_action` (`action`),
  CONSTRAINT `threshold_action` FOREIGN KEY (`action`) REFERENCES `threshold_actions` (`action`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `threshold_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`sensor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `threshold_type` FOREIGN KEY (`type`) REFERENCES `threshold_types` (`type`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.thresholds: ~0 rows (approximately)
DELETE FROM `thresholds`;

-- Dumping structure for table water-monitoring-system-db.threshold_actions
CREATE TABLE IF NOT EXISTS `threshold_actions` (
  `action` char(4) NOT NULL,
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.threshold_actions: ~3 rows (approximately)
DELETE FROM `threshold_actions`;
INSERT INTO `threshold_actions` (`action`) VALUES
	('ALRT'),
	('INFO'),
	('WARN');

-- Dumping structure for table water-monitoring-system-db.threshold_types
CREATE TABLE IF NOT EXISTS `threshold_types` (
  `type` char(2) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.threshold_types: ~3 rows (approximately)
DELETE FROM `threshold_types`;
INSERT INTO `threshold_types` (`type`) VALUES
	('EQ'),
	('GT'),
	('LT');

-- Dumping structure for table water-monitoring-system-db.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `middlename` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `lastname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.users: ~2 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(1, 'Juan Dela', 'Vega', 'Cruz', 'test@gmail.com', '$2a$12$ymNu3FWKcjamdaug0mZSseFaucZOsUqOSBtWs3Ale2KT.XdUC8E4S'),
	(2, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$lDfKsjU94tv/.dfX1ewVsuuIycdYG6Poa8Y6DEsZSb2pcB4kQhW4m');

-- Dumping structure for table water-monitoring-system-db.user_notification
CREATE TABLE IF NOT EXISTS `user_notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` char(4) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT 'No Message',
  `issued_at` datetime NOT NULL DEFAULT (now()),
  PRIMARY KEY (`notification_id`),
  KEY `notification_user_id` (`user_id`),
  KEY `notification_action` (`action`),
  CONSTRAINT `notification_action` FOREIGN KEY (`action`) REFERENCES `threshold_actions` (`action`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.user_notification: ~0 rows (approximately)
DELETE FROM `user_notification`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
