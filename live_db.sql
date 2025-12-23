-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: guppies
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add customer',7,'add_customer'),(26,'Can change customer',7,'change_customer'),(27,'Can delete customer',7,'delete_customer'),(28,'Can view customer',7,'view_customer'),(29,'Can add order',8,'add_order'),(30,'Can change order',8,'change_order'),(31,'Can delete order',8,'delete_order'),(32,'Can view order',8,'view_order'),(33,'Can add product',9,'add_product'),(34,'Can change product',9,'change_product'),(35,'Can delete product',9,'delete_product'),(36,'Can view product',9,'view_product'),(37,'Can add shipping address',10,'add_shippingaddress'),(38,'Can change shipping address',10,'change_shippingaddress'),(39,'Can delete shipping address',10,'delete_shippingaddress'),(40,'Can view shipping address',10,'view_shippingaddress'),(41,'Can add order item',11,'add_orderitem'),(42,'Can change order item',11,'change_orderitem'),(43,'Can delete order item',11,'delete_orderitem'),(44,'Can view order item',11,'view_orderitem'),(45,'Can add category',12,'add_category'),(46,'Can change category',12,'change_category'),(47,'Can delete category',12,'delete_category'),(48,'Can view category',12,'view_category'),(49,'Can add purchase history',13,'add_purchasehistory'),(50,'Can change purchase history',13,'change_purchasehistory'),(51,'Can delete purchase history',13,'delete_purchasehistory'),(52,'Can view purchase history',13,'view_purchasehistory'),(53,'Can add wishlist',14,'add_wishlist'),(54,'Can change wishlist',14,'change_wishlist'),(55,'Can delete wishlist',14,'delete_wishlist'),(56,'Can view wishlist',14,'view_wishlist'),(57,'Can add shipping rate',15,'add_shippingrate'),(58,'Can change shipping rate',15,'change_shippingrate'),(59,'Can delete shipping rate',15,'delete_shippingrate'),(60,'Can view shipping rate',15,'view_shippingrate'),(61,'Can add payment record',16,'add_paymentrecord'),(62,'Can change payment record',16,'change_paymentrecord'),(63,'Can delete payment record',16,'delete_paymentrecord'),(64,'Can view payment record',16,'view_paymentrecord');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (2,'pbkdf2_sha256$600000$TfZQjYq2UVxSTr7N46gTOL$d9ahspvzEyZNk1BBSFxcvirL8aSox4O25DBoP/LXZTo=','2025-12-20 08:51:26.790121',1,'Admin','','','Salman@gmai.com',1,1,'2025-11-03 21:28:15.031888'),(3,'!98dK6GOrEJrIRfTlgFDNloswxXuk94tcQGFRYTCh','2025-11-10 11:45:03.662780',0,'UserTwo_XViPpE','','','',0,1,'2025-11-04 07:32:03.113820'),(4,'!TcgMnjdu5gHxWR2P45TVTRQDP9QnvS4PcPZdUPNj','2025-11-04 17:38:21.045967',0,'sonjoe_OrI54M','','','',0,1,'2025-11-04 17:38:20.969124'),(5,'!9tNnFqLcF1htQKpRop21VyxAqEEJTIzgdZpPs3Gn','2025-11-07 12:54:44.394489',0,'abcd_x0Qak3','','','',0,1,'2025-11-07 12:54:44.364459'),(6,'!GsaZNL4Kr6KcqAkYesE0Bcz0LWLI3qTgTQ0Qbaaz','2025-11-10 11:30:40.779171',0,'mujthaba_6TetGs','','','',0,1,'2025-11-10 11:30:40.661378'),(7,'!ZrYlvNqLkBnAECe97j0VCdLyYJf0S94UnJjfFyjq','2025-11-12 14:08:11.711884',0,'asepganteng_SrSLTs','','','',0,1,'2025-11-12 14:08:11.603637'),(8,'!4RzPpjlxT1O6u1Q1XDeK6xckW2ehwyqebENV7kk0','2025-11-13 18:48:40.161425',0,'Christopher_qBjPcc','','','',0,1,'2025-11-13 18:48:40.079643'),(9,'!6zOhdI4C1J1R4kCLzBDPcB8eZsW65RtGbIlA5qaj','2025-11-16 03:57:42.049121',0,'msathish_4B6A9l','','','',0,1,'2025-11-16 03:57:41.959451'),(10,'!L7HVzarBZ60UXUYqoJdEtMTEzfRf8FtsGr2rrxle','2025-11-20 15:22:15.212979',0,'DekaJ_nnOM1H','','','',0,1,'2025-11-20 15:22:15.105374'),(11,'!c4sgaqE0SMNJYk2vsYNIuhtgu4RfFXYePbViPpsH','2025-11-21 05:39:00.846543',0,'test_VKfhW9','','','',0,1,'2025-11-21 05:39:00.728659'),(12,'!4ix9SgZxq4arQ6GQknnFGa5ccqpLejNCfAvgqeV5','2025-12-01 10:38:04.419220',0,'Chaitanya_FmryIu','','','',0,1,'2025-12-01 10:38:04.315458'),(13,'!DfMGSmEgmhqtkz8p8Ic8Qpr6jVXXZUI1dgoH9EPG','2025-12-02 15:49:26.171748',0,'Maqswood_sZcW9I','','','',0,1,'2025-12-02 15:49:26.076825'),(14,'!vAQvbhaVMFGJRd4aWbJ8tYm59mTGihnssqE28sT2','2025-12-05 02:21:27.215618',0,'Yashwanth_oZJcuR','','','',0,1,'2025-12-05 02:21:27.116987'),(15,'!kmu6lw6bJQkEL5ShRlqGntwyCXkDLAAMeqxhSXPB','2025-12-12 18:56:22.871745',0,'muhammedharis_5JD4bT','','','',0,1,'2025-12-12 18:56:22.774424'),(16,'!tOitOZbbapnnVdyqBzufNS4BkKFdkzQuUscleq8e','2025-12-16 07:41:22.243350',0,'Nnnhhjhjjk_lnXQNO','','','',0,1,'2025-12-16 07:41:22.168225'),(17,'!eRQ7RbwIhwIEJlbuPDV2U0up9xhezSFAgayaMzWF','2025-12-16 14:05:53.467009',0,'Shabeer_rq805D','','','',0,1,'2025-12-16 14:05:53.373159'),(18,'!82PuO7jZTJ7bO9Q4K7KOAibtTGeQIQTrbUnFNjwR','2025-12-22 04:39:34.401975',0,'Shijiluser_9IrGLV','','','',0,1,'2025-12-21 06:07:41.145569'),(19,'!vmmQtuMGbRFqfOq3Ihn4Ms5B4phSZxhS2Oj902lW','2025-12-21 16:28:13.407934',0,'newtest_bul1bj','','','',0,1,'2025-12-21 16:28:13.337563');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session'),(12,'store','category'),(7,'store','customer'),(8,'store','order'),(11,'store','orderitem'),(16,'store','paymentrecord'),(9,'store','product'),(13,'store','purchasehistory'),(10,'store','shippingaddress'),(15,'store','shippingrate'),(14,'store','wishlist');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-11-03 17:27:04.293154'),(2,'auth','0001_initial','2025-11-03 17:27:04.957041'),(3,'admin','0001_initial','2025-11-03 17:27:05.125559'),(4,'admin','0002_logentry_remove_auto_add','2025-11-03 17:27:05.135023'),(5,'admin','0003_logentry_add_action_flag_choices','2025-11-03 17:27:05.145438'),(6,'contenttypes','0002_remove_content_type_name','2025-11-03 17:27:05.262598'),(7,'auth','0002_alter_permission_name_max_length','2025-11-03 17:27:05.338440'),(8,'auth','0003_alter_user_email_max_length','2025-11-03 17:27:05.363952'),(9,'auth','0004_alter_user_username_opts','2025-11-03 17:27:05.371816'),(10,'auth','0005_alter_user_last_login_null','2025-11-03 17:27:05.432327'),(11,'auth','0006_require_contenttypes_0002','2025-11-03 17:27:05.436002'),(12,'auth','0007_alter_validators_add_error_messages','2025-11-03 17:27:05.445169'),(13,'auth','0008_alter_user_username_max_length','2025-11-03 17:27:05.517149'),(14,'auth','0009_alter_user_last_name_max_length','2025-11-03 17:27:05.582401'),(15,'auth','0010_alter_group_name_max_length','2025-11-03 17:27:05.600824'),(16,'auth','0011_update_proxy_permissions','2025-11-03 17:27:05.612037'),(17,'auth','0012_alter_user_first_name_max_length','2025-11-03 17:27:05.676588'),(18,'sessions','0001_initial','2025-11-03 17:27:05.716409'),(19,'store','0001_initial','2025-11-03 17:27:06.094539'),(20,'store','0002_customer_number_alter_customer_id_alter_order_id_and_more','2025-11-03 17:27:07.068563'),(21,'store','0003_alter_customer_user','2025-11-03 17:27:07.206420'),(22,'store','0004_alter_customer_user','2025-11-03 17:27:07.330996'),(23,'store','0005_alter_customer_number','2025-11-03 17:27:07.360130'),(24,'store','0006_alter_order_customer','2025-11-03 17:27:07.506572'),(25,'store','0007_rename_customer_order_justuser','2025-11-03 17:27:07.599495'),(26,'store','0008_alter_customer_name','2025-11-03 17:27:07.669858'),(27,'store','0009_remove_order_justuser_order_customer_and_more','2025-11-03 17:27:07.839536'),(28,'store','0010_remove_customer_number_shippingaddress_number','2025-11-03 17:27:07.950197'),(29,'store','0011_category_alter_product_options_remove_product_image_and_more','2025-11-03 17:27:08.885232'),(30,'store','0012_remove_product_digital','2025-11-03 17:27:08.946302'),(31,'store','0013_alter_product_old_price','2025-11-03 17:27:09.013960'),(32,'store','0014_order_status_orderitem_price_at_purchase_and_more','2025-11-03 17:27:09.261825'),(33,'store','0015_rename_date_purchased_purchasehistory_date_added_and_more','2025-11-03 17:27:09.294032'),(34,'store','0016_order_delivered_time_order_processing_time_and_more','2025-11-03 17:27:09.436881'),(35,'store','0017_customer_default_address_customer_default_city_and_more','2025-11-03 17:27:09.705537'),(36,'store','0018_remove_customer_default_address_and_more','2025-11-03 17:27:09.957031'),(37,'store','0019_shippingaddress_whatsapp','2025-11-03 17:27:10.022200'),(38,'store','0020_rename_available_product_active','2025-11-03 17:27:10.053463'),(39,'store','0021_alter_product_category','2025-11-03 17:27:10.066607'),(40,'store','0022_remove_customer_email_customer_contact_number_and_more','2025-11-03 17:27:10.332162'),(41,'store','0023_remove_customer_email','2025-11-03 17:27:10.381002'),(42,'store','0024_introimage','2025-11-03 17:27:10.399294'),(43,'store','0025_wishlist','2025-11-03 17:27:10.525155'),(44,'store','0026_delete_introimage_product_status','2025-11-03 17:27:10.591606'),(45,'store','0027_alter_order_status','2025-11-03 17:27:10.602703'),(46,'store','0028_order_confirmed_time','2025-11-03 17:27:10.649008'),(47,'store','0029_alter_product_old_price','2025-11-03 17:27:10.658197'),(48,'store','0030_alter_product_old_price','2025-11-03 17:27:10.664387'),(49,'store','0031_alter_orderitem_price_at_purchase_and_more','2025-11-03 17:27:10.887391'),(50,'store','0032_shippingrate','2025-11-03 17:27:10.910298'),(51,'store','0033_product_priority','2025-11-03 17:27:10.973022'),(52,'store','0034_alter_product_options_alter_product_priority','2025-11-03 17:27:10.986181'),(53,'store','0035_alter_category_options_category_priority','2025-11-03 17:27:11.042591'),(54,'store','0036_alter_category_options_and_more','2025-11-03 17:27:11.237847'),(55,'store','0037_remove_purchasehistory_discounted_price_at_purchase_and_more','2025-11-03 17:27:11.463211'),(56,'store','0038_remove_order_transaction_id_and_more','2025-11-03 17:27:11.551167'),(57,'store','0039_add_order_id_field','2025-11-03 17:27:11.708217'),(58,'store','0040_populate_order_id','2025-11-03 17:27:11.727503'),(59,'store','0041_finalize_order_id_field','2025-11-03 17:27:11.833230'),(60,'store','0042_order_order_created_order_payment_status','2025-11-03 17:27:11.969887'),(61,'store','0043_order_total_price','2025-11-03 17:27:12.033934'),(62,'store','0044_remove_order_razorpay_signature_and_more','2025-11-03 17:27:12.176240'),(63,'store','0045_alter_order_shipping_charge','2025-11-03 17:27:12.186446'),(64,'store','0046_alter_order_payment_status','2025-11-03 17:27:12.196877'),(65,'store','0047_alter_order_payment_status','2025-11-03 17:27:12.205178'),(66,'store','0048_paymenthistory','2025-11-03 17:27:12.342432'),(67,'store','0049_paymentrecord_alter_order_payment_status_and_more','2025-11-03 17:27:12.447645'),(68,'store','0050_remove_order_payment_status_and_more','2025-11-03 17:27:12.597746'),(69,'store','0051_alter_shippingaddress_order_and_more','2025-11-03 17:27:12.626481'),(70,'store','0052_rename_processing_time_order_received_time_and_more','2025-11-03 17:27:12.658784'),(71,'store','0053_rename_received_time_order_placed_time_and_more','2025-11-03 17:27:12.696299'),(72,'store','0054_rename_complete_order_payment_success_and_more','2025-11-03 17:27:12.726518'),(73,'store','0055_product_age_product_size_and_more','2025-11-03 17:27:12.853403'),(74,'store','0056_order_courier_partner_order_tracking_id','2025-11-03 17:27:12.943898');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('14wyow6jkkfxn7hfzu9smgn14hflmr1q','.eJxVkMtugzAQRX8FuVuEHAwmZNkuumnV_gEaP8AOYCw_VNEo_95ByiJdWT5z58xobmSAnMyQow6DVeRCelI-MwFy1u4oqCu4aavk5lKwojoi1aMaq89N6eX1kf0nMBDNodW1pIydRcO5HDsOqhFU6JZyIU9MSdaLceyUbgHfuuvajo-Mivqs-hPTvEFpNNZ766bBunEjlxtxeRU6oJz2XU_PTU-bGnM_BlIE74-pzxyUCjpGxN_LlooXXhYfMEez2uIdHHhIZi8cTBDKYoaAyPqssjQ6hL0scsDIPMOKKmnTjp43o90EC3amfCyYIGnEXwlb8P9rvcS7IOGU1bQm9_sfamx3dw:1vKTwa:1dkuGZ_OwstkFUs1oS5aIExCGo6vs9deqfXcaNalv6Q','2025-11-30 04:00:52.075828'),('1knlwmh3alvv71jm2rsn28874tf8f2hz','.eJxVj01uwyAQRu_COrIMDj_Ospuu2h7BGsNgcBOwDFbVRrl7BymLVsyGNx9vhjub4KhhOgruU3Tswrhip79wBvuJqXXcCmnJnc2p7nHuWqR7dkv3lh1eX57Zf4IAJdDrMwqHrkc9IorRu1HrXnlwXElrZ-DSaS96kF5bNeOIYIdROcH9wNEqPpC0hLhtMS1TTD6zy52l4zbjTnJzlsJoaWRb_itALbBtjSs6UpnBEAfndiyF8HtKMacYwmHWFBPd1lZrpKKgjfWbUq_5Cgu52uQKFQl91EDzTuwnbpY-TESTXnD2ePwCCn9rXg:1vVPh3:5cUpwQ2lTRU8H2bqmHM0X1A-2akjPaDuSKGyxnTB1R0','2025-12-30 07:42:01.594107'),('4tc3ybyl16nrehbqeoqwul78ytajfhks','.eJxVjTsOwjAQRO_iGlmO_0tJnzNYa6-NA8iR4qRC3J1ESgHtvDczbxZwW2vYel7CROzKNLv8ZhHTM7cD0APbfeZpbusyRX4o_KSdjzPl1-10_wYq9rq3k9ADIBQRlY6etBQZrDIgiiMCXZQFWZzLKDX6Qug8mMH6_QBNVBbZ5wvZLDfn:1vGKz7:FelBhiguNZhbEBPP_KbILdRkDaraoR7UtydZIFNVwJc','2025-11-18 17:38:21.075200'),('8b2unbom8djcj6oc0m4l9kyv5umaehu5','.eJxVjMEOwiAQRP-FsyEIKQWP3v0GssvuStXQpLQn479Lkx70MpnMm5m3SrCtJW2NlzSRuiinTr8ZQn5y3QE9oN5nnee6LhPqvaIP2vRtJn5dj-7fQYFW-jpnYxAknykwy4hEgJYFRiCJ1jtjQiSHgt2z8VlgCN6hEzvErqw-Xzm_Oak:1vIQKV:0Xp44EK5_uZyucG65RDNtlnOcaG6ZKxIUvhy1BY3ecc','2025-11-24 11:45:03.671488'),('8kv6lkpqsetjmrjaj69scaf1gmgpmmxl','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vTKFT:Djwvj5FbHXZ547-hzqzaQGRnYOh86UD-ogOnz4NCykw','2025-12-24 13:28:55.366285'),('99fm9w6yt6y4o1ncjtlwfan23tjcs82i','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vNxPZ:aClrv4JFAJQCJ2LTp5EInuFlJo-WmI348mI4a0ML9i4','2025-12-09 18:05:09.545982'),('9nnkqgklcx3h8jtais11x67zk9tkmwsp','.eJxdj8FuwyAMhl9l4jxFQAOhPfY67RkiA6bQtQQBUdVVffc5Ug_bjv78-7P9YDOsPc5rwzonzw5MGPb-G1pwX5i3jj9DPi2DW3KvyQ5bZHh12_C5eLwcX9k_gggt0rQLQuyC57CfJhcmra3zXMDIwQoAuUNlOAaNDoW1PqhRCSPQS6VGaa2RJG0xlZLyaU45LOzwYHm9Wqwk3ystudFKb8ffIvQGpfzn4H3F1gh3bP2NSkHUpX4ndIV8xpq2LR06EvnAChcg8J2Ko-8IGdKNgj2fP5VVYsk:1vXXiY:9f_38M3i8Zc3o7xo1EjDiVPB2N-FyljQ1H637Tx1E-I','2026-01-05 04:40:22.096495'),('aowgyvz0jm4era8qjlpsam64nl49sjmg','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vHLhq:S7NWyxBGCX1rpcubLQduFG4i580Sfxv_3JfkeL19T6o','2025-11-21 12:36:42.257234'),('dkgfhc3l8ntibk05twq2obtq1kd40fyn','.eJxVjMsOwiAQRf-FtSFDeBRcuvcbyDADUjWQlHZl_Hdt0oVu7znnvkTEba1xG3mJM4uzmMTpd0tIj9x2wHdsty6pt3WZk9wVedAhr53z83K4fwcVR_3WzvqSLLgJvCOvMRUOJXAGHZTSgIqCLqGw4QRFowXKPulgwRhyBEq8P-RjN9Y:1vJBW7:FUyjLF_oGSvAwwYUJ5HDwleO2UaOoIQQSeG7batSTpk','2025-11-26 14:08:11.736115'),('i6jrwsa7zy494pmlfv6uyi4w7spc063i','.eJxdj0FvAiEQhf-K4Ww2wC4seuy18db7ZoBBUMsSYGPU-N9lE5u0Pb7vvXkz8yATLNVPS8E8BUv2hCmy_Q01mDPG1bEniMe5M3OsOehujXRvt3SH2eLl4539U-Ch-DZtHGO9sxR242jcKKU2ljIYKGgGwHsUiqKTaJBpbZ0YBFMMLRdi4For3kqLDymFeJxCdDPZP0hcvjXmVr4TklMlhVyPv3qoBVL6z8HajKU0_IWlbn7klphQb40eIJ5wXVOhYtOfmOECDdxDMu29huQoGe_J8_kCBEtjOQ:1vXCj8:RR0O3lPS37GPoDO2mYTp8vswOTyTdjRp56t2GwOBWII','2026-01-04 06:15:34.753305'),('j26odwjswi7cl3y0tz24ap35zs613to1','.eJxlkMtuwyAQRX8FsbYsYmpsZ5l9lP6BNbwCtQ0W4FRplH_vuMqiVTcI3cfR1TzoCFtx45ZNGr2mR8pp9VuToCYTdkN_QLjGWsVQkpf1Hqlfbq7PUZv59Mr-ATjIDttKMSbBqoPujbGd1BpkYyx0oO3QCM5YP2gurcS_YUJZaHvBJbdNO-BrEJqdX1cfrqMPNtLjg4ZtkSYhnHUMY6I5dC3mPh2UDOv6zwCtk8kZ9TMkKA6mKWoIxEVcWpGbn-HuZ_JOLqQiC4QJNNw2LCpf7j-tGbFbgmVfU6AYFC_F4YaKfvlV4RFQER0Xby19Pr8BncNxSw:1vGDOQ:qAOG_ox4sqEtHN-LL7GfR77P2uUyQC-yisbXxLaU2eo','2025-11-18 09:31:58.978850'),('jdmtjchp82in7hfni7ed8ugzw6ljc9ev','.eJxVj81uwyAQhF8l4tRKkeWfxcY59l71EawF1oE6AQQ4VRvl3QtSDq329s3s7M6dLbhns-yJ4mI1OzHOjn-ZRLWRq4L-RHf2jfIuRyubammeamrevabL29P7L8BgMmV77JUcqO-7sUUQHOSMMK-T6ABIA2gcegntLKZW8W4iwVsuRafaFTUoNdTQZGwI1p0X61bPTnfm9qukWMJnwcUMfOzr818Gc8IQKueCT4WXKQJqHSmlwjfvLz5uu3P74cW8HkjfQsTzuhaXsvm7WEjjDZ3DgBHr7YyZCv7Iplw8sh8bVKlci03DCJw9Hr8TlGmE:1vHM1B:MuaCxwWqmUa9Bzth3QIwgLZOH-OYmfsSoP8QxcQFVRo','2025-11-21 12:56:41.399329'),('jylfmgvp9fevvf70oksz4rn4zh7jpl46','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vG2Ng:b1ax1W1vNVPOZ0jzRBSYnF74CKXXIJAmWoapdcQoSBI','2025-11-17 21:46:28.850816'),('k6rr4rpp8qavdni2akn7686zk0b1ex3i','.eJxdj8tuwyAQRX-lYh1ZBmKDvUu7rvoJ1vAKNDFGgFWlUf69g5RF2-05d-7M3MkCe_XLXmxegiEzYeTwmynQFxubMJ8Qz1unt1hzUF2LdE9buvfN2OvrM_unwEPxOK3AMMGkAKBM9cLoYRDy2Ds6KUudUcB7xjiwCY7DxKl0zo1OMUtprzQd2lXFh5RCPC8huo3MdxL3VdmM5XIcBReCc4mxLw-1QEr_ORiTbSmI33zIcAvrCtcXFDrUG9JTtvaCb7RNFapF9FE99h_Id0i6mZlg38gn8nj8AAUyYx8:1vHMnT:vNNtDhy38EsJOoGKZvaF_Vd_ga7oLoFXIdjrimpjnUk','2025-11-21 13:46:35.155897'),('kehalk7kavbsrj3s4mf1ttw4p72kkf8l','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vIQE6:uqgYNpEH-nmQJ69J2vgrrhfzAOxYthTnXWxYIgOoGl0','2025-11-24 11:38:26.265638'),('ligxt91if6r72zjwaf07ilxj4bl00rpe','.eJxdkE1uwyAQRq9isa4siMGQ7JJt1U16AGtgcKB1sQVYVRLl7h1LWbTdvnnzzc-dDbDWMKzF5yEiOzDRsZff0IL79Gmr4Aeky9y6OdUcbbsp7bNa2rcZ_XR6un8CApRA3do4BcbyUXPZj1YJNxoUnRJG77nWqCwKz8Wutw56jV6Q2nEpexxRSc4ptIS4LDFdhpjGmR3uLK1f1mcK50rwvTBcGtK-A9QCy_KfA2L2pRB-n2k7n1NzprTmlCG50Jy3vV2sVxKOU3O8xVu8QtjmVqie6KvPMAGBW1wc3bt9SyqxY4_HD57wZ5Q:1vQSdJ:OEydFkuD7LL9dODJsd4Rvb_2KUY1030tvXCNXm5a-mA','2025-12-16 15:49:41.994467'),('nj9smglpi7wo0ml6tyd6mhvxnx6vjz3n','.eJxVjMsOwiAQRf-FtSE8ZXDpvt9ABhikaiAp7cr479qkC93ec859sYDbWsM2aAlzZhcmHTv9jhHTg9pO8h3brfPU27rMke8KP-jgU8_0vB7u30HFUb-1sj4nLwyBF15LrTFKcj4pawQ4QGdUilELaQGLBxNzIZPwrJTQJYNj7w_nSDeA:1vVVgX:25m5fFNrI68YLYfHmJD-fMfqTVUwIEEYa9HZTLvRmWU','2025-12-30 14:05:53.523101'),('palv5z4m5r7qg6we8x93218uwkwmseio','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vLaBU:NoOyIk9rsuy6uDtX58kf_nHn23ecJEgrDoV95u4e51o','2025-12-03 04:52:48.894411'),('qkl8mfrbwyx7tpknko5pnwigu4cmpeqe','.eJxVjMsOwiAQRf-FtSHDo8C4dO83kGGgUjU0Ke3K-O_apAvd3nPOfYlI21rj1ssSpyzOQmlx-h0T8aO0neQ7tdsseW7rMiW5K_KgXV7nXJ6Xw_07qNTrt9ZsoSSLVgOhwYHdgCP4xFzQeQcex2CUAxWUZUgEzlsDqJhDNtYk8f4A4QQ24g:1vQ1IC:5NMrOkB6Qiw2QwtxnKG19BVShWKV17UlqXps4i3WZPw','2025-12-15 10:38:04.484293'),('ru3v6cwfs0gkaszfr3jvo2kaoitnb8kl','.eJxdj8tOwzAQRX8l8rqKxrXTOF2yYoP4hGj8SG0ItmU7oFL135lIXQDbc8887o3NuDU_b9WVOVh2ZoodfjON5t3FPbBvGC-pNym2EnS_K_0jrf1Lsm59erh_FnisnqadmpQAnLSSwAUXArgZDJ-OSkqDBkEvHAAsl-NwBLOAM6ClOAnlRjHq_avqQ84hXuYQl8TONxa3D-3K_jMMoOQE8kTal8dWMef_HK0trlbCGdcrdiWh7Q7RYemaL6FuK3akmdCu5DynGPGTsv1ww-aIvTZP5w7sO2RDfYkMippIdr__ADJQZwM:1vJcPv:8Rp3VmtqenwnYBgnfgXVzbIqlOaKfLxRIjIfp-8A4zA','2025-11-27 18:51:35.016966'),('s1ynmf02dmokpn2cf5o81ne1kin8sb6m','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vTDlJ:ew9Tg_-xZjvRAM30vvyiRNyEIDzntEG5YBL8V1KDYDY','2025-12-24 06:33:21.770926'),('shopxknu8jjweakafnkp1grg8s7i9ecs','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vWsgQ:Yj8sWs0QWmnhK7Eu_MfSIkyIPg32AxzuCMwguzj6Vmk','2026-01-03 08:51:26.810551'),('toznmjy7tulmz2in4xyrv1f8ixspkljw','.eJxVjMsOwiAQRf-FtSHMUARcuu83NDM8pGogKe3K-O_apAvd3nPOfYmJtrVMW0_LNEdxEShOvxtTeKS6g3inemsytLouM8tdkQftcmwxPa-H-3dQqJdvzRTRorNEgKxsDMZYN6gMnhPkyKQVoib0NBivweWcz5kxASgOYFC8P-g0N-E:1vU8PS:aRYaAx2xLTCiAHBaBCsCT4aEtAnvvUt2LecC1CIZ42w','2025-12-26 19:02:34.561394'),('uz6m995pb3wj7gxmhl6jnu3invfe3pn2','.eJxdj7FuwyAQhl8lYq4sA7GxvbWdk6m7dcARaGyMAKtKo7x7QcrQdv2-__67u5MZ9mznPWGcnSYTYeTlN5Ogruir0J_gL1ujNp-jk02NNE-bmtOmcXl7Zv8UWEi2TEvQTLBBAFAmW6FV14nh2Bo6SqRGS-AtYxzYCMdu5HQwxvRGMqS0lYp29apkXQjOX2bnzUamO_H7KjGW8qHvBReC86HEvizkBCH856B1xJQKfrcuws2tKyyHIpTLt0JfI-K1vFE3ZchY0AesbjmcQe8Ffrugqp5IKe35SB6PH_0XZLw:1vNycK:0veTKT2kg--CzhvMR5WOxDjXXxY9iQxPvmJq5eE0bEM','2025-12-09 19:22:24.271961'),('v8yumn4h0h19vso2hej2mqk51wjyz1j1','.eJxVjMsOwiAUBf-FtSFSHgWX7vsN5D5AqgaS0q6M_65NutDtmZnzEhG2tcStpyXOLC5CGXH6HRHokepO-A711iS1ui4zyl2RB-1yapye18P9OyjQy7fG7EDz6JMDz9oHaywCOiRNKpBSIYHOWZmRIfAZrWaVaTA2oONgaRDvDymaOMw:1vRLRn:PED2yXOwD82nezkauF1FDcsDttZlQNNpW4Mcw4qPw1I','2025-12-19 02:21:27.280784'),('xvbk0do211g8uuavhwdavm5732s1yjx2','.eJxVjEsOwiAUAO_C2hDg8XXpvmcg8HiVqqFJaVfGuxuSLnQ7M5k3i-nYazw6bXEp7MqkYJdfmBM-qQ1THqndV45r27cl85Hw03Y-rYVet7P9G9TU6_hahGQgYxDofJFFeZICnAWhpNXCWFQZHOUZZhGcRlIpBDBOGo9Emn2-5SE3PQ:1vM6UB:2jNgDD00Pxzn7qpCiVhz9QTMmF2olq0wBuvVlJdf4v0','2025-12-04 15:22:15.248226'),('y8fhf8opyt4yl6upf8zmp0p858tts3a4','.eJxdT0FuxCAM_AvnVUQgwGaPva_6hMhgCNCWRIGoalf79zpSDm3tg-2Z8Vh-sAn2Fqe9-m1KyG6s79nlN2jBvflyMJihzEvnltK2ZLtD0p1s7e4L-veXU_vHIEKNtG2CUBbRWTcGroEPaLkJUukBcAQuhETXU-2VR-0lNTpwI60Vqh-UlWRaY1rXVOYplbCw24OV_cP6jcxHzZUcJb8Kkn1GaBXW9T8OiJuvleDma4szZZ5zjpk4l9rXSRyHGjRP42uLZH9h32l19B8h2pgrBXs-fwBrc2O3:1vMJvI:I6uuuISU6Wrr5_eV6W383MizhfH4AAg6YdkzVy6647s','2025-12-05 05:43:08.119357'),('zq0yfg2fq3n616t8s9pmphelf2prsuwj','.eJxlj7tuwzAMRX-l0FwYetiWlS1di3yDQUt0pDqRDUlGkAb591JAhhYduJxzeUE-2Ah78eOeMY3BsQMTHXv_DSewC8Zq3BfE89rYNZYUpqZGmpfNzWl1ePl4Zf8UeMi-9oLkeubCoRAz153iUirTI4oBUIEyuu2cFO2gzaQkci0El7qVmveDNSCoNPuwbSGexxDnlR0eLO7XCROV84EPvaFpDeVuHkqGbfsnwLmEORM_JsSFTn47wYWSe4IreRvKneQnZr_WL3KBghVAilBgAWLfYbO0SFT1UkrOns8fWNZlUg:1vU8N2:rTO2TdppTNTc6lGtnjyUFWiK4aq2xy6l8uS5C6KsDCc','2025-12-26 19:00:04.809779'),('zt6eylsa839o7mrlq5crmilm26voob6t','.eJxdkN1qwzAMhV8l-HqE2KmdtHfd7eheIci2UtvtnOAfSlf67lOgF9tupMN3pIPQg01Qi5tqxjR5yw6Mj-ztN9RgLhg3xwaI56U1SyzJ63YbaV9ubk-Lxev7a_ZPgIPsaNvMnPez7WA_DGYelNLGdhx2HWgOIHqUY4ezQoNcazvLneQjRyuk3AmtR0Gh2fl19fE8-Tgv7PBgsX5pTBS-l0p0o5JqO_7moGRY1_8crE2YM-HPkpqjaGLMusnObfXuSGBT0YWAgUTI4UKtZhLhFqiSnatH8inM-HKnpBPEgMlvxxUoSOQDE1yBwLdfDT2FkBoUFz17Pn8A5Wx3og:1vXMbL:uYI19c2IUCpozehGVkIvkmvaEcU2sliOp_nu-Ek4kaQ','2026-01-04 16:48:11.982375');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_category`
--

