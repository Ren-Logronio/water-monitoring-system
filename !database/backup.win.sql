-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.7.0.6850
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
DROP DATABASE IF EXISTS `water-monitoring-system-db`;
CREATE DATABASE IF NOT EXISTS `water-monitoring-system-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `water-monitoring-system-db`;

-- Dumping structure for table water-monitoring-system-db.devices
DROP TABLE IF EXISTS `devices`;
CREATE TABLE IF NOT EXISTS `devices` (
  `device_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDLE',
  `last_established_connection` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`),
  KEY `device_status` (`status`),
  CONSTRAINT `device_status` FOREIGN KEY (`status`) REFERENCES `device_statuses` (`status`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.devices: ~0 rows (approximately)
DELETE FROM `devices`;

-- Dumping structure for table water-monitoring-system-db.device_statuses
DROP TABLE IF EXISTS `device_statuses`;
CREATE TABLE IF NOT EXISTS `device_statuses` (
  `status` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.device_statuses: ~3 rows (approximately)
DELETE FROM `device_statuses`;
INSERT INTO `device_statuses` (`status`) VALUES
	('ACTIVE');
INSERT INTO `device_statuses` (`status`) VALUES
	('IDLE');
INSERT INTO `device_statuses` (`status`) VALUES
	('INACTIVE');

-- Dumping structure for table water-monitoring-system-db.farms
DROP TABLE IF EXISTS `farms`;
CREATE TABLE IF NOT EXISTS `farms` (
  `farm_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_street` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_city` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_province` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  PRIMARY KEY (`farm_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farms: ~0 rows (approximately)
DELETE FROM `farms`;
INSERT INTO `farms` (`farm_id`, `name`, `address_street`, `address_city`, `address_province`, `latitude`, `longitude`) VALUES
	(15, 'MSU College of Fisheries Research Station', 'Siguel Road', 'General Santos City', 'South Cotabato', 5.95996127, 125.10584247);

