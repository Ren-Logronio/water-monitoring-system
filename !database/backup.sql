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
CREATE DATABASE IF NOT EXISTS `water-monitoring-system-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `water-monitoring-system-db`;

-- Dumping structure for table water-monitoring-system-db.devices
CREATE TABLE IF NOT EXISTS `devices` (
  `device_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDLE',
  `last_established_connection` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`),
  KEY `device_status` (`status`),
  CONSTRAINT `device_status` FOREIGN KEY (`status`) REFERENCES `device_statuses` (`status`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.devices: ~0 rows (approximately)
DELETE FROM `devices`;

-- Dumping structure for table water-monitoring-system-db.device_statuses
CREATE TABLE IF NOT EXISTS `device_statuses` (
  `status` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.device_statuses: ~3 rows (approximately)
DELETE FROM `device_statuses`;
INSERT INTO `device_statuses` (`status`) VALUES
	('ACTIVE'),
	('IDLE'),
	('INACTIVE');

-- Dumping structure for table water-monitoring-system-db.farms
CREATE TABLE IF NOT EXISTS `farms` (
  `farm_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_street` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_city` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_province` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`farm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farms: ~2 rows (approximately)
DELETE FROM `farms`;
INSERT INTO `farms` (`farm_id`, `name`, `address_street`, `address_city`, `address_province`) VALUES
	(1, 'R&D Shrimps Inc.', 'Siguel Road', 'General Santos City', 'South Cotabato');

-- Dumping structure for table water-monitoring-system-db.farm_farmer
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int NOT NULL,
  `farmer_id` int NOT NULL,
  `role` char(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STAFF',
  `is_approved` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`farm_id`,`farmer_id`),
  UNIQUE KEY `farmer_id` (`farmer_id`),
  KEY `farm_farmer_id` (`farmer_id`),
  KEY `farm_farmer_role` (`role`),
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `farm_farmer_roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~2 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `is_approved`) VALUES
	(1, 1, 'OWNER', 1);

-- Dumping structure for table water-monitoring-system-db.farm_farmer_roles
CREATE TABLE IF NOT EXISTS `farm_farmer_roles` (
  `role` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer_roles: ~2 rows (approximately)
DELETE FROM `farm_farmer_roles`;
INSERT INTO `farm_farmer_roles` (`role`) VALUES
	('OWNER'),
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.parameters
CREATE TABLE IF NOT EXISTS `parameters` (
  `parameter_id` int NOT NULL AUTO_INCREMENT,
  `pond_id` int DEFAULT NULL,
  `parameter` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`parameter_id`),
  KEY `parameter_pond_id` (`pond_id`),
  KEY `parameter_parameter` (`parameter`),
  CONSTRAINT `parameter_parameter` FOREIGN KEY (`parameter`) REFERENCES `parameter_list` (`parameter`),
  CONSTRAINT `parameter_pond_id` FOREIGN KEY (`pond_id`) REFERENCES `ponds` (`pond_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameters: ~8 rows (approximately)
DELETE FROM `parameters`;
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(13, 1, 'TMP'),
	(14, 1, 'PH'),
	(15, 1, 'TDS'),
	(16, 1, 'AMN');

