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
  `address_street` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address_city` varchar(128) NOT NULL,
  `address_country` varchar(128) NOT NULL,
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.farms: ~1 rows (approximately)
DELETE FROM `farms`;
INSERT INTO `farms` (`farm_id`, `name`, `address_street`, `address_city`, `address_country`) VALUES
	(1, 'RD Farm', 'Next Street', 'General Santos City', 'Philippines');

-- Dumping structure for table water-monitoring-system-db.farm_farmer
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int NOT NULL,
  `farmer_id` int NOT NULL,
  `role` char(5) NOT NULL DEFAULT 'STAFF',
  PRIMARY KEY (`farm_id`,`farmer_id`),
  KEY `farm_farmer_id` (`farmer_id`),
  KEY `farm_farmer_role` (`role`),
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~1 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`) VALUES
	(1, 1, 'OWNER');

-- Dumping structure for table water-monitoring-system-db.ponds
CREATE TABLE IF NOT EXISTS `ponds` (
  `device_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `farm_id` int NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'My Pond',
  `status` varchar(8) NOT NULL DEFAULT '''IDLE''',
  PRIMARY KEY (`device_id`) USING BTREE,
  KEY `pond_farm_id` (`farm_id`),
  KEY `pond_status` (`status`),
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pond_status` FOREIGN KEY (`status`) REFERENCES `pond_statuses` (`status`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.ponds: ~2 rows (approximately)
DELETE FROM `ponds`;
INSERT INTO `ponds` (`device_id`, `farm_id`, `name`, `status`) VALUES
	('a0f8250e-49a7-4354-bf8c-bae94119a4fb', 1, 'Testing Pond', 'ACTIVE'),
	('e5b672a9-feba-490c-a987-a50fdca38441', 1, 'Virtual Pond', 'ACTIVE');

-- Dumping structure for table water-monitoring-system-db.pond_statuses
CREATE TABLE IF NOT EXISTS `pond_statuses` (
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.pond_statuses: ~2 rows (approximately)
DELETE FROM `pond_statuses`;
INSERT INTO `pond_statuses` (`status`) VALUES
	('ACTIVE'),
	('IDLE'),
	('INACTIVE');

-- Dumping structure for table water-monitoring-system-db.readings
CREATE TABLE IF NOT EXISTS `readings` (
  `reading_id` int NOT NULL AUTO_INCREMENT,
  `sensor_id` int DEFAULT NULL,
  `value` double NOT NULL DEFAULT (0.0),
  `recorded_at` datetime NOT NULL DEFAULT (now()),
  `modified_at` datetime NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reading_id`),
  KEY `reading_sensor_id` (`sensor_id`),
  CONSTRAINT `reading_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`sensor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.readings: ~30 rows (approximately)
DELETE FROM `readings`;
INSERT INTO `readings` (`reading_id`, `sensor_id`, `value`, `recorded_at`, `modified_at`) VALUES
	(1, 1, 24, '2024-02-01 00:00:00', '2024-02-01 00:00:00'),
	(2, 1, 25, '2024-02-02 00:00:00', '2024-02-02 00:00:00'),
	(3, 1, 26, '2024-02-03 00:00:00', '2024-02-03 00:00:00'),
	(4, 1, 27, '2024-02-04 00:00:00', '2024-02-04 00:00:00'),
	(5, 1, 28, '2024-02-05 00:00:00', '2024-02-05 00:00:00'),
	(6, 1, 29, '2024-02-06 00:00:00', '2024-02-06 00:00:00'),
	(7, 1, 30, '2024-02-07 00:00:00', '2024-02-07 00:00:00'),
	(8, 1, 31, '2024-02-08 00:00:00', '2024-02-08 00:00:00'),
	(9, 1, 32, '2024-02-09 00:00:00', '2024-02-09 00:00:00'),
	(10, 1, 33, '2024-02-10 00:00:00', '2024-02-10 00:00:00'),
	(11, 1, 34, '2024-02-11 00:00:00', '2024-02-11 00:00:00'),
	(12, 1, 35, '2024-02-12 00:00:00', '2024-02-12 00:00:00'),
	(13, 1, 23, '2024-02-13 00:00:00', '2024-02-13 00:00:00'),
	(14, 1, 24, '2024-02-14 00:00:00', '2024-02-14 00:00:00'),
	(15, 1, 25, '2024-02-15 00:00:00', '2024-02-15 00:00:00'),
	(16, 1, 26, '2024-02-16 00:00:00', '2024-02-16 00:00:00'),
	(17, 1, 27, '2024-02-17 00:00:00', '2024-02-17 00:00:00'),
	(18, 1, 28, '2024-02-18 00:00:00', '2024-02-18 00:00:00'),
	(19, 1, 29, '2024-02-19 00:00:00', '2024-02-19 00:00:00'),
	(20, 1, 30, '2024-02-20 00:00:00', '2024-02-20 00:00:00'),
	(21, 1, 31, '2024-02-21 00:00:00', '2024-02-21 00:00:00'),
	(22, 1, 32, '2024-02-22 00:00:00', '2024-02-22 00:00:00'),
	(23, 1, 33, '2024-02-23 00:00:00', '2024-02-23 00:00:00'),
	(24, 1, 34, '2024-02-24 00:00:00', '2024-02-24 00:00:00'),
	(25, 1, 35, '2024-02-25 00:00:00', '2024-02-25 00:00:00'),
	(26, 1, 23, '2024-02-26 00:00:00', '2024-02-26 00:00:00'),
	(27, 1, 24, '2024-02-27 00:00:00', '2024-02-27 00:00:00'),
	(28, 1, 25, '2024-02-28 00:00:00', '2024-02-28 00:00:00'),
	(29, 1, 26, '2024-02-29 00:00:00', '2024-02-29 00:00:00'),
	(30, 1, 27, '2024-03-01 00:00:00', '2024-03-01 00:00:00');

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

-- Dumping data for table water-monitoring-system-db.sensors: ~1 rows (approximately)
DELETE FROM `sensors`;
INSERT INTO `sensors` (`sensor_id`, `device_id`, `parameter`) VALUES
	(1, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'TMP');

-- Dumping structure for table water-monitoring-system-db.sensor_notifications
CREATE TABLE IF NOT EXISTS `sensor_notifications` (
  `sensor_notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reading_id` int NOT NULL,
  `threshold_id` int NOT NULL,
  `issued_at` datetime NOT NULL DEFAULT (now()),
  `isRead` tinyint DEFAULT (0),
  `read_at` datetime DEFAULT NULL,
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

-- Dumping data for table water-monitoring-system-db.sensor_parameters: ~4 rows (approximately)
DELETE FROM `sensor_parameters`;
INSERT INTO `sensor_parameters` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', 'ppm'),
	('DO', 'Dissolved Oxygen', 'ppm'),
	('PH', 'pH', 'pH'),
	('SAL', 'Salinity', 'ppt'),
	('TMP', 'Temperature', '°C');

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

-- Dumping data for table water-monitoring-system-db.threshold_actions: ~2 rows (approximately)
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

-- Dumping data for table water-monitoring-system-db.threshold_types: ~2 rows (approximately)
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
	(1, 'Juan Dela', 'Vega', 'Cruz', 'test@gmail.com', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS'),
	(2, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS');

-- Dumping structure for table water-monitoring-system-db.user_notifications
CREATE TABLE IF NOT EXISTS `user_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` char(4) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT 'No Message',
  `issued_at` datetime NOT NULL DEFAULT (now()),
  `isRead` tinyint DEFAULT (0),
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notification_user_id` (`user_id`),
  KEY `notification_action` (`action`),
  CONSTRAINT `notification_action` FOREIGN KEY (`action`) REFERENCES `threshold_actions` (`action`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table water-monitoring-system-db.user_notifications: ~3 rows (approximately)
DELETE FROM `user_notifications`;
INSERT INTO `user_notifications` (`notification_id`, `user_id`, `action`, `message`, `issued_at`, `isRead`, `read_at`) VALUES
	(1, 1, 'INFO', 'Sample Message', '2024-03-03 17:34:01', 0, NULL),
	(2, 1, 'WARN', 'Sample Warn Message', '2024-03-03 17:34:23', 0, NULL),
	(3, 1, 'ALRT', 'Sample Alert Message', '2024-03-03 17:34:42', 0, NULL);

-- Dumping structure for view water-monitoring-system-db.view_dashboard_numbers
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_dashboard_numbers` (
	`farmer_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`ponds_monitored` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_farm
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_farm` (
	`user_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`address_street` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`address_city` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_ponds
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_ponds` (
	`user_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`status` VARCHAR(8) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farm_pond_sensor_parameter_reading_dump
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farm_pond_sensor_parameter_reading_dump` (
	`farm_name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`pond_name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`parameter` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`value` DOUBLE NOT NULL,
	`unit` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`modified_at` DATETIME NOT NULL,
	`recorded_at` DATETIME NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`sensor_id` INT(10) NOT NULL,
	`reading_id` INT(10) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_notification_count
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_notification_count` (
	`user_id` INT(10) NOT NULL,
	`notification_count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_sensors
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_sensors` (
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`sensor_id` INT(10) NOT NULL,
	`parameter` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`name` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`unit` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_dashboard_numbers`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_dashboard_numbers` AS select `farm_farmer`.`farmer_id` AS `farmer_id`,`farms`.`farm_id` AS `farm_id`,count(`ponds`.`device_id`) AS `ponds_monitored` from ((`farm_farmer` join `farms` on((`farm_farmer`.`farmer_id` = `farms`.`farm_id`))) join `ponds` on((`farms`.`farm_id` = `ponds`.`farm_id`))) group by `farm_farmer`.`farmer_id`,`farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_farm`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_farm` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`farms`.`name` AS `name`,`farms`.`address_street` AS `address_street`,`farms`.`address_city` AS `address_city` from (`farm_farmer` join `farms` on((`farm_farmer`.`farm_id` = `farms`.`farm_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_ponds`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_ponds` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`ponds`.`device_id` AS `device_id`,`ponds`.`name` AS `name`,`ponds`.`status` AS `status` from ((`ponds` join `farms` on((`ponds`.`farm_id` = `farms`.`farm_id`))) join `farm_farmer` on((`farms`.`farm_id` = `farm_farmer`.`farmer_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_pond_sensor_parameter_reading_dump`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_pond_sensor_parameter_reading_dump` AS select `farms`.`name` AS `farm_name`,`ponds`.`name` AS `pond_name`,`sensor_parameters`.`parameter` AS `parameter`,`readings`.`value` AS `value`,`sensor_parameters`.`unit` AS `unit`,`readings`.`modified_at` AS `modified_at`,`readings`.`recorded_at` AS `recorded_at`,`farms`.`farm_id` AS `farm_id`,`ponds`.`device_id` AS `device_id`,`sensors`.`sensor_id` AS `sensor_id`,`readings`.`reading_id` AS `reading_id` from ((((`readings` join `sensors` on((`readings`.`sensor_id` = `sensors`.`sensor_id`))) join `sensor_parameters` on((`sensor_parameters`.`parameter` = `sensors`.`parameter`))) join `ponds` on((`sensors`.`device_id` = `ponds`.`device_id`))) join `farms` on((`farms`.`farm_id` = `ponds`.`farm_id`))) order by `readings`.`recorded_at` desc;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_notification_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_notification_count` AS select `users`.`user_id` AS `user_id`,(count(`user_notifications`.`notification_id`) + count(`sensor_notifications`.`sensor_notification_id`)) AS `notification_count` from ((`users` left join `user_notifications` on((`user_notifications`.`user_id` = `users`.`user_id`))) left join `sensor_notifications` on((`user_notifications`.`user_id` = `sensor_notifications`.`user_id`))) where ((`user_notifications`.`isRead` = false) or (`sensor_notifications`.`isRead` = false)) group by `users`.`user_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_sensors`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_sensors` AS select `ponds`.`device_id` AS `device_id`,`sensors`.`sensor_id` AS `sensor_id`,`sensor_parameters`.`parameter` AS `parameter`,`sensor_parameters`.`name` AS `name`,`sensor_parameters`.`unit` AS `unit` from ((`sensors` join `sensor_parameters` on((`sensors`.`parameter` = `sensor_parameters`.`parameter`))) join `ponds` on((`sensors`.`device_id` = `ponds`.`device_id`)));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