-- Dumping structure for table water-monitoring-system-db.farm_farmer
DROP TABLE IF EXISTS `farm_farmer`;
CREATE TABLE IF NOT EXISTS `farm_farmer` (
  `farm_id` int NOT NULL,
  `farmer_id` int NOT NULL,
  `role` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STAFF',
  `is_approved` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`farm_id`,`farmer_id`),
  KEY `farm_farmer_id` (`farmer_id`),
  KEY `farm_farmer_role` (`role`),
  CONSTRAINT `farm_farmer_id` FOREIGN KEY (`farmer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farm_farmer_role` FOREIGN KEY (`role`) REFERENCES `farm_farmer_roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `farmer_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer: ~0 rows (approximately)
DELETE FROM `farm_farmer`;
INSERT INTO `farm_farmer` (`farm_id`, `farmer_id`, `role`, `is_approved`) VALUES
	(15, 1, 'OWNER', 1);

-- Dumping structure for table water-monitoring-system-db.farm_farmer_roles
DROP TABLE IF EXISTS `farm_farmer_roles`;
CREATE TABLE IF NOT EXISTS `farm_farmer_roles` (
  `role` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.farm_farmer_roles: ~2 rows (approximately)
DELETE FROM `farm_farmer_roles`;
INSERT INTO `farm_farmer_roles` (`role`) VALUES
	('OWNER');
INSERT INTO `farm_farmer_roles` (`role`) VALUES
	('STAFF');

-- Dumping structure for table water-monitoring-system-db.parameters
DROP TABLE IF EXISTS `parameters`;
CREATE TABLE IF NOT EXISTS `parameters` (
  `parameter_id` int NOT NULL AUTO_INCREMENT,
  `pond_id` int DEFAULT NULL,
  `parameter` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`parameter_id`),
  KEY `parameter_pond_id` (`pond_id`),
  KEY `parameter_parameter` (`parameter`),
  CONSTRAINT `parameter_parameter` FOREIGN KEY (`parameter`) REFERENCES `parameter_list` (`parameter`),
  CONSTRAINT `parameter_pond_id` FOREIGN KEY (`pond_id`) REFERENCES `ponds` (`pond_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameters: ~4 rows (approximately)
DELETE FROM `parameters`;
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(141, 36, 'TMP');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(142, 36, 'PH');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(143, 36, 'TDS');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(144, 36, 'AMN');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(145, 37, 'TMP');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(146, 37, 'PH');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(147, 37, 'TDS');
INSERT INTO `parameters` (`parameter_id`, `pond_id`, `parameter`) VALUES
	(148, 37, 'AMN');

-- Dumping structure for table water-monitoring-system-db.parameter_list
DROP TABLE IF EXISTS `parameter_list`;
CREATE TABLE IF NOT EXISTS `parameter_list` (
  `parameter` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_list: ~4 rows (approximately)
DELETE FROM `parameter_list`;
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('AMN', 'Ammonia', 'ppm');
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('PH', 'pH', 'pH');
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('TDS', 'Total Dissolved Solids', 'ppm');
INSERT INTO `parameter_list` (`parameter`, `name`, `unit`) VALUES
	('TMP', 'Temperature', '°C');

-- Dumping structure for table water-monitoring-system-db.parameter_thresholds
DROP TABLE IF EXISTS `parameter_thresholds`;
CREATE TABLE IF NOT EXISTS `parameter_thresholds` (
  `threshold_id` int NOT NULL AUTO_INCREMENT,
  `parameter` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
	(1, 'TMP', 'GT', 'WARN', 30, 0.5);
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(2, 'TMP', 'LT', 'WARN', 20, 0.5);
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(3, 'AMN', 'GT', 'ALRT', 300, 0.5);
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(4, 'PH', 'GT', 'ALRT', 9, 0.2);
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(5, 'PH', 'LT', 'ALRT', 6, 0.2);
INSERT INTO `parameter_thresholds` (`threshold_id`, `parameter`, `type`, `action`, `target`, `error`) VALUES
	(6, 'TDS', 'GT', 'WARN', 600, 10);

-- Dumping structure for table water-monitoring-system-db.parameter_threshold_actions
DROP TABLE IF EXISTS `parameter_threshold_actions`;
CREATE TABLE IF NOT EXISTS `parameter_threshold_actions` (
  `action` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_threshold_actions: ~3 rows (approximately)
DELETE FROM `parameter_threshold_actions`;
INSERT INTO `parameter_threshold_actions` (`action`) VALUES
	('ALRT');
INSERT INTO `parameter_threshold_actions` (`action`) VALUES
	('INFO');
INSERT INTO `parameter_threshold_actions` (`action`) VALUES
	('WARN');

-- Dumping structure for table water-monitoring-system-db.parameter_threshold_types
DROP TABLE IF EXISTS `parameter_threshold_types`;
CREATE TABLE IF NOT EXISTS `parameter_threshold_types` (
  `type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.parameter_threshold_types: ~3 rows (approximately)
DELETE FROM `parameter_threshold_types`;
INSERT INTO `parameter_threshold_types` (`type`) VALUES
	('EQ');
INSERT INTO `parameter_threshold_types` (`type`) VALUES
	('GT');
INSERT INTO `parameter_threshold_types` (`type`) VALUES
	('LT');

-- Dumping structure for table water-monitoring-system-db.ponds
DROP TABLE IF EXISTS `ponds`;
CREATE TABLE IF NOT EXISTS `ponds` (
  `pond_id` int NOT NULL AUTO_INCREMENT,
  `device_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `farm_id` int DEFAULT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'My Pond',
  `width` double DEFAULT '0',
  `length` double DEFAULT '0',
  `depth` double DEFAULT '0',
  `method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'NONE',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  PRIMARY KEY (`pond_id`) USING BTREE,
  KEY `pond_farm_id` (`farm_id`),
  KEY `pond_method` (`method`),
  KEY `pond_device_id` (`device_id`),
  CONSTRAINT `pond_device_id` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE SET NULL,
  CONSTRAINT `pond_farm_id` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`farm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pond_method` FOREIGN KEY (`method`) REFERENCES `pond_methods` (`method`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='INTENSIVE\r\nSEMI-INTENSIVE\r\nTRADITIONAL';

-- Dumping data for table water-monitoring-system-db.ponds: ~0 rows (approximately)
DELETE FROM `ponds`;
INSERT INTO `ponds` (`pond_id`, `device_id`, `farm_id`, `name`, `width`, `length`, `depth`, `method`, `latitude`, `longitude`) VALUES
	(36, NULL, 15, 'Pond 1', 0, 0, 0, 'SEMI-INTENSIVE', 5.95941617, 125.10555717);
INSERT INTO `ponds` (`pond_id`, `device_id`, `farm_id`, `name`, `width`, `length`, `depth`, `method`, `latitude`, `longitude`) VALUES
	(37, NULL, 15, 'Pond 2', 0, 0, 0, 'SEMI-INTENSIVE', 5.95952762, 125.10576739);

-- Dumping structure for table water-monitoring-system-db.pond_methods
DROP TABLE IF EXISTS `pond_methods`;
CREATE TABLE IF NOT EXISTS `pond_methods` (
  `method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.pond_methods: ~5 rows (approximately)
DELETE FROM `pond_methods`;
INSERT INTO `pond_methods` (`method`) VALUES
	('INTENSIVE');
INSERT INTO `pond_methods` (`method`) VALUES
	('NONE');
INSERT INTO `pond_methods` (`method`) VALUES
	('SEMI-INTENSIVE');
INSERT INTO `pond_methods` (`method`) VALUES
	('SUPER-INTENSIVE');
INSERT INTO `pond_methods` (`method`) VALUES
	('TRADITIONAL');

-- Dumping structure for table water-monitoring-system-db.pond_reading_notifications
DROP TABLE IF EXISTS `pond_reading_notifications`;
CREATE TABLE IF NOT EXISTS `pond_reading_notifications` (
  `reading_notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reading_id` int NOT NULL,
  `threshold_id` int NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `date_resolved` timestamp NULL DEFAULT NULL,
  `is_resolved` tinyint DEFAULT (0),
  PRIMARY KEY (`reading_notification_id`) USING BTREE,
  KEY `sensor_notification_threshold_id` (`threshold_id`),
  KEY `sensor_notification_reading_id` (`reading_id`),
  KEY `sensor_notification_user_id` (`user_id`),
  CONSTRAINT `FK_reading_notifications_parameter_thresholds` FOREIGN KEY (`threshold_id`) REFERENCES `parameter_thresholds` (`threshold_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_reading_id` FOREIGN KEY (`reading_id`) REFERENCES `readings` (`reading_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sensor_notification_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.pond_reading_notifications: ~0 rows (approximately)
DELETE FROM `pond_reading_notifications`;

-- Dumping structure for table water-monitoring-system-db.pond_water_quality_notifications
DROP TABLE IF EXISTS `pond_water_quality_notifications`;
CREATE TABLE IF NOT EXISTS `pond_water_quality_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `pond_id` int DEFAULT NULL,
  `water_quality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FAIR',
  `is_resolved` tinyint NOT NULL DEFAULT (0),
  `date_resolved` timestamp NULL DEFAULT NULL,
  `date_issued` timestamp NOT NULL DEFAULT (now()),
  `date_modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `notification_pond_id` (`pond_id`),
  CONSTRAINT `notification_pond_id` FOREIGN KEY (`pond_id`) REFERENCES `ponds` (`pond_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.pond_water_quality_notifications: ~0 rows (approximately)
DELETE FROM `pond_water_quality_notifications`;

-- Dumping structure for table water-monitoring-system-db.readings
DROP TABLE IF EXISTS `readings`;
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

-- Dumping data for table water-monitoring-system-db.readings: ~4,822 rows (approximately)
DELETE FROM `readings`;
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3073, 143, 153, '2024-04-22 04:34:03', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3074, 141, 24, '2024-04-22 04:34:03', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3075, 142, 5.99, '2024-04-22 04:34:13', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3076, 144, 17, '2024-04-22 04:34:13', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3077, 143, 153, '2024-04-22 04:34:13', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3078, 141, 24, '2024-04-22 04:34:13', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3079, 142, 6.15, '2024-04-22 04:34:23', '2024-05-13 01:54:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3080, 144, 21, '2024-04-22 04:34:23', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3081, 143, 153, '2024-04-22 04:34:23', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3082, 141, 24, '2024-04-22 04:34:23', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3083, 142, 6.14, '2024-04-22 04:34:33', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3084, 144, 21, '2024-04-22 04:34:33', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3085, 143, 153, '2024-04-22 04:34:33', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3086, 141, 24, '2024-04-22 04:34:33', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3087, 142, 5.74, '2024-04-22 04:34:43', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3088, 144, 14, '2024-04-22 04:34:43', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3089, 143, 155, '2024-04-22 04:34:43', '2024-05-13 01:54:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3090, 141, 24, '2024-04-22 04:34:43', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3091, 142, 5.81, '2024-04-22 04:34:53', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3092, 144, 21, '2024-04-22 04:34:53', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3093, 143, 156, '2024-04-22 04:34:53', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3094, 141, 24, '2024-04-22 04:34:53', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3095, 142, 5.59, '2024-04-22 04:35:03', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3096, 144, 20, '2024-04-22 04:35:03', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3097, 143, 156, '2024-04-22 04:35:03', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3098, 141, 23, '2024-04-22 04:35:03', '2024-05-13 01:54:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3099, 142, 5.8, '2024-04-22 04:35:13', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3100, 144, 15, '2024-04-22 04:35:13', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3101, 143, 155, '2024-04-22 04:35:13', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3102, 141, 23, '2024-04-22 04:35:13', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3103, 142, 6, '2024-04-22 04:35:23', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3104, 144, 15, '2024-04-22 04:35:23', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3105, 143, 154, '2024-04-22 04:35:23', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3106, 141, 23, '2024-04-22 04:35:23', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3107, 142, 5.89, '2024-04-22 04:35:33', '2024-05-13 01:54:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3108, 144, 20, '2024-04-22 04:35:33', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3109, 143, 154, '2024-04-22 04:35:33', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3110, 141, 23, '2024-04-22 04:35:33', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3111, 142, 5.52, '2024-04-22 04:35:43', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3112, 144, 13, '2024-04-22 04:35:43', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3113, 143, 155, '2024-04-22 04:35:43', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3114, 141, 23, '2024-04-22 04:35:43', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3115, 142, 5.59, '2024-04-22 04:35:53', '2024-05-13 01:54:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3116, 144, 20, '2024-04-22 04:35:53', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3117, 143, 155, '2024-04-22 04:35:53', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3118, 141, 23, '2024-04-22 04:35:53', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3119, 142, 5.72, '2024-04-22 04:36:04', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3120, 144, 15, '2024-04-22 04:36:04', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3121, 143, 155, '2024-04-22 04:36:04', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3122, 141, 22, '2024-04-22 04:36:04', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3123, 142, 5.72, '2024-04-22 04:36:14', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3124, 144, 14, '2024-04-22 04:36:14', '2024-05-13 01:54:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3125, 143, 155, '2024-04-22 04:36:14', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3126, 141, 22, '2024-04-22 04:36:14', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3127, 142, 5.82, '2024-04-22 04:36:24', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3128, 144, 16, '2024-04-22 04:36:24', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3129, 143, 154, '2024-04-22 04:36:24', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3130, 141, 22, '2024-04-22 04:36:24', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3131, 142, 6.05, '2024-04-22 04:36:34', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3132, 144, 20, '2024-04-22 04:36:34', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3133, 143, 154, '2024-04-22 04:36:34', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3134, 141, 22, '2024-04-22 04:36:34', '2024-05-13 01:54:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3135, 142, 5.89, '2024-04-22 04:36:44', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3136, 144, 15, '2024-04-22 04:36:44', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3137, 143, 154, '2024-04-22 04:36:44', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3138, 141, 22, '2024-04-22 04:36:44', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3139, 142, 6.08, '2024-04-22 04:36:54', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3140, 144, 20, '2024-04-22 04:36:54', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3141, 143, 154, '2024-04-22 04:36:54', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3142, 141, 22, '2024-04-22 04:36:54', '2024-05-13 01:54:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3143, 142, 5.88, '2024-04-22 04:37:04', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3144, 144, 20, '2024-04-22 04:37:04', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3145, 143, 153, '2024-04-22 04:37:04', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3146, 141, 22, '2024-04-22 04:37:04', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3147, 142, 5.94, '2024-04-22 04:37:14', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3148, 144, 20, '2024-04-22 04:37:14', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3149, 143, 153, '2024-04-22 04:37:14', '2024-05-13 01:54:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3150, 141, 22, '2024-04-22 04:37:14', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3151, 142, 5.92, '2024-04-22 04:37:24', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3152, 144, 20, '2024-04-22 04:37:24', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3153, 143, 153, '2024-04-22 04:37:24', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3154, 141, 22, '2024-04-22 04:37:24', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3155, 142, 6.06, '2024-04-22 04:37:34', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3156, 144, 17, '2024-04-22 04:37:34', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3157, 143, 153, '2024-04-22 04:37:34', '2024-05-13 01:54:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3158, 141, 22, '2024-04-22 04:37:34', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3159, 142, 6, '2024-04-22 04:37:44', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3160, 144, 19, '2024-04-22 04:37:44', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3161, 143, 153, '2024-04-22 04:37:44', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3162, 141, 22, '2024-04-22 04:37:44', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3163, 142, 5.9, '2024-04-22 04:37:54', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3164, 144, 20, '2024-04-22 04:37:54', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3165, 143, 153, '2024-04-22 04:37:54', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3166, 141, 21, '2024-04-22 04:37:54', '2024-05-13 01:54:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3167, 142, 6.12, '2024-04-22 04:38:04', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3168, 144, 20, '2024-04-22 04:38:04', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3169, 143, 153, '2024-04-22 04:38:04', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3170, 141, 22, '2024-04-22 04:38:04', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3171, 142, 5.91, '2024-04-22 04:38:14', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3172, 144, 20, '2024-04-22 04:38:14', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3173, 143, 153, '2024-04-22 04:38:14', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3174, 141, 22, '2024-04-22 04:38:14', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3175, 142, 6.08, '2024-04-22 04:38:25', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3176, 144, 20, '2024-04-22 04:38:25', '2024-05-13 01:54:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3177, 143, 153, '2024-04-22 04:38:25', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3178, 141, 21, '2024-04-22 04:38:25', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3179, 142, 6.12, '2024-04-22 04:38:35', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3180, 144, 20, '2024-04-22 04:38:35', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3181, 143, 153, '2024-04-22 04:38:35', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3182, 141, 21, '2024-04-22 04:38:35', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3183, 142, 6.06, '2024-04-22 04:38:45', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3184, 144, 20, '2024-04-22 04:38:45', '2024-05-13 01:54:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3185, 143, 153, '2024-04-22 04:38:45', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3186, 141, 21, '2024-04-22 04:38:45', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3187, 142, 6.07, '2024-04-22 04:38:55', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3188, 144, 15, '2024-04-22 04:38:55', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3189, 143, 152, '2024-04-22 04:38:55', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3190, 141, 21, '2024-04-22 04:38:55', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3191, 142, 6.08, '2024-04-22 04:39:05', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3192, 144, 20, '2024-04-22 04:39:05', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3193, 143, 152, '2024-04-22 04:39:05', '2024-05-13 01:54:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3194, 141, 21, '2024-04-22 04:39:05', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3195, 142, 6.04, '2024-04-22 04:39:15', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3196, 144, 15, '2024-04-22 04:39:15', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3197, 143, 152, '2024-04-22 04:39:15', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3198, 141, 21, '2024-04-22 04:39:15', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3199, 142, 6.08, '2024-04-22 04:39:25', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3200, 144, 18, '2024-04-22 04:39:25', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3201, 143, 152, '2024-04-22 04:39:25', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3202, 141, 21, '2024-04-22 04:39:25', '2024-05-13 01:54:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3203, 142, 5.94, '2024-04-22 04:39:35', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3204, 144, 19, '2024-04-22 04:39:35', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3205, 143, 152, '2024-04-22 04:39:35', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3206, 141, 21, '2024-04-22 04:39:35', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3207, 142, 5.81, '2024-04-22 04:39:45', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3208, 144, 20, '2024-04-22 04:39:45', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3209, 143, 153, '2024-04-22 04:39:45', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3210, 141, 21, '2024-04-22 04:39:45', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3211, 142, 6.01, '2024-04-22 04:39:55', '2024-05-13 01:54:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3212, 144, 15, '2024-04-22 04:39:55', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3213, 143, 153, '2024-04-22 04:39:55', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3214, 141, 21, '2024-04-22 04:39:55', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3215, 142, 5.49, '2024-04-22 04:40:05', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3216, 144, 21, '2024-04-22 04:40:05', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3217, 143, 154, '2024-04-22 04:40:05', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3218, 141, 21, '2024-04-22 04:40:05', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3219, 142, 5.71, '2024-04-22 04:40:15', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3220, 144, 17, '2024-04-22 04:40:15', '2024-05-13 01:54:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3221, 143, 154, '2024-04-22 04:40:15', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3222, 141, 21, '2024-04-22 04:40:15', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3223, 142, 6.01, '2024-04-22 04:40:25', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3224, 144, 19, '2024-04-22 04:40:25', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3225, 143, 153, '2024-04-22 04:40:25', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3226, 141, 21, '2024-04-22 04:40:25', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3227, 142, 5.9, '2024-04-22 04:40:35', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3228, 144, 14, '2024-04-22 04:40:35', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3229, 143, 154, '2024-04-22 04:40:35', '2024-05-13 01:54:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3230, 141, 21, '2024-04-22 04:40:35', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3231, 142, 5.86, '2024-04-22 04:40:46', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3232, 144, 20, '2024-04-22 04:40:46', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3233, 143, 154, '2024-04-22 04:40:46', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3234, 141, 21, '2024-04-22 04:40:46', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3235, 142, 5.84, '2024-04-22 04:40:56', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3236, 144, 20, '2024-04-22 04:40:56', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3237, 143, 153, '2024-04-22 04:40:56', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3238, 141, 21, '2024-04-22 04:40:56', '2024-05-13 01:54:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3239, 142, 5.83, '2024-04-22 04:41:06', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3240, 144, 17, '2024-04-22 04:41:06', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3241, 143, 153, '2024-04-22 04:41:06', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3242, 141, 21, '2024-04-22 04:41:06', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3243, 142, 6, '2024-04-22 04:41:16', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3244, 144, 20, '2024-04-22 04:41:16', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3245, 143, 153, '2024-04-22 04:41:16', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3246, 141, 21, '2024-04-22 04:41:16', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3247, 142, 5.88, '2024-04-22 04:41:26', '2024-05-13 01:54:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3248, 144, 19, '2024-04-22 04:41:26', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3249, 143, 153, '2024-04-22 04:41:26', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3250, 141, 21, '2024-04-22 04:41:26', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3251, 142, 5.58, '2024-04-22 04:41:36', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3252, 144, 17, '2024-04-22 04:41:36', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3253, 143, 154, '2024-04-22 04:41:36', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3254, 141, 21, '2024-04-22 04:41:36', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3255, 142, 5.33, '2024-04-22 04:41:46', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3256, 144, 19, '2024-04-22 04:41:46', '2024-05-13 01:54:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3257, 143, 155, '2024-04-22 04:41:46', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3258, 141, 21, '2024-04-22 04:41:46', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3259, 142, 5.88, '2024-04-22 04:41:56', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3260, 144, 20, '2024-04-22 04:41:56', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3261, 143, 154, '2024-04-22 04:41:56', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3262, 141, 21, '2024-04-22 04:41:56', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3263, 142, 5.88, '2024-04-22 04:42:06', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3264, 144, 19, '2024-04-22 04:42:06', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3265, 143, 154, '2024-04-22 04:42:06', '2024-05-13 01:54:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3266, 141, 21, '2024-04-22 04:42:06', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3267, 142, 5.88, '2024-04-22 04:42:16', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3268, 144, 16, '2024-04-22 04:42:16', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3269, 143, 154, '2024-04-22 04:42:16', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3270, 141, 21, '2024-04-22 04:42:16', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3271, 142, 5.96, '2024-04-22 04:42:26', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3272, 144, 17, '2024-04-22 04:42:26', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3273, 143, 154, '2024-04-22 04:42:26', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3274, 141, 21, '2024-04-22 04:42:26', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3275, 142, 6, '2024-04-22 04:42:36', '2024-05-13 01:54:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3276, 144, 19, '2024-04-22 04:42:36', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3277, 143, 153, '2024-04-22 04:42:36', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3278, 141, 21, '2024-04-22 04:42:36', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3279, 142, 5.87, '2024-04-22 04:42:46', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3280, 144, 20, '2024-04-22 04:42:46', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3281, 143, 153, '2024-04-22 04:42:46', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3282, 141, 21, '2024-04-22 04:42:46', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3283, 142, 5.88, '2024-04-22 04:42:56', '2024-05-13 01:54:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3284, 144, 20, '2024-04-22 04:42:56', '2024-05-13 01:54:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3285, 143, 153, '2024-04-22 04:42:56', '2024-05-13 01:54:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3286, 141, 21, '2024-04-22 04:42:56', '2024-05-13 01:54:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3287, 142, 6.09, '2024-04-22 04:19:15', '2024-05-13 01:54:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3288, 144, 13, '2024-04-22 04:19:15', '2024-05-13 01:54:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3289, 143, 158, '2024-04-22 04:19:15', '2024-05-13 01:54:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3290, 141, 33, '2024-04-22 04:19:15', '2024-05-13 01:54:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3291, 142, 6.23, '2024-04-22 04:19:25', '2024-05-13 01:54:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3292, 144, 15, '2024-04-22 04:19:25', '2024-05-13 01:54:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3293, 143, 158, '2024-04-22 04:19:25', '2024-05-13 01:54:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3294, 141, 33, '2024-04-22 04:19:25', '2024-05-13 01:54:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3295, 142, 6.15, '2024-04-22 04:19:35', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3296, 144, 14, '2024-04-22 04:19:35', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3297, 143, 158, '2024-04-22 04:19:35', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3298, 141, 33, '2024-04-22 04:19:35', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3299, 142, 6.09, '2024-04-22 04:24:09', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3300, 144, 16, '2024-04-22 04:24:09', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3301, 143, 157, '2024-04-22 04:24:09', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3302, 141, 29, '2024-04-22 04:24:09', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3303, 142, 6.13, '2024-04-22 04:24:19', '2024-05-13 01:54:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3304, 144, 20, '2024-04-22 04:24:19', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3305, 143, 157, '2024-04-22 04:24:19', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3306, 141, 29, '2024-04-22 04:24:19', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3307, 142, 6.14, '2024-04-22 04:24:29', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3308, 144, 15, '2024-04-22 04:24:29', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3309, 143, 156, '2024-04-22 04:24:29', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3310, 141, 29, '2024-04-22 04:24:29', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3311, 142, 6.18, '2024-04-22 04:24:39', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3312, 144, 20, '2024-04-22 04:24:39', '2024-05-13 01:54:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3313, 143, 156, '2024-04-22 04:24:39', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3314, 141, 29, '2024-04-22 04:24:39', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3315, 142, 6, '2024-04-22 04:24:49', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3316, 144, 21, '2024-04-22 04:24:49', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3317, 143, 157, '2024-04-22 04:24:49', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3318, 141, 29, '2024-04-22 04:24:49', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3319, 142, 6.13, '2024-04-22 04:24:59', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3320, 144, 20, '2024-04-22 04:24:59', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3321, 143, 156, '2024-04-22 04:24:59', '2024-05-13 01:54:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3322, 141, 28, '2024-04-22 04:24:59', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3323, 142, 6.06, '2024-04-22 04:25:09', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3324, 144, 15, '2024-04-22 04:25:09', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3325, 143, 157, '2024-04-22 04:25:09', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3326, 141, 28, '2024-04-22 04:25:09', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3327, 142, 5.86, '2024-04-22 04:25:19', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3328, 144, 18, '2024-04-22 04:25:19', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3329, 143, 157, '2024-04-22 04:25:19', '2024-05-13 01:55:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3330, 141, 28, '2024-04-22 04:25:19', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3331, 142, 5.97, '2024-04-22 04:25:29', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3332, 144, 20, '2024-04-22 04:25:29', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3333, 143, 157, '2024-04-22 04:25:29', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3334, 141, 28, '2024-04-22 04:25:29', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3335, 142, 6.06, '2024-04-22 04:25:39', '2024-05-13 01:55:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3336, 144, 16, '2024-04-22 04:25:39', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3337, 143, 157, '2024-04-22 04:25:39', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3338, 141, 28, '2024-04-22 04:25:39', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3339, 142, 6.28, '2024-04-22 04:25:49', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3340, 144, 15, '2024-04-22 04:25:49', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3341, 143, 156, '2024-04-22 04:25:49', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3342, 141, 28, '2024-04-22 04:25:49', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3343, 142, 6.32, '2024-04-22 04:25:59', '2024-05-13 01:55:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3344, 144, 19, '2024-04-22 04:25:59', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3345, 143, 156, '2024-04-22 04:25:59', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3346, 141, 28, '2024-04-22 04:25:59', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3347, 142, 6.34, '2024-04-22 04:26:09', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3348, 144, 21, '2024-04-22 04:26:09', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3349, 143, 156, '2024-04-22 04:26:09', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3350, 141, 28, '2024-04-22 04:26:09', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3351, 142, 6.15, '2024-04-22 04:26:19', '2024-05-13 01:55:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3352, 144, 17, '2024-04-22 04:26:19', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3353, 143, 156, '2024-04-22 04:26:19', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3354, 141, 28, '2024-04-22 04:26:19', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3355, 142, 6.32, '2024-04-22 04:26:30', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3356, 144, 14, '2024-04-22 04:26:30', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3357, 143, 156, '2024-04-22 04:26:30', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3358, 141, 28, '2024-04-22 04:26:30', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3359, 142, 6.19, '2024-04-22 04:26:40', '2024-05-13 01:55:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3360, 144, 18, '2024-04-22 04:26:40', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3361, 143, 156, '2024-04-22 04:26:40', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3362, 141, 28, '2024-04-22 04:26:40', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3363, 142, 6.34, '2024-04-22 04:26:50', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3364, 144, 20, '2024-04-22 04:26:50', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3365, 143, 155, '2024-04-22 04:26:50', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3366, 141, 28, '2024-04-22 04:26:50', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3367, 142, 6.18, '2024-04-22 04:27:00', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3368, 144, 10, '2024-04-22 04:27:00', '2024-05-13 01:55:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3369, 143, 155, '2024-04-22 04:27:00', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3370, 141, 28, '2024-04-22 04:27:00', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3371, 142, 6.28, '2024-04-22 04:27:10', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3372, 144, 14, '2024-04-22 04:27:10', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3373, 143, 155, '2024-04-22 04:27:10', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3374, 141, 28, '2024-04-22 04:27:10', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3375, 142, 6.24, '2024-04-22 04:27:20', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3376, 144, 16, '2024-04-22 04:27:20', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3377, 143, 155, '2024-04-22 04:27:20', '2024-05-13 01:55:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3378, 141, 28, '2024-04-22 04:27:20', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3379, 142, 6.28, '2024-04-22 04:27:30', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3380, 144, 21, '2024-04-22 04:27:30', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3381, 143, 155, '2024-04-22 04:27:30', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3382, 141, 27, '2024-04-22 04:27:30', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3383, 142, 6.14, '2024-04-22 04:27:40', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3384, 144, 10, '2024-04-22 04:27:40', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3385, 143, 155, '2024-04-22 04:27:40', '2024-05-13 01:55:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3386, 141, 28, '2024-04-22 04:27:40', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3387, 142, 6.15, '2024-04-22 04:27:50', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3388, 144, 16, '2024-04-22 04:27:50', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3389, 143, 155, '2024-04-22 04:27:50', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3390, 141, 27, '2024-04-22 04:27:50', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3391, 142, 6.16, '2024-04-22 04:28:00', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3392, 144, 15, '2024-04-22 04:28:00', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3393, 143, 155, '2024-04-22 04:28:00', '2024-05-13 01:55:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3394, 141, 27, '2024-04-22 04:28:00', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3395, 142, 6.16, '2024-04-22 04:28:10', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3396, 144, 21, '2024-04-22 04:28:10', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3397, 143, 154, '2024-04-22 04:28:10', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3398, 141, 27, '2024-04-22 04:28:10', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3399, 142, 6.15, '2024-04-22 04:28:20', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3400, 144, 18, '2024-04-22 04:28:20', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3401, 143, 154, '2024-04-22 04:28:20', '2024-05-13 01:55:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3402, 141, 27, '2024-04-22 04:28:20', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3403, 142, 6.3, '2024-04-22 04:28:30', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3404, 144, 22, '2024-04-22 04:28:30', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3405, 143, 154, '2024-04-22 04:28:30', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3406, 141, 27, '2024-04-22 04:28:30', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3407, 142, 6.12, '2024-04-22 04:28:40', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3408, 144, 16, '2024-04-22 04:28:40', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3409, 143, 154, '2024-04-22 04:28:40', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3410, 141, 26, '2024-04-22 04:28:40', '2024-05-13 01:55:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3411, 142, 6.26, '2024-04-22 04:28:51', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3412, 144, 22, '2024-04-22 04:28:51', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3413, 143, 154, '2024-04-22 04:28:51', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3414, 141, 26, '2024-04-22 04:28:51', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3415, 142, 6.12, '2024-04-22 04:29:01', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3416, 144, 22, '2024-04-22 04:29:01', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3417, 143, 154, '2024-04-22 04:29:01', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3418, 141, 26, '2024-04-22 04:29:01', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3419, 142, 6.3, '2024-04-22 04:29:11', '2024-05-13 01:55:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3420, 144, 21, '2024-04-22 04:29:11', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3421, 143, 154, '2024-04-22 04:29:11', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3422, 141, 26, '2024-04-22 04:29:11', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3423, 142, 6.14, '2024-04-22 04:29:21', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3424, 144, 21, '2024-04-22 04:29:21', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3425, 143, 154, '2024-04-22 04:29:21', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3426, 141, 26, '2024-04-22 04:29:21', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3427, 142, 6.05, '2024-04-22 04:29:31', '2024-05-13 01:55:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3428, 144, 14, '2024-04-22 04:29:31', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3429, 143, 154, '2024-04-22 04:29:31', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3430, 141, 26, '2024-04-22 04:29:31', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3431, 142, 6.11, '2024-04-22 04:29:41', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3432, 144, 20, '2024-04-22 04:29:41', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3433, 143, 154, '2024-04-22 04:29:41', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3434, 141, 26, '2024-04-22 04:29:41', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3435, 142, 6.03, '2024-04-22 04:29:51', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3436, 144, 18, '2024-04-22 04:29:51', '2024-05-13 01:55:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3437, 143, 154, '2024-04-22 04:29:51', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3438, 141, 25, '2024-04-22 04:29:51', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3439, 142, 5.96, '2024-04-22 04:30:01', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3440, 144, 21, '2024-04-22 04:30:01', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3441, 143, 155, '2024-04-22 04:30:01', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3442, 141, 25, '2024-04-22 04:30:01', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3443, 142, 5.86, '2024-04-22 04:30:11', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3444, 144, 18, '2024-04-22 04:30:11', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3445, 143, 155, '2024-04-22 04:30:11', '2024-05-13 01:55:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3446, 141, 25, '2024-04-22 04:30:11', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3447, 142, 5.92, '2024-04-22 04:30:21', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3448, 144, 19, '2024-04-22 04:30:21', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3449, 143, 156, '2024-04-22 04:30:21', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3450, 141, 25, '2024-04-22 04:30:21', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3451, 142, 5.94, '2024-04-22 04:30:31', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3452, 144, 15, '2024-04-22 04:30:31', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3453, 143, 155, '2024-04-22 04:30:31', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3454, 141, 25, '2024-04-22 04:30:31', '2024-05-13 01:55:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3455, 142, 5.98, '2024-04-22 04:30:41', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3456, 144, 16, '2024-04-22 04:30:41', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3457, 143, 155, '2024-04-22 04:30:41', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3458, 141, 25, '2024-04-22 04:30:41', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3459, 142, 5.94, '2024-04-22 04:30:51', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3460, 144, 20, '2024-04-22 04:30:51', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3461, 143, 155, '2024-04-22 04:30:51', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3462, 141, 25, '2024-04-22 04:30:51', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3463, 142, 5.97, '2024-04-22 04:31:01', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3464, 144, 20, '2024-04-22 04:31:01', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3465, 143, 155, '2024-04-22 04:31:01', '2024-05-13 01:55:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3466, 141, 25, '2024-04-22 04:31:01', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3467, 142, 5.89, '2024-04-22 04:31:12', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3468, 144, 21, '2024-04-22 04:31:12', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3469, 143, 155, '2024-04-22 04:31:12', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3470, 141, 25, '2024-04-22 04:31:12', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3471, 142, 6.15, '2024-04-22 04:31:22', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3472, 144, 21, '2024-04-22 04:31:22', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3473, 143, 155, '2024-04-22 04:31:22', '2024-05-13 01:55:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3474, 141, 25, '2024-04-22 04:31:22', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3475, 142, 6.19, '2024-04-22 04:31:32', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3476, 144, 21, '2024-04-22 04:31:32', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3477, 143, 154, '2024-04-22 04:31:32', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3478, 141, 25, '2024-04-22 04:31:32', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3479, 142, 5.94, '2024-04-22 04:31:42', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3480, 144, 21, '2024-04-22 04:31:42', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3481, 143, 155, '2024-04-22 04:31:42', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3482, 141, 25, '2024-04-22 04:31:42', '2024-05-13 01:55:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3483, 142, 6.02, '2024-04-22 04:31:52', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3484, 144, 16, '2024-04-22 04:31:52', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3485, 143, 154, '2024-04-22 04:31:52', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3486, 141, 25, '2024-04-22 04:31:52', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3487, 142, 6.05, '2024-04-22 04:32:02', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3488, 144, 16, '2024-04-22 04:32:02', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3489, 143, 154, '2024-04-22 04:32:02', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3490, 141, 25, '2024-04-22 04:32:02', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3491, 142, 6.23, '2024-04-22 04:32:12', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3492, 144, 17, '2024-04-22 04:32:12', '2024-05-13 01:55:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3493, 143, 153, '2024-04-22 04:32:12', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3494, 141, 25, '2024-04-22 04:32:12', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3495, 142, 6.06, '2024-04-22 04:32:22', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3496, 144, 16, '2024-04-22 04:32:22', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3497, 143, 153, '2024-04-22 04:32:22', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3498, 141, 25, '2024-04-22 04:32:22', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3499, 142, 6.18, '2024-04-22 04:32:32', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3500, 144, 18, '2024-04-22 04:32:32', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3501, 143, 154, '2024-04-22 04:32:32', '2024-05-13 01:55:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3502, 141, 24, '2024-04-22 04:32:32', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3503, 142, 6.06, '2024-04-22 04:32:42', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3504, 144, 20, '2024-04-22 04:32:42', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3505, 143, 154, '2024-04-22 04:32:42', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3506, 141, 24, '2024-04-22 04:32:42', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3507, 142, 6.21, '2024-04-22 04:32:52', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3508, 144, 21, '2024-04-22 04:32:52', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3509, 143, 153, '2024-04-22 04:32:52', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3510, 141, 24, '2024-04-22 04:32:52', '2024-05-13 01:55:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3511, 142, 6.18, '2024-04-22 04:33:02', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3512, 144, 21, '2024-04-22 04:33:02', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3513, 143, 153, '2024-04-22 04:33:02', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3514, 141, 24, '2024-04-22 04:33:02', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3515, 142, 6.22, '2024-04-22 04:33:12', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3516, 144, 21, '2024-04-22 04:33:12', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3517, 143, 153, '2024-04-22 04:33:12', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3518, 141, 24, '2024-04-22 04:33:12', '2024-05-13 01:55:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3519, 142, 6.01, '2024-04-22 04:33:22', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3520, 144, 17, '2024-04-22 04:33:22', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3521, 143, 153, '2024-04-22 04:33:22', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3522, 141, 24, '2024-04-22 04:33:22', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3523, 142, 6.18, '2024-04-22 04:33:33', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3524, 144, 21, '2024-04-22 04:33:33', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3525, 143, 153, '2024-04-22 04:33:33', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3526, 141, 24, '2024-04-22 04:33:33', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3527, 142, 6.14, '2024-04-22 04:33:43', '2024-05-13 01:55:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3528, 144, 16, '2024-04-22 04:33:43', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3529, 143, 153, '2024-04-22 04:33:43', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3530, 141, 24, '2024-04-22 04:33:43', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3531, 142, 6.2, '2024-04-22 04:33:53', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3532, 144, 21, '2024-04-22 04:33:53', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3533, 143, 153, '2024-04-22 04:33:53', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3534, 141, 24, '2024-04-22 04:33:53', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3535, 142, 6.18, '2024-04-22 04:34:03', '2024-05-13 01:55:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3536, 144, 17, '2024-04-22 04:34:03', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3537, 143, 153, '2024-04-22 04:34:03', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3538, 141, 24, '2024-04-22 04:34:03', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3539, 142, 5.99, '2024-04-22 04:34:13', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3540, 144, 17, '2024-04-22 04:34:13', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3541, 143, 153, '2024-04-22 04:34:13', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3542, 141, 24, '2024-04-22 04:34:13', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3543, 142, 6.15, '2024-04-22 04:34:23', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3544, 144, 21, '2024-04-22 04:34:23', '2024-05-13 01:55:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3545, 143, 153, '2024-04-22 04:34:23', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3546, 141, 24, '2024-04-22 04:34:23', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3547, 142, 6.14, '2024-04-22 04:34:33', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3548, 144, 21, '2024-04-22 04:34:33', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3549, 143, 153, '2024-04-22 04:34:33', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3550, 141, 24, '2024-04-22 04:34:33', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3551, 142, 5.74, '2024-04-22 04:34:43', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3552, 144, 14, '2024-04-22 04:34:43', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3553, 143, 155, '2024-04-22 04:34:43', '2024-05-13 01:55:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3554, 141, 24, '2024-04-22 04:34:43', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3555, 142, 5.81, '2024-04-22 04:34:53', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3556, 144, 21, '2024-04-22 04:34:53', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3557, 143, 156, '2024-04-22 04:34:53', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3558, 141, 24, '2024-04-22 04:34:53', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3559, 142, 5.59, '2024-04-22 04:35:03', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3560, 144, 20, '2024-04-22 04:35:03', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3561, 143, 156, '2024-04-22 04:35:03', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3562, 141, 23, '2024-04-22 04:35:03', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3563, 142, 5.8, '2024-04-22 04:35:13', '2024-05-13 01:55:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3564, 144, 15, '2024-04-22 04:35:13', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3565, 143, 155, '2024-04-22 04:35:13', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3566, 141, 23, '2024-04-22 04:35:13', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3567, 142, 6, '2024-04-22 04:35:23', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3568, 144, 15, '2024-04-22 04:35:23', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3569, 143, 154, '2024-04-22 04:35:23', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3570, 141, 23, '2024-04-22 04:35:23', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3571, 142, 5.89, '2024-04-22 04:35:33', '2024-05-13 01:55:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3572, 144, 20, '2024-04-22 04:35:33', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3573, 143, 154, '2024-04-22 04:35:33', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3574, 141, 23, '2024-04-22 04:35:33', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3575, 142, 5.52, '2024-04-22 04:35:43', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3576, 144, 13, '2024-04-22 04:35:43', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3577, 143, 155, '2024-04-22 04:35:43', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3578, 141, 23, '2024-04-22 04:35:43', '2024-05-13 01:55:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3579, 142, 5.59, '2024-04-22 04:35:53', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3580, 144, 20, '2024-04-22 04:35:53', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3581, 143, 155, '2024-04-22 04:35:53', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3582, 141, 23, '2024-04-22 04:35:53', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3583, 142, 5.72, '2024-04-22 04:36:04', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3584, 144, 15, '2024-04-22 04:36:04', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3585, 143, 155, '2024-04-22 04:36:04', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3586, 141, 22, '2024-04-22 04:36:04', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3587, 142, 5.72, '2024-04-22 04:36:14', '2024-05-13 01:55:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3588, 144, 14, '2024-04-22 04:36:14', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3589, 143, 155, '2024-04-22 04:36:14', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3590, 141, 22, '2024-04-22 04:36:14', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3591, 142, 5.82, '2024-04-22 04:36:24', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3592, 144, 16, '2024-04-22 04:36:24', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3593, 143, 154, '2024-04-22 04:36:24', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3594, 141, 22, '2024-04-22 04:36:24', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3595, 142, 6.05, '2024-04-22 04:36:34', '2024-05-13 01:55:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3596, 144, 20, '2024-04-22 04:36:34', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3597, 143, 154, '2024-04-22 04:36:34', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3598, 141, 22, '2024-04-22 04:36:34', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3599, 142, 5.89, '2024-04-22 04:36:44', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3600, 144, 15, '2024-04-22 04:36:44', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3601, 143, 154, '2024-04-22 04:36:44', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3602, 141, 22, '2024-04-22 04:36:44', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3603, 142, 6.08, '2024-04-22 04:36:54', '2024-05-13 01:55:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3604, 144, 20, '2024-04-22 04:36:54', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3605, 143, 154, '2024-04-22 04:36:54', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3606, 141, 22, '2024-04-22 04:36:54', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3607, 142, 5.88, '2024-04-22 04:37:04', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3608, 144, 20, '2024-04-22 04:37:04', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3609, 143, 153, '2024-04-22 04:37:04', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3610, 141, 22, '2024-04-22 04:37:04', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3611, 142, 5.94, '2024-04-22 04:37:14', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3612, 144, 20, '2024-04-22 04:37:14', '2024-05-13 01:55:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3613, 143, 153, '2024-04-22 04:37:14', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3614, 141, 22, '2024-04-22 04:37:14', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3615, 142, 5.92, '2024-04-22 04:37:24', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3616, 144, 20, '2024-04-22 04:37:24', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3617, 143, 153, '2024-04-22 04:37:24', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3618, 141, 22, '2024-04-22 04:37:24', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3619, 142, 6.06, '2024-04-22 04:37:34', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3620, 144, 17, '2024-04-22 04:37:34', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3621, 143, 153, '2024-04-22 04:37:34', '2024-05-13 01:55:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3622, 141, 22, '2024-04-22 04:37:34', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3623, 142, 6, '2024-04-22 04:37:44', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3624, 144, 19, '2024-04-22 04:37:44', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3625, 143, 153, '2024-04-22 04:37:44', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3626, 141, 22, '2024-04-22 04:37:44', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3627, 142, 5.9, '2024-04-22 04:37:54', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3628, 144, 20, '2024-04-22 04:37:54', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3629, 143, 153, '2024-04-22 04:37:54', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3630, 141, 21, '2024-04-22 04:37:54', '2024-05-13 01:55:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3631, 142, 6.12, '2024-04-22 04:38:04', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3632, 144, 20, '2024-04-22 04:38:04', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3633, 143, 153, '2024-04-22 04:38:04', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3634, 141, 22, '2024-04-22 04:38:04', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3635, 142, 5.91, '2024-04-22 04:38:14', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3636, 144, 20, '2024-04-22 04:38:14', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3637, 143, 153, '2024-04-22 04:38:14', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3638, 141, 22, '2024-04-22 04:38:14', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3639, 142, 6.08, '2024-04-22 04:38:25', '2024-05-13 01:55:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3640, 144, 20, '2024-04-22 04:38:25', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3641, 143, 153, '2024-04-22 04:38:25', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3642, 141, 21, '2024-04-22 04:38:25', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3643, 142, 6.12, '2024-04-22 04:38:35', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3644, 144, 20, '2024-04-22 04:38:35', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3645, 143, 153, '2024-04-22 04:38:35', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3646, 141, 21, '2024-04-22 04:38:35', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3647, 142, 6.06, '2024-04-22 04:38:45', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3648, 144, 20, '2024-04-22 04:38:45', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3649, 143, 153, '2024-04-22 04:38:45', '2024-05-13 01:55:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3650, 141, 21, '2024-04-22 04:38:45', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3651, 142, 6.07, '2024-04-22 04:38:55', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3652, 144, 15, '2024-04-22 04:38:55', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3653, 143, 152, '2024-04-22 04:38:55', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3654, 141, 21, '2024-04-22 04:38:55', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3655, 142, 6.08, '2024-04-22 04:39:05', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3656, 144, 20, '2024-04-22 04:39:05', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3657, 143, 152, '2024-04-22 04:39:05', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3658, 141, 21, '2024-04-22 04:39:05', '2024-05-13 01:55:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3659, 142, 6.04, '2024-04-22 04:39:15', '2024-05-13 01:55:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3660, 144, 15, '2024-04-22 04:39:15', '2024-05-13 01:55:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3661, 143, 152, '2024-04-22 04:39:15', '2024-05-13 01:55:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3662, 141, 21, '2024-04-22 04:39:15', '2024-05-13 01:55:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3663, 142, 6.08, '2024-04-22 04:39:25', '2024-05-13 01:55:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3664, 144, 18, '2024-04-22 04:39:25', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3665, 143, 152, '2024-04-22 04:39:25', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3666, 141, 21, '2024-04-22 04:39:25', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3667, 142, 5.94, '2024-04-22 04:39:35', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3668, 144, 19, '2024-04-22 04:39:35', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3669, 143, 152, '2024-04-22 04:39:35', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3670, 141, 21, '2024-04-22 04:39:35', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3671, 142, 5.81, '2024-04-22 04:39:45', '2024-05-13 01:55:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3672, 144, 20, '2024-04-22 04:39:45', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3673, 143, 153, '2024-04-22 04:39:45', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3674, 141, 21, '2024-04-22 04:39:45', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3675, 142, 6.01, '2024-04-22 04:39:55', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3676, 144, 15, '2024-04-22 04:39:55', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3677, 143, 153, '2024-04-22 04:39:55', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3678, 141, 21, '2024-04-22 04:39:55', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3679, 142, 5.49, '2024-04-22 04:40:05', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3680, 144, 21, '2024-04-22 04:40:05', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3681, 143, 154, '2024-04-22 04:40:05', '2024-05-13 01:55:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3682, 141, 21, '2024-04-22 04:40:05', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3683, 142, 5.71, '2024-04-22 04:40:15', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3684, 144, 17, '2024-04-22 04:40:15', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3685, 143, 154, '2024-04-22 04:40:15', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3686, 141, 21, '2024-04-22 04:40:15', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3687, 142, 6.01, '2024-04-22 04:40:25', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3688, 144, 19, '2024-04-22 04:40:25', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3689, 143, 153, '2024-04-22 04:40:25', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3690, 141, 21, '2024-04-22 04:40:25', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3691, 142, 5.9, '2024-04-22 04:40:35', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3692, 144, 14, '2024-04-22 04:40:35', '2024-05-13 01:55:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3693, 143, 154, '2024-04-22 04:40:35', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3694, 141, 21, '2024-04-22 04:40:35', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3695, 142, 5.86, '2024-04-22 04:40:46', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3696, 144, 20, '2024-04-22 04:40:46', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3697, 143, 154, '2024-04-22 04:40:46', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3698, 141, 21, '2024-04-22 04:40:46', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3699, 142, 5.84, '2024-04-22 04:40:56', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3700, 144, 20, '2024-04-22 04:40:56', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3701, 143, 153, '2024-04-22 04:40:56', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3702, 141, 21, '2024-04-22 04:40:56', '2024-05-13 01:55:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3703, 142, 5.83, '2024-04-22 04:41:06', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3704, 144, 17, '2024-04-22 04:41:06', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3705, 143, 153, '2024-04-22 04:41:06', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3706, 141, 21, '2024-04-22 04:41:06', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3707, 142, 6, '2024-04-22 04:41:16', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3708, 144, 20, '2024-04-22 04:41:16', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3709, 143, 153, '2024-04-22 04:41:16', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3710, 141, 21, '2024-04-22 04:41:16', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3711, 142, 5.88, '2024-04-22 04:41:26', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3712, 144, 19, '2024-04-22 04:41:26', '2024-05-13 01:55:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3713, 143, 153, '2024-04-22 04:41:26', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3714, 141, 21, '2024-04-22 04:41:26', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3715, 142, 5.58, '2024-04-22 04:41:36', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3716, 144, 17, '2024-04-22 04:41:36', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3717, 143, 154, '2024-04-22 04:41:36', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3718, 141, 21, '2024-04-22 04:41:36', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3719, 142, 5.33, '2024-04-22 04:41:46', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3720, 144, 19, '2024-04-22 04:41:46', '2024-05-13 01:55:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3721, 143, 155, '2024-04-22 04:41:46', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3722, 141, 21, '2024-04-22 04:41:46', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3723, 142, 5.88, '2024-04-22 04:41:56', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3724, 144, 20, '2024-04-22 04:41:56', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3725, 143, 154, '2024-04-22 04:41:56', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3726, 141, 21, '2024-04-22 04:41:56', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3727, 142, 5.88, '2024-04-22 04:42:06', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3728, 144, 19, '2024-04-22 04:42:06', '2024-05-13 01:55:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3729, 143, 154, '2024-04-22 04:42:06', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3730, 141, 21, '2024-04-22 04:42:06', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3731, 142, 5.88, '2024-04-22 04:42:16', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3732, 144, 16, '2024-04-22 04:42:16', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3733, 143, 154, '2024-04-22 04:42:16', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3734, 141, 21, '2024-04-22 04:42:16', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3735, 142, 5.96, '2024-04-22 04:42:26', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3736, 144, 17, '2024-04-22 04:42:26', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3737, 143, 154, '2024-04-22 04:42:26', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3738, 141, 21, '2024-04-22 04:42:26', '2024-05-13 01:55:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3739, 142, 6, '2024-04-22 04:42:36', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3740, 144, 19, '2024-04-22 04:42:36', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3741, 143, 153, '2024-04-22 04:42:36', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3742, 141, 21, '2024-04-22 04:42:36', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3743, 142, 5.87, '2024-04-22 04:42:46', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3744, 144, 20, '2024-04-22 04:42:46', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3745, 143, 153, '2024-04-22 04:42:46', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3746, 141, 21, '2024-04-22 04:42:46', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3747, 142, 5.88, '2024-04-22 04:42:56', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3748, 144, 20, '2024-04-22 04:42:56', '2024-05-13 01:55:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3749, 143, 153, '2024-04-22 04:42:56', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3750, 141, 21, '2024-04-22 04:42:56', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3751, 142, 5.91, '2024-04-22 04:43:07', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3752, 144, 20, '2024-04-22 04:43:07', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3753, 143, 152, '2024-04-22 04:43:07', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3754, 141, 21, '2024-04-22 04:43:07', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3755, 142, 5.89, '2024-04-22 04:43:17', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3756, 144, 15, '2024-04-22 04:43:17', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3757, 143, 152, '2024-04-22 04:43:17', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3758, 141, 21, '2024-04-22 04:43:17', '2024-05-13 01:55:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3759, 142, 5.91, '2024-04-22 04:43:27', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3760, 144, 20, '2024-04-22 04:43:27', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3761, 143, 152, '2024-04-22 04:43:27', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3762, 141, 21, '2024-04-22 04:43:27', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3763, 142, 6.1, '2024-04-22 04:43:37', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3764, 144, 15, '2024-04-22 04:43:37', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3765, 143, 152, '2024-04-22 04:43:37', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3766, 141, 21, '2024-04-22 04:43:37', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3767, 142, 6.07, '2024-04-22 04:43:47', '2024-05-13 01:55:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3768, 144, 20, '2024-04-22 04:43:47', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3769, 143, 152, '2024-04-22 04:43:47', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3770, 141, 21, '2024-04-22 04:43:47', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3771, 142, 5.88, '2024-04-22 04:43:57', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3772, 144, 15, '2024-04-22 04:43:57', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3773, 143, 152, '2024-04-22 04:43:57', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3774, 141, 21, '2024-04-22 04:43:57', '2024-05-13 01:55:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3775, 142, 5.88, '2024-04-22 04:44:07', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3776, 144, 20, '2024-04-22 04:44:07', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3777, 143, 152, '2024-04-22 04:44:07', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3778, 141, 21, '2024-04-22 04:44:07', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3779, 142, 6.04, '2024-04-22 04:44:17', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3780, 144, 15, '2024-04-22 04:44:17', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3781, 143, 152, '2024-04-22 04:44:17', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3782, 141, 21, '2024-04-22 04:44:17', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3783, 142, 5.78, '2024-04-22 04:44:27', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3784, 144, 20, '2024-04-22 04:44:27', '2024-05-13 01:55:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3785, 143, 153, '2024-04-22 04:44:27', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3786, 141, 21, '2024-04-22 04:44:27', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3787, 142, 5.86, '2024-04-22 04:44:37', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3788, 144, 19, '2024-04-22 04:44:37', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3789, 143, 154, '2024-04-22 04:44:37', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3790, 141, 21, '2024-04-22 04:44:37', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3791, 142, 5.81, '2024-04-22 04:44:47', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3792, 144, 20, '2024-04-22 04:44:47', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3793, 143, 154, '2024-04-22 04:44:47', '2024-05-13 01:55:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3794, 141, 21, '2024-04-22 04:44:47', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3795, 142, 6.01, '2024-04-22 04:44:57', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3796, 144, 16, '2024-04-22 04:44:57', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3797, 143, 153, '2024-04-22 04:44:57', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3798, 141, 21, '2024-04-22 04:44:57', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3799, 142, 6.06, '2024-04-22 04:45:07', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3800, 144, 16, '2024-04-22 04:45:07', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3801, 143, 152, '2024-04-22 04:45:07', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3802, 141, 21, '2024-04-22 04:45:07', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3803, 142, 5.86, '2024-04-22 04:45:17', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3804, 144, 16, '2024-04-22 04:45:17', '2024-05-13 01:55:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3805, 143, 152, '2024-04-22 04:45:17', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3806, 141, 21, '2024-04-22 04:45:17', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3807, 142, 5.94, '2024-04-22 04:45:28', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3808, 144, 16, '2024-04-22 04:45:28', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3809, 143, 151, '2024-04-22 04:45:28', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3810, 141, 21, '2024-04-22 04:45:28', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3811, 142, 6.04, '2024-04-22 04:45:38', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3812, 144, 17, '2024-04-22 04:45:38', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3813, 143, 152, '2024-04-22 04:45:38', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3814, 141, 21, '2024-04-22 04:45:38', '2024-05-13 01:55:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3815, 142, 5.59, '2024-04-22 04:45:48', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3816, 144, 20, '2024-04-22 04:45:48', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3817, 143, 153, '2024-04-22 04:45:48', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3818, 141, 21, '2024-04-22 04:45:48', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3819, 142, 4.64, '2024-04-22 04:45:58', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3820, 144, 14, '2024-04-22 04:45:58', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3821, 143, 169, '2024-04-22 04:45:58', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3822, 141, 21, '2024-04-22 04:45:58', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3823, 142, 4.71, '2024-04-22 04:46:08', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3824, 144, 13, '2024-04-22 04:46:08', '2024-05-13 01:55:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3825, 143, 183, '2024-04-22 04:46:08', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3826, 141, 21, '2024-04-22 04:46:08', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3827, 142, 5.14, '2024-04-22 04:46:18', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3828, 144, 15, '2024-04-22 04:46:18', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3829, 143, 176, '2024-04-22 04:46:18', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3830, 141, 21, '2024-04-22 04:46:18', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3831, 142, 5.49, '2024-04-22 04:46:28', '2024-05-13 01:55:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3832, 144, 21, '2024-04-22 04:46:28', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3833, 143, 174, '2024-04-22 04:46:28', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3834, 141, 21, '2024-04-22 04:46:28', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3835, 142, 5.47, '2024-04-22 04:46:38', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3836, 144, 16, '2024-04-22 04:46:38', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3837, 143, 174, '2024-04-22 04:46:38', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3838, 141, 21, '2024-04-22 04:46:38', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3839, 142, 5.81, '2024-04-22 04:46:48', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3840, 144, 19, '2024-04-22 04:46:48', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3841, 143, 173, '2024-04-22 04:46:48', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3842, 141, 21, '2024-04-22 04:46:48', '2024-05-13 01:55:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3843, 142, 5.6, '2024-04-22 04:46:58', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3844, 144, 20, '2024-04-22 04:46:58', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3845, 143, 173, '2024-04-22 04:46:58', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3846, 141, 21, '2024-04-22 04:46:58', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3847, 142, 5.41, '2024-04-22 04:47:08', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3848, 144, 8, '2024-04-22 04:47:08', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3849, 143, 171, '2024-04-22 04:47:08', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3850, 141, 21, '2024-04-22 04:47:08', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3851, 142, 4.74, '2024-04-22 04:47:18', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3852, 144, 9, '2024-04-22 04:47:18', '2024-05-13 01:55:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3853, 143, 179, '2024-04-22 04:47:18', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3854, 141, 21, '2024-04-22 04:47:18', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3855, 142, 4.94, '2024-04-22 04:47:28', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3856, 144, 18, '2024-04-22 04:47:28', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3857, 143, 187, '2024-04-22 04:47:28', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3858, 141, 21, '2024-04-22 04:47:28', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3859, 142, 5.21, '2024-04-22 04:47:38', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3860, 144, 13, '2024-04-22 04:47:38', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3861, 143, 178, '2024-04-22 04:47:38', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3862, 141, 21, '2024-04-22 04:47:38', '2024-05-13 01:56:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3863, 142, 4.76, '2024-04-22 04:47:49', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3864, 144, 11, '2024-04-22 04:47:49', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3865, 143, 178, '2024-04-22 04:47:49', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3866, 141, 21, '2024-04-22 04:47:49', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3867, 142, 4.9, '2024-04-22 04:47:59', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3868, 144, 7, '2024-04-22 04:47:59', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3869, 143, 178, '2024-04-22 04:47:59', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3870, 141, 20, '2024-04-22 04:47:59', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3871, 142, 4.96, '2024-04-22 04:48:09', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3872, 144, 19, '2024-04-22 04:48:09', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3873, 143, 178, '2024-04-22 04:48:09', '2024-05-13 01:56:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3874, 141, 20, '2024-04-22 04:48:09', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3875, 142, 5.34, '2024-04-22 04:48:19', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3876, 144, 16, '2024-04-22 04:48:19', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3877, 143, 182, '2024-04-22 04:48:19', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3878, 141, 21, '2024-04-22 04:48:19', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3879, 142, 5.22, '2024-04-22 04:48:29', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3880, 144, 19, '2024-04-22 04:48:29', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3881, 143, 187, '2024-04-22 04:48:29', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3882, 141, 21, '2024-04-22 04:48:29', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3883, 142, 5.41, '2024-04-22 04:48:39', '2024-05-13 01:56:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3884, 144, 15, '2024-04-22 04:48:39', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3885, 143, 186, '2024-04-22 04:48:39', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3886, 141, 21, '2024-04-22 04:48:39', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3887, 142, 5.51, '2024-04-22 04:48:49', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3888, 144, 20, '2024-04-22 04:48:49', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3889, 143, 185, '2024-04-22 04:48:49', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3890, 141, 20, '2024-04-22 04:48:49', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3891, 142, 5.3, '2024-04-22 04:48:59', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3892, 144, 20, '2024-04-22 04:48:59', '2024-05-13 01:56:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3893, 143, 185, '2024-04-22 04:48:59', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3894, 141, 20, '2024-04-22 04:48:59', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3895, 142, 5.65, '2024-04-22 04:49:09', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3896, 144, 20, '2024-04-22 04:49:09', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3897, 143, 184, '2024-04-22 04:49:09', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3898, 141, 20, '2024-04-22 04:49:09', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3899, 142, 5.92, '2024-04-22 04:49:19', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3900, 144, 19, '2024-04-22 04:49:19', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3901, 143, 184, '2024-04-22 04:49:19', '2024-05-13 01:56:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3902, 141, 20, '2024-04-22 04:49:19', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3903, 142, 5.75, '2024-04-22 04:49:29', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3904, 144, 19, '2024-04-22 04:49:29', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3905, 143, 184, '2024-04-22 04:49:29', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3906, 141, 20, '2024-04-22 04:49:29', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3907, 142, 5.82, '2024-04-22 04:49:39', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3908, 144, 20, '2024-04-22 04:49:39', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3909, 143, 184, '2024-04-22 04:49:39', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3910, 141, 20, '2024-04-22 04:49:39', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3911, 142, 5.7, '2024-04-22 04:49:49', '2024-05-13 01:56:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3912, 144, 21, '2024-04-22 04:49:49', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3913, 143, 183, '2024-04-22 04:49:49', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3914, 141, 20, '2024-04-22 04:49:49', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3915, 142, 5.66, '2024-04-22 04:49:59', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3916, 144, 15, '2024-04-22 04:49:59', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3917, 143, 183, '2024-04-22 04:49:59', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3918, 141, 20, '2024-04-22 04:49:59', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3919, 142, 5.3, '2024-04-22 04:50:09', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3920, 144, 15, '2024-04-22 04:50:09', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3921, 143, 185, '2024-04-22 04:50:09', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3922, 141, 20, '2024-04-22 04:50:09', '2024-05-13 01:56:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3923, 142, 5.53, '2024-04-22 04:50:20', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3924, 144, 18, '2024-04-22 04:50:20', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3925, 143, 184, '2024-04-22 04:50:20', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3926, 141, 20, '2024-04-22 04:50:20', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3927, 142, 5.77, '2024-04-22 04:50:30', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3928, 144, 16, '2024-04-22 04:50:30', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3929, 143, 183, '2024-04-22 04:50:30', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3930, 141, 20, '2024-04-22 04:50:30', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3931, 142, 5.4, '2024-04-22 04:50:40', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3932, 144, 19, '2024-04-22 04:50:40', '2024-05-13 01:56:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3933, 143, 184, '2024-04-22 04:50:40', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3934, 141, 20, '2024-04-22 04:50:40', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3935, 142, 5.35, '2024-04-22 04:50:50', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3936, 144, 16, '2024-04-22 04:50:50', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3937, 143, 182, '2024-04-22 04:50:50', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3938, 141, 20, '2024-04-22 04:50:50', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3939, 142, 5.35, '2024-04-22 04:51:00', '2024-05-13 01:56:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3940, 144, 18, '2024-04-22 04:51:00', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3941, 143, 182, '2024-04-22 04:51:00', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3942, 141, 20, '2024-04-22 04:51:00', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3943, 142, 5.73, '2024-04-22 04:51:10', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3944, 144, 18, '2024-04-22 04:51:10', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3945, 143, 181, '2024-04-22 04:51:10', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3946, 141, 21, '2024-04-22 04:51:10', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3947, 142, 5.59, '2024-04-22 04:51:20', '2024-05-13 01:56:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3948, 144, 20, '2024-04-22 04:51:20', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3949, 143, 182, '2024-04-22 04:51:20', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3950, 141, 21, '2024-04-22 04:51:20', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3951, 142, 5.65, '2024-04-22 04:51:30', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3952, 144, 21, '2024-04-22 04:51:30', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3953, 143, 181, '2024-04-22 04:51:30', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3954, 141, 21, '2024-04-22 04:51:30', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3955, 142, 5.39, '2024-04-22 04:51:40', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3956, 144, 20, '2024-04-22 04:51:40', '2024-05-13 01:56:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3957, 143, 182, '2024-04-22 04:51:40', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3958, 141, 21, '2024-04-22 04:51:40', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3959, 142, 5.5, '2024-04-22 04:51:50', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3960, 144, 21, '2024-04-22 04:51:50', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3961, 143, 182, '2024-04-22 04:51:50', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3962, 141, 21, '2024-04-22 04:51:50', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3963, 142, 5.74, '2024-04-22 04:52:00', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3964, 144, 15, '2024-04-22 04:52:00', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3965, 143, 181, '2024-04-22 04:52:00', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3966, 141, 22, '2024-04-22 04:52:00', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3967, 142, 5.51, '2024-04-22 04:52:10', '2024-05-13 01:56:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3968, 144, 19, '2024-04-22 04:52:10', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3969, 143, 181, '2024-04-22 04:52:10', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3970, 141, 22, '2024-04-22 04:52:10', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3971, 142, 5.34, '2024-04-22 04:52:20', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3972, 144, 16, '2024-04-22 04:52:20', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3973, 143, 182, '2024-04-22 04:52:20', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3974, 141, 22, '2024-04-22 04:52:20', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3975, 142, 5.23, '2024-04-22 04:52:30', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3976, 144, 15, '2024-04-22 04:52:30', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3977, 143, 182, '2024-04-22 04:52:30', '2024-05-13 01:56:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3978, 141, 22, '2024-04-22 04:52:30', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3979, 142, 5.53, '2024-04-22 04:52:41', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3980, 144, 16, '2024-04-22 04:52:41', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3981, 143, 175, '2024-04-22 04:52:41', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3982, 141, 22, '2024-04-22 04:52:41', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3983, 142, 5.61, '2024-04-22 04:52:51', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3984, 144, 16, '2024-04-22 04:52:51', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3985, 143, 179, '2024-04-22 04:52:51', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3986, 141, 22, '2024-04-22 04:52:51', '2024-05-13 01:56:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3987, 142, 5.31, '2024-04-22 04:53:01', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3988, 144, 16, '2024-04-22 04:53:01', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3989, 143, 173, '2024-04-22 04:53:01', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3990, 141, 23, '2024-04-22 04:53:01', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3991, 142, 5.69, '2024-04-22 04:53:11', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3992, 144, 21, '2024-04-22 04:53:11', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3993, 143, 173, '2024-04-22 04:53:11', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3994, 141, 23, '2024-04-22 04:53:11', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3995, 142, 5.45, '2024-04-22 04:53:21', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3996, 144, 16, '2024-04-22 04:53:21', '2024-05-13 01:56:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3997, 143, 173, '2024-04-22 04:53:21', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3998, 141, 23, '2024-04-22 04:53:21', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(3999, 142, 5.63, '2024-04-22 04:53:31', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4000, 144, 15, '2024-04-22 04:53:31', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4001, 143, 172, '2024-04-22 04:53:31', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4002, 141, 23, '2024-04-22 04:53:31', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4003, 142, 5.71, '2024-04-22 04:53:41', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4004, 144, 21, '2024-04-22 04:53:41', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4005, 143, 172, '2024-04-22 04:53:41', '2024-05-13 01:56:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4006, 141, 23, '2024-04-22 04:53:41', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4007, 142, 5.47, '2024-04-22 04:53:51', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4008, 144, 15, '2024-04-22 04:53:51', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4009, 143, 184, '2024-04-22 04:53:51', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4010, 141, 23, '2024-04-22 04:53:51', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4011, 142, 5.87, '2024-04-22 04:54:01', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4012, 144, 21, '2024-04-22 04:54:01', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4013, 143, 182, '2024-04-22 04:54:01', '2024-05-13 01:56:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4014, 141, 23, '2024-04-22 04:54:01', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4015, 142, 5.7, '2024-04-22 04:54:11', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4016, 144, 16, '2024-04-22 04:54:11', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4017, 143, 181, '2024-04-22 04:54:11', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4018, 141, 23, '2024-04-22 04:54:11', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4019, 142, 5.73, '2024-04-22 04:54:21', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4020, 144, 18, '2024-04-22 04:54:21', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4021, 143, 180, '2024-04-22 04:54:21', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4022, 141, 23, '2024-04-22 04:54:21', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4023, 142, 5.7, '2024-04-22 04:54:31', '2024-05-13 01:56:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4024, 144, 18, '2024-04-22 04:54:31', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4025, 143, 180, '2024-04-22 04:54:31', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4026, 141, 23, '2024-04-22 04:54:31', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4027, 142, 5.77, '2024-04-22 04:54:41', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4028, 144, 20, '2024-04-22 04:54:41', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4029, 143, 179, '2024-04-22 04:54:41', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4030, 141, 22, '2024-04-22 04:54:41', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4031, 142, 5.75, '2024-04-22 04:54:51', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4032, 144, 19, '2024-04-22 04:54:51', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4033, 143, 180, '2024-04-22 04:54:51', '2024-05-13 01:56:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4034, 141, 22, '2024-04-22 04:54:51', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4035, 142, 5.8, '2024-04-22 04:55:02', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4036, 144, 15, '2024-04-22 04:55:02', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4037, 143, 179, '2024-04-22 04:55:02', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4038, 141, 22, '2024-04-22 04:55:02', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4039, 142, 6, '2024-04-22 04:55:12', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4040, 144, 20, '2024-04-22 04:55:12', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4041, 143, 179, '2024-04-22 04:55:12', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4042, 141, 22, '2024-04-22 04:55:12', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4043, 142, 5.82, '2024-04-22 04:55:22', '2024-05-13 01:56:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4044, 144, 20, '2024-04-22 04:55:22', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4045, 143, 178, '2024-04-22 04:55:22', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4046, 141, 22, '2024-04-22 04:55:22', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4047, 142, 5.68, '2024-04-22 04:55:32', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4048, 144, 19, '2024-04-22 04:55:32', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4049, 143, 179, '2024-04-22 04:55:32', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4050, 141, 22, '2024-04-22 04:55:32', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4051, 142, 5.78, '2024-04-22 04:55:42', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4052, 144, 18, '2024-04-22 04:55:42', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4053, 143, 178, '2024-04-22 04:55:42', '2024-05-13 01:56:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4054, 141, 22, '2024-04-22 04:55:42', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4055, 142, 5.98, '2024-04-22 04:55:52', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4056, 144, 20, '2024-04-22 04:55:52', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4057, 143, 178, '2024-04-22 04:55:52', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4058, 141, 22, '2024-04-22 04:55:52', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4059, 142, 5.69, '2024-04-22 04:56:02', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4060, 144, 19, '2024-04-22 04:56:02', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4061, 143, 179, '2024-04-22 04:56:02', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4062, 141, 22, '2024-04-22 04:56:02', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4063, 142, 6, '2024-04-22 04:56:12', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4064, 144, 19, '2024-04-22 04:56:12', '2024-05-13 01:56:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4065, 143, 178, '2024-04-22 04:56:12', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4066, 141, 22, '2024-04-22 04:56:12', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4067, 142, 5.78, '2024-04-22 04:56:22', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4068, 144, 15, '2024-04-22 04:56:22', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4069, 143, 177, '2024-04-22 04:56:22', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4070, 141, 21, '2024-04-22 04:56:22', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4071, 142, 5.98, '2024-04-22 04:56:32', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4072, 144, 20, '2024-04-22 04:56:32', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4073, 143, 178, '2024-04-22 04:56:32', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4074, 141, 21, '2024-04-22 04:56:32', '2024-05-13 01:56:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4075, 142, 5.54, '2024-04-22 04:56:42', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4076, 144, 21, '2024-04-22 04:56:42', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4077, 143, 181, '2024-04-22 04:56:42', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4078, 141, 21, '2024-04-22 04:56:42', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4079, 142, 5.69, '2024-04-22 04:56:52', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4080, 144, 14, '2024-04-22 04:56:52', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4081, 143, 180, '2024-04-22 04:56:52', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4082, 141, 21, '2024-04-22 04:56:52', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4083, 142, 5.57, '2024-04-22 04:57:02', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4084, 144, 21, '2024-04-22 04:57:02', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4085, 143, 179, '2024-04-22 04:57:02', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4086, 141, 21, '2024-04-22 04:57:02', '2024-05-13 01:56:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4087, 142, 5.67, '2024-04-22 04:57:12', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4088, 144, 17, '2024-04-22 04:57:12', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4089, 143, 179, '2024-04-22 04:57:12', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4090, 141, 21, '2024-04-22 04:57:12', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4091, 142, 5.61, '2024-04-22 04:57:23', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4092, 144, 17, '2024-04-22 04:57:23', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4093, 143, 179, '2024-04-22 04:57:23', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4094, 141, 21, '2024-04-22 04:57:23', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4095, 142, 5.53, '2024-04-22 04:57:33', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4096, 144, 16, '2024-04-22 04:57:33', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4097, 143, 180, '2024-04-22 04:57:33', '2024-05-13 01:56:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4098, 141, 21, '2024-04-22 04:57:33', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4099, 142, 5.69, '2024-04-22 04:57:43', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4100, 144, 13, '2024-04-22 04:57:43', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4101, 143, 179, '2024-04-22 04:57:43', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4102, 141, 21, '2024-04-22 04:57:43', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4103, 142, 5.25, '2024-04-22 04:57:53', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4104, 144, 16, '2024-04-22 04:57:53', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4105, 143, 182, '2024-04-22 04:57:53', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4106, 141, 21, '2024-04-22 04:57:53', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4107, 142, 5.48, '2024-04-22 04:58:03', '2024-05-13 01:56:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4108, 144, 21, '2024-04-22 04:58:03', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4109, 143, 180, '2024-04-22 04:58:03', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4110, 141, 21, '2024-04-22 04:58:03', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4111, 142, 5.61, '2024-04-22 04:58:13', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4112, 144, 17, '2024-04-22 04:58:13', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4113, 143, 179, '2024-04-22 04:58:13', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4114, 141, 21, '2024-04-22 04:58:13', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4115, 142, 5.76, '2024-04-22 04:58:23', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4116, 144, 17, '2024-04-22 04:58:23', '2024-05-13 01:56:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4117, 143, 179, '2024-04-22 04:58:23', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4118, 141, 21, '2024-04-22 04:58:23', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4119, 142, 5.88, '2024-04-22 04:58:33', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4120, 144, 19, '2024-04-22 04:58:33', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4121, 143, 179, '2024-04-22 04:58:33', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4122, 141, 21, '2024-04-22 04:58:33', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4123, 142, 5.52, '2024-04-22 04:58:43', '2024-05-13 01:56:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4124, 144, 19, '2024-04-22 04:58:43', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4125, 143, 180, '2024-04-22 04:58:43', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4126, 141, 21, '2024-04-22 04:58:43', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4127, 142, 5.84, '2024-04-22 04:58:53', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4128, 144, 16, '2024-04-22 04:58:53', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4129, 143, 179, '2024-04-22 04:58:53', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4130, 141, 21, '2024-04-22 04:58:53', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4131, 142, 5.71, '2024-04-22 04:59:03', '2024-05-13 01:56:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4132, 144, 16, '2024-04-22 04:59:03', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4133, 143, 178, '2024-04-22 04:59:03', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4134, 141, 21, '2024-04-22 04:59:03', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4135, 142, 5.98, '2024-04-22 04:59:13', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4136, 144, 16, '2024-04-22 04:59:13', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4137, 143, 177, '2024-04-22 04:59:13', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4138, 141, 21, '2024-04-22 04:59:13', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4139, 142, 5.69, '2024-04-22 04:59:23', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4140, 144, 17, '2024-04-22 04:59:23', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4141, 143, 178, '2024-04-22 04:59:23', '2024-05-13 01:56:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4142, 141, 21, '2024-04-22 04:59:23', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4143, 142, 5.66, '2024-04-22 04:59:33', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4144, 144, 16, '2024-04-22 04:59:33', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4145, 143, 178, '2024-04-22 04:59:33', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4146, 141, 20, '2024-04-22 04:59:33', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4147, 142, 5.84, '2024-04-22 04:59:44', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4148, 144, 16, '2024-04-22 04:59:44', '2024-05-13 01:56:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4149, 143, 179, '2024-04-22 04:59:44', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4150, 141, 20, '2024-04-22 04:59:44', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4151, 142, 5.97, '2024-04-22 04:59:54', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4152, 144, 16, '2024-04-22 04:59:54', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4153, 143, 177, '2024-04-22 04:59:54', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4154, 141, 20, '2024-04-22 04:59:54', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4155, 142, 5.56, '2024-04-22 05:00:04', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4156, 144, 17, '2024-04-22 05:00:04', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4157, 143, 180, '2024-04-22 05:00:04', '2024-05-13 01:56:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4158, 141, 20, '2024-04-22 05:00:04', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4159, 142, 5.65, '2024-04-22 05:00:14', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4160, 144, 20, '2024-04-22 05:00:14', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4161, 143, 178, '2024-04-22 05:00:14', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4162, 141, 20, '2024-04-22 05:00:14', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4163, 142, 5.41, '2024-04-22 05:00:24', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4164, 144, 19, '2024-04-22 05:00:24', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4165, 143, 179, '2024-04-22 05:00:24', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4166, 141, 20, '2024-04-22 05:00:24', '2024-05-13 01:56:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4167, 142, 5.5, '2024-04-22 05:00:34', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4168, 144, 19, '2024-04-22 05:00:34', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4169, 143, 180, '2024-04-22 05:00:34', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4170, 141, 20, '2024-04-22 05:00:34', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4171, 142, 5.68, '2024-04-22 05:00:44', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4172, 144, 15, '2024-04-22 05:00:44', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4173, 143, 179, '2024-04-22 05:00:44', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4174, 141, 20, '2024-04-22 05:00:44', '2024-05-13 01:56:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4175, 142, 5.76, '2024-04-22 05:00:54', '2024-05-13 01:56:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4176, 144, 20, '2024-04-22 05:00:54', '2024-05-13 01:56:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4177, 143, 179, '2024-04-22 05:00:54', '2024-05-13 01:56:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4178, 141, 20, '2024-04-22 05:00:54', '2024-05-13 01:56:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4179, 142, 5.55, '2024-04-22 05:01:04', '2024-05-13 01:56:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4180, 144, 11, '2024-04-22 05:01:04', '2024-05-13 01:56:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4181, 143, 178, '2024-04-22 05:01:04', '2024-05-13 01:56:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4182, 141, 20, '2024-04-22 05:01:04', '2024-05-13 01:56:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4183, 142, 5.92, '2024-04-22 05:01:14', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4184, 144, 19, '2024-04-22 05:01:14', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4185, 143, 177, '2024-04-22 05:01:14', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4186, 141, 20, '2024-04-22 05:01:14', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4187, 142, 5.47, '2024-04-22 05:01:24', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4188, 144, 19, '2024-04-22 05:01:24', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4189, 143, 179, '2024-04-22 05:01:24', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4190, 141, 20, '2024-04-22 05:01:24', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4191, 142, 5.93, '2024-04-22 05:01:34', '2024-05-13 01:56:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4192, 144, 21, '2024-04-22 05:01:34', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4193, 143, 177, '2024-04-22 05:01:34', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4194, 141, 20, '2024-04-22 05:01:34', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4195, 142, 5.97, '2024-04-22 05:01:44', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4196, 144, 21, '2024-04-22 05:01:44', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4197, 143, 176, '2024-04-22 05:01:44', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4198, 141, 20, '2024-04-22 05:01:44', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4199, 142, 5.92, '2024-04-22 05:01:54', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4200, 144, 17, '2024-04-22 05:01:54', '2024-05-13 01:56:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4201, 143, 176, '2024-04-22 05:01:54', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4202, 141, 20, '2024-04-22 05:01:54', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4203, 142, 5.35, '2024-04-22 05:02:05', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4204, 144, 15, '2024-04-22 05:02:05', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4205, 143, 178, '2024-04-22 05:02:05', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4206, 141, 20, '2024-04-22 05:02:05', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4207, 142, 5.66, '2024-04-22 05:02:15', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4208, 144, 16, '2024-04-22 05:02:15', '2024-05-13 01:56:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4209, 143, 178, '2024-04-22 05:02:15', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4210, 141, 20, '2024-04-22 05:02:15', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4211, 142, 5.82, '2024-04-22 05:02:25', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4212, 144, 20, '2024-04-22 05:02:25', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4213, 143, 178, '2024-04-22 05:02:25', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4214, 141, 20, '2024-04-22 05:02:25', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4215, 142, 5.55, '2024-04-22 05:02:35', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4216, 144, 19, '2024-04-22 05:02:35', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4217, 143, 178, '2024-04-22 05:02:35', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4218, 141, 20, '2024-04-22 05:02:35', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4219, 142, 5.88, '2024-04-22 05:02:45', '2024-05-13 01:56:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4220, 144, 15, '2024-04-22 05:02:45', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4221, 143, 177, '2024-04-22 05:02:45', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4222, 141, 20, '2024-04-22 05:02:45', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4223, 142, 5.73, '2024-04-22 05:02:55', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4224, 144, 17, '2024-04-22 05:02:55', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4225, 143, 176, '2024-04-22 05:02:55', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4226, 141, 20, '2024-04-22 05:02:55', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4227, 142, 5.73, '2024-04-22 05:03:05', '2024-05-13 01:56:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4228, 144, 21, '2024-04-22 05:03:05', '2024-05-13 01:56:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4229, 143, 176, '2024-04-22 05:03:05', '2024-05-13 01:56:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4230, 141, 20, '2024-04-22 05:03:05', '2024-05-13 01:56:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4231, 142, 5.98, '2024-04-22 05:03:15', '2024-05-13 01:56:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4232, 144, 20, '2024-04-22 05:03:15', '2024-05-13 01:56:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4233, 143, 175, '2024-04-22 05:03:15', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4234, 141, 19, '2024-04-22 05:03:15', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4235, 142, 5.81, '2024-04-22 05:03:25', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4236, 144, 17, '2024-04-22 05:03:25', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4237, 143, 174, '2024-04-22 05:03:25', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4238, 141, 19, '2024-04-22 05:03:25', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4239, 142, 5.77, '2024-04-22 05:03:35', '2024-05-13 01:56:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4240, 144, 18, '2024-04-22 05:03:35', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4241, 143, 174, '2024-04-22 05:03:35', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4242, 141, 19, '2024-04-22 05:03:35', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4243, 142, 6.02, '2024-04-22 05:03:45', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4244, 144, 21, '2024-04-22 05:03:45', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4245, 143, 173, '2024-04-22 05:03:45', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4246, 141, 19, '2024-04-22 05:03:45', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4247, 142, 5.98, '2024-04-22 05:03:55', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4248, 144, 17, '2024-04-22 05:03:55', '2024-05-13 01:56:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4249, 143, 173, '2024-04-22 05:03:55', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4250, 141, 19, '2024-04-22 05:03:55', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4251, 142, 5.75, '2024-04-22 05:04:05', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4252, 144, 21, '2024-04-22 05:04:05', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4253, 143, 173, '2024-04-22 05:04:05', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4254, 141, 19, '2024-04-22 05:04:05', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4255, 142, 5.95, '2024-04-22 05:04:15', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4256, 144, 21, '2024-04-22 05:04:15', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4257, 143, 174, '2024-04-22 05:04:15', '2024-05-13 01:56:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4258, 141, 19, '2024-04-22 05:04:15', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4259, 142, 5.76, '2024-04-22 05:04:26', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4260, 144, 20, '2024-04-22 05:04:26', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4261, 143, 174, '2024-04-22 05:04:26', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4262, 141, 19, '2024-04-22 05:04:26', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4263, 142, 5.97, '2024-04-22 05:04:36', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4264, 144, 19, '2024-04-22 05:04:36', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4265, 143, 173, '2024-04-22 05:04:36', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4266, 141, 19, '2024-04-22 05:04:36', '2024-05-13 01:56:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4267, 142, 5.78, '2024-04-22 05:04:46', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4268, 144, 17, '2024-04-22 05:04:46', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4269, 143, 174, '2024-04-22 05:04:46', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4270, 141, 19, '2024-04-22 05:04:46', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4271, 142, 5.93, '2024-04-22 05:04:56', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4272, 144, 21, '2024-04-22 05:04:56', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4273, 143, 174, '2024-04-22 05:04:56', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4274, 141, 19, '2024-04-22 05:04:56', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4275, 142, 5.67, '2024-04-22 05:05:06', '2024-05-13 01:56:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4276, 144, 17, '2024-04-22 05:05:06', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4277, 143, 174, '2024-04-22 05:05:06', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4278, 141, 19, '2024-04-22 05:05:06', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4279, 142, 5.71, '2024-04-22 05:05:16', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4280, 144, 21, '2024-04-22 05:05:16', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4281, 143, 174, '2024-04-22 05:05:16', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4282, 141, 19, '2024-04-22 05:05:16', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4283, 142, 5.92, '2024-04-22 05:05:26', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4284, 144, 20, '2024-04-22 05:05:26', '2024-05-13 01:56:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4285, 143, 175, '2024-04-22 05:05:26', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4286, 141, 19, '2024-04-22 05:05:26', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4287, 142, 5.97, '2024-04-22 05:05:36', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4288, 144, 17, '2024-04-22 05:05:36', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4289, 143, 174, '2024-04-22 05:05:36', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4290, 141, 19, '2024-04-22 05:05:36', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4291, 142, 5.77, '2024-04-22 05:05:46', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4292, 144, 21, '2024-04-22 05:05:46', '2024-05-13 01:56:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4293, 143, 173, '2024-04-22 05:05:46', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4294, 141, 19, '2024-04-22 05:05:46', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4295, 142, 5.86, '2024-04-22 05:05:56', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4296, 144, 19, '2024-04-22 05:05:56', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4297, 143, 174, '2024-04-22 05:05:56', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4298, 141, 19, '2024-04-22 05:05:56', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4299, 142, 5.92, '2024-04-22 05:06:06', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4300, 144, 21, '2024-04-22 05:06:06', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4301, 143, 174, '2024-04-22 05:06:06', '2024-05-13 01:56:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4302, 141, 19, '2024-04-22 05:06:06', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4303, 142, 5.68, '2024-04-22 05:06:16', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4304, 144, 19, '2024-04-22 05:06:16', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4305, 143, 173, '2024-04-22 05:06:16', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4306, 141, 19, '2024-04-22 05:06:16', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4307, 142, 5.98, '2024-04-22 05:06:26', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4308, 144, 21, '2024-04-22 05:06:26', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4309, 143, 173, '2024-04-22 05:06:26', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4310, 141, 19, '2024-04-22 05:06:26', '2024-05-13 01:56:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4311, 142, 5.91, '2024-04-22 05:06:36', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4312, 144, 18, '2024-04-22 05:06:36', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4313, 143, 173, '2024-04-22 05:06:36', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4314, 141, 19, '2024-04-22 05:06:36', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4315, 142, 5.69, '2024-04-22 05:06:46', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4316, 144, 21, '2024-04-22 05:06:46', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4317, 143, 173, '2024-04-22 05:06:46', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4318, 141, 19, '2024-04-22 05:06:46', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4319, 142, 5.9, '2024-04-22 05:06:57', '2024-05-13 01:56:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4320, 144, 21, '2024-04-22 05:06:57', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4321, 143, 173, '2024-04-22 05:06:57', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4322, 141, 19, '2024-04-22 05:06:57', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4323, 142, 5.94, '2024-04-22 05:07:07', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4324, 144, 17, '2024-04-22 05:07:07', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4325, 143, 173, '2024-04-22 05:07:07', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4326, 141, 19, '2024-04-22 05:07:07', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4327, 142, 6, '2024-04-22 05:07:17', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4328, 144, 20, '2024-04-22 05:07:17', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4329, 143, 173, '2024-04-22 05:07:17', '2024-05-13 01:56:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4330, 141, 19, '2024-04-22 05:07:17', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4331, 142, 5.79, '2024-04-22 05:07:27', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4332, 144, 17, '2024-04-22 05:07:27', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4333, 143, 173, '2024-04-22 05:07:27', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4334, 141, 18, '2024-04-22 05:07:27', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4335, 142, 5.77, '2024-04-22 05:07:37', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4336, 144, 21, '2024-04-22 05:07:37', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4337, 143, 173, '2024-04-22 05:07:37', '2024-05-13 01:56:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4338, 141, 19, '2024-04-22 05:07:37', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4339, 142, 5.76, '2024-04-22 05:07:47', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4340, 144, 17, '2024-04-22 05:07:47', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4341, 143, 173, '2024-04-22 05:07:47', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4342, 141, 18, '2024-04-22 05:07:47', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4343, 142, 4.76, '2024-04-22 05:07:57', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4344, 144, 15, '2024-04-22 05:07:57', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4345, 143, 177, '2024-04-22 05:07:57', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4346, 141, 18, '2024-04-22 05:07:57', '2024-05-13 01:56:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4347, 142, 5.23, '2024-04-22 05:08:07', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4348, 144, 19, '2024-04-22 05:08:07', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4349, 143, 176, '2024-04-22 05:08:07', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4350, 141, 18, '2024-04-22 05:08:07', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4351, 142, 5.28, '2024-04-22 05:08:17', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4352, 144, 20, '2024-04-22 05:08:17', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4353, 143, 176, '2024-04-22 05:08:17', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4354, 141, 18, '2024-04-22 05:08:17', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4355, 142, 5.58, '2024-04-22 05:08:27', '2024-05-13 01:56:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4356, 144, 18, '2024-04-22 05:08:27', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4357, 143, 176, '2024-04-22 05:08:27', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4358, 141, 18, '2024-04-22 05:08:27', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4359, 142, 5.43, '2024-04-22 05:08:37', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4360, 144, 18, '2024-04-22 05:08:37', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4361, 143, 176, '2024-04-22 05:08:37', '2024-05-13 01:56:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4362, 141, 18, '2024-04-22 05:08:37', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4363, 142, 5.09, '2024-04-22 05:08:47', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4364, 144, 18, '2024-04-22 05:08:47', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4365, 143, 177, '2024-04-22 05:08:47', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4366, 141, 18, '2024-04-22 05:08:47', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4367, 142, 5.79, '2024-04-22 05:08:57', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4368, 144, 18, '2024-04-22 05:08:57', '2024-05-13 01:56:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4369, 143, 175, '2024-04-22 05:08:57', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4370, 141, 18, '2024-04-22 05:08:57', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4371, 142, 5.82, '2024-04-22 05:11:03', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4372, 144, 6, '2024-04-22 05:11:03', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4373, 143, 175, '2024-04-22 05:11:03', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4374, 141, 20, '2024-04-22 05:11:03', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4375, 142, 5.73, '2024-04-22 05:11:13', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4376, 144, 9, '2024-04-22 05:11:13', '2024-05-13 01:56:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4377, 143, 174, '2024-04-22 05:11:13', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4378, 141, 19, '2024-04-22 05:11:13', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4379, 142, 5.46, '2024-04-22 05:11:23', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4380, 144, 9, '2024-04-22 05:11:23', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4381, 143, 177, '2024-04-22 05:11:23', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4382, 141, 21, '2024-04-22 05:11:23', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4383, 142, 5.85, '2024-04-22 05:11:33', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4384, 144, 9, '2024-04-22 05:11:33', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4385, 143, 177, '2024-04-22 05:11:33', '2024-05-13 01:56:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4386, 141, 21, '2024-04-22 05:11:33', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4387, 142, 5.53, '2024-04-22 05:11:43', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4388, 144, 9, '2024-04-22 05:11:43', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4389, 143, 177, '2024-04-22 05:11:43', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4390, 141, 20, '2024-04-22 05:11:43', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4391, 142, 5.29, '2024-04-22 05:18:14', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4392, 144, 5, '2024-04-22 05:18:14', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4393, 143, 175, '2024-04-22 05:18:14', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4394, 141, 21, '2024-04-22 05:18:14', '2024-05-13 01:57:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4395, 142, 5.49, '2024-04-22 05:19:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4396, 144, 9, '2024-04-22 05:19:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4397, 143, 175, '2024-04-22 05:19:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4398, 141, 21, '2024-04-22 05:19:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4399, 142, 5.45, '2024-04-22 05:20:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4400, 144, 8, '2024-04-22 05:20:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4401, 143, 174, '2024-04-22 05:20:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4402, 141, 21, '2024-04-22 05:20:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4403, 142, 5.23, '2024-04-22 05:21:15', '2024-05-13 01:57:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4404, 144, 8, '2024-04-22 05:21:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4405, 143, 175, '2024-04-22 05:21:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4406, 141, 21, '2024-04-22 05:21:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4407, 142, 5.12, '2024-04-22 05:22:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4408, 144, 7, '2024-04-22 05:22:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4409, 143, 175, '2024-04-22 05:22:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4410, 141, 20, '2024-04-22 05:22:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4411, 142, 5.43, '2024-04-22 05:23:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4412, 144, 9, '2024-04-22 05:23:15', '2024-05-13 01:57:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4413, 143, 174, '2024-04-22 05:23:15', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4414, 141, 20, '2024-04-22 05:23:15', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4415, 142, 5.62, '2024-04-22 05:24:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4416, 144, 8, '2024-04-22 05:24:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4417, 143, 174, '2024-04-22 05:24:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4418, 141, 20, '2024-04-22 05:24:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4419, 142, 5.77, '2024-04-22 05:25:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4420, 144, 9, '2024-04-22 05:25:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4421, 143, 173, '2024-04-22 05:25:16', '2024-05-13 01:57:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4422, 141, 20, '2024-04-22 05:25:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4423, 142, 5.11, '2024-04-22 05:26:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4424, 144, 8, '2024-04-22 05:26:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4425, 143, 173, '2024-04-22 05:26:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4426, 141, 23, '2024-04-22 05:26:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4427, 142, 5.44, '2024-04-22 05:27:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4428, 144, 8, '2024-04-22 05:27:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4429, 143, 172, '2024-04-22 05:27:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4430, 141, 24, '2024-04-22 05:27:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4431, 142, 5.51, '2024-04-22 05:28:16', '2024-05-13 01:57:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4432, 144, 8, '2024-04-22 05:28:16', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4433, 143, 170, '2024-04-22 05:28:16', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4434, 141, 24, '2024-04-22 05:28:16', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4435, 142, 5.38, '2024-04-22 05:29:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4436, 144, 8, '2024-04-22 05:29:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4437, 143, 168, '2024-04-22 05:29:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4438, 141, 24, '2024-04-22 05:29:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4439, 142, 5.69, '2024-04-22 05:30:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4440, 144, 8, '2024-04-22 05:30:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4441, 143, 170, '2024-04-22 05:30:17', '2024-05-13 01:57:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4442, 141, 23, '2024-04-22 05:30:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4443, 142, 5.76, '2024-04-22 05:31:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4444, 144, 8, '2024-04-22 05:31:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4445, 143, 169, '2024-04-22 05:31:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4446, 141, 22, '2024-04-22 05:31:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4447, 142, 5.4, '2024-04-22 05:32:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4448, 144, 8, '2024-04-22 05:32:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4449, 143, 168, '2024-04-22 05:32:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4450, 141, 22, '2024-04-22 05:32:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4451, 142, 5.26, '2024-04-22 05:33:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4452, 144, 8, '2024-04-22 05:33:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4453, 143, 168, '2024-04-22 05:33:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4454, 141, 25, '2024-04-22 05:33:17', '2024-05-13 01:57:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4455, 142, 5.4, '2024-04-22 05:34:17', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4456, 144, 8, '2024-04-22 05:34:17', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4457, 143, 169, '2024-04-22 05:34:17', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4458, 141, 25, '2024-04-22 05:34:17', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4459, 142, 5.42, '2024-04-22 05:35:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4460, 144, 8, '2024-04-22 05:35:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4461, 143, 167, '2024-04-22 05:35:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4462, 141, 25, '2024-04-22 05:35:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4463, 142, 5.34, '2024-04-22 05:36:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4464, 144, 8, '2024-04-22 05:36:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4465, 143, 171, '2024-04-22 05:36:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4466, 141, 26, '2024-04-22 05:36:18', '2024-05-13 01:57:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4467, 142, 5.28, '2024-04-22 05:37:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4468, 144, 8, '2024-04-22 05:37:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4469, 143, 171, '2024-04-22 05:37:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4470, 141, 27, '2024-04-22 05:37:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4471, 142, 5.56, '2024-04-22 05:38:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4472, 144, 8, '2024-04-22 05:38:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4473, 143, 170, '2024-04-22 05:38:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4474, 141, 31, '2024-04-22 05:38:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4475, 142, 5.38, '2024-04-22 05:39:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4476, 144, 8, '2024-04-22 05:39:18', '2024-05-13 01:57:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4477, 143, 172, '2024-04-22 05:39:18', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4478, 141, 31, '2024-04-22 05:39:18', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4479, 142, 5.38, '2024-04-22 05:40:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4480, 144, 8, '2024-04-22 05:40:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4481, 143, 171, '2024-04-22 05:40:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4482, 141, 30, '2024-04-22 05:40:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4483, 142, 5.56, '2024-04-22 05:41:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4484, 144, 8, '2024-04-22 05:41:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4485, 143, 171, '2024-04-22 05:41:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4486, 141, 29, '2024-04-22 05:41:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4487, 142, 5.51, '2024-04-22 05:42:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4488, 144, 8, '2024-04-22 05:42:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4489, 143, 171, '2024-04-22 05:42:19', '2024-05-13 01:57:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4490, 141, 28, '2024-04-22 05:42:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4491, 142, 5.02, '2024-04-22 05:43:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4492, 144, 9, '2024-04-22 05:43:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4493, 143, 171, '2024-04-22 05:43:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4494, 141, 28, '2024-04-22 05:43:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4495, 142, 5.25, '2024-04-22 05:44:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4496, 144, 8, '2024-04-22 05:44:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4497, 143, 171, '2024-04-22 05:44:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4498, 141, 27, '2024-04-22 05:44:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4499, 142, 5.4, '2024-04-22 05:45:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4500, 144, 8, '2024-04-22 05:45:19', '2024-05-13 01:57:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4501, 143, 169, '2024-04-22 05:45:19', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4502, 141, 26, '2024-04-22 05:45:19', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4503, 142, 5.28, '2024-04-22 05:46:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4504, 144, 9, '2024-04-22 05:46:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4505, 143, 171, '2024-04-22 05:46:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4506, 141, 26, '2024-04-22 05:46:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4507, 142, 5.54, '2024-04-22 05:47:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4508, 144, 8, '2024-04-22 05:47:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4509, 143, 171, '2024-04-22 05:47:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4510, 141, 25, '2024-04-22 05:47:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4511, 142, 5.76, '2024-04-22 05:48:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4512, 144, 9, '2024-04-22 05:48:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4513, 143, 170, '2024-04-22 05:48:20', '2024-05-13 01:57:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4514, 141, 24, '2024-04-22 05:48:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4515, 142, 5.35, '2024-04-22 05:49:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4516, 144, 9, '2024-04-22 05:49:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4517, 143, 171, '2024-04-22 05:49:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4518, 141, 24, '2024-04-22 05:49:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4519, 142, 5.42, '2024-04-22 05:50:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4520, 144, 8, '2024-04-22 05:50:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4521, 143, 170, '2024-04-22 05:50:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4522, 141, 23, '2024-04-22 05:50:20', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4523, 142, 5.65, '2024-04-22 05:51:21', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4524, 144, 8, '2024-04-22 05:51:21', '2024-05-13 01:57:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4525, 143, 171, '2024-04-22 05:51:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4526, 141, 23, '2024-04-22 05:51:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4527, 142, 5.52, '2024-04-22 05:52:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4528, 144, 7, '2024-04-22 05:52:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4529, 143, 171, '2024-04-22 05:52:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4530, 141, 23, '2024-04-22 05:52:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4531, 142, 5.38, '2024-04-22 05:53:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4532, 144, 8, '2024-04-22 05:53:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4533, 143, 170, '2024-04-22 05:53:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4534, 141, 22, '2024-04-22 05:53:21', '2024-05-13 01:57:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4535, 142, 4.96, '2024-04-22 05:54:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4536, 144, 8, '2024-04-22 05:54:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4537, 143, 169, '2024-04-22 05:54:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4538, 141, 21, '2024-04-22 05:54:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4539, 142, 5.52, '2024-04-22 05:55:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4540, 144, 8, '2024-04-22 05:55:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4541, 143, 170, '2024-04-22 05:55:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4542, 141, 21, '2024-04-22 05:55:21', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4543, 142, 5.35, '2024-04-22 05:56:22', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4544, 144, 8, '2024-04-22 05:56:22', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4545, 143, 170, '2024-04-22 05:56:22', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4546, 141, 20, '2024-04-22 05:56:22', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4547, 142, 5.27, '2024-04-22 05:57:22', '2024-05-13 01:57:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4548, 144, 9, '2024-04-22 05:57:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4549, 143, 170, '2024-04-22 05:57:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4550, 141, 20, '2024-04-22 05:57:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4551, 142, 5.47, '2024-04-22 05:58:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4552, 144, 9, '2024-04-22 05:58:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4553, 143, 170, '2024-04-22 05:58:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4554, 141, 20, '2024-04-22 05:58:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4555, 142, 5.33, '2024-04-22 05:59:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4556, 144, 9, '2024-04-22 05:59:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4557, 143, 169, '2024-04-22 05:59:22', '2024-05-13 01:57:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4558, 141, 20, '2024-04-22 05:59:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4559, 142, 5.43, '2024-04-22 06:00:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4560, 144, 9, '2024-04-22 06:00:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4561, 143, 169, '2024-04-22 06:00:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4562, 141, 20, '2024-04-22 06:00:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4563, 142, 5.61, '2024-04-22 06:01:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4564, 144, 8, '2024-04-22 06:01:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4565, 143, 169, '2024-04-22 06:01:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4566, 141, 19, '2024-04-22 06:01:22', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4567, 142, 5.07, '2024-04-22 06:02:23', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4568, 144, 8, '2024-04-22 06:02:23', '2024-05-13 01:57:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4569, 143, 166, '2024-04-22 06:02:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4570, 141, 19, '2024-04-22 06:02:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4571, 142, 5.65, '2024-04-22 06:03:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4572, 144, 8, '2024-04-22 06:03:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4573, 143, 169, '2024-04-22 06:03:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4574, 141, 19, '2024-04-22 06:03:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4575, 142, 5.17, '2024-04-22 06:04:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4576, 144, 8, '2024-04-22 06:04:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4577, 143, 169, '2024-04-22 06:04:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4578, 141, 19, '2024-04-22 06:04:23', '2024-05-13 01:57:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4579, 142, 5.23, '2024-04-22 06:05:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4580, 144, 7, '2024-04-22 06:05:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4581, 143, 170, '2024-04-22 06:05:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4582, 141, 19, '2024-04-22 06:05:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4583, 142, 5.37, '2024-04-22 06:06:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4584, 144, 9, '2024-04-22 06:06:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4585, 143, 169, '2024-04-22 06:06:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4586, 141, 19, '2024-04-22 06:06:23', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4587, 142, 5.56, '2024-04-22 06:07:24', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4588, 144, 9, '2024-04-22 06:07:24', '2024-05-13 01:57:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4589, 143, 169, '2024-04-22 06:07:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4590, 141, 19, '2024-04-22 06:07:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4591, 142, 5.96, '2024-04-22 06:08:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4592, 144, 8, '2024-04-22 06:08:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4593, 143, 168, '2024-04-22 06:08:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4594, 141, 19, '2024-04-22 06:08:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4595, 142, 5.94, '2024-04-22 06:09:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4596, 144, 9, '2024-04-22 06:09:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4597, 143, 167, '2024-04-22 06:09:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4598, 141, 18, '2024-04-22 06:09:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4599, 142, 5.68, '2024-04-22 06:10:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4600, 144, 9, '2024-04-22 06:10:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4601, 143, 168, '2024-04-22 06:10:24', '2024-05-13 01:57:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4602, 141, 18, '2024-04-22 06:10:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4603, 142, 5.61, '2024-04-22 06:11:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4604, 144, 8, '2024-04-22 06:11:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4605, 143, 168, '2024-04-22 06:11:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4606, 141, 18, '2024-04-22 06:11:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4607, 142, 5.38, '2024-04-22 06:12:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4608, 144, 8, '2024-04-22 06:12:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4609, 143, 168, '2024-04-22 06:12:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4610, 141, 18, '2024-04-22 06:12:24', '2024-05-13 01:57:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4611, 142, 5.82, '2024-04-22 06:13:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4612, 144, 9, '2024-04-22 06:13:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4613, 143, 167, '2024-04-22 06:13:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4614, 141, 18, '2024-04-22 06:13:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4615, 142, 5.65, '2024-04-22 06:14:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4616, 144, 9, '2024-04-22 06:14:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4617, 143, 166, '2024-04-22 06:14:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4618, 141, 18, '2024-04-22 06:14:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4619, 142, 5.88, '2024-04-22 06:15:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4620, 144, 9, '2024-04-22 06:15:25', '2024-05-13 01:57:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4621, 143, 165, '2024-04-22 06:15:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4622, 141, 20, '2024-04-22 06:15:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4623, 142, 5.69, '2024-04-22 06:16:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4624, 144, 9, '2024-04-22 06:16:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4625, 143, 165, '2024-04-22 06:16:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4626, 141, 21, '2024-04-22 06:16:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4627, 142, 5.5, '2024-04-22 06:17:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4628, 144, 8, '2024-04-22 06:17:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4629, 143, 168, '2024-04-22 06:17:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4630, 141, 20, '2024-04-22 06:17:25', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4631, 142, 5.25, '2024-04-22 06:18:26', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4632, 144, 8, '2024-04-22 06:18:26', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4633, 143, 168, '2024-04-22 06:18:26', '2024-05-13 01:57:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4634, 141, 20, '2024-04-22 06:18:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4635, 142, 4.94, '2024-04-22 06:19:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4636, 144, 8, '2024-04-22 06:19:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4637, 143, 167, '2024-04-22 06:19:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4638, 141, 20, '2024-04-22 06:19:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4639, 142, 5.04, '2024-04-22 06:20:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4640, 144, 9, '2024-04-22 06:20:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4641, 143, 168, '2024-04-22 06:20:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4642, 141, 20, '2024-04-22 06:20:26', '2024-05-13 01:57:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4643, 142, 5.31, '2024-04-22 06:21:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4644, 144, 8, '2024-04-22 06:21:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4645, 143, 168, '2024-04-22 06:21:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4646, 141, 20, '2024-04-22 06:21:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4647, 142, 4.88, '2024-04-22 06:22:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4648, 144, 8, '2024-04-22 06:22:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4649, 143, 168, '2024-04-22 06:22:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4650, 141, 20, '2024-04-22 06:22:26', '2024-05-13 01:57:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4651, 142, 5.03, '2024-04-22 06:23:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4652, 144, 8, '2024-04-22 06:23:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4653, 143, 167, '2024-04-22 06:23:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4654, 141, 19, '2024-04-22 06:23:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4655, 142, 5.17, '2024-04-22 06:24:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4656, 144, 8, '2024-04-22 06:24:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4657, 143, 168, '2024-04-22 06:24:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4658, 141, 19, '2024-04-22 06:24:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4659, 142, 5.38, '2024-04-22 06:25:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4660, 144, 8, '2024-04-22 06:25:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4661, 143, 167, '2024-04-22 06:25:27', '2024-05-13 01:57:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4662, 141, 19, '2024-04-22 06:25:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4663, 142, 5.11, '2024-04-22 06:26:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4664, 144, 8, '2024-04-22 06:26:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4665, 143, 168, '2024-04-22 06:26:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4666, 141, 19, '2024-04-22 06:26:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4667, 142, 5.03, '2024-04-22 06:27:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4668, 144, 8, '2024-04-22 06:27:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4669, 143, 168, '2024-04-22 06:27:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4670, 141, 19, '2024-04-22 06:27:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4671, 142, 5.21, '2024-04-22 06:28:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4672, 144, 8, '2024-04-22 06:28:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4673, 143, 168, '2024-04-22 06:28:27', '2024-05-13 01:57:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4674, 141, 18, '2024-04-22 06:28:27', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4675, 142, 5.1, '2024-04-22 06:29:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4676, 144, 8, '2024-04-22 06:29:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4677, 143, 168, '2024-04-22 06:29:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4678, 141, 19, '2024-04-22 06:29:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4679, 142, 5.01, '2024-04-22 06:30:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4680, 144, 8, '2024-04-22 06:30:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4681, 143, 166, '2024-04-22 06:30:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4682, 141, 19, '2024-04-22 06:30:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4683, 142, 5.35, '2024-04-22 06:31:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4684, 144, 8, '2024-04-22 06:31:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4685, 143, 167, '2024-04-22 06:31:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4686, 141, 19, '2024-04-22 06:31:28', '2024-05-13 01:57:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4687, 142, 4.92, '2024-04-22 06:32:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4688, 144, 8, '2024-04-22 06:32:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4689, 143, 168, '2024-04-22 06:32:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4690, 141, 19, '2024-04-22 06:32:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4691, 142, 5.23, '2024-04-22 06:33:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4692, 144, 8, '2024-04-22 06:33:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4693, 143, 167, '2024-04-22 06:33:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4694, 141, 19, '2024-04-22 06:33:28', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4695, 142, 5.07, '2024-04-22 06:34:29', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4696, 144, 8, '2024-04-22 06:34:29', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4697, 143, 167, '2024-04-22 06:34:29', '2024-05-13 01:57:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4698, 141, 19, '2024-04-22 06:34:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4699, 142, 5.17, '2024-04-22 06:35:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4700, 144, 8, '2024-04-22 06:35:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4701, 143, 167, '2024-04-22 06:35:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4702, 141, 18, '2024-04-22 06:35:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4703, 142, 5.44, '2024-04-22 06:36:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4704, 144, 8, '2024-04-22 06:36:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4705, 143, 167, '2024-04-22 06:36:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4706, 141, 18, '2024-04-22 06:36:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4707, 142, 5.77, '2024-04-22 06:37:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4708, 144, 8, '2024-04-22 06:37:29', '2024-05-13 01:57:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4709, 143, 166, '2024-04-22 06:37:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4710, 141, 19, '2024-04-22 06:37:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4711, 142, 5.58, '2024-04-22 06:38:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4712, 144, 9, '2024-04-22 06:38:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4713, 143, 165, '2024-04-22 06:38:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4714, 141, 19, '2024-04-22 06:38:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4715, 142, 5.59, '2024-04-22 06:39:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4716, 144, 8, '2024-04-22 06:39:29', '2024-05-13 01:57:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4717, 143, 166, '2024-04-22 06:39:29', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4718, 141, 18, '2024-04-22 06:39:29', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4719, 142, 5.56, '2024-04-22 06:40:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4720, 144, 9, '2024-04-22 06:40:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4721, 143, 166, '2024-04-22 06:40:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4722, 141, 18, '2024-04-22 06:40:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4723, 142, 5.37, '2024-04-22 06:41:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4724, 144, 8, '2024-04-22 06:41:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4725, 143, 165, '2024-04-22 06:41:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4726, 141, 18, '2024-04-22 06:41:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4727, 142, 5.75, '2024-04-22 06:42:30', '2024-05-13 01:57:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4728, 144, 8, '2024-04-22 06:42:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4729, 143, 166, '2024-04-22 06:42:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4730, 141, 18, '2024-04-22 06:42:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4731, 142, 5.49, '2024-04-22 06:43:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4732, 144, 8, '2024-04-22 06:43:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4733, 143, 166, '2024-04-22 06:43:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4734, 141, 19, '2024-04-22 06:43:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4735, 142, 5.27, '2024-04-22 06:44:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4736, 144, 9, '2024-04-22 06:44:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4737, 143, 167, '2024-04-22 06:44:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4738, 141, 19, '2024-04-22 06:44:30', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4739, 142, 5.41, '2024-04-22 06:45:31', '2024-05-13 01:57:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4740, 144, 8, '2024-04-22 06:45:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4741, 143, 167, '2024-04-22 06:45:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4742, 141, 18, '2024-04-22 06:45:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4743, 142, 5.66, '2024-04-22 06:46:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4744, 144, 8, '2024-04-22 06:46:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4745, 143, 167, '2024-04-22 06:46:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4746, 141, 18, '2024-04-22 06:46:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4747, 142, 5.06, '2024-04-22 06:47:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4748, 144, 8, '2024-04-22 06:47:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4749, 143, 168, '2024-04-22 06:47:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4750, 141, 18, '2024-04-22 06:47:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4751, 142, 5.1, '2024-04-22 06:48:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4752, 144, 8, '2024-04-22 06:48:31', '2024-05-13 01:57:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4753, 143, 163, '2024-04-22 06:48:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4754, 141, 18, '2024-04-22 06:48:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4755, 142, 5.35, '2024-04-22 06:49:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4756, 144, 8, '2024-04-22 06:49:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4757, 143, 167, '2024-04-22 06:49:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4758, 141, 19, '2024-04-22 06:49:31', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4759, 142, 5.05, '2024-04-22 06:50:32', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4760, 144, 8, '2024-04-22 06:50:32', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4761, 143, 167, '2024-04-22 06:50:32', '2024-05-13 01:57:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4762, 141, 18, '2024-04-22 06:50:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4763, 142, 5.53, '2024-04-22 06:51:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4764, 144, 9, '2024-04-22 06:51:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4765, 143, 167, '2024-04-22 06:51:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4766, 141, 18, '2024-04-22 06:51:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4767, 142, 5.11, '2024-04-22 06:52:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4768, 144, 8, '2024-04-22 06:52:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4769, 143, 167, '2024-04-22 06:52:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4770, 141, 18, '2024-04-22 06:52:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4771, 142, 5.17, '2024-04-22 06:53:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4772, 144, 8, '2024-04-22 06:53:32', '2024-05-13 01:57:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4773, 143, 166, '2024-04-22 06:53:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4774, 141, 18, '2024-04-22 06:53:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4775, 142, 5.64, '2024-04-22 06:54:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4776, 144, 8, '2024-04-22 06:54:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4777, 143, 167, '2024-04-22 06:54:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4778, 141, 18, '2024-04-22 06:54:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4779, 142, 5.26, '2024-04-22 06:55:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4780, 144, 8, '2024-04-22 06:55:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4781, 143, 167, '2024-04-22 06:55:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4782, 141, 18, '2024-04-22 06:55:32', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4783, 142, 4.95, '2024-04-22 06:56:33', '2024-05-13 01:57:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4784, 144, 8, '2024-04-22 06:56:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4785, 143, 167, '2024-04-22 06:56:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4786, 141, 19, '2024-04-22 06:56:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4787, 142, 5.54, '2024-04-22 06:57:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4788, 144, 9, '2024-04-22 06:57:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4789, 143, 167, '2024-04-22 06:57:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4790, 141, 20, '2024-04-22 06:57:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4791, 142, 5.59, '2024-04-22 06:58:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4792, 144, 8, '2024-04-22 06:58:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4793, 143, 167, '2024-04-22 06:58:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4794, 141, 21, '2024-04-22 06:58:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4795, 142, 5.34, '2024-04-22 06:59:33', '2024-05-13 01:57:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4796, 144, 8, '2024-04-22 06:59:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4797, 143, 167, '2024-04-22 06:59:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4798, 141, 21, '2024-04-22 06:59:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4799, 142, 5.54, '2024-04-22 07:00:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4800, 144, 8, '2024-04-22 07:00:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4801, 143, 166, '2024-04-22 07:00:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4802, 141, 21, '2024-04-22 07:00:33', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4803, 142, 5.67, '2024-04-22 07:01:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4804, 144, 8, '2024-04-22 07:01:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4805, 143, 166, '2024-04-22 07:01:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4806, 141, 21, '2024-04-22 07:01:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4807, 142, 5.53, '2024-04-22 07:02:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4808, 144, 8, '2024-04-22 07:02:34', '2024-05-13 01:57:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4809, 143, 166, '2024-04-22 07:02:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4810, 141, 22, '2024-04-22 07:02:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4811, 142, 4.94, '2024-04-22 07:03:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4812, 144, 8, '2024-04-22 07:03:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4813, 143, 167, '2024-04-22 07:03:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4814, 141, 25, '2024-04-22 07:03:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4815, 142, 5.26, '2024-04-22 07:04:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4816, 144, 8, '2024-04-22 07:04:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4817, 143, 167, '2024-04-22 07:04:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4818, 141, 26, '2024-04-22 07:04:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4819, 142, 5.32, '2024-04-22 07:05:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4820, 144, 8, '2024-04-22 07:05:34', '2024-05-13 01:57:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4821, 143, 167, '2024-04-22 07:05:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4822, 141, 25, '2024-04-22 07:05:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4823, 142, 5.58, '2024-04-22 07:06:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4824, 144, 8, '2024-04-22 07:06:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4825, 143, 167, '2024-04-22 07:06:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4826, 141, 24, '2024-04-22 07:06:34', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4827, 142, 4.98, '2024-04-22 07:07:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4828, 144, 8, '2024-04-22 07:07:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4829, 143, 166, '2024-04-22 07:07:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4830, 141, 24, '2024-04-22 07:07:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4831, 142, 5.39, '2024-04-22 07:08:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4832, 144, 8, '2024-04-22 07:08:35', '2024-05-13 01:57:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4833, 143, 165, '2024-04-22 07:08:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4834, 141, 23, '2024-04-22 07:08:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4835, 142, 5.27, '2024-04-22 07:09:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4836, 144, 8, '2024-04-22 07:09:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4837, 143, 166, '2024-04-22 07:09:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4838, 141, 23, '2024-04-22 07:09:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4839, 142, 5.33, '2024-04-22 07:10:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4840, 144, 9, '2024-04-22 07:10:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4841, 143, 166, '2024-04-22 07:10:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4842, 141, 22, '2024-04-22 07:10:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4843, 142, 5.29, '2024-04-22 07:11:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4844, 144, 7, '2024-04-22 07:11:35', '2024-05-13 01:57:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4845, 143, 166, '2024-04-22 07:11:35', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4846, 141, 22, '2024-04-22 07:11:35', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4847, 142, 5.2, '2024-04-22 07:12:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4848, 144, 8, '2024-04-22 07:12:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4849, 143, 166, '2024-04-22 07:12:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4850, 141, 22, '2024-04-22 07:12:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4851, 142, 5.07, '2024-04-22 07:13:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4852, 144, 8, '2024-04-22 07:13:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4853, 143, 167, '2024-04-22 07:13:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4854, 141, 22, '2024-04-22 07:13:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4855, 142, 5.37, '2024-04-22 07:14:36', '2024-05-13 01:57:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4856, 144, 8, '2024-04-22 07:14:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4857, 143, 166, '2024-04-22 07:14:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4858, 141, 22, '2024-04-22 07:14:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4859, 142, 5.03, '2024-04-22 07:15:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4860, 144, 8, '2024-04-22 07:15:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4861, 143, 166, '2024-04-22 07:15:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4862, 141, 21, '2024-04-22 07:15:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4863, 142, 5.83, '2024-04-22 07:16:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4864, 144, 8, '2024-04-22 07:16:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4865, 143, 153, '2024-04-22 07:16:36', '2024-05-13 01:57:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4866, 141, 20, '2024-04-22 07:16:36', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4867, 142, 5.75, '2024-04-22 07:17:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4868, 144, 8, '2024-04-22 07:17:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4869, 143, 151, '2024-04-22 07:17:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4870, 141, 21, '2024-04-22 07:17:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4871, 142, 5.87, '2024-04-22 07:18:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4872, 144, 8, '2024-04-22 07:18:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4873, 143, 151, '2024-04-22 07:18:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4874, 141, 21, '2024-04-22 07:18:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4875, 142, 5.94, '2024-04-22 07:19:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4876, 144, 9, '2024-04-22 07:19:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4877, 143, 149, '2024-04-22 07:19:37', '2024-05-13 01:57:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4878, 141, 21, '2024-04-22 07:19:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4879, 142, 5.82, '2024-04-22 07:20:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4880, 144, 8, '2024-04-22 07:20:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4881, 143, 149, '2024-04-22 07:20:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4882, 141, 21, '2024-04-22 07:20:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4883, 142, 5.8, '2024-04-22 07:21:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4884, 144, 8, '2024-04-22 07:21:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4885, 143, 149, '2024-04-22 07:21:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4886, 141, 20, '2024-04-22 07:21:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4887, 142, 5.77, '2024-04-22 07:22:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4888, 144, 8, '2024-04-22 07:22:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4889, 143, 149, '2024-04-22 07:22:37', '2024-05-13 01:57:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4890, 141, 20, '2024-04-22 07:22:37', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4891, 142, 6.04, '2024-04-22 07:23:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4892, 144, 8, '2024-04-22 07:23:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4893, 143, 150, '2024-04-22 07:23:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4894, 141, 20, '2024-04-22 07:23:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4895, 142, 5.83, '2024-04-22 07:24:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4896, 144, 9, '2024-04-22 07:24:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4897, 143, 148, '2024-04-22 07:24:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4898, 141, 20, '2024-04-22 07:24:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4899, 142, 5.83, '2024-04-22 07:25:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4900, 144, 9, '2024-04-22 07:25:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4901, 143, 148, '2024-04-22 07:25:38', '2024-05-13 01:57:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4902, 141, 20, '2024-04-22 07:25:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4903, 142, 5.96, '2024-04-22 07:26:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4904, 144, 8, '2024-04-22 07:26:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4905, 143, 148, '2024-04-22 07:26:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4906, 141, 20, '2024-04-22 07:26:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4907, 142, 5.65, '2024-04-22 07:27:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4908, 144, 8, '2024-04-22 07:27:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4909, 143, 149, '2024-04-22 07:27:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4910, 141, 21, '2024-04-22 07:27:38', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4911, 142, 5.59, '2024-04-22 07:28:39', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4912, 144, 8, '2024-04-22 07:28:39', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4913, 143, 150, '2024-04-22 07:28:39', '2024-05-13 01:57:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4914, 141, 20, '2024-04-22 07:28:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4915, 142, 5.59, '2024-04-22 07:29:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4916, 144, 8, '2024-04-22 07:29:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4917, 143, 149, '2024-04-22 07:29:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4918, 141, 20, '2024-04-22 07:29:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4919, 142, 5.45, '2024-04-22 07:30:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4920, 144, 9, '2024-04-22 07:30:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4921, 143, 149, '2024-04-22 07:30:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4922, 141, 20, '2024-04-22 07:30:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4923, 142, 5.55, '2024-04-22 07:31:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4924, 144, 9, '2024-04-22 07:31:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4925, 143, 151, '2024-04-22 07:31:39', '2024-05-13 01:57:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4926, 141, 19, '2024-04-22 07:31:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4927, 142, 5.47, '2024-04-22 07:32:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4928, 144, 9, '2024-04-22 07:32:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4929, 143, 151, '2024-04-22 07:32:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4930, 141, 19, '2024-04-22 07:32:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4931, 142, 5.75, '2024-04-22 07:33:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4932, 144, 9, '2024-04-22 07:33:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4933, 143, 150, '2024-04-22 07:33:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4934, 141, 19, '2024-04-22 07:33:39', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4935, 142, 5.37, '2024-04-22 07:34:40', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4936, 144, 8, '2024-04-22 07:34:40', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4937, 143, 150, '2024-04-22 07:34:40', '2024-05-13 01:57:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4938, 141, 19, '2024-04-22 07:34:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4939, 142, 5.59, '2024-04-22 07:35:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4940, 144, 8, '2024-04-22 07:35:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4941, 143, 147, '2024-04-22 07:35:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4942, 141, 17, '2024-04-22 07:35:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4943, 142, 5.44, '2024-04-22 07:36:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4944, 144, 8, '2024-04-22 07:36:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4945, 143, 150, '2024-04-22 07:36:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4946, 141, 20, '2024-04-22 07:36:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4947, 142, 5.47, '2024-04-22 07:37:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4948, 144, 8, '2024-04-22 07:37:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4949, 143, 150, '2024-04-22 07:37:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4950, 141, 19, '2024-04-22 07:37:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4951, 142, 5.44, '2024-04-22 07:38:40', '2024-05-13 01:57:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4952, 144, 8, '2024-04-22 07:38:40', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4953, 143, 151, '2024-04-22 07:38:40', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4954, 141, 19, '2024-04-22 07:38:40', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4955, 142, 5.48, '2024-04-22 07:39:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4956, 144, 8, '2024-04-22 07:39:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4957, 143, 150, '2024-04-22 07:39:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4958, 141, 19, '2024-04-22 07:39:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4959, 142, 5.54, '2024-04-22 07:40:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4960, 144, 8, '2024-04-22 07:40:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4961, 143, 153, '2024-04-22 07:40:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4962, 141, 19, '2024-04-22 07:40:41', '2024-05-13 01:57:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4963, 142, 5.48, '2024-04-22 07:41:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4964, 144, 8, '2024-04-22 07:41:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4965, 143, 151, '2024-04-22 07:41:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4966, 141, 19, '2024-04-22 07:41:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4967, 142, 5.46, '2024-04-22 07:42:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4968, 144, 9, '2024-04-22 07:42:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4969, 143, 151, '2024-04-22 07:42:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4970, 141, 19, '2024-04-22 07:42:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4971, 142, 5.59, '2024-04-22 07:43:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4972, 144, 8, '2024-04-22 07:43:41', '2024-05-13 01:57:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4973, 143, 152, '2024-04-22 07:43:41', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4974, 141, 19, '2024-04-22 07:43:41', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4975, 142, 5.41, '2024-04-22 07:44:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4976, 144, 8, '2024-04-22 07:44:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4977, 143, 152, '2024-04-22 07:44:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4978, 141, 19, '2024-04-22 07:44:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4979, 142, 5.24, '2024-04-22 07:45:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4980, 144, 9, '2024-04-22 07:45:42', '2024-05-13 01:57:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4981, 143, 152, '2024-04-22 07:45:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4982, 141, 19, '2024-04-22 07:45:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4983, 142, 5.65, '2024-04-22 07:46:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4984, 144, 8, '2024-04-22 07:46:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4985, 143, 151, '2024-04-22 07:46:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4986, 141, 19, '2024-04-22 07:46:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4987, 142, 5.61, '2024-04-22 07:47:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4988, 144, 8, '2024-04-22 07:47:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4989, 143, 152, '2024-04-22 07:47:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4990, 141, 19, '2024-04-22 07:47:42', '2024-05-13 01:57:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4991, 142, 5.3, '2024-04-22 07:48:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4992, 144, 9, '2024-04-22 07:48:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4993, 143, 153, '2024-04-22 07:48:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4994, 141, 19, '2024-04-22 07:48:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4995, 142, 5.35, '2024-04-22 07:49:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4996, 144, 8, '2024-04-22 07:49:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4997, 143, 151, '2024-04-22 07:49:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4998, 141, 18, '2024-04-22 07:49:42', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(4999, 142, 5.34, '2024-04-22 07:50:43', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5000, 144, 8, '2024-04-22 07:50:43', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5001, 143, 151, '2024-04-22 07:50:43', '2024-05-13 01:57:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5002, 141, 18, '2024-04-22 07:50:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5003, 142, 5.44, '2024-04-22 07:51:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5004, 144, 8, '2024-04-22 07:51:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5005, 143, 151, '2024-04-22 07:51:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5006, 141, 18, '2024-04-22 07:51:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5007, 142, 5.51, '2024-04-22 07:52:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5008, 144, 8, '2024-04-22 07:52:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5009, 143, 152, '2024-04-22 07:52:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5010, 141, 18, '2024-04-22 07:52:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5011, 142, 5.8, '2024-04-22 07:53:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5012, 144, 8, '2024-04-22 07:53:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5013, 143, 152, '2024-04-22 07:53:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5014, 141, 18, '2024-04-22 07:53:43', '2024-05-13 01:57:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5015, 142, 5.34, '2024-04-22 07:54:43', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5016, 144, 8, '2024-04-22 07:54:43', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5017, 143, 152, '2024-04-22 07:54:43', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5018, 141, 18, '2024-04-22 07:54:43', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5019, 142, 5.6, '2024-04-22 07:55:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5020, 144, 8, '2024-04-22 07:55:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5021, 143, 149, '2024-04-22 07:55:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5022, 141, 18, '2024-04-22 07:55:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5023, 142, 5.28, '2024-04-22 07:56:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5024, 144, 8, '2024-04-22 07:56:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5025, 143, 153, '2024-04-22 07:56:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5026, 141, 18, '2024-04-22 07:56:44', '2024-05-13 01:57:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5027, 142, 5.06, '2024-04-22 07:57:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5028, 144, 8, '2024-04-22 07:57:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5029, 143, 171, '2024-04-22 07:57:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5030, 141, 18, '2024-04-22 07:57:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5031, 142, 5.13, '2024-04-22 07:58:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5032, 144, 8, '2024-04-22 07:58:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5033, 143, 169, '2024-04-22 07:58:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5034, 141, 17, '2024-04-22 07:58:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5035, 142, 5.37, '2024-04-22 07:59:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5036, 144, 8, '2024-04-22 07:59:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5037, 143, 158, '2024-04-22 07:59:44', '2024-05-13 01:57:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5038, 141, 17, '2024-04-22 07:59:44', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5039, 142, 5.79, '2024-04-22 08:00:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5040, 144, 6, '2024-04-22 08:00:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5041, 143, 156, '2024-04-22 08:00:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5042, 141, 17, '2024-04-22 08:00:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5043, 142, 5.81, '2024-04-22 08:01:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5044, 144, 8, '2024-04-22 08:01:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5045, 143, 155, '2024-04-22 08:01:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5046, 141, 17, '2024-04-22 08:01:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5047, 142, 5.25, '2024-04-22 08:02:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5048, 144, 8, '2024-04-22 08:02:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5049, 143, 158, '2024-04-22 08:02:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5050, 141, 17, '2024-04-22 08:02:34', '2024-05-13 01:57:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5051, 142, 5.63, '2024-04-22 08:03:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5052, 144, 8, '2024-04-22 08:03:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5053, 143, 155, '2024-04-22 08:03:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5054, 141, 17, '2024-04-22 08:03:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5055, 142, 5.59, '2024-04-22 08:04:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5056, 144, 9, '2024-04-22 08:04:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5057, 143, 155, '2024-04-22 08:04:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5058, 141, 18, '2024-04-22 08:04:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5059, 142, 5.59, '2024-04-22 08:05:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5060, 144, 9, '2024-04-22 08:05:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5061, 143, 155, '2024-04-22 08:05:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5062, 141, 18, '2024-04-22 08:05:34', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5063, 142, 5.85, '2024-04-22 08:06:35', '2024-05-13 01:58:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5064, 144, 8, '2024-04-22 08:06:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5065, 143, 154, '2024-04-22 08:06:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5066, 141, 18, '2024-04-22 08:06:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5067, 142, 5.55, '2024-04-22 08:07:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5068, 144, 8, '2024-04-22 08:07:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5069, 143, 156, '2024-04-22 08:07:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5070, 141, 17, '2024-04-22 08:07:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5071, 142, 5.8, '2024-04-22 08:08:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5072, 144, 8, '2024-04-22 08:08:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5073, 143, 154, '2024-04-22 08:08:35', '2024-05-13 01:58:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5074, 141, 18, '2024-04-22 08:08:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5075, 142, 5.59, '2024-04-22 08:09:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5076, 144, 9, '2024-04-22 08:09:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5077, 143, 154, '2024-04-22 08:09:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5078, 141, 18, '2024-04-22 08:09:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5079, 142, 5.82, '2024-04-22 08:10:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5080, 144, 9, '2024-04-22 08:10:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5081, 143, 153, '2024-04-22 08:10:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5082, 141, 18, '2024-04-22 08:10:35', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5083, 142, 5.78, '2024-04-22 08:11:36', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5084, 144, 8, '2024-04-22 08:11:36', '2024-05-13 01:58:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5085, 143, 153, '2024-04-22 08:11:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5086, 141, 18, '2024-04-22 08:11:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5087, 142, 5.77, '2024-04-22 08:12:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5088, 144, 8, '2024-04-22 08:12:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5089, 143, 153, '2024-04-22 08:12:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5090, 141, 18, '2024-04-22 08:12:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5091, 142, 5.84, '2024-04-22 08:13:36', '2024-05-13 01:58:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5092, 144, 8, '2024-04-22 08:13:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5093, 143, 153, '2024-04-22 08:13:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5094, 141, 18, '2024-04-22 08:13:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5095, 142, 5.55, '2024-04-22 08:14:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5096, 144, 8, '2024-04-22 08:14:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5097, 143, 153, '2024-04-22 08:14:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5098, 141, 18, '2024-04-22 08:14:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5099, 142, 5.79, '2024-04-22 08:15:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5100, 144, 8, '2024-04-22 08:15:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5101, 143, 153, '2024-04-22 08:15:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5102, 141, 18, '2024-04-22 08:15:36', '2024-05-13 01:58:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5103, 142, 5.54, '2024-04-22 08:16:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5104, 144, 9, '2024-04-22 08:16:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5105, 143, 152, '2024-04-22 08:16:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5106, 141, 18, '2024-04-22 08:16:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5107, 142, 5.37, '2024-04-22 08:17:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5108, 144, 8, '2024-04-22 08:17:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5109, 143, 150, '2024-04-22 08:17:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5110, 141, 16, '2024-04-22 08:17:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5111, 142, 5.59, '2024-04-22 08:18:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5112, 144, 8, '2024-04-22 08:18:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5113, 143, 148, '2024-04-22 08:18:37', '2024-05-13 01:58:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5114, 141, 17, '2024-04-22 08:18:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5115, 142, 5.43, '2024-04-22 08:19:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5116, 144, 9, '2024-04-22 08:19:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5117, 143, 149, '2024-04-22 08:19:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5118, 141, 17, '2024-04-22 08:19:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5119, 142, 5.46, '2024-04-22 08:20:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5120, 144, 8, '2024-04-22 08:20:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5121, 143, 149, '2024-04-22 08:20:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5122, 141, 18, '2024-04-22 08:20:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5123, 142, 5.51, '2024-04-22 08:21:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5124, 144, 8, '2024-04-22 08:21:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5125, 143, 148, '2024-04-22 08:21:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5126, 141, 18, '2024-04-22 08:21:37', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5127, 142, 5.57, '2024-04-22 08:22:38', '2024-05-13 01:58:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5128, 144, 8, '2024-04-22 08:22:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5129, 143, 147, '2024-04-22 08:22:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5130, 141, 19, '2024-04-22 08:22:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5131, 142, 5.63, '2024-04-22 08:23:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5132, 144, 9, '2024-04-22 08:23:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5133, 143, 153, '2024-04-22 08:23:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5134, 141, 20, '2024-04-22 08:23:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5135, 142, 5.57, '2024-04-22 08:24:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5136, 144, 9, '2024-04-22 08:24:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5137, 143, 151, '2024-04-22 08:24:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5138, 141, 19, '2024-04-22 08:24:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5139, 142, 5.31, '2024-04-22 08:25:38', '2024-05-13 01:58:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5140, 144, 8, '2024-04-22 08:25:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5141, 143, 152, '2024-04-22 08:25:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5142, 141, 18, '2024-04-22 08:25:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5143, 142, 5.57, '2024-04-22 08:26:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5144, 144, 8, '2024-04-22 08:26:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5145, 143, 151, '2024-04-22 08:26:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5146, 141, 18, '2024-04-22 08:26:38', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5147, 142, 5.7, '2024-04-22 08:27:39', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5148, 144, 8, '2024-04-22 08:27:39', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5149, 143, 152, '2024-04-22 08:27:39', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5150, 141, 18, '2024-04-22 08:27:39', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5151, 142, 5.62, '2024-04-22 08:28:39', '2024-05-13 01:58:08', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5152, 144, 8, '2024-04-22 08:28:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5153, 143, 150, '2024-04-22 08:28:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5154, 141, 18, '2024-04-22 08:28:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5155, 142, 5.86, '2024-04-22 08:29:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5156, 144, 9, '2024-04-22 08:29:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5157, 143, 149, '2024-04-22 08:29:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5158, 141, 18, '2024-04-22 08:29:39', '2024-05-13 01:58:09', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5159, 142, 5.61, '2024-04-22 08:30:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5160, 144, 8, '2024-04-22 08:30:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5161, 143, 150, '2024-04-22 08:30:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5162, 141, 18, '2024-04-22 08:30:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5163, 142, 5.64, '2024-04-22 08:31:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5164, 144, 9, '2024-04-22 08:31:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5165, 143, 149, '2024-04-22 08:31:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5166, 141, 18, '2024-04-22 08:31:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5167, 142, 5.8, '2024-04-22 08:32:39', '2024-05-13 01:58:10', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5168, 144, 9, '2024-04-22 08:32:39', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5169, 143, 150, '2024-04-22 08:32:39', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5170, 141, 18, '2024-04-22 08:32:39', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5171, 142, 5.65, '2024-04-22 08:33:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5172, 144, 9, '2024-04-22 08:33:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5173, 143, 149, '2024-04-22 08:33:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5174, 141, 18, '2024-04-22 08:33:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5175, 142, 5.88, '2024-04-22 08:34:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5176, 144, 8, '2024-04-22 08:34:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5177, 143, 148, '2024-04-22 08:34:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5178, 141, 18, '2024-04-22 08:34:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5179, 142, 5.63, '2024-04-22 08:35:40', '2024-05-13 01:58:11', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5180, 144, 9, '2024-04-22 08:35:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5181, 143, 148, '2024-04-22 08:35:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5182, 141, 18, '2024-04-22 08:35:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5183, 142, 5.84, '2024-04-22 08:36:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5184, 144, 8, '2024-04-22 08:36:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5185, 143, 148, '2024-04-22 08:36:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5186, 141, 18, '2024-04-22 08:36:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5187, 142, 5.78, '2024-04-22 08:37:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5188, 144, 9, '2024-04-22 08:37:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5189, 143, 148, '2024-04-22 08:37:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5190, 141, 18, '2024-04-22 08:37:40', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5191, 142, 5.72, '2024-04-22 08:38:41', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5192, 144, 8, '2024-04-22 08:38:41', '2024-05-13 01:58:12', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5193, 143, 145, '2024-04-22 08:38:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5194, 141, 17, '2024-04-22 08:38:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5195, 142, 5.53, '2024-04-22 08:39:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5196, 144, 8, '2024-04-22 08:39:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5197, 143, 144, '2024-04-22 08:39:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5198, 141, 17, '2024-04-22 08:39:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5199, 142, 5.76, '2024-04-22 08:40:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5200, 144, 8, '2024-04-22 08:40:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5201, 143, 144, '2024-04-22 08:40:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5202, 141, 18, '2024-04-22 08:40:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5203, 142, 5.52, '2024-04-22 08:41:41', '2024-05-13 01:58:13', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5204, 144, 8, '2024-04-22 08:41:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5205, 143, 145, '2024-04-22 08:41:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5206, 141, 18, '2024-04-22 08:41:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5207, 142, 5.5, '2024-04-22 08:42:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5208, 144, 8, '2024-04-22 08:42:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5209, 143, 145, '2024-04-22 08:42:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5210, 141, 18, '2024-04-22 08:42:41', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5211, 142, 5.41, '2024-04-22 08:43:42', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5212, 144, 8, '2024-04-22 08:43:42', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5213, 143, 145, '2024-04-22 08:43:42', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5214, 141, 19, '2024-04-22 08:43:42', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5215, 142, 6.95, '2024-04-23 05:02:14', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5216, 144, 6, '2024-04-23 05:02:14', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5217, 143, 309, '2024-04-23 05:02:14', '2024-05-13 01:58:14', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5218, 141, 30, '2024-04-23 05:02:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5219, 142, 6.93, '2024-04-23 05:03:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5220, 144, 9, '2024-04-23 05:03:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5221, 143, 306, '2024-04-23 05:03:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5222, 141, 28, '2024-04-23 05:03:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5223, 142, 6.92, '2024-04-23 05:04:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5224, 144, 9, '2024-04-23 05:04:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5225, 143, 304, '2024-04-23 05:04:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5226, 141, 26, '2024-04-23 05:04:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5227, 142, 6.91, '2024-04-23 05:05:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5228, 144, 9, '2024-04-23 05:05:14', '2024-05-13 01:58:15', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5229, 143, 301, '2024-04-23 05:05:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5230, 141, 25, '2024-04-23 05:05:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5231, 142, 5.82, '2024-04-23 05:06:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5232, 144, 9, '2024-04-23 05:06:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5233, 143, 442, '2024-04-23 05:06:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5234, 141, 24, '2024-04-23 05:06:14', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5235, 142, 6.89, '2024-04-23 05:07:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5236, 144, 9, '2024-04-23 05:07:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5237, 143, 344, '2024-04-23 05:07:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5238, 141, 24, '2024-04-23 05:07:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5239, 142, 6.89, '2024-04-23 05:08:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5240, 144, 9, '2024-04-23 05:08:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5241, 143, 374, '2024-04-23 05:08:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5242, 141, 23, '2024-04-23 05:08:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5243, 142, 6.89, '2024-04-23 05:09:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5244, 144, 9, '2024-04-23 05:09:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5245, 143, 368, '2024-04-23 05:09:15', '2024-05-13 01:58:16', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5246, 141, 23, '2024-04-23 05:09:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5247, 142, 6.89, '2024-04-23 05:10:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5248, 144, 9, '2024-04-23 05:10:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5249, 143, 362, '2024-04-23 05:10:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5250, 141, 22, '2024-04-23 05:10:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5251, 142, 6.88, '2024-04-23 05:11:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5252, 144, 9, '2024-04-23 05:11:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5253, 143, 26, '2024-04-23 05:11:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5254, 141, 22, '2024-04-23 05:11:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5255, 142, 6.89, '2024-04-23 05:12:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5256, 144, 9, '2024-04-23 05:12:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5257, 143, 285, '2024-04-23 05:12:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5258, 141, 22, '2024-04-23 05:12:15', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5259, 142, 6.88, '2024-04-23 05:13:16', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5260, 144, 9, '2024-04-23 05:13:16', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5261, 143, 281, '2024-04-23 05:13:16', '2024-05-13 01:58:17', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5262, 141, 21, '2024-04-23 05:13:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5263, 142, 6.88, '2024-04-23 05:14:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5264, 144, 9, '2024-04-23 05:14:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5265, 143, 278, '2024-04-23 05:14:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5266, 141, 21, '2024-04-23 05:14:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5267, 142, 6.88, '2024-04-23 05:15:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5268, 144, 9, '2024-04-23 05:15:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5269, 143, 275, '2024-04-23 05:15:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5270, 141, 21, '2024-04-23 05:15:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5271, 142, 6.88, '2024-04-23 05:16:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5272, 144, 9, '2024-04-23 05:16:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5273, 143, 269, '2024-04-23 05:16:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5274, 141, 20, '2024-04-23 05:16:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5275, 142, 6.88, '2024-04-23 05:17:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5276, 144, 9, '2024-04-23 05:17:16', '2024-05-13 01:58:18', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5277, 143, 263, '2024-04-23 05:17:16', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5278, 141, 20, '2024-04-23 05:17:16', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5279, 142, 6.88, '2024-04-23 05:18:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5280, 144, 9, '2024-04-23 05:18:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5281, 143, 250, '2024-04-23 05:18:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5282, 141, 20, '2024-04-23 05:18:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5283, 142, 6.88, '2024-04-23 05:19:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5284, 144, 9, '2024-04-23 05:19:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5285, 143, 246, '2024-04-23 05:19:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5286, 141, 20, '2024-04-23 05:19:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5287, 142, 6.88, '2024-04-23 05:20:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5288, 144, 9, '2024-04-23 05:20:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5289, 143, 244, '2024-04-23 05:20:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5290, 141, 19, '2024-04-23 05:20:17', '2024-05-13 01:58:19', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5291, 142, 6.88, '2024-04-23 05:21:17', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5292, 144, 9, '2024-04-23 05:21:17', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5293, 143, 242, '2024-04-23 05:21:17', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5294, 141, 19, '2024-04-23 05:21:17', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5295, 142, 6.95, '2024-04-23 05:24:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5296, 144, 6, '2024-04-23 05:24:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5297, 143, 243, '2024-04-23 05:24:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5298, 141, 22, '2024-04-23 05:24:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5299, 142, 6.95, '2024-04-23 05:25:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5300, 144, 10, '2024-04-23 05:25:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5301, 143, 242, '2024-04-23 05:25:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5302, 141, 21, '2024-04-23 05:25:28', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5303, 142, 6.95, '2024-04-23 05:26:29', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5304, 144, 9, '2024-04-23 05:26:29', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5305, 143, 240, '2024-04-23 05:26:29', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5306, 141, 20, '2024-04-23 05:26:29', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5307, 142, 6.95, '2024-04-23 05:27:29', '2024-05-13 01:58:20', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5308, 144, 9, '2024-04-23 05:27:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5309, 143, 238, '2024-04-23 05:27:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5310, 141, 20, '2024-04-23 05:27:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5311, 142, 6.95, '2024-04-23 05:28:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5312, 144, 10, '2024-04-23 05:28:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5313, 143, 237, '2024-04-23 05:28:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5314, 141, 20, '2024-04-23 05:28:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5315, 142, 6.95, '2024-04-23 05:29:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5316, 144, 10, '2024-04-23 05:29:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5317, 143, 236, '2024-04-23 05:29:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5318, 141, 20, '2024-04-23 05:29:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5319, 142, 6.95, '2024-04-23 05:30:29', '2024-05-13 01:58:21', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5320, 144, 10, '2024-04-23 05:30:29', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5321, 143, 235, '2024-04-23 05:30:29', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5322, 141, 19, '2024-04-23 05:30:29', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5323, 142, 6.95, '2024-04-23 05:31:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5324, 144, 10, '2024-04-23 05:31:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5325, 143, 233, '2024-04-23 05:31:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5326, 141, 19, '2024-04-23 05:31:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5327, 142, 6.95, '2024-04-23 05:32:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5328, 144, 9, '2024-04-23 05:32:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5329, 143, 232, '2024-04-23 05:32:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5330, 141, 19, '2024-04-23 05:32:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5331, 142, 6.94, '2024-04-23 05:33:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5332, 144, 9, '2024-04-23 05:33:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5333, 143, 230, '2024-04-23 05:33:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5334, 141, 19, '2024-04-23 05:33:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5335, 142, 6.95, '2024-04-23 05:34:30', '2024-05-13 01:58:22', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5336, 144, 10, '2024-04-23 05:34:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5337, 143, 229, '2024-04-23 05:34:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5338, 141, 19, '2024-04-23 05:34:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5339, 142, 6.94, '2024-04-23 05:35:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5340, 144, 9, '2024-04-23 05:35:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5341, 143, 227, '2024-04-23 05:35:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5342, 141, 19, '2024-04-23 05:35:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5343, 142, 6.94, '2024-04-23 05:36:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5344, 144, 10, '2024-04-23 05:36:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5345, 143, 226, '2024-04-23 05:36:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5346, 141, 19, '2024-04-23 05:36:30', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5347, 142, 6.94, '2024-04-23 05:37:31', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5348, 144, 10, '2024-04-23 05:37:31', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5349, 143, 225, '2024-04-23 05:37:31', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5350, 141, 19, '2024-04-23 05:37:31', '2024-05-13 01:58:23', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5351, 142, 6.94, '2024-04-23 05:38:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5352, 144, 9, '2024-04-23 05:38:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5353, 143, 224, '2024-04-23 05:38:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5354, 141, 18, '2024-04-23 05:38:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5355, 142, 6.94, '2024-04-23 05:39:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5356, 144, 10, '2024-04-23 05:39:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5357, 143, 223, '2024-04-23 05:39:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5358, 141, 18, '2024-04-23 05:39:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5359, 142, 6.94, '2024-04-23 05:40:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5360, 144, 10, '2024-04-23 05:40:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5361, 143, 222, '2024-04-23 05:40:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5362, 141, 18, '2024-04-23 05:40:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5363, 142, 6.95, '2024-04-23 05:41:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5364, 144, 10, '2024-04-23 05:41:31', '2024-05-13 01:58:24', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5365, 143, 221, '2024-04-23 05:41:31', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5366, 141, 18, '2024-04-23 05:41:31', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5367, 142, 6.94, '2024-04-23 05:42:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5368, 144, 9, '2024-04-23 05:42:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5369, 143, 221, '2024-04-23 05:42:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5370, 141, 18, '2024-04-23 05:42:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5371, 142, 6.94, '2024-04-23 05:43:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5372, 144, 9, '2024-04-23 05:43:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5373, 143, 220, '2024-04-23 05:43:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5374, 141, 18, '2024-04-23 05:43:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5375, 142, 6.94, '2024-04-23 05:44:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5376, 144, 9, '2024-04-23 05:44:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5377, 143, 219, '2024-04-23 05:44:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5378, 141, 19, '2024-04-23 05:44:32', '2024-05-13 01:58:25', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5379, 142, 6.94, '2024-04-23 05:45:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5380, 144, 9, '2024-04-23 05:45:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5381, 143, 217, '2024-04-23 05:45:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5382, 141, 19, '2024-04-23 05:45:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5383, 142, 6.95, '2024-04-23 05:46:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5384, 144, 10, '2024-04-23 05:46:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5385, 143, 216, '2024-04-23 05:46:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5386, 141, 19, '2024-04-23 05:46:32', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5387, 142, 6.95, '2024-04-23 05:47:33', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5388, 144, 10, '2024-04-23 05:47:33', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5389, 143, 216, '2024-04-23 05:47:33', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5390, 141, 19, '2024-04-23 05:47:33', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5391, 142, 7.01, '2024-04-23 05:50:54', '2024-05-13 01:58:26', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5392, 144, 7, '2024-04-23 05:50:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5393, 143, 218, '2024-04-23 05:50:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5394, 141, 22, '2024-04-23 05:50:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5395, 142, 7, '2024-04-23 05:51:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5396, 144, 11, '2024-04-23 05:51:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5397, 143, 217, '2024-04-23 05:51:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5398, 141, 21, '2024-04-23 05:51:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5399, 142, 6.99, '2024-04-23 05:52:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5400, 144, 10, '2024-04-23 05:52:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5401, 143, 216, '2024-04-23 05:52:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5402, 141, 21, '2024-04-23 05:52:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5403, 142, 7, '2024-04-23 05:53:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5404, 144, 10, '2024-04-23 05:53:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5405, 143, 216, '2024-04-23 05:53:54', '2024-05-13 01:58:27', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5406, 141, 21, '2024-04-23 05:53:54', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5407, 142, 6.99, '2024-04-23 05:54:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5408, 144, 10, '2024-04-23 05:54:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5409, 143, 215, '2024-04-23 05:54:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5410, 141, 20, '2024-04-23 05:54:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5411, 142, 6.99, '2024-04-23 05:55:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5412, 144, 10, '2024-04-23 05:55:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5413, 143, 214, '2024-04-23 05:55:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5414, 141, 20, '2024-04-23 05:55:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5415, 142, 6.99, '2024-04-23 05:56:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5416, 144, 10, '2024-04-23 05:56:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5417, 143, 214, '2024-04-23 05:56:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5418, 141, 20, '2024-04-23 05:56:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5419, 142, 6.99, '2024-04-23 05:57:55', '2024-05-13 01:58:28', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5420, 144, 11, '2024-04-23 05:57:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5421, 143, 213, '2024-04-23 05:57:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5422, 141, 20, '2024-04-23 05:57:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5423, 142, 6.99, '2024-04-23 05:58:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5424, 144, 11, '2024-04-23 05:58:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5425, 143, 212, '2024-04-23 05:58:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5426, 141, 20, '2024-04-23 05:58:55', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5427, 142, 6.99, '2024-04-23 05:59:56', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5428, 144, 11, '2024-04-23 05:59:56', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5429, 143, 212, '2024-04-23 05:59:56', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5430, 141, 20, '2024-04-23 05:59:56', '2024-05-13 01:58:29', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5431, 142, 6.99, '2024-04-23 06:00:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5432, 144, 11, '2024-04-23 06:00:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5433, 143, 211, '2024-04-23 06:00:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5434, 141, 20, '2024-04-23 06:00:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5435, 142, 6.99, '2024-04-23 06:01:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5436, 144, 10, '2024-04-23 06:01:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5437, 143, 211, '2024-04-23 06:01:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5438, 141, 20, '2024-04-23 06:01:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5439, 142, 6.99, '2024-04-23 06:02:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5440, 144, 10, '2024-04-23 06:02:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5441, 143, 210, '2024-04-23 06:02:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5442, 141, 20, '2024-04-23 06:02:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5443, 142, 6.99, '2024-04-23 06:03:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5444, 144, 11, '2024-04-23 06:03:56', '2024-05-13 01:58:30', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5445, 143, 210, '2024-04-23 06:03:56', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5446, 141, 20, '2024-04-23 06:03:56', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5447, 142, 6.99, '2024-04-23 06:04:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5448, 144, 10, '2024-04-23 06:04:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5449, 143, 209, '2024-04-23 06:04:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5450, 141, 20, '2024-04-23 06:04:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5451, 142, 6.99, '2024-04-23 06:05:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5452, 144, 11, '2024-04-23 06:05:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5453, 143, 209, '2024-04-23 06:05:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5454, 141, 20, '2024-04-23 06:05:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5455, 142, 6.99, '2024-04-23 06:06:57', '2024-05-13 01:58:31', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5456, 144, 10, '2024-04-23 06:06:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5457, 143, 208, '2024-04-23 06:06:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5458, 141, 20, '2024-04-23 06:06:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5459, 142, 6.99, '2024-04-23 06:07:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5460, 144, 10, '2024-04-23 06:07:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5461, 143, 208, '2024-04-23 06:07:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5462, 141, 20, '2024-04-23 06:07:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5463, 142, 6.99, '2024-04-23 06:08:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5464, 144, 11, '2024-04-23 06:08:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5465, 143, 208, '2024-04-23 06:08:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5466, 141, 20, '2024-04-23 06:08:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5467, 142, 6.99, '2024-04-23 06:09:57', '2024-05-13 01:58:32', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5468, 144, 10, '2024-04-23 06:09:57', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5469, 143, 207, '2024-04-23 06:09:57', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5470, 141, 20, '2024-04-23 06:09:57', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5471, 142, 6.99, '2024-04-23 06:10:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5472, 144, 10, '2024-04-23 06:10:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5473, 143, 207, '2024-04-23 06:10:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5474, 141, 20, '2024-04-23 06:10:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5475, 142, 6.98, '2024-04-23 06:11:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5476, 144, 11, '2024-04-23 06:11:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5477, 143, 206, '2024-04-23 06:11:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5478, 141, 20, '2024-04-23 06:11:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5479, 142, 6.99, '2024-04-23 06:12:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5480, 144, 11, '2024-04-23 06:12:58', '2024-05-13 01:58:33', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5481, 143, 206, '2024-04-23 06:12:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5482, 141, 19, '2024-04-23 06:12:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5483, 142, 6.98, '2024-04-23 06:13:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5484, 144, 10, '2024-04-23 06:13:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5485, 143, 205, '2024-04-23 06:13:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5486, 141, 20, '2024-04-23 06:13:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5487, 142, 6.98, '2024-04-23 06:14:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5488, 144, 10, '2024-04-23 06:14:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5489, 143, 205, '2024-04-23 06:14:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5490, 141, 20, '2024-04-23 06:14:58', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5491, 142, 6.98, '2024-04-23 06:15:59', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5492, 144, 10, '2024-04-23 06:15:59', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5493, 143, 205, '2024-04-23 06:15:59', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5494, 141, 20, '2024-04-23 06:15:59', '2024-05-13 01:58:34', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5495, 142, 6.99, '2024-04-23 06:16:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5496, 144, 11, '2024-04-23 06:16:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5497, 143, 204, '2024-04-23 06:16:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5498, 141, 20, '2024-04-23 06:16:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5499, 142, 6.99, '2024-04-23 06:17:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5500, 144, 10, '2024-04-23 06:17:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5501, 143, 204, '2024-04-23 06:17:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5502, 141, 20, '2024-04-23 06:17:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5503, 142, 6.99, '2024-04-23 06:18:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5504, 144, 11, '2024-04-23 06:18:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5505, 143, 204, '2024-04-23 06:18:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5506, 141, 20, '2024-04-23 06:18:59', '2024-05-13 01:58:35', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5507, 142, 6.99, '2024-04-23 06:19:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5508, 144, 10, '2024-04-23 06:19:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5509, 143, 203, '2024-04-23 06:19:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5510, 141, 20, '2024-04-23 06:19:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5511, 142, 6.99, '2024-04-23 06:20:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5512, 144, 11, '2024-04-23 06:20:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5513, 143, 203, '2024-04-23 06:20:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5514, 141, 20, '2024-04-23 06:20:59', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5515, 142, 6.99, '2024-04-23 06:22:00', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5516, 144, 10, '2024-04-23 06:22:00', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5517, 143, 203, '2024-04-23 06:22:00', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5518, 141, 20, '2024-04-23 06:22:00', '2024-05-13 01:58:36', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5519, 142, 6.97, '2024-04-23 06:23:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5520, 144, 10, '2024-04-23 06:23:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5521, 143, 202, '2024-04-23 06:23:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5522, 141, 20, '2024-04-23 06:23:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5523, 142, 6.99, '2024-04-23 06:24:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5524, 144, 10, '2024-04-23 06:24:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5525, 143, 202, '2024-04-23 06:24:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5526, 141, 20, '2024-04-23 06:24:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5527, 142, 6.99, '2024-04-23 06:25:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5528, 144, 10, '2024-04-23 06:25:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5529, 143, 202, '2024-04-23 06:25:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5530, 141, 20, '2024-04-23 06:25:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5531, 142, 6.99, '2024-04-23 06:26:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5532, 144, 10, '2024-04-23 06:26:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5533, 143, 202, '2024-04-23 06:26:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5534, 141, 20, '2024-04-23 06:26:00', '2024-05-13 01:58:37', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5535, 142, 7.01, '2024-04-23 06:27:01', '2024-05-13 01:58:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5536, 144, 10, '2024-04-23 06:27:01', '2024-05-13 01:58:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5537, 143, 202, '2024-04-23 06:27:01', '2024-05-13 01:58:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5538, 141, 20, '2024-04-23 06:27:01', '2024-05-13 01:58:38', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5539, 142, 6.99, '2024-04-23 06:28:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5540, 144, 11, '2024-04-23 06:28:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5541, 143, 201, '2024-04-23 06:28:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5542, 141, 20, '2024-04-23 06:28:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5543, 142, 6.99, '2024-04-23 06:29:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5544, 144, 10, '2024-04-23 06:29:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5545, 143, 202, '2024-04-23 06:29:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5546, 141, 20, '2024-04-23 06:29:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5547, 142, 6.98, '2024-04-23 06:30:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5548, 144, 11, '2024-04-23 06:30:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5549, 143, 201, '2024-04-23 06:30:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5550, 141, 20, '2024-04-23 06:30:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5551, 142, 6.98, '2024-04-23 06:31:01', '2024-05-13 01:58:39', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5552, 144, 11, '2024-04-23 06:31:01', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5553, 143, 201, '2024-04-23 06:31:01', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5554, 141, 20, '2024-04-23 06:31:01', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5555, 142, 7, '2024-04-23 06:32:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5556, 144, 10, '2024-04-23 06:32:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5557, 143, 203, '2024-04-23 06:32:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5558, 141, 19, '2024-04-23 06:32:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5559, 142, 7, '2024-04-23 06:33:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5560, 144, 10, '2024-04-23 06:33:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5561, 143, 202, '2024-04-23 06:33:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5562, 141, 18, '2024-04-23 06:33:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5563, 142, 7, '2024-04-23 06:34:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5564, 144, 10, '2024-04-23 06:34:02', '2024-05-13 01:58:40', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5565, 143, 202, '2024-04-23 06:34:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5566, 141, 18, '2024-04-23 06:34:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5567, 142, 7, '2024-04-23 06:35:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5568, 144, 11, '2024-04-23 06:35:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5569, 143, 202, '2024-04-23 06:35:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5570, 141, 18, '2024-04-23 06:35:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5571, 142, 7, '2024-04-23 06:36:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5572, 144, 11, '2024-04-23 06:36:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5573, 143, 201, '2024-04-23 06:36:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5574, 141, 18, '2024-04-23 06:36:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5575, 142, 7, '2024-04-23 06:37:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5576, 144, 11, '2024-04-23 06:37:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5577, 143, 201, '2024-04-23 06:37:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5578, 141, 18, '2024-04-23 06:37:02', '2024-05-13 01:58:41', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5579, 142, 7, '2024-04-23 06:38:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5580, 144, 10, '2024-04-23 06:38:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5581, 143, 200, '2024-04-23 06:38:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5582, 141, 18, '2024-04-23 06:38:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5583, 142, 7, '2024-04-23 06:39:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5584, 144, 10, '2024-04-23 06:39:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5585, 143, 200, '2024-04-23 06:39:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5586, 141, 18, '2024-04-23 06:39:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5587, 142, 6.99, '2024-04-23 06:40:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5588, 144, 11, '2024-04-23 06:40:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5589, 143, 200, '2024-04-23 06:40:03', '2024-05-13 01:58:42', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5590, 141, 18, '2024-04-23 06:40:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5591, 142, 6.98, '2024-04-23 06:41:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5592, 144, 11, '2024-04-23 06:41:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5593, 143, 200, '2024-04-23 06:41:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5594, 141, 18, '2024-04-23 06:41:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5595, 142, 7, '2024-04-23 06:42:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5596, 144, 10, '2024-04-23 06:42:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5597, 143, 200, '2024-04-23 06:42:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5598, 141, 18, '2024-04-23 06:42:03', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5599, 142, 7, '2024-04-23 06:43:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5600, 144, 10, '2024-04-23 06:43:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5601, 143, 199, '2024-04-23 06:43:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5602, 141, 18, '2024-04-23 06:43:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5603, 142, 7, '2024-04-23 06:44:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5604, 144, 11, '2024-04-23 06:44:04', '2024-05-13 01:58:43', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5605, 143, 200, '2024-04-23 06:44:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5606, 141, 18, '2024-04-23 06:44:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5607, 142, 6.99, '2024-04-23 06:45:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5608, 144, 10, '2024-04-23 06:45:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5609, 143, 199, '2024-04-23 06:45:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5610, 141, 18, '2024-04-23 06:45:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5611, 142, 7, '2024-04-23 06:46:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5612, 144, 11, '2024-04-23 06:46:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5613, 143, 199, '2024-04-23 06:46:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5614, 141, 18, '2024-04-23 06:46:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5615, 142, 7, '2024-04-23 06:47:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5616, 144, 11, '2024-04-23 06:47:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5617, 143, 199, '2024-04-23 06:47:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5618, 141, 18, '2024-04-23 06:47:04', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5619, 142, 7, '2024-04-23 06:48:05', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5620, 144, 11, '2024-04-23 06:48:05', '2024-05-13 01:58:44', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5621, 143, 199, '2024-04-23 06:48:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5622, 141, 22, '2024-04-23 06:48:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5623, 142, 7, '2024-04-23 06:49:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5624, 144, 11, '2024-04-23 06:49:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5625, 143, 198, '2024-04-23 06:49:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5626, 141, 26, '2024-04-23 06:49:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5627, 142, 7, '2024-04-23 06:50:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5628, 144, 11, '2024-04-23 06:50:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5629, 143, 198, '2024-04-23 06:50:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5630, 141, 26, '2024-04-23 06:50:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5631, 142, 7, '2024-04-23 06:51:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5632, 144, 11, '2024-04-23 06:51:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5633, 143, 198, '2024-04-23 06:51:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5634, 141, 25, '2024-04-23 06:51:05', '2024-05-13 01:58:45', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5635, 142, 7, '2024-04-23 06:52:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5636, 144, 11, '2024-04-23 06:52:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5637, 143, 198, '2024-04-23 06:52:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5638, 141, 23, '2024-04-23 06:52:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5639, 142, 7, '2024-04-23 06:53:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5640, 144, 11, '2024-04-23 06:53:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5641, 143, 198, '2024-04-23 06:53:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5642, 141, 22, '2024-04-23 06:53:05', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5643, 142, 7, '2024-04-23 06:54:06', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5644, 144, 11, '2024-04-23 06:54:06', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5645, 143, 197, '2024-04-23 06:54:06', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5646, 141, 21, '2024-04-23 06:54:06', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5647, 142, 7, '2024-04-23 06:55:06', '2024-05-13 01:58:46', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5648, 144, 11, '2024-04-23 06:55:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5649, 143, 197, '2024-04-23 06:55:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5650, 141, 21, '2024-04-23 06:55:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5651, 142, 7, '2024-04-23 06:56:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5652, 144, 11, '2024-04-23 06:56:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5653, 143, 197, '2024-04-23 06:56:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5654, 141, 20, '2024-04-23 06:56:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5655, 142, 7, '2024-04-23 06:57:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5656, 144, 11, '2024-04-23 06:57:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5657, 143, 197, '2024-04-23 06:57:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5658, 141, 20, '2024-04-23 06:57:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5659, 142, 7, '2024-04-23 06:58:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5660, 144, 11, '2024-04-23 06:58:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5661, 143, 197, '2024-04-23 06:58:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5662, 141, 19, '2024-04-23 06:58:06', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5663, 142, 7, '2024-04-23 06:59:07', '2024-05-13 01:58:47', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5664, 144, 11, '2024-04-23 06:59:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5665, 143, 196, '2024-04-23 06:59:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5666, 141, 19, '2024-04-23 06:59:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5667, 142, 6.99, '2024-04-23 07:00:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5668, 144, 10, '2024-04-23 07:00:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5669, 143, 196, '2024-04-23 07:00:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5670, 141, 19, '2024-04-23 07:00:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5671, 142, 6.99, '2024-04-23 07:01:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5672, 144, 11, '2024-04-23 07:01:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5673, 143, 196, '2024-04-23 07:01:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5674, 141, 18, '2024-04-23 07:01:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5675, 142, 6.99, '2024-04-23 07:02:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5676, 144, 11, '2024-04-23 07:02:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5677, 143, 196, '2024-04-23 07:02:07', '2024-05-13 01:58:48', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5678, 141, 18, '2024-04-23 07:02:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5679, 142, 6.99, '2024-04-23 07:03:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5680, 144, 11, '2024-04-23 07:03:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5681, 143, 196, '2024-04-23 07:03:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5682, 141, 18, '2024-04-23 07:03:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5683, 142, 6.99, '2024-04-23 07:04:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5684, 144, 11, '2024-04-23 07:04:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5685, 143, 196, '2024-04-23 07:04:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5686, 141, 18, '2024-04-23 07:04:07', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5687, 142, 6.99, '2024-04-23 07:05:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5688, 144, 10, '2024-04-23 07:05:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5689, 143, 195, '2024-04-23 07:05:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5690, 141, 18, '2024-04-23 07:05:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5691, 142, 6.99, '2024-04-23 07:06:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5692, 144, 11, '2024-04-23 07:06:08', '2024-05-13 01:58:49', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5693, 143, 195, '2024-04-23 07:06:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5694, 141, 18, '2024-04-23 07:06:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5695, 142, 7, '2024-04-23 07:07:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5696, 144, 11, '2024-04-23 07:07:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5697, 143, 195, '2024-04-23 07:07:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5698, 141, 18, '2024-04-23 07:07:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5699, 142, 7, '2024-04-23 07:08:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5700, 144, 10, '2024-04-23 07:08:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5701, 143, 195, '2024-04-23 07:08:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5702, 141, 18, '2024-04-23 07:08:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5703, 142, 7, '2024-04-23 07:09:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5704, 144, 10, '2024-04-23 07:09:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5705, 143, 195, '2024-04-23 07:09:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5706, 141, 18, '2024-04-23 07:09:08', '2024-05-13 01:58:50', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5707, 142, 7, '2024-04-23 07:10:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5708, 144, 11, '2024-04-23 07:10:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5709, 143, 195, '2024-04-23 07:10:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5710, 141, 18, '2024-04-23 07:10:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5711, 142, 6.99, '2024-04-23 07:11:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5712, 144, 11, '2024-04-23 07:11:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5713, 143, 194, '2024-04-23 07:11:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5714, 141, 18, '2024-04-23 07:11:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5715, 142, 6.99, '2024-04-23 07:12:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5716, 144, 10, '2024-04-23 07:12:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5717, 143, 195, '2024-04-23 07:12:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5718, 141, 18, '2024-04-23 07:12:09', '2024-05-13 01:58:51', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5719, 142, 6.99, '2024-04-23 07:13:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5720, 144, 11, '2024-04-23 07:13:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5721, 143, 195, '2024-04-23 07:13:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5722, 141, 18, '2024-04-23 07:13:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5723, 142, 7, '2024-04-23 07:14:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5724, 144, 11, '2024-04-23 07:14:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5725, 143, 194, '2024-04-23 07:14:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5726, 141, 18, '2024-04-23 07:14:09', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5727, 142, 6.99, '2024-04-23 07:15:10', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5728, 144, 11, '2024-04-23 07:15:10', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5729, 143, 194, '2024-04-23 07:15:10', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5730, 141, 18, '2024-04-23 07:15:10', '2024-05-13 01:58:52', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5731, 142, 6.99, '2024-04-23 07:16:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5732, 144, 11, '2024-04-23 07:16:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5733, 143, 194, '2024-04-23 07:16:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5734, 141, 18, '2024-04-23 07:16:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5735, 142, 6.99, '2024-04-23 07:17:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5736, 144, 11, '2024-04-23 07:17:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5737, 143, 194, '2024-04-23 07:17:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5738, 141, 18, '2024-04-23 07:17:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5739, 142, 7.01, '2024-04-23 07:18:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5740, 144, 11, '2024-04-23 07:18:10', '2024-05-13 01:58:53', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5741, 143, 194, '2024-04-23 07:18:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5742, 141, 18, '2024-04-23 07:18:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5743, 142, 6.99, '2024-04-23 07:19:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5744, 144, 11, '2024-04-23 07:19:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5745, 143, 194, '2024-04-23 07:19:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5746, 141, 18, '2024-04-23 07:19:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5747, 142, 6.99, '2024-04-23 07:20:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5748, 144, 10, '2024-04-23 07:20:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5749, 143, 193, '2024-04-23 07:20:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5750, 141, 18, '2024-04-23 07:20:10', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5751, 142, 6.99, '2024-04-23 07:21:11', '2024-05-13 01:58:54', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5752, 144, 11, '2024-04-23 07:21:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5753, 143, 193, '2024-04-23 07:21:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5754, 141, 18, '2024-04-23 07:21:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5755, 142, 6.99, '2024-04-23 07:22:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5756, 144, 11, '2024-04-23 07:22:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5757, 143, 193, '2024-04-23 07:22:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5758, 141, 18, '2024-04-23 07:22:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5759, 142, 6.99, '2024-04-23 07:23:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5760, 144, 10, '2024-04-23 07:23:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5761, 143, 193, '2024-04-23 07:23:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5762, 141, 18, '2024-04-23 07:23:11', '2024-05-13 01:58:55', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5763, 142, 6.99, '2024-04-23 07:24:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5764, 144, 11, '2024-04-23 07:24:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5765, 143, 193, '2024-04-23 07:24:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5766, 141, 18, '2024-04-23 07:24:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5767, 142, 6.99, '2024-04-23 07:25:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5768, 144, 11, '2024-04-23 07:25:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5769, 143, 193, '2024-04-23 07:25:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5770, 141, 18, '2024-04-23 07:25:11', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5771, 142, 6.99, '2024-04-23 07:26:12', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5772, 144, 10, '2024-04-23 07:26:12', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5773, 143, 193, '2024-04-23 07:26:12', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5774, 141, 18, '2024-04-23 07:26:12', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5775, 142, 6.99, '2024-04-23 07:27:12', '2024-05-13 01:58:56', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5776, 144, 11, '2024-04-23 07:27:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5777, 143, 193, '2024-04-23 07:27:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5778, 141, 18, '2024-04-23 07:27:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5779, 142, 6.99, '2024-04-23 07:28:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5780, 144, 10, '2024-04-23 07:28:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5781, 143, 192, '2024-04-23 07:28:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5782, 141, 18, '2024-04-23 07:28:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5783, 142, 6.99, '2024-04-23 07:29:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5784, 144, 11, '2024-04-23 07:29:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5785, 143, 192, '2024-04-23 07:29:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5786, 141, 17, '2024-04-23 07:29:12', '2024-05-13 01:58:57', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5787, 142, 6.99, '2024-04-23 07:30:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5788, 144, 11, '2024-04-23 07:30:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5789, 143, 193, '2024-04-23 07:30:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5790, 141, 17, '2024-04-23 07:30:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5791, 142, 6.99, '2024-04-23 07:31:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5792, 144, 11, '2024-04-23 07:31:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5793, 143, 192, '2024-04-23 07:31:12', '2024-05-13 01:58:58', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5794, 141, 18, '2024-04-23 07:31:12', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5795, 142, 6.99, '2024-04-23 07:32:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5796, 144, 11, '2024-04-23 07:32:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5797, 143, 193, '2024-04-23 07:32:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5798, 141, 18, '2024-04-23 07:32:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5799, 142, 6.99, '2024-04-23 07:33:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5800, 144, 11, '2024-04-23 07:33:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5801, 143, 192, '2024-04-23 07:33:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5802, 141, 18, '2024-04-23 07:33:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5803, 142, 6.99, '2024-04-23 07:34:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5804, 144, 10, '2024-04-23 07:34:13', '2024-05-13 01:58:59', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5805, 143, 192, '2024-04-23 07:34:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5806, 141, 18, '2024-04-23 07:34:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5807, 142, 6.99, '2024-04-23 07:35:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5808, 144, 11, '2024-04-23 07:35:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5809, 143, 192, '2024-04-23 07:35:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5810, 141, 18, '2024-04-23 07:35:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5811, 142, 6.99, '2024-04-23 07:36:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5812, 144, 11, '2024-04-23 07:36:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5813, 143, 192, '2024-04-23 07:36:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5814, 141, 18, '2024-04-23 07:36:13', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5815, 142, 6.99, '2024-04-23 07:37:14', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5816, 144, 11, '2024-04-23 07:37:14', '2024-05-13 01:59:00', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5817, 143, 192, '2024-04-23 07:37:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5818, 141, 18, '2024-04-23 07:37:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5819, 142, 6.99, '2024-04-23 07:38:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5820, 144, 10, '2024-04-23 07:38:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5821, 143, 192, '2024-04-23 07:38:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5822, 141, 18, '2024-04-23 07:38:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5823, 142, 6.99, '2024-04-23 07:39:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5824, 144, 10, '2024-04-23 07:39:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5825, 143, 192, '2024-04-23 07:39:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5826, 141, 18, '2024-04-23 07:39:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5827, 142, 6.99, '2024-04-23 07:40:14', '2024-05-13 01:59:01', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5828, 144, 11, '2024-04-23 07:40:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5829, 143, 192, '2024-04-23 07:40:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5830, 141, 18, '2024-04-23 07:40:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5831, 142, 6.99, '2024-04-23 07:41:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5832, 144, 11, '2024-04-23 07:41:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5833, 143, 191, '2024-04-23 07:41:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5834, 141, 18, '2024-04-23 07:41:14', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5835, 142, 6.98, '2024-04-23 07:42:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5836, 144, 10, '2024-04-23 07:42:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5837, 143, 190, '2024-04-23 07:42:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5838, 141, 18, '2024-04-23 07:42:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5839, 142, 6.98, '2024-04-23 07:43:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5840, 144, 10, '2024-04-23 07:43:15', '2024-05-13 01:59:02', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5841, 143, 190, '2024-04-23 07:43:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5842, 141, 19, '2024-04-23 07:43:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5843, 142, 6.98, '2024-04-23 07:44:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5844, 144, 10, '2024-04-23 07:44:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5845, 143, 190, '2024-04-23 07:44:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5846, 141, 19, '2024-04-23 07:44:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5847, 142, 6.99, '2024-04-23 07:45:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5848, 144, 10, '2024-04-23 07:45:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5849, 143, 190, '2024-04-23 07:45:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5850, 141, 19, '2024-04-23 07:45:15', '2024-05-13 01:59:03', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5851, 142, 6.99, '2024-04-23 07:46:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5852, 144, 10, '2024-04-23 07:46:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5853, 143, 190, '2024-04-23 07:46:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5854, 141, 19, '2024-04-23 07:46:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5855, 142, 6.99, '2024-04-23 07:47:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5856, 144, 10, '2024-04-23 07:47:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5857, 143, 190, '2024-04-23 07:47:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5858, 141, 19, '2024-04-23 07:47:15', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5859, 142, 6.98, '2024-04-23 07:48:16', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5860, 144, 10, '2024-04-23 07:48:16', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5861, 143, 190, '2024-04-23 07:48:16', '2024-05-13 01:59:04', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5862, 141, 19, '2024-04-23 07:48:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5863, 142, 6.98, '2024-04-23 07:49:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5864, 144, 10, '2024-04-23 07:49:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5865, 143, 190, '2024-04-23 07:49:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5866, 141, 19, '2024-04-23 07:49:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5867, 142, 6.98, '2024-04-23 07:50:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5868, 144, 10, '2024-04-23 07:50:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5869, 143, 190, '2024-04-23 07:50:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5870, 141, 19, '2024-04-23 07:50:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5871, 142, 6.98, '2024-04-23 07:51:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5872, 144, 10, '2024-04-23 07:51:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5873, 143, 190, '2024-04-23 07:51:16', '2024-05-13 01:59:05', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5874, 141, 19, '2024-04-23 07:51:16', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5875, 142, 6.99, '2024-04-23 07:52:16', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5876, 144, 10, '2024-04-23 07:52:16', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5877, 143, 190, '2024-04-23 07:52:16', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5878, 141, 19, '2024-04-23 07:52:16', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5879, 142, 6.98, '2024-04-23 07:53:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5880, 144, 10, '2024-04-23 07:53:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5881, 143, 190, '2024-04-23 07:53:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5882, 141, 19, '2024-04-23 07:53:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5883, 142, 6.98, '2024-04-23 07:54:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5884, 144, 10, '2024-04-23 07:54:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5885, 143, 190, '2024-04-23 07:54:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5886, 141, 19, '2024-04-23 07:54:17', '2024-05-13 01:59:06', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5887, 142, 6.98, '2024-04-23 07:55:17', '2024-05-13 01:59:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5888, 144, 10, '2024-04-23 07:55:17', '2024-05-13 01:59:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5889, 143, 191, '2024-04-23 07:55:17', '2024-05-13 01:59:07', 1);
INSERT INTO `readings` (`reading_id`, `parameter_id`, `value`, `recorded_at`, `modified_at`, `isRecordedBySensor`) VALUES
	(5890, 141, 19, '2024-04-23 07:55:17', '2024-05-13 01:59:07', 1);

-- Dumping structure for table water-monitoring-system-db.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `middlename` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.users: ~0 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(1, 'Reinhart', 'Ferrer', 'Logronio', 'reinhart.logronio@msugensan.edu.ph', '$2a$12$97pPAfoi/KcoKNeaUwYJAOqTV4fKMU6WpGBETtmswdHeiGppnlDpK');
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(2, 'Nielmer', '', 'Camintoy', 'nielmer.camintoy@msugensan.edu.ph', '$2a$12$97pPAfoi/KcoKNeaUwYJAOqTV4fKMU6WpGBETtmswdHeiGppnlDpK');
INSERT INTO `users` (`user_id`, `firstname`, `middlename`, `lastname`, `email`, `password`) VALUES
	(3, 'John Rey', NULL, 'Vilbar', 'johnrey.vilbar@msugensan.edu.ph', '$2a$12$97pPAfoi/KcoKNeaUwYJAOqTV4fKMU6WpGBETtmswdHeiGppnlDpK');

-- Dumping structure for table water-monitoring-system-db.user_notifications
DROP TABLE IF EXISTS `user_notifications`;
CREATE TABLE IF NOT EXISTS `user_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'No Message',
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
DROP VIEW IF EXISTS `view_dashboard_ponds_monitored`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_dashboard_ponds_monitored` (
	`farmer_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`ponds_monitored` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_farm
DROP VIEW IF EXISTS `view_farmer_farm`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_farm` (
	`role` CHAR(5) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`user_id` INT(10) NOT NULL,
	`latitude` DECIMAL(10,8) NULL,
	`longitude` DECIMAL(11,8) NULL,
	`farm_id` INT(10) NOT NULL,
	`name` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_street` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_city` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`address_province` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`is_approved` TINYINT(3) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_farmer_ponds
DROP VIEW IF EXISTS `view_farmer_ponds`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farmer_ponds` (
	`user_id` INT(10) NOT NULL,
	`farm_id` INT(10) NOT NULL,
	`pond_id` INT(10) NOT NULL,
	`latitude` DECIMAL(10,8) NULL,
	`longitude` DECIMAL(11,8) NULL,
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
DROP VIEW IF EXISTS `view_farm_farmers`;
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
DROP VIEW IF EXISTS `view_farm_reading_count`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_farm_reading_count` (
	`farm_id` INT(10) NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_hourly_readings
DROP VIEW IF EXISTS `view_pond_hourly_readings`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_hourly_readings` (
	`pond_id` INT(10) NOT NULL,
	`temperature` DOUBLE NULL,
	`ph` DOUBLE NULL,
	`ammonia` DOUBLE NULL,
	`tds` DOUBLE NULL,
	`recorded_at_start` VARCHAR(29) NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_pond_parameters
DROP VIEW IF EXISTS `view_pond_parameters`;
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
DROP VIEW IF EXISTS `view_pond_parameter_readings`;
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

-- Dumping structure for view water-monitoring-system-db.view_pond_readings
DROP VIEW IF EXISTS `view_pond_readings`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_pond_readings` (
	`pond_id` INT(10) NOT NULL,
	`recorded_at` TIMESTAMP NOT NULL,
	`temperature` DOUBLE NULL,
	`ph` DOUBLE NULL,
	`ammonia` DOUBLE NULL,
	`tds` DOUBLE NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_reading_notifications
DROP VIEW IF EXISTS `view_reading_notifications`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_reading_notifications` (
	`pond_reading_notifications` INT(10) NOT NULL,
	`user_id` INT(10) NOT NULL,
	`issued_at` TIMESTAMP NOT NULL,
	`is_resoved` TINYINT(3) NULL,
	`date_resolved` TIMESTAMP NULL,
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
DROP VIEW IF EXISTS `view_reading_notifications_count`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_reading_notifications_count` (
	`user_id` INT(10) NOT NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_user_notifications_count
DROP VIEW IF EXISTS `view_user_notifications_count`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_user_notifications_count` (
	`user_id` INT(10) NOT NULL,
	`count` BIGINT(19) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view water-monitoring-system-db.view_user_water_quality_notifications
DROP VIEW IF EXISTS `view_user_water_quality_notifications`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_user_water_quality_notifications` (
	`user_id` INT(10) NULL,
	`farm_id` INT(10) NULL,
	`name` VARCHAR(32) NULL COLLATE 'utf8mb4_unicode_ci',
	`latitude` DECIMAL(10,8) NULL,
	`longitude` DECIMAL(11,8) NULL,
	`status` VARCHAR(8) NULL COLLATE 'utf8mb4_unicode_ci',
	`notification_id` INT(10) NOT NULL,
	`pond_id` INT(10) NULL,
	`water_quality` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`is_resolved` TINYINT(3) NOT NULL,
	`date_resolved` TIMESTAMP NULL,
	`date_issued` TIMESTAMP NOT NULL,
	`date_modified` TIMESTAMP NULL
) ENGINE=MyISAM;

-- Dumping structure for table water-monitoring-system-db.water_change_schedules
DROP TABLE IF EXISTS `water_change_schedules`;
CREATE TABLE IF NOT EXISTS `water_change_schedules` (
  `water_change_schedule_id` int NOT NULL AUTO_INCREMENT,
  `water_change_schedule` timestamp NOT NULL,
  `duration` int NOT NULL DEFAULT (1),
  `duration_unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'day',
  `date_created` timestamp NOT NULL DEFAULT (now()),
  PRIMARY KEY (`water_change_schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table water-monitoring-system-db.water_change_schedules: ~0 rows (approximately)
DELETE FROM `water_change_schedules`;

-- Dumping structure for trigger water-monitoring-system-db.parameters_after_pond_insert
DROP TRIGGER IF EXISTS `parameters_after_pond_insert`;
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
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_farm` AS select `farm_farmer`.`role` AS `role`,`farm_farmer`.`farmer_id` AS `user_id`,`farms`.`latitude` AS `latitude`,`farms`.`longitude` AS `longitude`,`farms`.`farm_id` AS `farm_id`,`farms`.`name` AS `name`,`farms`.`address_street` AS `address_street`,`farms`.`address_city` AS `address_city`,`farms`.`address_province` AS `address_province`,`farm_farmer`.`is_approved` AS `is_approved` from (`farm_farmer` join `farms` on((`farm_farmer`.`farm_id` = `farms`.`farm_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farmer_ponds`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farmer_ponds` AS select `farm_farmer`.`farmer_id` AS `user_id`,`farms`.`farm_id` AS `farm_id`,`ponds`.`pond_id` AS `pond_id`,`ponds`.`latitude` AS `latitude`,`ponds`.`longitude` AS `longitude`,`ponds`.`device_id` AS `device_id`,`devices`.`status` AS `status`,`devices`.`last_established_connection` AS `last_established_connection`,`ponds`.`name` AS `name`,`ponds`.`width` AS `width`,`ponds`.`length` AS `length`,`ponds`.`depth` AS `depth`,`ponds`.`method` AS `method` from (((`ponds` left join `devices` on((`ponds`.`device_id` = `devices`.`device_id`))) join `farms` on((`ponds`.`farm_id` = `farms`.`farm_id`))) join `farm_farmer` on((`farm_farmer`.`farm_id` = `farms`.`farm_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_farmers`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_farmers` AS select `farm_farmer`.`farm_id` AS `farm_id`,`farm_farmer`.`farmer_id` AS `farmer_id`,`farm_farmer`.`role` AS `role`,`farm_farmer`.`is_approved` AS `is_approved`,`users`.`user_id` AS `user_id`,`users`.`firstname` AS `firstname`,`users`.`middlename` AS `middlename`,`users`.`lastname` AS `lastname`,`users`.`email` AS `email`,`users`.`password` AS `password` from (`farm_farmer` join `users` on((`farm_farmer`.`farmer_id` = `users`.`user_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_farm_reading_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_farm_reading_count` AS select `farms`.`farm_id` AS `farm_id`,count(`view_pond_parameter_readings`.`reading_id`) AS `count` from ((`view_pond_parameter_readings` left join `ponds` on((`view_pond_parameter_readings`.`pond_id` = `ponds`.`pond_id`))) left join `farms` on((`ponds`.`farm_id` = `farms`.`farm_id`))) group by `farms`.`farm_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_hourly_readings`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_hourly_readings` AS select `view_pond_readings`.`pond_id` AS `pond_id`,round(avg(`view_pond_readings`.`temperature`),2) AS `temperature`,round(avg(`view_pond_readings`.`ph`),2) AS `ph`,round(avg(`view_pond_readings`.`ammonia`),2) AS `ammonia`,round(avg(`view_pond_readings`.`tds`),2) AS `tds`,(date_format(`view_pond_readings`.`recorded_at`,'%Y-%m-%d %H:00:00') + interval (floor((hour(`view_pond_readings`.`recorded_at`) / 1)) * 1) hour) AS `recorded_at_start` from `view_pond_readings` group by `recorded_at_start`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_parameters`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_parameters` AS select `parameters`.`parameter_id` AS `parameter_id`,`parameters`.`pond_id` AS `pond_id`,`parameter_list`.`parameter` AS `parameter`,`parameter_list`.`name` AS `name`,`parameter_list`.`unit` AS `unit`,count(`readings`.`reading_id`) AS `count` from ((`parameters` left join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) left join `readings` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) group by `parameters`.`parameter_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_parameter_readings`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_parameter_readings` AS select `ponds`.`pond_id` AS `pond_id`,`parameters`.`parameter_id` AS `parameter_id`,`readings`.`reading_id` AS `reading_id`,`parameters`.`parameter` AS `parameter`,`parameter_list`.`name` AS `name`,`parameter_list`.`unit` AS `unit`,`readings`.`value` AS `value`,`readings`.`recorded_at` AS `recorded_at`,`readings`.`modified_at` AS `modified_at`,`readings`.`isRecordedBySensor` AS `isRecordedBySensor` from (((`readings` join `parameters` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) join `ponds` on((`parameters`.`pond_id` = `ponds`.`pond_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_pond_readings`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pond_readings` AS select `view_pond_parameter_readings`.`pond_id` AS `pond_id`,`view_pond_parameter_readings`.`recorded_at` AS `recorded_at`,max((case when (`view_pond_parameter_readings`.`parameter` = 'tmp') then `view_pond_parameter_readings`.`value` end)) AS `temperature`,max((case when (`view_pond_parameter_readings`.`parameter` = 'ph') then `view_pond_parameter_readings`.`value` end)) AS `ph`,max((case when (`view_pond_parameter_readings`.`parameter` = 'amn') then `view_pond_parameter_readings`.`value` end)) AS `ammonia`,max((case when (`view_pond_parameter_readings`.`parameter` = 'tds') then `view_pond_parameter_readings`.`value` end)) AS `tds` from `view_pond_parameter_readings` group by `view_pond_parameter_readings`.`pond_id`,`view_pond_parameter_readings`.`recorded_at`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_reading_notifications`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_reading_notifications` AS select `pond_reading_notifications`.`reading_notification_id` AS `pond_reading_notifications`,`pond_reading_notifications`.`user_id` AS `user_id`,`pond_reading_notifications`.`issued_at` AS `issued_at`,`pond_reading_notifications`.`is_resolved` AS `is_resoved`,`pond_reading_notifications`.`date_resolved` AS `date_resolved`,`parameter_thresholds`.`threshold_id` AS `threshold_id`,`parameter_thresholds`.`parameter` AS `parameter`,`parameter_list`.`name` AS `parameter_name`,`parameter_list`.`unit` AS `unit`,`parameter_thresholds`.`type` AS `type`,`parameter_thresholds`.`action` AS `action`,`parameter_thresholds`.`target` AS `target`,`readings`.`reading_id` AS `reading_id`,`readings`.`value` AS `value`,`readings`.`recorded_at` AS `recorded_at`,`readings`.`isRecordedBySensor` AS `isRecordedBySensor`,`parameters`.`parameter_id` AS `parameter_id`,`ponds`.`pond_id` AS `pond_id`,`ponds`.`name` AS `pond_name` from (((((`pond_reading_notifications` left join `parameter_thresholds` on((`pond_reading_notifications`.`threshold_id` = `parameter_thresholds`.`threshold_id`))) left join `readings` on((`pond_reading_notifications`.`reading_id` = `readings`.`reading_id`))) left join `parameters` on((`readings`.`parameter_id` = `parameters`.`parameter_id`))) left join `parameter_list` on((`parameters`.`parameter` = `parameter_list`.`parameter`))) left join `ponds` on((`parameters`.`pond_id` = `ponds`.`pond_id`)));

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_reading_notifications_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_reading_notifications_count` AS select `users`.`user_id` AS `user_id`,count(`pond_reading_notifications`.`reading_notification_id`) AS `count` from (`users` left join `pond_reading_notifications` on((`users`.`user_id` = `pond_reading_notifications`.`user_id`))) group by `users`.`user_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_user_notifications_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_user_notifications_count` AS select `users`.`user_id` AS `user_id`,count(`user_notifications`.`notification_id`) AS `count` from (`users` left join `user_notifications` on((`users`.`user_id` = `user_notifications`.`user_id`))) where (`user_notifications`.`isRead` = false) group by `users`.`user_id`;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_user_water_quality_notifications`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_user_water_quality_notifications` AS select `view_farmer_ponds`.`user_id` AS `user_id`,`view_farmer_ponds`.`farm_id` AS `farm_id`,`view_farmer_ponds`.`name` AS `name`,`view_farmer_ponds`.`latitude` AS `latitude`,`view_farmer_ponds`.`longitude` AS `longitude`,`view_farmer_ponds`.`status` AS `status`,`pond_water_quality_notifications`.`notification_id` AS `notification_id`,`pond_water_quality_notifications`.`pond_id` AS `pond_id`,`pond_water_quality_notifications`.`water_quality` AS `water_quality`,`pond_water_quality_notifications`.`is_resolved` AS `is_resolved`,`pond_water_quality_notifications`.`date_resolved` AS `date_resolved`,`pond_water_quality_notifications`.`date_issued` AS `date_issued`,`pond_water_quality_notifications`.`date_modified` AS `date_modified` from (`pond_water_quality_notifications` left join `view_farmer_ponds` on((`view_farmer_ponds`.`pond_id` = `pond_water_quality_notifications`.`pond_id`)));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