-- Dumping structure for table water-monitoring-system-db.parameter_list
CREATE TABLE IF NOT EXISTS `parameter_list` (
  `parameter` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_list: ~4 rows (approximately)
DELETE FROM `parameter_list`;
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', 'ppm'),
	('PH', 'pH', 'pH'),
	('TDS', 'Total Dissolved Solids', 'tds'),
	('TMP', 'Temperature', '°C');

-- Dumping structure for table water-monitoring-system-db.parameter_thresholds
CREATE TABLE IF NOT EXISTS `parameter_thresholds` (
  `threshold_id` int NOT NULL AUTO_INCREMENT,
  `parameter` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target` double NOT NULL DEFAULT '0',
  `error` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`threshold_id`),
  KEY `default_threshold_parameter` (`parameter`),
  KEY `default_threshold_type` (`type`),
  KEY `default_threshold_action` (`action`),
  CONSTRAINT `default_threshold_action` FOREIGN KEY (`action`) REFERENCES `parameter_threshold_actions` (`action`),
  CONSTRAINT `default_threshold_parameter` FOREIGN KEY (`parameter`) REFERENCES `parameter_list` (`parameter`),
  CONSTRAINT `default_threshold_type` FOREIGN KEY (`type`) REFERENCES `parameter_threshold_types` (`type`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_thresholds: ~6 rows (approximately)
DELETE FROM `parameter_thresholds`;
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(1, 'TMP', 'GT', 'WARN', 30, 2),
	(2, 'TMP', 'LT', 'WARN', 20, 2),
	(3, 'AMN', 'GT', 'ALRT', 1, 0.2),
	(4, 'PH', 'GT', 'ALRT', 9, 0.2),
	(5, 'PH', 'LT', 'ALRT', 6, 0.2),
	(6, 'TDS', 'GT', 'WARN', 500, 50);

-- Dumping structure for table water-monitoring-system-db.parameter_threshold_actions
CREATE TABLE IF NOT EXISTS `parameter_threshold_actions` (
  `action` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_threshold_actions: ~3 rows (approximately)
DELETE FROM `parameter_threshold_actions`;
INSERT INTO `parameter_threshold_actions` (`action`) VALUES
	('ALRT'),
	('INFO'),
	('WARN');

-- Dumping structure for table water-monitoring-system-db.parameter_threshold_types
CREATE TABLE IF NOT EXISTS `parameter_threshold_types` (
  `type` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_threshold_types: ~3 rows (approximately)
DELETE FROM `parameter_threshold_types`;
INSERT INTO `parameter_threshold_types` (`type`) VALUES
	('EQ'),
	('GT'),
	('LT');

-- Dumping structure for table water-monitoring-system-db.ponds
CREATE TABLE IF NOT EXISTS `ponds` (
  `pond_id` int NOT NULL AUTO_INCREMENT,
  `device_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `farm_id` int DEFAULT NULL,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'My Pond',
  `width` double DEFAULT '0',
  `length` double DEFAULT '0',
  `depth` double DEFAULT '0',
  `method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'NONE',
  PRIMARY KEY (`pond_id`) USING BTREE,
  KEY `pond_farm_id` (`farm_id`),
  KEY `pond_method` (`method`),
  KEY `pond_device_id` (`device_id`),
  CONSTRAINT `pond_device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE SET NULL,
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pond_method` FOREIGN KEY (`method`) REFERENCES `pond_methods` (`method`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='INTENSIVE\r\nSEMI-INTENSIVE\r\nTRADITIONAL';

-- Dumping data for table water-monitoring-system-db.ponds: ~2 rows (approximately)
DELETE FROM `ponds`;
INSERT INTO `ponds` (`pond_id`, `device_id`, `farm_id`, `name`, `width`, `length`, `depth`, `method`) VALUES
	(1, NULL, 1, 'Sample Pond', 0, 0, 0, 'SEMI-INTENSIVE');

-- Dumping structure for table water-monitoring-system-db.pond_methods
CREATE TABLE IF NOT EXISTS `pond_methods` (
  `method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
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

-- Dumping structure for table water-monitoring-system-db.readings
CREATE TABLE IF NOT EXISTS `readings` (
  `reading_id` int NOT NULL AUTO_INCREMENT,
  `parameter_id` int DEFAULT NULL,
  `value` double NOT NULL DEFAULT '0',
  `recorded_at` timestamp NOT NULL DEFAULT (now()),
  `modified_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `isRecordedBySensor` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`reading_id`),
  KEY `reading_parameter_id` (`parameter_id`),
  CONSTRAINT `reading_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`parameter_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.readings: ~6 rows (approximately)
DELETE FROM `readings`;

-- Dumping structure for table water-monitoring-system-db.reading_notifications
CREATE TABLE IF NOT EXISTS `reading_notifications` (
  `reading_notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reading_id` int NOT NULL,
  `threshold_id` int NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `isRead` tinyint DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`reading_notification_id`) USING BTREE,
  KEY `sensor_notification_threshold_id` (`threshold_id`),
  KEY `sensor_notification_reading_id` (`reading_id`),
  KEY `sensor_notification_user_id` (`user_id`),
  CONSTRAINT `FK_reading_notifications_parameter_thresholds` FOREIGN KEY (`threshold_id`) REFERENCES `parameter_thresholds` (`threshold_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_reading_id` FOREIGN KEY (`reading_id`) REFERENCES `readings` (`reading_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.reading_notifications: ~0 rows (approximately)
DELETE FROM `reading_notifications`;

-- Dumping structure for table water-monitoring-system-db.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middlename` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.users: ~3 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(1, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$97pPAfoi/KcoKNeaUwYJAOqTV4fKMU6WpGBETtmswdHeiGppnlDpK'),
	(2, 'John Rey', NULL, 'Vilbar', 'johnrey.vilbar@msugensan.edu.ph', '$2a$12$JR3OLT2XOTvWV0G5tTYUpeXkhxy5IXSHju7JXS6MKDxbGZI3Ix0rm'),
	(3, 'Nielmer', NULL, 'Camintoy', 'nielmer.camintoy@msugensan.edu.ph', '$2a$12$/9c02UGSKL4.RB9OmZWbRewJHa0TX.s48uUXIqK6GABg9LyTFubqK');

-- Dumping structure for table water-monitoring-system-db.user_notifications
CREATE TABLE IF NOT EXISTS `user_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'No Message',
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isRead` tinyint DEFAULT '0',
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notification_user_id` (`user_id`),
  KEY `notification_action` (`action`),
  CONSTRAINT `notification_action` FOREIGN KEY (`action`) REFERENCES `parameter_threshold_actions` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.user_notifications: ~0 rows (approximately)
DELETE FROM `user_notifications`;

-- Dumping structure for view water-monitoring-system-db.view_dashboard_ponds_monitored
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_dashboard_ponds_monitored` (
	`farmer_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`ponds_monitored` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_farm
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_farm` (
	`user_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_street` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_city` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_province` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`is_approved` TINYINT(3) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_ponds
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_ponds` (
	`user_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`pond_id` INT(10) NOT NULL,
	`device_id` CHAR(36) NULL COLLATE 'utf8mb4_unicode_ci',
	`status` VARCHAR(8) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_established_connection` TIMESTAMP NULL,
	`name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`width` DOUBLE NULL,
	`length` DOUBLE NULL,
	`depth` DOUBLE NULL,
	`method` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farm_farmers
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farm_farmers` (
	`farm_id` INT(10) NOT NULL,
	`farmer_id` INT(10) NOT NULL,
	`role` CHAR(5) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`is_approved` TINYINT(3) NOT NULL,
	`user_id` INT(10) NOT NULL,
	`firstname` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`middlename` VARCHAR(64) NULL COLLATE 'utf8mb4_unicode_ci',
	`lastname` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`email` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`password` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farm_reading_count
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farm_reading_count` (
	`farm_id` INT(10) NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_parameters
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_parameters` (
	`parameter_id` INT(10) NOT NULL,
	`pond_id` INT(10) NULL,
	`parameter` VARCHAR(3) NULL COLLATE 'utf8mb4_unicode_ci',
	`name` VARCHAR(64) NULL COLLATE 'utf8mb4_unicode_ci',
	`unit` VARCHAR(16) NULL COLLATE 'utf8mb4_unicode_ci',
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_parameter_readings
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_parameter_readings` (
	`pond_id` INT(10) NOT NULL,
	`parameter_id` INT(10) NOT NULL,
	`reading_id` INT(10) NOT NULL,
	`parameter` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`name` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`unit` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`value` DOUBLE NOT NULL,
	`recorded_at` TIMESTAMP NOT NULL,
	`modified_at` TIMESTAMP NOT NULL,
	`isRecordedBySensor` TINYINT(3) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_reading_notifications
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_reading_notifications` (
	`reading_notification_id` INT(10) NOT NULL,
	`user_id` INT(10) NOT NULL,
	`issued_at` TIMESTAMP NOT NULL,
	`isRead` TINYINT(3) NULL,
	`read_at` TIMESTAMP NULL,
	`threshold_id` INT(10) NULL,
	`parameter` VARCHAR(3) NULL COLLATE 'utf8mb4_unicode_ci',
	`parameter_name` VARCHAR(64) NULL COLLATE 'utf8mb4_unicode_ci',
	`unit` VARCHAR(16) NULL COLLATE 'utf8mb4_unicode_ci',
	`type` CHAR(2) NULL COLLATE 'utf8mb4_unicode_ci',
	`action` CHAR(4) NULL COLLATE 'utf8mb4_unicode_ci',
	`target` DOUBLE NULL,
	`reading_id` INT(10) NULL,
	`value` DOUBLE NULL,
	`recorded_at` TIMESTAMP NULL,
	`isRecordedBySensor` TINYINT(3) NULL,
	`parameter_id` INT(10) NULL,
	`pond_id` INT(10) NULL,
	`pond_name` VARCHAR(32) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_reading_notifications_count
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_reading_notifications_count` (
	`user_id` INT(10) NOT NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_user_notifications_count
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_user_notifications_count` (
	`user_id` INT(10) NOT NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for trigger water-monitoring-system-db.parameters_after_pond_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `parameters_after_pond_insert` AFTER INSERT ON `ponds` FOR EACH ROW BEGIN
	INSERT INTO parameters (pond_id, parameter)VALUES
      (NEW.pond_id, 'TMP'),
      (NEW.pond_id, 'PH'),
      (NEW.pond_id, 'TDS'),
      (NEW.pond_id, 'AMN');
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_dashboard_ponds_monitored`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_dashboard_ponds_monitored` AS select `farm_farmer`.`farmer_id` AS `farmer_id`,`farms`.`farm_id` AS `farm_id`,count(`ponds`.`device_id`) AS `ponds_monitored` from ((`farm_farmer` join `farms` on((`farm_farmer`.`farmer_id` = `farms`.`farm_id`))) join `ponds` on((`farms`.`farm_id` = `ponds`.`farm_id`))) group by `farm_farmer`.`farmer_id`,`farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_farm`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_farm` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`farms`.`name` AS `name`,`farms`.`address_street` AS `address_street`,`farms`.`address_city` AS `address_city`,`farms`.`address_province` AS `address_province`,`farm_farmer`.`is_approved` AS `is_approved` from (`farm_farmer` join `farms` on((`farm_farmer`.`farm_id` = `farms`.`farm_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_ponds`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_ponds` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`ponds`.`pond_id` AS `pond_id`,`ponds`.`device_id` AS `device_id`,`devices`.`status` AS `status`,`devices`.`last_established_connection` AS `last_established_connection`,`ponds`.`name` AS `name`,`ponds`.`width` AS `width`,`ponds`.`length` AS `length`,`ponds`.`depth` AS `depth`,`ponds`.`method` AS `method` from (((`ponds` left join `devices` on((`ponds`.`device_id` = `devices`.`device_id`))) join `farms` on((`ponds`.`farm_id` = `farms`.`farm_id`))) join `farm_farmer` on((`farm_farmer`.`farm_id` = `farms`.`farm_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_farmers`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_farmers` AS select `farm_farmer`.`farm_id` AS `farm_id`,`farm_farmer`.`farmer_id` AS `farmer_id`,`farm_farmer`.`role` AS `role`,`farm_farmer`.`is_approved` AS `is_approved`,`users`.`user_id` AS `user_id`,`users`.`firstname` AS `firstname`,`users`.`middlename` AS `middlename`,`users`.`lastname` AS `lastname`,`users`.`email` AS `email`,`users`.`password` AS `password` from (`farm_farmer` join `users` on((`farm_farmer`.`farmer_id` = `users`.`user_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_reading_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_reading_count` AS select `farms`.`farm_id` AS `farm_id`,count(`view_pond_parameter_readings`.`reading_id`) AS `count` from ((`view_pond_parameter_readings` left join `ponds` on((`view_pond_parameter_readings`.`pond_id` = `ponds`.`pond_id`))) left join `farms` on((`ponds`.`farm_id` = `farms`.`farm_id`))) group by `farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_parameters`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_parameters` AS select `parameters`.`parameter_id` AS `parameter_id`,`parameters`.`pond_id` AS `pond_id`,`parameter_list`.`parameter` AS `parameter`,`parameter_list`.`name` AS `name`,`parameter_list`.`unit` AS `unit`,count(`readings`.`reading_id`) AS `count` from ((`parameters` left join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) left join `readings` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) group by `parameters`.`parameter_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_parameter_readings`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_parameter_readings` AS select `ponds`.`pond_id` AS `pond_id`,`parameters`.`parameter_id` AS `parameter_id`,`readings`.`reading_id` AS `reading_id`,`parameters`.`parameter` AS `parameter`,`parameter_list`.`name` AS `name`,`parameter_list`.`unit` AS `unit`,`readings`.`value` AS `value`,`readings`.`recorded_at` AS `recorded_at`,`readings`.`modified_at` AS `modified_at`,`readings`.`isRecordedBySensor` AS `isRecordedBySensor` from (((`readings` join `parameters` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) join `ponds` on((`parameters`.`pond_id` = `ponds`.`pond_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_reading_notifications`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_reading_notifications` AS select `reading_notifications`.`reading_notification_id` AS `reading_notification_id`,`reading_notifications`.`user_id` AS `user_id`,`reading_notifications`.`issued_at` AS `issued_at`,`reading_notifications`.`isRead` AS `isRead`,`reading_notifications`.`read_at` AS `read_at`,`parameter_thresholds`.`threshold_id` AS `threshold_id`,`parameter_thresholds`.`parameter` AS `parameter`,`parameter_list`.`name` AS `parameter_name`,`parameter_list`.`unit` AS `unit`,`parameter_thresholds`.`type` AS `type`,`parameter_thresholds`.`action` AS `action`,`parameter_thresholds`.`target` AS `target`,`readings`.`reading_id` AS `reading_id`,`readings`.`value` AS `value`,`readings`.`recorded_at` AS `recorded_at`,`readings`.`isRecordedBySensor` AS `isRecordedBySensor`,`parameters`.`parameter_id` AS `parameter_id`,`ponds`.`pond_id` AS `pond_id`,`ponds`.`name` AS `pond_name` from (((((`reading_notifications` left join `parameter_thresholds` on((`reading_notifications`.`threshold_id` = `parameter_thresholds`.`threshold_id`))) left join `readings` on((`reading_notifications`.`reading_id` = `readings`.`reading_id`))) left join `parameters` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) left join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) left join `ponds` on((`parameters`.`pond_id` = `ponds`.`pond_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_reading_notifications_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_reading_notifications_count` AS select `users`.`user_id` AS `user_id`,count(`reading_notifications`.`reading_notification_id`) AS `count` from (`users` left join `reading_notifications` on((`users`.`user_id` = `reading_notifications`.`user_id`))) where (`reading_notifications`.`isRead` = false) group by `users`.`user_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_user_notifications_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_user_notifications_count` AS select `users`.`user_id` AS `user_id`,count(`user_notifications`.`notification_id`) AS `count` from (`users` left join `user_notifications` on((`users`.`user_id` = `user_notifications`.`user_id`))) where (`user_notifications`.`isRead` = false) group by `users`.`user_id`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
