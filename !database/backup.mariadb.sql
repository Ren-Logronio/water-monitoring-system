-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.6.16-MariaDB-0ubuntu0.22.04.1 - Ubuntu 22.04
-- Server OS:                    debian-linux-gnu
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
CREATE DATABASE IF NOT EXISTS `water-monitoring-system-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `water-monitoring-system-db`;

-- Dumping structure for table water-monitoring-system-db.farms
CREATE TABLE IF NOT EXISTS `farms` (
  `farm_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `address_street` varchar(128) NOT NULL,
  `address_city` varchar(128) NOT NULL,
  `address_province` varchar(128) NOT NULL,
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farms: ~4 rows (approximately)
DELETE FROM `farms`;
INSERT INTO `farms` (`farm_id`, `name`, `address_street`, `address_city`, `address_province`) VALUES
	(1, 'RD Farm', 'Next Street', 'General Santos City', 'South Cotabato'),
	(2, 'MUDA Farm', 'React Street', 'General Santos City', 'South Cotabato'),
	(3, 'Innoendo Sea Exhibition', 'Tartar ', 'General Santos City', 'Basta ah'),
	(4, 'Aragazi Shrimp Factory', 'Lando Street', 'General Santos City', 'South Cotabato');

-- Dumping structure for table water-monitoring-system-db.farm_farmer
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int(11) NOT NULL,
  `farmer_id` int(11) NOT NULL,
  `role` char(5) NOT NULL DEFAULT 'STAFF',
  `is_approved` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`farm_id`,`farmer_id`),
  KEY `farm_farmer_id` (`farmer_id`),
  KEY `farm_farmer_role` (`role`),
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~2 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `is_approved`) VALUES
	(1, 1, 'OWNER', 1),
	(6, 2, 'OWNER', 1);

-- Dumping structure for table water-monitoring-system-db.ponds
CREATE TABLE IF NOT EXISTS `ponds` (
  `device_id` char(36) NOT NULL DEFAULT '',
  `farm_id` int(11) DEFAULT NULL,
  `name` varchar(32) NOT NULL DEFAULT 'My Pond',
  `status` varchar(8) NOT NULL DEFAULT 'INACTIVE',
  `width` double DEFAULT 0,
  `length` double DEFAULT 0,
  `depth` double DEFAULT 0,
  `method` varchar(50) DEFAULT 'NONE',
  PRIMARY KEY (`device_id`) USING BTREE,
  KEY `pond_farm_id` (`farm_id`),
  KEY `pond_status` (`status`),
  KEY `pond_method` (`method`),
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pond_method` FOREIGN KEY (`method`) REFERENCES `pond_methods` (`method`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `pond_status` FOREIGN KEY (`status`) REFERENCES `pond_statuses` (`status`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='INTENSIVE\r\nSEMI-INTENSIVE\r\nTRADITIONAL';

-- Dumping data for table water-monitoring-system-db.ponds: ~2 rows (approximately)
DELETE FROM `ponds`;
INSERT INTO `ponds` (`device_id`, `farm_id`, `name`, `status`, `width`, `length`, `depth`, `method`) VALUES
	('a0f8250e-49a7-4354-bf8c-bae94119a4fb', 1, 'Testing Pond', 'ACTIVE', 0, 0, 0, 'SEMI-INTENSIVE'),
	('e5b672a9-feba-490c-a987-a50fdca38441', 1, 'Virtual Pond', 'ACTIVE', 0, 0, 0, 'SEMI-INTENSIVE');

-- Dumping structure for table water-monitoring-system-db.pond_methods
CREATE TABLE IF NOT EXISTS `pond_methods` (
  `method` varchar(50) NOT NULL,
  PRIMARY KEY (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.pond_methods: ~5 rows (approximately)
DELETE FROM `pond_methods`;
INSERT INTO `pond_methods` (`method`) VALUES
	('INTENSIVE'),
	('NONE'),
	('SEMI-INTENSIVE'),
	('SUPER-INTENSIVE'),
	('TRADITIONAL');

-- Dumping structure for table water-monitoring-system-db.pond_statuses
CREATE TABLE IF NOT EXISTS `pond_statuses` (
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.pond_statuses: ~3 rows (approximately)
DELETE FROM `pond_statuses`;
INSERT INTO `pond_statuses` (`status`) VALUES
	('ACTIVE'),
	('IDLE'),
	('INACTIVE');

-- Dumping structure for table water-monitoring-system-db.readings
CREATE TABLE IF NOT EXISTS `readings` (
  `reading_id` int(11) NOT NULL AUTO_INCREMENT,
  `sensor_id` int(11) DEFAULT NULL,
  `value` double NOT NULL DEFAULT 0,
  `recorded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`reading_id`),
  KEY `reading_sensor_id` (`sensor_id`),
  CONSTRAINT `reading_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`sensor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.readings: ~30 rows (approximately)
