-- MySQL dump 10.11
--
-- Host: localhost    Database: vbx2008
-- ------------------------------------------------------
-- Server version	5.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `annotation_types`
--

DROP TABLE IF EXISTS `annotation_types`;
CREATE TABLE `annotation_types` (
  `id` tinyint(4) NOT NULL auto_increment,
  `description` varchar(32) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `annotation_types_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `annotation_types`
--

LOCK TABLES `annotation_types` WRITE;
/*!40000 ALTER TABLE `annotation_types` DISABLE KEYS */;
INSERT INTO `annotation_types` VALUES (1,'called',1),(2,'read',1),(3,'noted',1),(4,'changed',1),(5,'labeled',1),(6,'sms',1);
/*!40000 ALTER TABLE `annotation_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annotations`
--

DROP TABLE IF EXISTS `annotations`;
CREATE TABLE `annotations` (
  `id` bigint(20) NOT NULL auto_increment,
  `annotation_type` tinyint(4) NOT NULL,
  `message_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `description` text character set latin1 NOT NULL,
  `created` datetime NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `annotation_type_message_id` (`annotation_type`,`message_id`,`created`),
  KEY `created` (`created`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `annotations_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `annotations`
--

LOCK TABLES `annotations` WRITE;
/*!40000 ALTER TABLE `annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audio_files`
--

DROP TABLE IF EXISTS `audio_files`;
CREATE TABLE `audio_files` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(255) default NULL,
  `user_id` int(11) NOT NULL,
  `url` varchar(255) default NULL,
  `recording_call_sid` varchar(100) default NULL,
  `tag` varchar(100) default NULL,
  `cancelled` tinyint(4) default '0',
  `created` datetime default NULL,
  `updated` datetime default NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  KEY `url` (`url`),
  KEY `recording_call_sid` (`recording_call_sid`),
  KEY `tag` (`tag`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `audio_files_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `audio_files`
--

LOCK TABLES `audio_files` WRITE;
/*!40000 ALTER TABLE `audio_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `audio_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_types`
--

DROP TABLE IF EXISTS `auth_types`;
CREATE TABLE `auth_types` (
  `id` tinyint(4) NOT NULL auto_increment,
  `description` varchar(255) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `auth_types_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `auth_types`
--

LOCK TABLES `auth_types` WRITE;
/*!40000 ALTER TABLE `auth_types` DISABLE KEYS */;
INSERT INTO `auth_types` VALUES (1,'openvbx',1),(2,'google',1);
/*!40000 ALTER TABLE `auth_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_store`
--

DROP TABLE IF EXISTS `flow_store`;
CREATE TABLE `flow_store` (
  `key` varchar(255) NOT NULL,
  `value` text,
  `flow_id` int(11) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  UNIQUE KEY `key_flow` (`key`,`flow_id`),
  KEY `key` (`key`,`flow_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `flow_store_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flow_store`
--

LOCK TABLES `flow_store` WRITE;
/*!40000 ALTER TABLE `flow_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flows`
--

DROP TABLE IF EXISTS `flows`;
CREATE TABLE `flows` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime default NULL,
  `updated` datetime default NULL,
  `data` text,
  `sms_data` text,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`,`tenant_id`),
  KEY `user_id` (`user_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `flows_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `flows_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flows`
--

LOCK TABLES `flows` WRITE;
/*!40000 ALTER TABLE `flows` DISABLE KEYS */;
INSERT INTO `flows` VALUES (2,'Dial single user',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/258ff8\"},\"id\":\"start\",\"type\":\"standard---start\"},\"258ff8\":{\"name\":\"Dial\",\"data\":{\"dial-whom-user-or-group_id\":\"\",\"dial-whom-user-or-group_type\":\"\",\"dial-whom-selector\":\"number\",\"dial-whom-number\":\"15105555555\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"(555) 555-5555\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"start/258ff8/d6b982\",\"version\":\"3\"},\"id\":\"258ff8\",\"type\":\"standard---dial\"},\"d6b982\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"d6b982\",\"type\":\"standard---hangup\"}}',NULL,1),(3,'Dial a user',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/85d671\"},\"id\":\"start\",\"type\":\"standard---start\"},\"85d671\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"2\",\"dial-whom-user-or-group_type\":\"user\",\"dial-whom-number\":\"\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"(510) 552-5555\",\"library\":\"\",\"no-answer-action\":\"redirect\",\"no-answer-redirect\":\"start/85d671/3aa8b3\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"85d671\",\"type\":\"standard---dial\"},\"3aa8b3\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"3aa8b3\",\"type\":\"standard---hangup\"}}',NULL,1),(5,'Call Sales',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/a6da58\"},\"id\":\"start\",\"type\":\"standard---start\"},\"a6da58\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"1\",\"dial-whom-user-or-group_type\":\"group\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"start/a6da58/1bc918\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"a6da58\",\"type\":\"standard---dial\"},\"1bc918\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"1bc918\",\"type\":\"standard---hangup\"}}',NULL,1),(6,'Dial an invalid number',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/534e43\"},\"id\":\"start\",\"type\":\"standard---start\"},\"534e43\":{\"name\":\"Dial\",\"data\":{\"dial-whom-user-or-group_id\":\"\",\"dial-whom-user-or-group_type\":\"\",\"dial-whom-selector\":\"number\",\"dial-whom-number\":\"1232345678\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"534e43\",\"type\":\"standard---dial\"}}',NULL,1),(7,'Empty Dial',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/54f986\"},\"id\":\"start\",\"type\":\"standard---start\"},\"54f986\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"\",\"dial-whom-user-or-group_type\":\"\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"54f986\",\"type\":\"standard---dial\"}}',NULL,1),(9,'Empty Group Dial',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/3fc019\"},\"id\":\"start\",\"type\":\"standard---start\"},\"3fc019\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"3\",\"dial-whom-user-or-group_type\":\"group\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"3fc019\",\"type\":\"standard---dial\"}}',NULL,1),(10,'User with no device',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/e49967\"},\"id\":\"start\",\"type\":\"standard---start\"},\"e49967\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"4\",\"dial-whom-user-or-group_type\":\"user\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"e49967\",\"type\":\"standard---dial\"}}',NULL,1),(11,'User with many devices',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/d5e12c\"},\"id\":\"start\",\"type\":\"standard---start\"},\"d5e12c\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"7\",\"dial-whom-user-or-group_type\":\"user\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"d5e12c\",\"type\":\"standard---dial\"}}',NULL,1),(12,'Two user group, two devices each',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/2d6f0\"},\"id\":\"start\",\"type\":\"standard---start\"},\"2d6f0\":{\"name\":\"Dial\",\"data\":{\"dial-whom-selector\":\"user-or-group\",\"dial-whom-user-or-group_id\":\"4\",\"dial-whom-user-or-group_type\":\"group\",\"dial-whom-number\":\"\",\"no-answer-action\":\"voicemail\",\"no-answer-group-voicemail_say\":\"\",\"no-answer-group-voicemail_play\":\"\",\"no-answer-group-voicemail_mode\":\"\",\"no-answer-group-voicemail_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"no-answer-redirect\":\"\",\"no-answer-redirect-number\":\"\",\"version\":\"3\"},\"id\":\"2d6f0\",\"type\":\"standard---dial\"}}',NULL,1),(14,'0 item menu',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/81b122\"},\"id\":\"start\",\"type\":\"standard---start\"},\"81b122\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":\"\",\"choices[]\":[\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"81b122\",\"type\":\"menu---menu\"}}',NULL,1),(15,'1 item menu',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/847cee\"},\"id\":\"start\",\"type\":\"standard---start\"},\"847cee\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":\"1\",\"choices[]\":[\"start/847cee/6d2a42\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"847cee\",\"type\":\"menu---menu\"},\"6d2a42\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"6d2a42\",\"type\":\"standard---hangup\"}}',NULL,1),(16,'Voicemail empty',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/efe3e1\"},\"id\":\"start\",\"type\":\"standard---start\"},\"efe3e1\":{\"name\":\"Voicemail\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"permissions_id\":\"\",\"permissions_type\":\"\"},\"id\":\"efe3e1\",\"type\":\"standard---voicemail\"}}',NULL,1),(17,'Voicemail TTS',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/f166fa\"},\"id\":\"start\",\"type\":\"standard---start\"},\"f166fa\":{\"name\":\"Voicemail\",\"data\":{\"prompt_say\":\"I\'m reading text like a robot.\",\"prompt_play\":\"\",\"prompt_mode\":\"say\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"permissions_id\":\"\",\"permissions_type\":\"\"},\"id\":\"f166fa\",\"type\":\"standard---voicemail\"}}',NULL,1),(18,'Voicemail play a MP3',1,NULL,NULL,NULL,NULL,1),(19,'0 item menu - test1',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/296ca8\"},\"id\":\"start\",\"type\":\"standard---start\"},\"296ca8\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"\",\"\"],\"choices[]\":[\"\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"296ca8\",\"type\":\"menu---menu\"}}',NULL,1),(20,'Menu with 0 items',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/82c6d9\"},\"id\":\"start\",\"type\":\"standard---start\"},\"82c6d9\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"\",\"\"],\"choices[]\":[\"\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"82c6d9\",\"type\":\"menu---menu\"}}',NULL,1),(21,'Menu with 1 item',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/51a03a\"},\"id\":\"start\",\"type\":\"standard---start\"},\"51a03a\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"\"],\"choices[]\":[\"start/51a03a/8fe5db\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"51a03a\",\"type\":\"menu---menu\"},\"8fe5db\":{\"name\":\"Greeting\",\"data\":{\"prompt_say\":\"Hello World!\",\"prompt_play\":\"\",\"prompt_mode\":\"say\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"next\":\"\"},\"id\":\"8fe5db\",\"type\":\"standard---greeting\"}}',NULL,1),(22,'Menu with 3 items',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/1022af\"},\"id\":\"start\",\"type\":\"standard---start\"},\"1022af\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"2\",\"3\"],\"choices[]\":[\"start/1022af/98f996\",\"start/1022af/74c4fd\",\"start/1022af/f7640a\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"1022af\",\"type\":\"menu---menu\"},\"98f996\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"98f996\",\"type\":\"standard---hangup\"},\"74c4fd\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"74c4fd\",\"type\":\"standard---hangup\"},\"f7640a\":{\"name\":\"Greeting\",\"data\":{\"prompt_say\":\"Item 3\",\"prompt_play\":\"\",\"prompt_mode\":\"say\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"next\":\"\"},\"id\":\"f7640a\",\"type\":\"standard---greeting\"}}',NULL,1),(23,'More than 10 items',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/697e42\"},\"id\":\"start\",\"type\":\"standard---start\"},\"697e42\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"2\",\"3\",\"4\",\"5\",\"6\",\"7\",\"8\",\"9\",\"10\",\"11\"],\"choices[]\":[\"start/697e42/c30c2\",\"start/697e42/c50a1f\",\"start/697e42/365a40\",\"start/697e42/4c96b\",\"start/697e42/1e9166\",\"start/697e42/36719d\",\"start/697e42/30b0a4\",\"start/697e42/c18e0c\",\"start/697e42/1d178d\",\"start/697e42/65e81d\",\"start/697e42/b873f2\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"697e42\",\"type\":\"menu---menu\"},\"c30c2\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"c30c2\",\"type\":\"standard---hangup\"},\"c50a1f\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"c50a1f\",\"type\":\"standard---hangup\"},\"365a40\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"365a40\",\"type\":\"standard---hangup\"},\"4c96b\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"4c96b\",\"type\":\"standard---hangup\"},\"1e9166\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"1e9166\",\"type\":\"standard---hangup\"},\"36719d\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"36719d\",\"type\":\"standard---hangup\"},\"30b0a4\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"30b0a4\",\"type\":\"standard---hangup\"},\"c18e0c\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"c18e0c\",\"type\":\"standard---hangup\"},\"1d178d\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"1d178d\",\"type\":\"standard---hangup\"},\"65e81d\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"65e81d\",\"type\":\"standard---hangup\"},\"b873f2\":{\"name\":\"Greeting\",\"data\":{\"prompt_say\":\"Item 11\",\"prompt_play\":\"\",\"prompt_mode\":\"say\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"next\":\"\"},\"id\":\"b873f2\",\"type\":\"standard---greeting\"}}',NULL,1),(24,'Menu redirect to voicemail',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/4f084c\"},\"id\":\"start\",\"type\":\"standard---start\"},\"4f084c\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"\"],\"choices[]\":[\"start/4f084c/1dddee\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"4f084c\",\"type\":\"menu---menu\"},\"1dddee\":{\"name\":\"Voicemail\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"permissions_id\":\"\",\"permissions_type\":\"\"},\"id\":\"1dddee\",\"type\":\"standard---voicemail\"}}',NULL,1),(25,'Handle Oops',1,NULL,NULL,'{\"674042\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"674042\",\"type\":\"standard---hangup\"},\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/d678ad\"},\"id\":\"start\",\"type\":\"standard---start\"},\"d678ad\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"\"],\"choices[]\":[\"start/d678ad/674042\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"Oops fired\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"say\",\"invalid-option_tag\":\"global\"},\"id\":\"d678ad\",\"type\":\"menu---menu\"}}',NULL,1),(26,'Empty menu',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/2e2d86\"},\"id\":\"start\",\"type\":\"standard---start\"},\"2e2d86\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"\",\"\"],\"choices[]\":[\"\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"2e2d86\",\"type\":\"menu---menu\"}}',NULL,1),(27,'7, 77, 777 menu items',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/2566ed\"},\"id\":\"start\",\"type\":\"standard---start\"},\"2566ed\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"7\",\"77\",\"777\"],\"choices[]\":[\"start/2566ed/7b8e68\",\"start/2566ed/1f1522\",\"start/2566ed/ef8e25\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"2566ed\",\"type\":\"menu---menu\"},\"7b8e68\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"7b8e68\",\"type\":\"standard---hangup\"},\"1f1522\":{\"name\":\"Hangup\",\"data\":{},\"id\":\"1f1522\",\"type\":\"standard---hangup\"},\"ef8e25\":{\"name\":\"Greeting\",\"data\":{\"prompt_say\":\"I\'m told this is jackpot\",\"prompt_play\":\"\",\"prompt_mode\":\"say\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"next\":\"\"},\"id\":\"ef8e25\",\"type\":\"standard---greeting\"}}',NULL,1),(28,'Menu with empty applets',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/a25b4d\"},\"id\":\"start\",\"type\":\"standard---start\"},\"a25b4d\":{\"name\":\"Menu\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":[\"\",\"\"],\"library\":[\"\",\"\"],\"keys[]\":[\"1\",\"2\"],\"choices[]\":[\"\",\"\"],\"repeat-count\":\"\",\"next\":\"\",\"invalid-option_say\":\"\",\"invalid-option_play\":\"\",\"invalid-option_mode\":\"\",\"invalid-option_tag\":\"global\"},\"id\":\"a25b4d\",\"type\":\"menu---menu\"}}',NULL,1),(29,'SMS send',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/6cfc0\"},\"id\":\"start\",\"type\":\"standard---start\"},\"6cfc0\":{\"name\":\"Sms\",\"data\":{\"sms\":\"Hello World!\",\"next\":\"\"},\"id\":\"6cfc0\",\"type\":\"sms---sms\"}}',NULL,1),(30,'SMS with voicemail',1,NULL,NULL,'{\"start\":{\"name\":\"Call Start\",\"data\":{\"next\":\"start/a5b3e6\"},\"id\":\"start\",\"type\":\"standard---start\"},\"a5b3e6\":{\"name\":\"Sms\",\"data\":{\"sms\":\"Hello World!\",\"next\":\"start/a5b3e6/3883f7\"},\"id\":\"a5b3e6\",\"type\":\"sms---sms\"},\"3883f7\":{\"name\":\"Voicemail\",\"data\":{\"prompt_say\":\"\",\"prompt_play\":\"\",\"prompt_mode\":\"\",\"prompt_tag\":\"global\",\"number\":\"\",\"library\":\"\",\"permissions_id\":\"\",\"permissions_type\":\"\"},\"id\":\"3883f7\",\"type\":\"standard---voicemail\"}}',NULL,1),(31,'SMS Flow Greeting',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/764ddf\"},\"id\":\"start\",\"type\":\"standard---start\"},\"764ddf\":{\"name\":\"Sms\",\"data\":{\"sms\":\"Hello World!\",\"next\":\"\"},\"id\":\"764ddf\",\"type\":\"sms---sms\"}}',1),(32,'Sms Flow Empty Applet',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"\"},\"id\":\"start\",\"type\":\"standard---start\"}}',1),(33,'SMS Flow empty greeting',1,NULL,NULL,NULL,'{\"723001\":{\"name\":\"Sms\",\"data\":{\"sms\":\"\",\"next\":\"\"},\"id\":\"723001\",\"type\":\"sms---sms\"},\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/723001\"},\"id\":\"start\",\"type\":\"standard---start\"}}',1),(34,'SMS empty menu',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/4c635\"},\"id\":\"start\",\"type\":\"standard---start\"},\"4c635\":{\"name\":\"Menu\",\"data\":{\"prompt\":\"\",\"new-responses[]\":\"\",\"keys[]\":[\"\",\"\",\"\",\"\"],\"responses[]\":[\"\",\"\",\"\",\"\"]},\"id\":\"4c635\",\"type\":\"menu---query\"}}',1),(35,'SMS Flow Menu with 1 item',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/de2d77\"},\"id\":\"start\",\"type\":\"standard---start\"},\"de2d77\":{\"name\":\"Menu\",\"data\":{\"prompt\":\"\",\"new-responses[]\":\"\",\"keys[]\":[\"ping\",\"\",\"\",\"\"],\"responses[]\":[\"pong\",\"\",\"\",\"\"]},\"id\":\"de2d77\",\"type\":\"menu---query\"}}',1),(36,'SMS Menu with Greeting',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/a05988\"},\"id\":\"start\",\"type\":\"standard---start\"},\"a05988\":{\"name\":\"Menu\",\"data\":{\"prompt\":\"Hello World!\",\"new-responses[]\":\"\",\"keys[]\":[\"ping\",\"pang\",\"\",\"\"],\"responses[]\":[\"pong\",\"pongo\",\"\",\"\"]},\"id\":\"a05988\",\"type\":\"menu---query\"}}',1),(37,'SMS inbox',1,NULL,NULL,NULL,'{\"start\":{\"name\":\"Message Received\",\"data\":{\"next\":\"start/304f27\"},\"id\":\"start\",\"type\":\"standard---start\"},\"304f27\":{\"name\":\"Sms Inbox\",\"data\":{\"forward_id\":\"1\",\"forward_type\":\"user\"},\"id\":\"304f27\",\"type\":\"sms---sms-inbox\"}}',1);
/*!40000 ALTER TABLE `flows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_annotations`
--

DROP TABLE IF EXISTS `group_annotations`;
CREATE TABLE `group_annotations` (
  `group_id` int(11) NOT NULL,
  `annotation_id` bigint(20) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`group_id`,`annotation_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `group_annotations_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `group_annotations`
--

LOCK TABLES `group_annotations` WRITE;
/*!40000 ALTER TABLE `group_annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_messages`
--

DROP TABLE IF EXISTS `group_messages`;
CREATE TABLE `group_messages` (
  `group_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`group_id`,`message_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `message_id` (`message_id`),
  CONSTRAINT `group_messages_ibfk_3` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `group_messages_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `group_messages_ibfk_2` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `group_messages`
--

LOCK TABLES `group_messages` WRITE;
/*!40000 ALTER TABLE `group_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `is_active` tinyint(4) NOT NULL default '1',
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'Sales',1,1),(2,'Support',1,1),(3,'Empty Group',1,1),(4,'Many Device',1,1);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_users`
--

DROP TABLE IF EXISTS `groups_users`;
CREATE TABLE `groups_users` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `group_id` (`group_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `groups_users_ibfk_3` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `groups_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `groups_users_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `groups_users`
--

LOCK TABLES `groups_users` WRITE;
/*!40000 ALTER TABLE `groups_users` DISABLE KEYS */;
INSERT INTO `groups_users` VALUES (2,1,2,1),(3,1,3,1),(5,4,6,1),(6,4,7,1),(7,4,8,1);
/*!40000 ALTER TABLE `groups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `created` datetime default NULL,
  `updated` datetime default NULL,
  `read` datetime default NULL,
  `call_sid` varchar(34) default NULL,
  `caller` varchar(20) default NULL,
  `called` varchar(20) default NULL,
  `type` varchar(10) default NULL,
  `status` varchar(10) default NULL,
  `content_url` varchar(255) default NULL,
  `content_text` varchar(5000) default NULL,
  `notes` varchar(5000) default NULL,
  `size` smallint(6) default NULL,
  `assigned_to` bigint(20) default NULL,
  `archived` tinyint(4) NOT NULL default '0',
  `ticket_status` enum('open','closed','pending') NOT NULL default 'open',
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `call_sid` (`call_sid`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numbers`
--

DROP TABLE IF EXISTS `numbers`;
CREATE TABLE `numbers` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) default NULL,
  `value` text NOT NULL,
  `is_active` tinyint(1) default '1',
  `sms` tinyint(1) default '0',
  `sequence` smallint(6) default NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `numbers_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `numbers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `numbers`
--

LOCK TABLES `numbers` WRITE;
/*!40000 ALTER TABLE `numbers` DISABLE KEYS */;
INSERT INTO `numbers` VALUES (3,2,'Primary Device','+15105555555',1,1,NULL,1),(4,1,'Blank','+15555555555',1,1,NULL,1),(5,3,'Primary Device','+15105555556',1,1,NULL,1),(6,4,'Primary Device','',1,1,NULL,1),(7,5,'Primary Device','+15552225555',1,1,NULL,1),(8,6,'Primary Device','+15553335555',1,1,NULL,1),(9,7,'Primary Device','+15551112222',1,1,NULL,1),(10,8,'Primary Device','+15552223333',1,1,NULL,1),(11,7,'Second','+15343562222',1,1,NULL,1),(12,8,'Second','+12354567788',1,1,NULL,1);
/*!40000 ALTER TABLE `numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_store`
--

DROP TABLE IF EXISTS `plugin_store`;
CREATE TABLE `plugin_store` (
  `key` varchar(255) NOT NULL,
  `value` text,
  `plugin_id` varchar(34) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  UNIQUE KEY `key_plugin` (`key`,`plugin_id`,`tenant_id`),
  KEY `key` (`key`,`plugin_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `plugin_store_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `plugin_store`
--

LOCK TABLES `plugin_store` WRITE;
/*!40000 ALTER TABLE `plugin_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rest_access`
--

DROP TABLE IF EXISTS `rest_access`;
CREATE TABLE `rest_access` (
  `key` varchar(32) NOT NULL,
  `locked` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`key`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `rest_access_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `rest_access`
--

LOCK TABLES `rest_access` WRITE;
/*!40000 ALTER TABLE `rest_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `rest_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
CREATE TABLE `tenants` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `url_prefix` varchar(255) NOT NULL,
  `local_prefix` varchar(1000) NOT NULL,
  `active` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `url_prefix` (`url_prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES (1,'default','','',1);
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_annotations`
--

DROP TABLE IF EXISTS `user_annotations`;
CREATE TABLE `user_annotations` (
  `user_id` int(11) NOT NULL,
  `annotation_id` bigint(20) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`user_id`,`annotation_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `user_annotations_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_annotations`
--

LOCK TABLES `user_annotations` WRITE;
/*!40000 ALTER TABLE `user_annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_messages`
--

DROP TABLE IF EXISTS `user_messages`;
CREATE TABLE `user_messages` (
  `user_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`user_id`,`message_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `message_id` (`message_id`),
  CONSTRAINT `user_messages_ibfk_3` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `user_messages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_messages_ibfk_2` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_messages`
--

LOCK TABLES `user_messages` WRITE;
/*!40000 ALTER TABLE `user_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `is_admin` tinyint(1) default NULL,
  `is_active` tinyint(1) default '1',
  `first_name` varchar(100) default NULL,
  `last_name` varchar(100) default NULL,
  `password` varchar(40) default NULL,
  `invite_code` varchar(32) default NULL,
  `email` varchar(200) default NULL,
  `pin` varchar(40) default NULL,
  `notification` varchar(20) default NULL,
  `auth_type` tinyint(4) NOT NULL default '1',
  `voicemail` text NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  `last_seen` datetime default NULL,
  `last_login` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `email` (`email`,`tenant_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `auth_type` (`auth_type`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`auth_type`) REFERENCES `auth_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,1,'Ryan','Larrabure','a83615368c892e13d6241229feadbaea0bbfe384',NULL,'ryan+openvbxtest@asdfsa.inv',NULL,NULL,1,'Please leave a message after the beep.',1,'2011-02-11 23:45:46','2011-02-11 23:45:39'),(2,0,1,'Joe','Bob','2f1c41ca5bb195034364bc49042a8a1aeee4d340',NULL,'jb12342@234234.inv',NULL,NULL,1,'',1,NULL,NULL),(3,0,1,'Sue','Bob','0ff12e54a7427a73abbdd5757ecec9060f0fe57c',NULL,'suebob@aasdf.inv',NULL,NULL,1,'',1,NULL,NULL),(4,0,1,'No','Number','e5622ed50f7a76dd768f39296f1ad8d8192fd28a',NULL,'adsfasdf@asdfs.inv',NULL,NULL,1,'',1,NULL,NULL),(5,0,0,'Many','Device 1','900382819c96a0f73d96ebb63a2278eb623d3cd4',NULL,'manydevice1@dummy.inv',NULL,NULL,1,'',1,NULL,NULL),(6,0,0,'Many','Device 2','4386e2c4d5102c7418009d088ecf22cd92ea71e3',NULL,'manydevice2@dummy.inv',NULL,NULL,1,'',1,NULL,NULL),(7,0,1,'Many','Device 1','d26e8d501d4d11be24b04bf080914e0644a69615',NULL,'ryan+manydevice1@asdfsa.inv',NULL,NULL,1,'',1,'2011-02-02 01:53:18','2011-02-02 01:52:46'),(8,0,1,'Many','Device 2','9008d5da4e8ebbe7c059739b50f44733af35de1c',NULL,'ryan+manydevice2@asdfsa.inv',NULL,NULL,1,'',1,'2011-02-02 01:55:15','2011-02-02 01:54:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-02-12  0:13:21
