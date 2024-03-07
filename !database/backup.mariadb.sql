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

-- Dumping structure for table water-monitoring-system-db.farmer
CREATE TABLE IF NOT EXISTS `farmer` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(64) NOT NULL,
  `middlename` varchar(64) DEFAULT NULL,
  `lastname` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(128) NOT NULL,
  `profile` mediumblob DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `password` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farmer: ~2 rows (approximately)
DELETE FROM `farmer`;
INSERT INTO `farmer` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`, `profile`) VALUES
	(1, 'Juan Dela', 'Vega', 'Cruz', 'test@gmail.com', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS', NULL),
	(2, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$ZpPBPSV7AbJboSqL/UNA2O7gnnlVnYaqHpEc5Fc2SoU59KNSigRfS', NULL);

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
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `farm_farmer_roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~3 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `is_approved`) VALUES
	(1, 1, 'OWNER', 1),
	(1, 2, 'STAFF', 0),
	(6, 2, 'OWNER', 1);

-- Dumping structure for table water-monitoring-system-db.farm_farmer_roles
CREATE TABLE IF NOT EXISTS `farm_farmer_roles` (
  `role` char(5) NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer_roles: ~2 rows (approximately)
DELETE FROM `farm_farmer_roles`;
INSERT INTO `farm_farmer_roles` (`role`) VALUES
	('OWNER'),
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.parameters
CREATE TABLE IF NOT EXISTS `parameters` (
  `parameter_id` int(11) NOT NULL AUTO_INCREMENT,
  `pond_id` int(11) DEFAULT NULL,
  `parameter` varchar(3) NOT NULL,
  PRIMARY KEY (`parameter_id`),
  KEY `sensor_parameter` (`parameter`),
  KEY `parameter_pond_id` (`pond_id`),
  CONSTRAINT `parameter_list` FOREIGN KEY (`parameter`) REFERENCES `parameter_list` (`parameter`) ON UPDATE CASCADE,
  CONSTRAINT `parameter_pond_id` FOREIGN KEY (`pond_id`) REFERENCES `ponds` (`pond_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameters: ~5 rows (approximately)
DELETE FROM `parameters`;
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(1, 1, 'TMP'),
	(2, 1, 'SAL'),
	(3, 1, 'PH'),
	(4, 1, 'DO'),
	(5, 1, 'AMN');

-- Dumping structure for table water-monitoring-system-db.parameter_list
CREATE TABLE IF NOT EXISTS `parameter_list` (
  `parameter` varchar(3) NOT NULL,
  `name` varchar(16) NOT NULL,
  `unit` varchar(16) NOT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_list: ~5 rows (approximately)
DELETE FROM `parameter_list`;
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', 'ppm'),
	('DO', 'Dissolved Oxygen', 'ppm'),
	('PH', 'pH', 'pH'),
	('SAL', 'Salinity', 'ppt'),
	('TMP', 'Temperature', '°C');

-- Dumping structure for table water-monitoring-system-db.parameter_thresholds
CREATE TABLE IF NOT EXISTS `parameter_thresholds` (
  `threshold_id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_id` int(11) NOT NULL,
  `type` char(2) NOT NULL,
  `action` char(4) NOT NULL,
  `target` double NOT NULL DEFAULT 0,
  `error` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`threshold_id`),
  KEY `threshold_type` (`type`),
  KEY `threshold_action` (`action`),
  KEY `threshold_sensor_id` (`parameter_id`) USING BTREE,
  CONSTRAINT `threshold_action` FOREIGN KEY (`action`) REFERENCES `parameter_threshold_actions` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `threshold_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`parameter_id`) ON UPDATE CASCADE,
  CONSTRAINT `threshold_type` FOREIGN KEY (`type`) REFERENCES `parameter_threshold_types` (`type`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_thresholds: ~0 rows (approximately)
DELETE FROM `parameter_thresholds`;

-- Dumping structure for table water-monitoring-system-db.parameter_threshold_actions
CREATE TABLE IF NOT EXISTS `parameter_threshold_actions` (
  `action` char(4) NOT NULL,
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
  `type` char(2) NOT NULL,
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
  `pond_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` char(36) NOT NULL DEFAULT 'NO DEVICE',
  `farm_id` int(11) DEFAULT NULL,
  `name` varchar(32) NOT NULL DEFAULT 'My Pond',
  `status` varchar(8) NOT NULL DEFAULT 'INACTIVE',
  `width` double DEFAULT 0,
  `length` double DEFAULT 0,
  `depth` double DEFAULT 0,
  `method` varchar(50) DEFAULT 'NONE',
  PRIMARY KEY (`pond_id`,`device_id`),
  KEY `pond_farm_id` (`farm_id`),
  KEY `pond_status` (`status`),
  KEY `pond_method` (`method`),
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pond_method` FOREIGN KEY (`method`) REFERENCES `pond_methods` (`method`) ON UPDATE CASCADE,
  CONSTRAINT `pond_status` FOREIGN KEY (`status`) REFERENCES `pond_statuses` (`status`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='INTENSIVE\r\nSEMI-INTENSIVE\r\nTRADITIONAL';

-- Dumping data for table water-monitoring-system-db.ponds: ~2 rows (approximately)
DELETE FROM `ponds`;
INSERT INTO `ponds` (`pond_id`, `device_id`, `farm_id`, `name`, `status`, `width`, `length`, `depth`, `method`) VALUES
	(1, 'a0f8250e-49a7-4354-bf8c-bae94119a4fb', 1, 'Testing Pond', 'ACTIVE', 0, 0, 0, 'SEMI-INTENSIVE'),
	(2, 'e5b672a9-feba-490c-a987-a50fdca38441', 1, 'Virtual Pond', 'ACTIVE', 0, 0, 0, 'SEMI-INTENSIVE');

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
  `parameter_id` int(11) DEFAULT NULL,
  `value` double NOT NULL DEFAULT 0,
  `recorded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isRecordedBySensor` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`reading_id`),
  KEY `reading_parameter_id` (`parameter_id`),
  CONSTRAINT `reading_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`parameter_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.readings: ~25 rows (approximately)
DELETE FROM `readings`;
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(1, 1, 25, '2024-02-07 10:06:32', '2024-03-07 10:07:02', 1),
	(2, 1, 26, '2024-02-08 10:07:22', '2024-03-07 10:07:28', 1),
	(3, 1, 25.88, '2024-02-09 10:07:50', '2024-03-07 10:07:56', 1),
	(4, 1, 24.45, '2024-02-10 10:08:19', '2024-03-07 10:08:27', 1),
	(5, 1, 23.89, '2024-02-11 10:08:42', '2024-03-07 10:13:46', 1),
	(6, 2, 18.56, '2024-02-07 10:14:01', '2024-03-07 10:15:24', 1),
	(7, 2, 19.23, '2024-02-08 10:15:36', '2024-03-07 10:15:42', 1),
	(8, 2, 18.6, '2024-02-09 10:15:55', '2024-03-07 10:16:26', 1),
	(9, 2, 18.45, '2024-02-10 10:16:44', '2024-03-07 10:16:51', 1),
	(10, 2, 19.1, '2024-02-11 10:16:56', '2024-03-07 10:17:08', 1),
	(11, 3, 8.54, '2024-02-07 10:17:24', '2024-03-07 10:17:33', 1),
	(12, 3, 8.2, '2024-02-08 10:17:45', '2024-03-07 10:17:49', 1),
	(13, 3, 8.31, '2024-02-09 10:18:02', '2024-03-07 10:18:13', 1),
	(14, 3, 8.43, '2024-02-10 10:18:25', '2024-03-07 10:18:31', 1),
	(15, 3, 8.18, '2024-02-11 10:18:41', '2024-03-07 10:18:47', 1),
	(16, 4, 4.35, '2024-02-07 10:19:26', '2024-03-07 10:19:29', 1),
	(17, 4, 4.25, '2024-02-08 10:19:40', '2024-03-07 10:19:44', 1),
	(18, 4, 4.87, '2024-02-09 10:19:54', '2024-03-07 10:20:00', 1),
	(19, 4, 4.3, '2024-02-10 10:20:12', '2024-03-07 10:20:16', 1),
	(20, 4, 4.239, '2024-02-11 10:20:29', '2024-03-07 10:20:33', 1),
	(21, 5, 0.345, '2024-02-07 10:21:30', '2024-03-07 10:21:37', 1),
	(22, 5, 0.325, '2024-02-08 10:21:52', '2024-03-07 10:22:02', 1),
	(23, 5, 0.316, '2024-02-09 10:22:20', '2024-03-07 10:22:27', 1),
	(24, 5, 0.338, '2024-02-10 10:22:38', '2024-03-07 10:23:01', 1),
	(25, 5, 0.313, '2024-02-11 10:23:22', '2024-03-07 10:23:26', 1);

-- Dumping structure for table water-monitoring-system-db.reading_notifications
CREATE TABLE IF NOT EXISTS `reading_notifications` (
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
  CONSTRAINT `sensor_notification_threshold_id` FOREIGN KEY (`threshold_id`) REFERENCES `parameter_thresholds` (`threshold_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `farmer` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.reading_notifications: ~0 rows (approximately)
DELETE FROM `reading_notifications`;

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
  CONSTRAINT `notification_action` FOREIGN KEY (`action`) REFERENCES `parameter_threshold_actions` (`action`) ON UPDATE CASCADE,
  CONSTRAINT `notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `farmer` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.user_notifications: ~1 rows (approximately)
DELETE FROM `user_notifications`;
INSERT INTO `user_notifications` (`notification_id`, `user_id`, `action`, `message`, `issued_at`, `isRead`, `read_at`) VALUES
	(1, 2, 'INFO', 'You have been added as a STAFF to RD Farm, please wait for the farm owner\'s verification..', '2024-03-05 21:57:21', 0, NULL);

-- Dumping structure for view water-monitoring-system-db.view_dashboard_ponds_monitored
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_dashboard_ponds_monitored` (
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

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_dashboard_ponds_monitored`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_dashboard_ponds_monitored` AS select `farm_farmer`.`farmer_id` AS `farmer_id`,`farms`.`farm_id` AS `farm_id`,count(`ponds`.`device_id`) AS `ponds_monitored` from ((`farm_farmer` join `farms` on(`farm_farmer`.`farmer_id` = `farms`.`farm_id`)) join `ponds` on(`farms`.`farm_id` = `ponds`.`farm_id`)) group by `farm_farmer`.`farmer_id`,`farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_farm`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_farm` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`farms`.`name` AS `name`,`farms`.`address_street` AS `address_street`,`farms`.`address_city` AS `address_city`,`farm_farmer`.`is_approved` AS `is_approved` from (`farm_farmer` join `farms` on(`farm_farmer`.`farm_id` = `farms`.`farm_id`));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_ponds`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_ponds` AS select `farms`.`farm_id` AS `farm_id`,`ponds`.`device_id` AS `device_id`,`ponds`.`name` AS `name`,`ponds`.`status` AS `status`,`ponds`.`width` AS `width`,`ponds`.`length` AS `length`,`ponds`.`depth` AS `depth`,`ponds`.`method` AS `method` from (`ponds` join `farms` on(`ponds`.`farm_id` = `farms`.`farm_id`));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