DROP TABLE IF EXISTS `store_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_category`
--

LOCK TABLES `store_category` WRITE;
/*!40000 ALTER TABLE `store_category` DISABLE KEYS */;
INSERT INTO `store_category` VALUES (1,'Guppies','guppies','category/4b9879c8-e1ce-4e1c-8309-603087507e92.png',0),(2,'Bettas','bettas','category/2c9353f6-e9b1-4e9b-95d8-bd5d6ca2103d.png',1),(3,'Other fishes','other-fishes','category/b8bdb3f4-063c-4063-b34b-7f3416662a66.png',2),(4,'Water Plants','water-plants','category/0e232e69-8303-4830-b268-8726e76efa96.png',5),(5,'Feeds','feeds','category/2e733ba8-c98e-4c98-9060-d1065c5f1ed1.png',3),(6,'Accessories','accessories','category/500e4001-c3ca-4c3c-88c0-3c8cef46a77e.png',4);
/*!40000 ALTER TABLE `store_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_customer`
--

DROP TABLE IF EXISTS `store_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int NOT NULL,
  `contact_number` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `store_customer_user_id_04276401_uniq` (`user_id`),
  UNIQUE KEY `contact_number` (`contact_number`),
  CONSTRAINT `store_customer_user_id_04276401_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_customer`
--

LOCK TABLES `store_customer` WRITE;
/*!40000 ALTER TABLE `store_customer` DISABLE KEYS */;
INSERT INTO `store_customer` VALUES (1,'Admin',2,'1234567890'),(2,'UserTwo',3,'7025962172'),(3,'sonjoe',4,'9497282865'),(4,'abcd',5,'8759658515'),(5,'mujthaba',6,'7025962175'),(6,'asepganteng',7,'065452654556'),(7,'Christopher',8,'8050849046'),(8,'msathish',9,'9790849042'),(9,'DekaJ',10,'9643216901'),(10,'test',11,'9605393082'),(11,'Chaitanya',12,'9533441685'),(12,'Maqswood',13,'8129599577'),(13,'Yashwanth',14,'6369774332'),(14,'muhammedharis',15,'8086908649'),(15,'Nnnhhjhjjk',16,'7877878787'),(16,'Shabeer',17,'8590339493'),(17,'Shijiluser',18,'9562086568'),(18,'newtest',19,'7428730894');
/*!40000 ALTER TABLE `store_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_order`
--

DROP TABLE IF EXISTS `store_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date_ordered` datetime(6) NOT NULL,
  `payment_success` tinyint(1) NOT NULL,
  `customer_id` bigint DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivered_time` datetime(6) DEFAULT NULL,
  `placed_time` datetime(6) DEFAULT NULL,
  `shipped_time` datetime(6) DEFAULT NULL,
  `confirmed_time` datetime(6) DEFAULT NULL,
  `order_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_created` tinyint(1) NOT NULL,
  `total_price` decimal(7,0) DEFAULT NULL,
  `Shipping_charge` decimal(7,0) NOT NULL,
  `courier_partner` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `store_order_customer_id_13d6d43e_fk_store_customer_id` (`customer_id`),
  CONSTRAINT `store_order_customer_id_13d6d43e_fk_store_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `store_customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_order`
--

LOCK TABLES `store_order` WRITE;
/*!40000 ALTER TABLE `store_order` DISABLE KEYS */;
INSERT INTO `store_order` VALUES (1,'2025-11-03 21:36:45.536578',1,1,'Order Confirmed',NULL,'2025-11-07 13:47:12.166946',NULL,'2025-11-25 18:28:38.340834','2cd3b03b-e9c3-4763-8c71-ae518e89aac8',1,1500,300,NULL,NULL),(2,'2025-11-04 07:32:03.573146',1,2,'Product Shipped',NULL,'2025-11-04 09:32:58.903727','2025-11-10 11:44:23.862720','2025-11-10 11:43:10.947227','40a491e6-20f6-4df5-8ed3-6cc422bbaeee',1,460,180,'DTDC','R65983728'),(3,'2025-11-04 09:33:01.140321',0,2,'Order Abandoned',NULL,NULL,NULL,NULL,'a13129f3-881e-4545-a8e5-dce87f44144d',0,NULL,0,NULL,NULL),(4,'2025-11-04 17:38:21.247817',0,3,'Order Abandoned',NULL,NULL,NULL,NULL,'8b743f7b-c08b-4266-baa3-6ca883077422',0,NULL,0,NULL,NULL),(5,'2025-11-07 12:54:44.404960',1,4,'Product Shipped',NULL,'2025-11-07 12:58:05.500598','2025-11-07 13:04:35.992715','2025-11-07 13:03:36.627776','5afb38e3-8db6-44aa-8571-32d97408a7c9',1,800,220,'Delhivery','2245357568679'),(6,'2025-11-07 12:58:11.338539',0,4,'Order Abandoned',NULL,NULL,NULL,NULL,'c0022cac-8130-4b5c-ac9a-d7552d56b68d',0,NULL,0,NULL,NULL),(7,'2025-11-07 13:47:54.906709',1,1,'Order Placed',NULL,'2025-11-25 19:17:30.286735',NULL,NULL,'cbbd6967-daa0-4071-939f-f3a845d152f5',1,3030,500,NULL,NULL),(8,'2025-11-10 11:30:41.057540',1,5,'Product Shipped',NULL,'2025-11-10 11:36:41.851673','2025-11-10 11:42:29.351596','2025-11-10 11:42:19.553172','7ee4004e-1162-4e06-bca9-2e39403409e8',1,800,220,'',''),(9,'2025-11-10 11:36:44.282411',0,5,'Order Abandoned',NULL,NULL,NULL,NULL,'5aa76f90-f4c1-4d5a-ac24-5ccf7266a6d2',0,NULL,0,NULL,NULL),(10,'2025-11-12 14:08:11.912781',0,6,'Order Abandoned',NULL,NULL,NULL,NULL,'0f1d0678-2ed8-4757-9bf4-9042c9509307',0,NULL,0,NULL,NULL),(11,'2025-11-13 18:48:40.190407',0,7,'Order Abandoned',NULL,NULL,NULL,NULL,'cbb55a02-2627-420c-a5ad-bbc09caf4538',0,460,180,NULL,NULL),(12,'2025-11-16 03:57:42.070947',0,8,'Order Abandoned',NULL,NULL,NULL,NULL,'fa5afcaa-f4b7-4662-8cec-648a6ec5c3ba',0,480,180,NULL,NULL),(13,'2025-11-20 15:22:15.392023',0,9,'Order Abandoned',NULL,NULL,NULL,NULL,'ec93fcd8-53c4-4418-9996-7902b3b4d1ff',0,NULL,0,NULL,NULL),(14,'2025-11-21 05:39:00.885928',0,10,'Order Abandoned',NULL,NULL,NULL,NULL,'50d4e8c9-aaac-4d76-b46f-de28a315d3ee',0,460,180,NULL,NULL),(15,'2025-11-25 19:17:32.496589',0,1,'Order Abandoned',NULL,NULL,NULL,NULL,'a6ff5202-5616-4ef8-bb07-68d0009c6417',0,1020,220,NULL,NULL),(16,'2025-12-01 10:38:04.450576',0,11,'Order Abandoned',NULL,NULL,NULL,NULL,'c6a0997a-bd87-45f2-afa0-8458df6d5a11',0,NULL,0,NULL,NULL),(17,'2025-12-02 15:49:26.194535',0,12,'Order Abandoned',NULL,NULL,NULL,NULL,'907b183a-f5d9-4f73-8f48-654a63cc61b7',0,9170,740,NULL,NULL),(18,'2025-12-05 02:21:27.246552',0,13,'Order Abandoned',NULL,NULL,NULL,NULL,'98fbae44-6798-48bf-a4c4-5f89d08356ea',0,NULL,0,NULL,NULL),(19,'2025-12-12 18:56:22.895366',0,14,'Order Abandoned',NULL,NULL,NULL,NULL,'5124adcd-f129-4233-b9be-94db74a51be9',0,2290,400,NULL,NULL),(20,'2025-12-16 07:41:22.261579',0,15,'Order Abandoned',NULL,NULL,NULL,NULL,'9f9cf96f-3697-4dd2-966a-994167555d01',0,1010,260,NULL,NULL),(21,'2025-12-16 14:05:53.492687',0,16,'Order Abandoned',NULL,NULL,NULL,NULL,'25de2426-655a-4c11-b192-46216f653301',0,NULL,0,NULL,NULL),(22,'2025-12-21 06:07:41.283268',0,17,'Order Abandoned',NULL,NULL,NULL,NULL,'b0ca1ada-e0d7-4f11-bcb1-b4cf35b1dcd8',0,220,120,NULL,NULL),(23,'2025-12-21 16:28:13.430438',0,18,'Order Abandoned',NULL,NULL,NULL,NULL,'956a3c05-1d4a-4235-92d3-d132ce730d73',0,150,100,NULL,NULL);
/*!40000 ALTER TABLE `store_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_orderitem`
--

DROP TABLE IF EXISTS `store_orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_orderitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int DEFAULT NULL,
  `date_added` datetime(6) NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `price_at_purchase` decimal(7,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `store_orderitem_order_id_acf8722d_fk` (`order_id`),
  KEY `store_orderitem_product_id_f2b098d4_fk` (`product_id`),
  CONSTRAINT `store_orderitem_order_id_acf8722d_fk` FOREIGN KEY (`order_id`) REFERENCES `store_order` (`id`),
  CONSTRAINT `store_orderitem_product_id_f2b098d4_fk` FOREIGN KEY (`product_id`) REFERENCES `store_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_orderitem`
--

LOCK TABLES `store_orderitem` WRITE;
/*!40000 ALTER TABLE `store_orderitem` DISABLE KEYS */;
INSERT INTO `store_orderitem` VALUES (4,1,'2025-11-04 09:13:42.011981',2,1,280),(8,1,'2025-11-06 19:52:06.522907',1,3,300),(9,3,'2025-11-06 19:52:21.730255',1,2,300),(10,1,'2025-11-07 12:54:44.414085',5,1,280),(11,1,'2025-11-07 12:54:44.427623',5,2,300),(12,1,'2025-11-07 13:23:26.583961',6,3,300),(14,1,'2025-11-10 11:31:31.673317',8,1,280),(15,1,'2025-11-10 11:35:10.593661',8,3,300),(16,1,'2025-11-10 11:54:12.727844',3,1,280),(18,1,'2025-11-13 18:51:10.807217',11,1,280),(19,1,'2025-11-16 03:57:42.085519',12,2,300),(20,5,'2025-11-17 10:25:49.016603',7,3,300),(21,1,'2025-11-17 10:25:49.273477',7,1,280),(22,1,'2025-11-21 05:39:00.913986',14,1,280),(23,1,'2025-11-25 18:42:49.278707',7,9,250),(24,1,'2025-11-25 18:42:50.913107',7,6,250),(25,1,'2025-11-25 19:00:38.649065',7,18,250),(27,1,'2025-12-01 10:38:04.474908',16,6,250),(43,30,'2025-12-02 15:53:02.506556',17,17,250),(44,3,'2025-12-05 02:21:27.269097',18,12,200),(45,1,'2025-12-12 18:56:22.910440',19,1,280),(46,1,'2025-12-12 18:56:22.917309',19,4,250),(47,1,'2025-12-12 18:56:22.927687',19,6,250),(48,1,'2025-12-12 18:56:22.934463',19,7,350),(49,1,'2025-12-12 18:56:22.940470',19,11,160),(50,1,'2025-12-12 18:56:22.950290',19,12,200),(51,1,'2025-12-12 18:56:22.956963',19,13,50),(52,1,'2025-12-12 18:56:22.962067',19,14,50),(53,1,'2025-12-12 18:56:22.966757',19,16,50),(54,1,'2025-12-12 18:56:22.971694',19,17,250),(56,3,'2025-12-16 07:41:22.275533',20,9,250),(57,1,'2025-12-16 14:05:53.514938',21,9,250),(59,1,'2025-12-21 06:08:21.866670',15,9,250),(60,1,'2025-12-21 16:28:13.444188',23,14,50),(61,2,'2025-12-21 16:47:42.202605',22,13,50);
/*!40000 ALTER TABLE `store_orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_paymentrecord`
--

DROP TABLE IF EXISTS `store_paymentrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_paymentrecord` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `razorpay_order_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razorpay_payment_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `details` longtext COLLATE utf8mb4_unicode_ci,
  `order_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `razorpay_payment_id` (`razorpay_payment_id`),
  UNIQUE KEY `unique_payment_record_per_order` (`order_id`,`razorpay_order_id`),
  CONSTRAINT `store_paymentrecord_order_id_6c4223ec_fk_store_order_id` FOREIGN KEY (`order_id`) REFERENCES `store_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_paymentrecord`
--

LOCK TABLES `store_paymentrecord` WRITE;
/*!40000 ALTER TABLE `store_paymentrecord` DISABLE KEYS */;
INSERT INTO `store_paymentrecord` VALUES (1,'order_RbcABHmoxBay4S','pay_RbcAvDIAV456os','Payment Successful',460.00,'2025-11-04 09:32:00.380269','Order successful.',2),(2,'order_RcrFmLiNQP4zFH','pay_RcrGva5c4uxzkM','Payment Successful',800.00,'2025-11-07 12:56:42.664986','Order successful.',5),(3,'order_Rcs2lB1Tozvdn0','pay_Rcs6s57RnEJ3G7','Payment Successful',1500.00,'2025-11-07 13:43:04.849506','Order successful.',1),(4,'order_Re1TGRHrpSPYD3','pay_Re1UIjXvitZypw','Payment Successful',800.00,'2025-11-10 11:31:54.457717','Order successful.',8),(5,'order_RfKTLjDVzQLNyX',NULL,'Incomplete',460.00,'2025-11-13 18:49:40.514848','Waiting for payment.',11),(6,'order_RgGuiEXcL0jeJV',NULL,'Incomplete',480.00,'2025-11-16 03:59:48.390656','Waiting for payment.',12),(7,'order_RiHI5pXvyV7ltQ',NULL,'Incomplete',460.00,'2025-11-21 05:39:56.632486','Waiting for payment.',14),(8,'order_Rk5L9IHTR0dd6K','pay_Rk5Lx1xVLCghBs','Payment Successful',3030.00,'2025-11-25 19:16:31.039994','Order successful.',7),(9,'order_Rk5QM5CxCYdDCp',NULL,'Incomplete',1020.00,'2025-11-25 19:21:26.725571','Waiting for payment.',15),(10,'order_RmnYY5xehLDGgS',NULL,'Incomplete',9170.00,'2025-12-02 15:49:43.412588','Waiting for payment.',17),(11,'order_Rqo8r3t6vBopQk',NULL,'Incomplete',2290.00,'2025-12-12 18:56:54.669780','Waiting for payment.',19),(12,'order_RsCj5jRMGY9aSJ',NULL,'Incomplete',1010.00,'2025-12-16 07:42:03.162776','Waiting for payment.',20),(13,'order_RuWpuwy5Jbrz3E',NULL,'Incomplete',220.00,'2025-12-21 06:13:54.521541','Waiting for payment.',22),(14,'order_RuKO1PPv6VrCbV',NULL,'Incomplete',150.00,'2025-12-21 16:29:39.484144','Waiting for payment.',23);
/*!40000 ALTER TABLE `store_paymentrecord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_product`
--

DROP TABLE IF EXISTS `store_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created` datetime(6) NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT (_utf8mb3''),
  `image_1` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_2` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_3` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `new` tinyint(1) NOT NULL,
  `new_price` decimal(7,0) NOT NULL,
  `old_price` decimal(7,0) DEFAULT NULL,
  `slug` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock` int NOT NULL,
  `update` date NOT NULL,
  `video_url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int NOT NULL,
  `age` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  UNIQUE KEY `store_product_name_46bbb6a9_uniq` (`name`),
  KEY `store_product_category_id_574bae65_fk_store_category_id` (`category_id`),
  CONSTRAINT `store_product_category_id_574bae65_fk_store_category_id` FOREIGN KEY (`category_id`) REFERENCES `store_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_product`
--

LOCK TABLES `store_product` WRITE;
/*!40000 ALTER TABLE `store_product` DISABLE KEYS */;
INSERT INTO `store_product` VALUES (1,'Platinum Red Tail Big Ear',1,'2025-11-03 22:11:31.536071','The Platinum Redtail Big Ear Guppy is a true showstopper in any aquarium. Known for its shimmering metallic platinum body, bright red tail, and large, flowing pectoral fins that resemble angelic wings, this guppy adds a stunning touch of elegance and motion to your tank.\r\n\r\nThis strain is selectively bred for its premium coloration, balanced body shape, and strong genetics — making it not only beautiful but also hardy and easy to care for, even for beginners.','product/cropped_image_NsNk4SF.jpg','','',1,280,300,'platinum-red-tail-big-ear',26,'2025-11-25','https://youtu.be/SyFjR4Hcu-U?si=Mqd8I-8aZTm3Pdax',1,'in_stock',8,'3 month','1st Breeding size'),(2,'Yellow Mosaic Guppy',1,'2025-11-06 18:55:54.551118','','product/cropped_image_gCw1D3j.jpg','product/cropped_image_2wvMWQH.jpg','',1,300,360,'yellow-mosaic-guppy',26,'2025-11-07','',1,'in_stock',18,'3 month','Breeding size'),(3,'White Texido Crown',1,'2025-11-06 19:03:50.596333','','product/cropped_image_J3jgorJ.jpg','','',1,300,NULL,'white-texido-crown',3,'2025-11-25','',1,'in_stock',17,'2 month','Semi Adult'),(4,'Pinku Delta Guppy',1,'2025-11-25 18:10:43.396668','','product/cropped_image_uZ9yDle.jpg','','',1,250,NULL,'pinku-delta-guppy',30,'2025-11-25','',1,'in_stock',3,'3month','e1st Breeding size'),(5,'Silverado Texido Koi',1,'2025-11-25 18:13:50.206181','','product/cropped_image_h0oD9BR.jpg','product/cropped_image_deoImnY.jpg','',1,350,400,'silverado-texido-koi',30,'2025-11-25','',1,'in_stock',15,'3 month','Breeding Size'),(6,'Full Gold',1,'2025-11-25 18:17:24.070855','','product/cropped_image_rQ5Npdn.jpg','','',1,250,NULL,'full-gold',14,'2025-11-25','',1,'in_stock',13,'2 month','Semi Adult'),(7,'Platinum Koi Big Ear',1,'2025-11-25 18:20:07.683605','','product/cropped_image_znwwngY.jpg','product/cropped_image_x3VmO3v.jpg','',1,350,NULL,'platinum-koi-big-ear',15,'2025-12-12','',1,'in_stock',14,'not mentioned.','not mentioned.'),(8,'Yellow Lase Guppy',1,'2025-11-25 18:21:43.673490','','product/cropped_image_Q1Z67eY.jpg','','',1,350,NULL,'yellow-lase-guppy',20,'2025-11-25','',1,'in_stock',16,'not mentioned.','not mentioned.'),(9,'Blonde Koi Short Body  Guppy',1,'2025-11-25 18:23:17.047181','','product/cropped_image_YZdETfn.jpg','','',1,250,300,'blonde-koi-short-body-guppy',29,'2025-12-10','https://youtube.com/shorts/VZUAl1ljhHI?si=ESr03sm-R-ADeM9U',1,'in_stock',0,'not mentioned.','not mentioned.'),(10,'Purple Berry Dragon Guppy',1,'2025-11-25 18:25:07.924441','','product/cropped_image_OvAmHOm.jpg','','',1,250,NULL,'purple-berry-dragon-guppy',30,'2025-11-25','',1,'in_stock',9,'not mentioned.','not mentioned.'),(11,'Moina Egg',1,'2025-11-25 18:26:42.620118','','product/cropped_image_yMhDAOO.jpg','product/cropped_image_vMigDtX.jpg','',1,160,NULL,'moina-egg',30,'2025-11-25','',6,'in_stock',6,'not mentioned.','not mentioned.'),(12,'OSI Artemia FAlake',1,'2025-11-25 18:31:15.858612','100g packet','product/cropped_image_ToO57IH.jpg','','',1,200,NULL,'osi-artemia-falake',30,'2025-11-25','',5,'in_stock',7,'not mentioned.','not mentioned.'),(13,'Red Root Plant',1,'2025-11-25 18:32:56.890905','4-5 plant','product/cropped_image_g1t7Hi6.jpg','product/cropped_image_GMr7E8m.jpg','',1,50,NULL,'red-root-plant',30,'2025-11-25','',4,'in_stock',1,'not mentioned.','not mentioned.'),(14,'Methylene Blue medicine',1,'2025-11-25 18:34:47.215586','30 ml','product/cropped_image_WpDZYEY.jpg','product/cropped_image_wLX4hHx.jpg','',1,50,NULL,'methylene-blue-medicine',30,'2025-11-25','',6,'in_stock',5,'not mentioned.','not mentioned.'),(15,'Santa Clouse New Linage',1,'2025-11-25 18:35:56.490951','','product/cropped_image_Hp4VZ75.jpg','product/cropped_image_MXC4tj0.jpg','',1,400,NULL,'santa-clouse-new-linage',5,'2025-11-25','',1,'in_stock',10,'not mentioned.','not mentioned.'),(16,'Water Cabbage Plant',1,'2025-11-25 18:37:11.542289','','product/cropped_image_d8eeP78.jpg','product/cropped_image_pDrHErA.jpg','',1,50,NULL,'water-cabbage-plant',20,'2025-11-25','',4,'in_stock',12,'not mentioned.','not mentioned.'),(17,'Blue Panda Guppy',1,'2025-11-25 18:43:57.900696','','product/cropped_image_9zQETFQ.jpg','product/cropped_image_2awfCQn.jpg','',1,250,NULL,'blue-panda-guppy',30,'2025-12-10','https://youtube.com/shorts/u9lYu8CgorQ?si=AR2WEQNMMXRGmkFP',1,'in_stock',2,'not mentioned.','not mentioned.'),(18,'Full Red OHM Betta',1,'2025-11-25 18:56:21.814284','','product/cropped_image_15IzLuY.jpg','','',1,250,NULL,'full-red-ohm-betta',-1,'2025-11-25','',2,'out_of_stock',4,'not mentioned.','not mentioned.'),(19,'Platinum white big ear',1,'2025-12-12 19:11:36.992292','','product/cropped_image_GNfH1Ap.jpg','product/cropped_image_czWpSiG.jpg','product/cropped_image_avetfwG.jpg',1,400,NULL,'platinum-white-big-ear',3,'2025-12-12','',1,'in_stock',11,'not mentioned.','not mentioned.');
/*!40000 ALTER TABLE `store_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_purchasehistory`
--

DROP TABLE IF EXISTS `store_purchasehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_purchasehistory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `price_at_purchase` decimal(7,0) NOT NULL,
  `customer_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `date_added` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_purchasehistory_customer_id_9a271c1f_fk_store_customer_id` (`customer_id`),
  KEY `store_purchasehistory_product_id_719adaae_fk_store_product_id` (`product_id`),
  CONSTRAINT `store_purchasehistory_customer_id_9a271c1f_fk_store_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `store_customer` (`id`),
  CONSTRAINT `store_purchasehistory_product_id_719adaae_fk_store_product_id` FOREIGN KEY (`product_id`) REFERENCES `store_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_purchasehistory`
--

LOCK TABLES `store_purchasehistory` WRITE;
/*!40000 ALTER TABLE `store_purchasehistory` DISABLE KEYS */;
INSERT INTO `store_purchasehistory` VALUES (1,280,2,1,'2025-11-04 09:32:58.946790'),(2,300,4,2,'2025-11-07 12:58:05.560039'),(3,300,1,2,'2025-11-07 13:47:12.206247'),(4,300,5,3,'2025-11-10 11:36:41.899197'),(5,250,1,18,'2025-11-25 19:17:30.330973');
/*!40000 ALTER TABLE `store_purchasehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_shippingaddress`
--

DROP TABLE IF EXISTS `store_shippingaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_shippingaddress` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zipcode` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_added` datetime(6) NOT NULL,
  `customer_id` bigint DEFAULT NULL,
  `order_id` bigint DEFAULT NULL,
  `number` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `whatsapp` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_shippingaddress_customer_id_66e362a6_fk` (`customer_id`),
  KEY `store_shippingaddress_order_id_e6decfbb_fk` (`order_id`),
  CONSTRAINT `store_shippingaddress_customer_id_66e362a6_fk` FOREIGN KEY (`customer_id`) REFERENCES `store_customer` (`id`),
  CONSTRAINT `store_shippingaddress_order_id_e6decfbb_fk` FOREIGN KEY (`order_id`) REFERENCES `store_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_shippingaddress`
--

LOCK TABLES `store_shippingaddress` WRITE;
/*!40000 ALTER TABLE `store_shippingaddress` DISABLE KEYS */;
INSERT INTO `store_shippingaddress` VALUES (1,'Marathakkodan house, vilayil P O , mankadavu','Malappuram','Other','673645','2025-11-04 09:32:58.919944',2,2,'07025962175','07025962175'),(2,'koolorkunnu (h) edvpragff','edavannapara','Other','673645','2025-11-07 12:58:05.522771',4,5,'9858945625','95857456565'),(3,'Chirayimmal ','Areekode','Other','673639','2025-11-07 13:47:12.178993',1,1,'8667377338','8667377338'),(4,'Marathakkodan house, vilayil P O , mankadavu','Malappuram','Other','673645','2025-11-10 11:36:41.865893',5,8,'07025962175','07025962175'),(5,'Chirayimmal ','Areekode','Other','673639','2025-11-25 19:17:30.299199',1,7,'8667377338','8667377338');
/*!40000 ALTER TABLE `store_shippingaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_shippingrate`
--

DROP TABLE IF EXISTS `store_shippingrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_shippingrate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `base_rate` decimal(6,2) NOT NULL,
  `additional_item_rate` decimal(6,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_shippingrate`
--

LOCK TABLES `store_shippingrate` WRITE;
/*!40000 ALTER TABLE `store_shippingrate` DISABLE KEYS */;
INSERT INTO `store_shippingrate` VALUES (1,'Kerala',100.00,20.00),(2,'Tamil Nadu',130.00,30.00),(3,'Karnataka',130.00,30.00),(4,'Andhra Pradesh',180.00,40.00),(5,'Telangana',180.00,40.00),(6,'Goa',180.00,40.00);
/*!40000 ALTER TABLE `store_shippingrate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_wishlist`
--

DROP TABLE IF EXISTS `store_wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_wishlist` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `added_at` datetime(6) NOT NULL,
  `product_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `store_wishlist_user_id_product_id_bcc1ac25_uniq` (`user_id`,`product_id`),
  KEY `store_wishlist_product_id_8af1333d_fk_store_product_id` (`product_id`),
  CONSTRAINT `store_wishlist_product_id_8af1333d_fk_store_product_id` FOREIGN KEY (`product_id`) REFERENCES `store_product` (`id`),
  CONSTRAINT `store_wishlist_user_id_afcc4e88_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_wishlist`
--

LOCK TABLES `store_wishlist` WRITE;
/*!40000 ALTER TABLE `store_wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-22  6:41:26