DELETE FROM `readings`;
INSERT INTO `readings` (`reading_id`, `sensor_id`, `value`, `recorded_at`, `modified_at`) VALUES
	(1, 1, 28.4, '2024-02-01 00:00:00', '2024-03-04 06:49:43'),
	(2, 1, 28.5, '2024-02-02 00:00:00', '2024-03-04 06:49:57'),
	(3, 1, 30.2, '2024-02-03 00:00:00', '2024-03-04 06:49:50'),
	(4, 1, 21.1, '2024-02-04 00:00:00', '2024-03-04 06:49:46'),
	(5, 1, 24.2, '2024-02-05 00:00:00', '2024-03-04 06:56:27'),
	(6, 1, 25.99, '2024-02-06 00:00:00', '2024-03-04 06:50:28'),
	(7, 1, 30.56, '2024-02-07 00:00:00', '2024-03-04 06:50:32'),
	(8, 1, 31.9, '2024-02-08 00:00:00', '2024-03-04 06:50:39'),
	(9, 1, 32.2, '2024-02-09 00:00:00', '2024-03-04 06:50:37'),
	(10, 1, 27, '2024-02-10 00:00:00', '2024-03-04 06:50:46'),
	(11, 1, 26.7, '2024-02-11 00:00:00', '2024-03-04 06:50:43'),
	(12, 1, 29.4, '2024-02-12 00:00:00', '2024-03-04 06:50:50'),
	(13, 1, 23.1, '2024-02-13 00:00:00', '2024-03-04 06:50:56'),
	(14, 1, 24.6, '2024-02-14 00:00:00', '2024-03-04 06:50:53'),
	(15, 1, 25.17, '2024-02-15 00:00:00', '2024-03-05 01:13:10'),
	(16, 1, 26.36, '2024-02-16 00:00:00', '2024-03-04 06:51:16'),
	(17, 1, 28.2323232, '2024-02-17 00:00:00', '2024-03-05 01:13:24'),
	(18, 1, 27.89, '2024-02-18 00:00:00', '2024-03-04 06:51:58'),
	(19, 1, 29.2, '2024-02-19 00:00:00', '2024-03-04 06:51:05'),
	(20, 1, 25.23, '2024-02-20 00:00:00', '2024-03-04 06:51:50'),
	(21, 1, 27.4, '2024-02-21 00:00:00', '2024-03-04 06:51:41'),
	(22, 1, 32, '2024-02-22 00:00:00', '2024-02-22 00:00:00'),
	(23, 1, 33.1, '2024-02-23 00:00:00', '2024-03-04 06:51:02'),
	(24, 1, 34, '2024-02-24 00:00:00', '2024-02-24 00:00:00'),
	(25, 1, 35.87, '2024-02-25 00:00:00', '2024-03-04 06:51:20'),
	(26, 1, 23, '2024-02-26 00:00:00', '2024-02-26 00:00:00'),
	(27, 1, 24.3, '2024-02-27 00:00:00', '2024-03-04 06:51:11'),
	(28, 1, 25, '2024-02-28 00:00:00', '2024-02-28 00:00:00'),
	(29, 1, 26, '2024-02-29 00:00:00', '2024-02-29 00:00:00'),
	(30, 1, 27, '2024-03-01 00:00:00', '2024-03-01 00:00:00');

-- Dumping structure for table water-monitoring-system-db.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `role` char(5) NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.roles: ~2 rows (approximately)
DELETE FROM `roles`;
INSERT INTO `roles` (`role`) VALUES
	('OWNER'),
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.sensors
CREATE TABLE IF NOT EXISTS `sensors` (
  `sensor_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` char(36) NOT NULL,
  `parameter` varchar(3) NOT NULL,
  PRIMARY KEY (`sensor_id`),
  KEY `sensor_device_id` (`device_id`),
  KEY `sensor_parameter` (`parameter`),
  CONSTRAINT `sensor_parameter` FOREIGN KEY (`parameter`) REFERENCES `sensor_parameters` (`parameter`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.sensors: ~5 rows (approximately)
DELETE FROM `sensors`;
INSERT INTO `sensors` (`sensor_id`, `device_id`, `parameter`) VALUES
	(1, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'TMP'),
	(2, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'AMN'),
	(3, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'PH'),
	(4, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'SAL'),
	(5, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 'DO');

-- Dumping structure for table water-monitoring-system-db.sensor_notifications
CREATE TABLE IF NOT EXISTS `sensor_notifications` (
  `sensor_notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `reading_id` int(11) NOT NULL,
  `threshold_id` int(11) NOT NULL,
  `issued_at` datetime NOT NULL DEFAULT current_timestamp(),
  `isRead` tinyint(4) DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`sensor_notification_id`),
  KEY `sensor_notification_threshold_id` (`threshold_id`),
  KEY `sensor_notification_reading_id` (`reading_id`),
  KEY `sensor_notification_user_id` (`user_id`),
  CONSTRAINT `sensor_notification_reading_id` FOREIGN KEY (`reading_id`) REFERENCES `readings` (`reading_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_threshold_id` FOREIGN KEY (`threshold_id`) REFERENCES `thresholds` (`threshold_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.sensor_notifications: ~0 rows (approximately)
DELETE FROM `sensor_notifications`;

-- Dumping structure for table water-monitoring-system-db.sensor_parameters
CREATE TABLE IF NOT EXISTS `sensor_parameters` (
  `parameter` varchar(3) NOT NULL,
  `name` varchar(16) NOT NULL,
  `unit` varchar(16) NOT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.sensor_parameters: ~5 rows (approximately)
DELETE FROM `sensor_parameters`;
INSERT INTO `sensor_parameters` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', 'ppm'),
	('DO', 'Dissolved Oxygen', 'ppm'),
	('PH', 'pH', 'pH'),
	('SAL', 'Salinity', 'ppt'),
	('TMP', 'Temperature', '°C');

-- Dumping structure for table water-monitoring-system-db.thresholds
CREATE TABLE IF NOT EXISTS `thresholds` (
  `threshold_id` int(11) NOT NULL AUTO_INCREMENT,
  `sensor_id` int(11) NOT NULL,
  `type` char(2) NOT NULL,
  `action` char(4) NOT NULL,
  `target` double NOT NULL DEFAULT 0,
  `error` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`threshold_id`),
  KEY `threshold_sensor_id` (`sensor_id`),
  KEY `threshold_type` (`type`),
  KEY `threshold_action` (`action`),
  CONSTRAINT `threshold_action` FOREIGN KEY (`action`) REFERENCES `threshold_actions` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `threshold_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`sensor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `threshold_type` FOREIGN KEY (`type`) REFERENCES `threshold_types` (`type`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.thresholds: ~0 rows (approximately)
DELETE FROM `thresholds`;

-- Dumping structure for table water-monitoring-system-db.threshold_actions
CREATE TABLE IF NOT EXISTS `threshold_actions` (
  `action` char(4) NOT NULL,
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.threshold_types: ~3 rows (approximately)
DELETE FROM `threshold_types`;
INSERT INTO `threshold_types` (`type`) VALUES
	('EQ'),
	('GT'),
	('LT');

-- Dumping structure for table water-monitoring-system-db.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(64) NOT NULL,
  `middlename` varchar(64) DEFAULT NULL,
  `lastname` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(128) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `password` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.users: ~2 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(1, 'Juan Dela', 'Vega', 'Cruz', 'test@gmail.com', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS'),
	(2, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS');

-- Dumping structure for table water-monitoring-system-db.user_notifications
CREATE TABLE IF NOT EXISTS `user_notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` char(4) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT 'No Message',
  `issued_at` datetime NOT NULL DEFAULT current_timestamp(),
  `isRead` tinyint(4) DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notification_user_id` (`user_id`),
  KEY `notification_action` (`action`),
  CONSTRAINT `notification_action` FOREIGN KEY (`action`) REFERENCES `threshold_actions` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.user_notifications: ~0 rows (approximately)
DELETE FROM `user_notifications`;

-- Dumping structure for view water-monitoring-system-db.view_dashboard_numbers
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_dashboard_numbers` (
	`farmer_id` INT(11) NOT NULL,
	`farm_id` INT(11) NOT NULL,
	`ponds_monitored` BIGINT(21) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_farm
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_farm` (
	`user_id` INT(11) NOT NULL,
	`farm_id` INT(11) NOT NULL,
	`name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_street` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_city` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`is_approved` TINYINT(4) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_ponds
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_ponds` (
	`farm_id` INT(11) NOT NULL,
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`status` VARCHAR(8) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`width` DOUBLE NULL,
	`length` DOUBLE NULL,
	`depth` DOUBLE NULL,
	`method` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farm_pond_sensor_parameter_reading_dump
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farm_pond_sensor_parameter_reading_dump` (
	`farm_name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`pond_name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`parameter` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`value` DOUBLE NOT NULL,
	`unit` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`modified_at` DATETIME NOT NULL,
	`recorded_at` DATETIME NOT NULL,
	`farm_id` INT(11) NOT NULL,
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`sensor_id` INT(11) NOT NULL,
	`reading_id` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_notification_count
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_notification_count` (
	`user_id` INT(11) NOT NULL,
	`notification_count` BIGINT(22) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_sensors
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_sensors` (
	`device_id` CHAR(36) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`sensor_id` INT(11) NOT NULL,
	`parameter` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`name` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`unit` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_dashboard_numbers`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_dashboard_numbers` AS select `farm_farmer`.`farmer_id` AS `farmer_id`,`farms`.`farm_id` AS `farm_id`,count(`ponds`.`device_id`) AS `ponds_monitored` from ((`farm_farmer` join `farms` on(`farm_farmer`.`farmer_id` = `farms`.`farm_id`)) join `ponds` on(`farms`.`farm_id` = `ponds`.`farm_id`)) group by `farm_farmer`.`farmer_id`,`farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_farm`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_farm` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`farms`.`name` AS `name`,`farms`.`address_street` AS `address_street`,`farms`.`address_city` AS `address_city`,`farm_farmer`.`is_approved` AS `is_approved` from (`farm_farmer` join `farms` on(`farm_farmer`.`farm_id` = `farms`.`farm_id`));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_ponds`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_ponds` AS select `farms`.`farm_id` AS `farm_id`,`ponds`.`device_id` AS `device_id`,`ponds`.`name` AS `name`,`ponds`.`status` AS `status`,`ponds`.`width` AS `width`,`ponds`.`length` AS `length`,`ponds`.`depth` AS `depth`,`ponds`.`method` AS `method` from (`ponds` join `farms` on(`ponds`.`farm_id` = `farms`.`farm_id`));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_pond_sensor_parameter_reading_dump`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_pond_sensor_parameter_reading_dump` AS select `farms`.`name` AS `farm_name`,`ponds`.`name` AS `pond_name`,`sensor_parameters`.`parameter` AS `parameter`,`readings`.`value` AS `value`,`sensor_parameters`.`unit` AS `unit`,`readings`.`modified_at` AS `modified_at`,`readings`.`recorded_at` AS `recorded_at`,`farms`.`farm_id` AS `farm_id`,`ponds`.`device_id` AS `device_id`,`sensors`.`sensor_id` AS `sensor_id`,`readings`.`reading_id` AS `reading_id` from ((((`readings` join `sensors` on(`readings`.`sensor_id` = `sensors`.`sensor_id`)) join `sensor_parameters` on(`sensor_parameters`.`parameter` = `sensors`.`parameter`)) join `ponds` on(`sensors`.`device_id` = `ponds`.`device_id`)) join `farms` on(`farms`.`farm_id` = `ponds`.`farm_id`)) order by `readings`.`recorded_at` desc;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_notification_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_notification_count` AS select `users`.`user_id` AS `user_id`,count(`user_notifications`.`notification_id`) + count(`sensor_notifications`.`sensor_notification_id`) AS `notification_count` from ((`users` left join `user_notifications` on(`user_notifications`.`user_id` = `users`.`user_id`)) left join `sensor_notifications` on(`user_notifications`.`user_id` = `sensor_notifications`.`user_id`)) where `user_notifications`.`isRead` = 0 or `sensor_notifications`.`isRead` = 0 group by `users`.`user_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_sensors`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_sensors` AS select `ponds`.`device_id` AS `device_id`,`sensors`.`sensor_id` AS `sensor_id`,`sensor_parameters`.`parameter` AS `parameter`,`sensor_parameters`.`name` AS `name`,`sensor_parameters`.`unit` AS `unit` from ((`sensors` join `sensor_parameters` on(`sensors`.`parameter` = `sensor_parameters`.`parameter`)) join `ponds` on(`sensors`.`device_id` = `ponds`.`device_id`));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
