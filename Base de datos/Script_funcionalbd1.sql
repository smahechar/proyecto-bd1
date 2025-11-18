-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bdatos1
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



--
-- Table structure for table `bloque`
--

DROP TABLE IF EXISTS `bloque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bloque` (
  `id_bloque` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_bloque`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bloque`
--

LOCK TABLES `bloque` WRITE;
/*!40000 ALTER TABLE `bloque` DISABLE KEYS */;
INSERT INTO `bloque` VALUES (1,'A','Edificio Fundadores - 7 pisos'),(2,'E','Edificio Bloque E - 2 pisos'),(3,'F','Edificio Bloque F - 7 pisos'),(4,'G','Edificio Bloque G - 1 piso'),(5,'M','Edificio Bloque M - Auditorio'),(6,'I','Edificio Bloque I - 4 pisos'),(7,'O','Edificio Bloque O - Biblioteca'),(8,'D','Gimnasio Universitario'),(9,'B','Edificio Bloque B - 3 pisos'),(10,'N','Clínica Odontológica'),(11,'K','Edificio K - Museo'),(12,'J','Edificio Bloque J - 2 pisos');
/*!40000 ALTER TABLE `bloque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `espacio`
--

DROP TABLE IF EXISTS `espacio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `espacio` (
  `id_espacio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `capacidad` int DEFAULT '0',
  `descripcion` text COLLATE utf8mb4_general_ci,
  `estado` enum('Disponible','Ocupado','Reservado','Mantenimiento') COLLATE utf8mb4_general_ci DEFAULT 'Disponible',
  `id_tipo_espacio` int DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_bloque` int DEFAULT NULL,
  PRIMARY KEY (`id_espacio`),
  KEY `idx_espacio_tipo` (`id_tipo_espacio`),
  KEY `idx_espacio_estado` (`estado`),
  KEY `fk_bloque_espacio` (`id_bloque`),
  CONSTRAINT `espacio_ibfk_1` FOREIGN KEY (`id_tipo_espacio`) REFERENCES `tipo_espacio` (`id_tipo_espacio`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_bloque_espacio` FOREIGN KEY (`id_bloque`) REFERENCES `bloque` (`id_bloque`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `espacio`
--

LOCK TABLES `espacio` WRITE;
/*!40000 ALTER TABLE `espacio` DISABLE KEYS */;
INSERT INTO `espacio` VALUES (1,'A101',40,'Aula Bloque A Piso 1','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(2,'A102',40,'Aula Bloque A Piso 1','Reservado',1,'2025-11-16 23:32:40','2025-11-17 20:52:21',1),(3,'A103',40,'Aula Bloque A Piso 1','Reservado',1,'2025-11-16 23:32:40','2025-11-17 20:52:33',1),(4,'A104',40,'Aula Bloque A Piso 1','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(5,'A201',40,'Aula Bloque A Piso 2','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(6,'A202',40,'Aula Bloque A Piso 2','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(7,'A203',40,'Aula Bloque A Piso 2','Reservado',1,'2025-11-16 23:32:40','2025-11-17 20:52:43',1),(8,'A204',40,'Aula Bloque A Piso 2','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(9,'A301',40,'Aula Bloque A Piso 3','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(10,'A302',40,'Aula Bloque A Piso 3','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(11,'A303',40,'Aula Bloque A Piso 3','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(12,'A304',40,'Aula Bloque A Piso 3','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(13,'A401',40,'Aula Bloque A Piso 4','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(14,'A402',40,'Aula Bloque A Piso 4','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(15,'A403',40,'Aula Bloque A Piso 4','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(16,'A404',40,'Aula Bloque A Piso 4','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(17,'A501',40,'Aula Bloque A Piso 5','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(18,'A502',40,'Aula Bloque A Piso 5','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(19,'A503',40,'Aula Bloque A Piso 5','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(20,'A504',40,'Aula Bloque A Piso 5','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(21,'A601',0,'Oficina administrativa','Disponible',4,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(22,'A602',0,'Oficina administrativa','Disponible',4,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(23,'A603',0,'Restaurante universitario','Disponible',5,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(24,'A701',0,'Terraza general','Disponible',6,'2025-11-16 23:32:40','2025-11-16 23:34:52',1),(25,'E101',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(26,'E102',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(27,'E103',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(28,'E104',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(29,'E201',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(30,'E202',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(31,'E203',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(32,'E204',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',2),(33,'F101',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(34,'F102',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(35,'F103',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(36,'F104',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(37,'F201',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(38,'F202',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(39,'F203',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(40,'F204',30,'Laboratorio de computación','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(41,'F301',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(42,'F302',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(43,'F303',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(44,'F304',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(45,'F401',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(46,'F402',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(47,'F403',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(48,'F404',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(49,'F501',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(50,'F502',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(51,'F503',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(52,'F504',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(53,'F601',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(54,'F602',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(55,'F603',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(56,'F604',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(57,'F701',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(58,'F702',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(59,'F703',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(60,'F704',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',3),(61,'G101',40,'Aula izquierda','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',4),(62,'G102',40,'Aula izquierda','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',4),(63,'G103',40,'Aula izquierda','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',4),(64,'G201',40,'Aula derecha','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',4),(65,'G202',40,'Aula derecha','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',4),(66,'AUDM',300,'Auditorio Bloque M','Disponible',3,'2025-11-16 23:32:40','2025-11-16 23:34:52',5),(67,'M101',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(68,'M102',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(69,'M103',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(70,'M104',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(71,'M105',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(72,'M106',40,'Salón Bloque M','Disponible',NULL,'2025-11-16 23:32:40','2025-11-16 23:32:40',5),(73,'I101',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(74,'I102',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(75,'I103',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(76,'I104',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(77,'I105',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(78,'I106',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(79,'I107',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(80,'I108',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(81,'I109',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(82,'I201',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(83,'I202',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(84,'I203',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(85,'I204',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(86,'I301',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(87,'I302',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(88,'I303',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(89,'I304',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(90,'I401',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(91,'I402',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(92,'I403',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(93,'I404',40,'Aula videobeam','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',6),(94,'O101',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(95,'O102',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(96,'O103',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(97,'O104',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(98,'O105',120,'Auditorio Bloque O','Disponible',3,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(99,'O106',0,'Sala de música','Disponible',11,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(100,'O201',30,'Laboratorio especializado','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(101,'O202',30,'Laboratorio especializado','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(102,'O203',30,'Laboratorio especializado','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(103,'O301',0,'Sala de estudio biblioteca','Disponible',7,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(104,'O302',0,'Cubículos biblioteca','Disponible',8,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(105,'O303',0,'Sala de docentes','Disponible',9,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(106,'O401',0,'Sala de estudio biblioteca','Disponible',7,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(107,'O402',0,'Cubículos biblioteca','Disponible',8,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(108,'O403',0,'Sala de docentes','Disponible',9,'2025-11-16 23:32:40','2025-11-16 23:34:52',7),(109,'D101',0,'Gimnasio universitario','Disponible',12,'2025-11-16 23:32:40','2025-11-16 23:34:52',8),(110,'B101',30,'Laboratorio científico','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(111,'B102',30,'Laboratorio científico','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(112,'B103',30,'Laboratorio científico','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(113,'B104',30,'Laboratorio científico','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(114,'B201',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(115,'B202',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(116,'B203',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(117,'B204',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(118,'B205',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(119,'B206',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(120,'B207',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(121,'B208',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(122,'B209',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(123,'B210',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(124,'B211',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(125,'B212',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(126,'B213',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(127,'B301',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(128,'B302',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(129,'B303',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(130,'B304',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(131,'B305',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(132,'B306',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(133,'B307',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(134,'B308',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(135,'B309',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(136,'B310',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(137,'B311',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(138,'B312',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(139,'B313',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',9),(140,'N101',20,'Clínica Odontológica','Disponible',13,'2025-11-16 23:32:40','2025-11-16 23:34:52',10),(141,'K101',0,'Museo de biología','Disponible',10,'2025-11-16 23:32:40','2025-11-16 23:34:52',11),(142,'K201',25,'Laboratorio biológico','Disponible',2,'2025-11-16 23:32:40','2025-11-16 23:34:52',11),(143,'J101',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(144,'J102',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(145,'J103',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(146,'J104',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(147,'J201',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(148,'J202',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(149,'J203',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12),(150,'J204',40,'Aula general','Disponible',1,'2025-11-16 23:32:40','2025-11-16 23:34:52',12);
/*!40000 ALTER TABLE `espacio` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_espacio_cambio_estado` AFTER UPDATE ON `espacio` FOR EACH ROW BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO Historial (id_espacio, estado_anterior, estado_nuevo, hora_cambio)
        VALUES (NEW.id_espacio, OLD.estado, NEW.estado, CURTIME());
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `historial`
--

DROP TABLE IF EXISTS `historial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `id_espacio` int NOT NULL,
  `estado_anterior` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado_nuevo` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_cambio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `hora_cierre` time DEFAULT NULL,
  `hora_cambio` time DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `responsable_cambio` int DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `idx_historial_espacio` (`id_espacio`),
  KEY `idx_historial_fecha` (`fecha_cambio`),
  CONSTRAINT `historial_ibfk_1` FOREIGN KEY (`id_espacio`) REFERENCES `espacio` (`id_espacio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial`
--

LOCK TABLES `historial` WRITE;
/*!40000 ALTER TABLE `historial` DISABLE KEYS */;
INSERT INTO `historial` VALUES (1,1,'Reserva','Reserva creada para 2025-11-17 de 20:29 a 20:30','2025-11-17 01:29:05',NULL,'20:29:05','2025-11-17 01:29:05','2025-11-17 01:29:05',NULL),(2,114,'Reserva','Reserva creada para 2025-11-17 de 08:12 a 20:19','2025-11-17 05:00:00',NULL,'01:12:56','2025-11-17 06:12:56','2025-11-17 06:12:56',8),(3,69,'Reserva','Reserva creada para 2025-11-17 de 08:12 a 20:19','2025-11-17 05:00:00',NULL,'01:13:09','2025-11-17 06:13:09','2025-11-17 06:13:09',8),(4,4,'Mantenimiento','Mantenimiento programado: hola','2025-11-17 05:00:00',NULL,'01:19:23','2025-11-17 06:19:23','2025-11-17 06:19:23',6),(5,1,'Mantenimiento','Mantenimiento programado: hola','2025-11-17 05:00:00',NULL,'01:19:35','2025-11-17 06:19:35','2025-11-17 06:19:35',6),(6,1,'Reserva','Reserva creada para 2025-11-17 de 08:19 a 15:20','2025-11-17 05:00:00',NULL,'01:20:08','2025-11-17 06:20:08','2025-11-17 06:20:08',8),(7,143,'Reserva','Reserva creada para 2025-11-17 de 13:46 a 15:46','2025-11-17 06:46:16',NULL,NULL,'2025-11-17 06:46:16','2025-11-17 06:46:16',8),(8,2,'Disponible','Reservado','2025-11-17 20:52:21',NULL,'15:52:21','2025-11-17 20:52:21','2025-11-17 20:52:21',NULL),(9,2,'Reserva','Reserva creada para 2025-11-17 de 15:52 a 15:53','2025-11-17 20:52:21',NULL,NULL,'2025-11-17 20:52:21','2025-11-17 20:52:21',6),(10,3,'Disponible','Reservado','2025-11-17 20:52:33',NULL,'15:52:33','2025-11-17 20:52:33','2025-11-17 20:52:33',NULL),(11,3,'Reserva','Reserva creada para 2025-11-17 de 15:52 a 15:53','2025-11-17 20:52:33',NULL,NULL,'2025-11-17 20:52:33','2025-11-17 20:52:33',6),(12,7,'Disponible','Reservado','2025-11-17 20:52:43',NULL,'15:52:43','2025-11-17 20:52:43','2025-11-17 20:52:43',NULL),(13,7,'Reserva','Reserva creada para 2025-11-17 de 15:52 a 18:53','2025-11-17 20:52:43',NULL,NULL,'2025-11-17 20:52:43','2025-11-17 20:52:43',6),(14,1,'Reserva eliminada','Reserva #1 eliminada por administrador','2025-11-17 21:15:40',NULL,NULL,'2025-11-17 21:15:40','2025-11-17 21:15:40',6),(15,1,'Reserva eliminada','Reserva #5 eliminada por administrador','2025-11-17 21:16:13',NULL,NULL,'2025-11-17 21:16:13','2025-11-17 21:16:13',6),(16,9,'Reserva eliminada','Reserva #10 eliminada por administrador','2025-11-17 21:16:50',NULL,NULL,'2025-11-17 21:16:50','2025-11-17 21:16:50',6);
/*!40000 ALTER TABLE `historial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_acciones`
--

DROP TABLE IF EXISTS `log_acciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_acciones` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `accion` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `fecha_accion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`),
  KEY `idx_log_usuario` (`id_usuario`),
  KEY `idx_log_fecha` (`fecha_accion`),
  CONSTRAINT `log_acciones_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_acciones`
--

LOCK TABLES `log_acciones` WRITE;
/*!40000 ALTER TABLE `log_acciones` DISABLE KEYS */;
INSERT INTO `log_acciones` VALUES (2,4,'Login exitoso desde 127.0.0.1',NULL,'2025-11-16 22:03:08'),(4,4,'Crear Reserva','Reserva creada para Sala 102 el 2025-11-16 de 18:09:00 a 21:09:00','2025-11-16 23:09:10'),(5,4,'Crear Reserva','Reserva creada para A101 el 2025-11-17 de 20:29:00 a 20:30:00','2025-11-17 01:29:05'),(6,4,'Creó reserva','Espacio: A101 | Fecha: 2025-11-17 | 20:29-20:30','2025-11-17 01:29:05'),(7,6,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 01:34:35'),(8,7,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 04:39:51'),(9,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 05:13:53'),(10,7,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 05:55:41'),(11,6,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 05:56:14'),(12,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 05:59:29'),(14,8,'Crear Reserva','Reserva creada para B201 el 2025-11-17 de 08:12:00 a 20:19:00','2025-11-17 06:12:56'),(15,8,'Crear Reserva','Reserva creada para M103 el 2025-11-17 de 08:12:00 a 20:19:00','2025-11-17 06:13:09'),(16,6,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 06:13:29'),(17,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 06:19:47'),(18,8,'Crear Reserva','Reserva creada para A101 el 2025-11-17 de 08:19:00 a 15:20:00','2025-11-17 06:20:08'),(19,8,'Crear Reserva','Reserva creada para A101 el 2025-11-17 de 16:00:00 a 18:00:00','2025-11-17 06:34:42'),(20,6,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 06:35:04'),(21,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 06:37:04'),(22,8,'Crear Reserva','Reserva creada para I102 el 2025-11-17 de 14:37:00 a 15:37:00','2025-11-17 06:37:25'),(23,8,'Crear Reserva','Reserva creada para A202 el 2025-11-17 de 14:37:00 a 15:37:00','2025-11-17 06:41:10'),(24,8,'Crear Reserva','Reserva creada para A301 el 2025-11-17 de 14:37:00 a 15:37:00','2025-11-17 06:41:28'),(25,8,'Crear Reserva','Reserva creada para A301 el 2025-11-20 de 13:41:00 a 16:41:00','2025-11-17 06:41:58'),(26,8,'Crear Reserva','Reserva creada para J101 el 2025-11-17 de 13:46:00 a 15:46:00','2025-11-17 06:46:16'),(27,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 20:11:20'),(28,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 20:46:36'),(29,6,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 20:51:40'),(30,6,'Crear Reserva','Reserva creada para A102 el 2025-11-17 de 15:52:00 a 15:53:00','2025-11-17 20:52:21'),(31,6,'Crear Reserva','Reserva creada para A103 el 2025-11-17 de 15:52:00 a 15:53:00','2025-11-17 20:52:33'),(32,6,'Crear Reserva','Reserva creada para A203 el 2025-11-17 de 15:52:00 a 18:53:00','2025-11-17 20:52:43'),(33,8,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 21:18:00'),(34,7,'Login exitoso desde 127.0.0.1',NULL,'2025-11-17 21:18:47');
/*!40000 ALTER TABLE `log_acciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento` (
  `id_mantenimiento` int NOT NULL AUTO_INCREMENT,
  `id_espacio` int NOT NULL,
  `id_usuario` int NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('Programado','En Proceso','Completado','Cancelado') COLLATE utf8mb4_general_ci DEFAULT 'Programado',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `estado_mantenimiento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Programado',
  PRIMARY KEY (`id_mantenimiento`),
  KEY `idx_mantenimiento_espacio` (`id_espacio`),
  KEY `idx_mantenimiento_usuario` (`id_usuario`),
  KEY `idx_mantenimiento_estado` (`estado`),
  CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`id_espacio`) REFERENCES `espacio` (`id_espacio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mantenimiento_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento`
--

LOCK TABLES `mantenimiento` WRITE;
/*!40000 ALTER TABLE `mantenimiento` DISABLE KEYS */;
INSERT INTO `mantenimiento` VALUES (1,4,6,NULL,NULL,'Programado','2025-11-17 06:19:23','2025-11-17 06:19:23','hola','Programado'),(2,1,6,NULL,NULL,'Programado','2025-11-17 06:19:35','2025-11-17 06:19:35','hola','Programado'),(3,4,6,NULL,NULL,'Programado','2025-11-17 06:35:33','2025-11-17 06:35:33','hola','Programado'),(4,4,6,NULL,NULL,'Programado','2025-11-17 06:35:41','2025-11-17 06:35:41','hola','Programado'),(5,3,6,NULL,NULL,'Programado','2025-11-17 06:35:45','2025-11-17 06:35:45','hola','Programado'),(6,5,6,NULL,NULL,'Programado','2025-11-17 06:36:30','2025-11-17 06:36:30','hola','Programado');
/*!40000 ALTER TABLE `mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recurso`
--

DROP TABLE IF EXISTS `recurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recurso` (
  `id_recurso` int NOT NULL AUTO_INCREMENT,
  `id_espacio` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` int DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_recurso`),
  KEY `idx_recurso_espacio` (`id_espacio`),
  CONSTRAINT `recurso_ibfk_1` FOREIGN KEY (`id_espacio`) REFERENCES `espacio` (`id_espacio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recurso`
--

LOCK TABLES `recurso` WRITE;
/*!40000 ALTER TABLE `recurso` DISABLE KEYS */;
INSERT INTO `recurso` VALUES (1,1,'Proyector',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(2,1,'Sillas',25,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(3,1,'Pizarra',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(4,2,'Proyector',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(5,2,'Sistema de Sonido',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(6,2,'Sillas',30,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(7,3,'Mesas Colaborativas',5,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(8,3,'Sillas',20,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(9,4,'Proyector',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(10,4,'Sistema de Sonido',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(11,4,'Sillas',40,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(12,4,'Aire Acondicionado',2,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(13,5,'Computadores',35,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(14,5,'Proyector',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(15,6,'Microscopios',10,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(16,6,'Mesas de Laboratorio',5,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(17,6,'Equipos de Seguridad',15,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(18,7,'Sistema de Sonido Profesional',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(19,7,'Proyector de Alta Resolución',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(20,7,'Sillas Auditorio',150,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(21,7,'Escenario',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(22,8,'Mesas',2,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(23,8,'Sillas',10,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(24,8,'Pizarra',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(25,9,'Escritorios Individuales',8,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(26,9,'Sillas',8,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(27,10,'Sistema de Videoconferencia',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(28,10,'Proyector',1,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(29,10,'Sillas',50,'2025-11-16 17:46:49','2025-11-16 17:46:49'),(30,10,'Pantallas',2,'2025-11-16 17:46:49','2025-11-16 17:46:49');
/*!40000 ALTER TABLE `recurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva`
--

DROP TABLE IF EXISTS `reserva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva` (
  `id_reserva` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_espacio` int NOT NULL,
  `fecha_reserva` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `estado` enum('Activa','Cancelada','Completada') COLLATE utf8mb4_general_ci DEFAULT 'Activa',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `estado_reserva` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Activa',
  PRIMARY KEY (`id_reserva`),
  KEY `idx_reserva_usuario` (`id_usuario`),
  KEY `idx_reserva_espacio` (`id_espacio`),
  KEY `idx_reserva_fecha` (`fecha_reserva`),
  KEY `idx_reserva_estado` (`estado`),
  CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`id_espacio`) REFERENCES `espacio` (`id_espacio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva`
--

LOCK TABLES `reserva` WRITE;
/*!40000 ALTER TABLE `reserva` DISABLE KEYS */;
INSERT INTO `reserva` VALUES (3,8,114,'2025-11-17','08:12:00','20:19:00','Activa','2025-11-17 06:12:56','2025-11-17 06:12:56','Activa'),(4,8,69,'2025-11-17','08:12:00','20:19:00','Activa','2025-11-17 06:13:09','2025-11-17 06:13:09','Activa'),(6,8,1,'2025-11-17','16:00:00','18:00:00','Activa','2025-11-17 06:34:42','2025-11-17 06:34:42','Activa'),(7,8,74,'2025-11-17','14:37:00','15:37:00','Activa','2025-11-17 06:37:25','2025-11-17 06:37:25','Activa'),(8,8,6,'2025-11-17','14:37:00','15:37:00','Activa','2025-11-17 06:41:10','2025-11-17 06:41:10','Activa'),(9,8,9,'2025-11-17','14:37:00','15:37:00','Activa','2025-11-17 06:41:28','2025-11-17 06:41:28','Activa'),(11,8,143,'2025-11-17','13:46:00','15:46:00','Activa','2025-11-17 06:46:16','2025-11-17 06:46:16','Activa'),(12,6,2,'2025-11-17','15:52:00','15:53:00','Activa','2025-11-17 20:52:21','2025-11-17 20:52:21','Activa'),(13,6,3,'2025-11-17','15:52:00','15:53:00','Activa','2025-11-17 20:52:33','2025-11-17 20:52:33','Activa'),(14,6,7,'2025-11-17','15:52:00','18:53:00','Activa','2025-11-17 20:52:43','2025-11-17 20:52:43','Activa');
/*!40000 ALTER TABLE `reserva` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_reserva_actualizar_espacio` AFTER INSERT ON `reserva` FOR EACH ROW BEGIN
    -- Si la reserva es para hoy y está en horario actual, cambiar estado
    IF NEW.fecha_reserva = CURDATE() 
       AND NEW.estado = 'Activa' 
       AND CURTIME() BETWEEN NEW.hora_inicio AND NEW.hora_fin THEN
        UPDATE Espacio 
        SET estado = 'Reservado' 
        WHERE id_espacio = NEW.id_espacio;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_reserva_cancelar` AFTER UPDATE ON `reserva` FOR EACH ROW BEGIN
    -- Si se cancela una reserva activa de hoy, verificar si liberar el espacio
    IF OLD.estado = 'Activa' 
       AND NEW.estado = 'Cancelada'
       AND NEW.fecha_reserva = CURDATE() THEN
        
        -- Verificar si hay otras reservas activas en este momento
        IF NOT EXISTS (
            SELECT 1 FROM Reserva 
            WHERE id_espacio = NEW.id_espacio 
              AND fecha_reserva = CURDATE()
              AND estado = 'Activa'
              AND CURTIME() BETWEEN hora_inicio AND hora_fin
              AND id_reserva != NEW.id_reserva
        ) THEN
            UPDATE Espacio 
            SET estado = 'Disponible' 
            WHERE id_espacio = NEW.id_espacio;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Administrador','Acceso completo al sistema con permisos de gestión','2025-11-16 17:46:49','2025-11-16 17:46:49'),(2,'Docente','Puede reservar espacios y gestionar sus reservas','2025-11-16 17:46:49','2025-11-16 17:46:49'),(3,'Estudiante','Puede reservar espacios disponibles','2025-11-16 17:46:49','2025-11-16 17:46:49');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_espacio`
--

DROP TABLE IF EXISTS `tipo_espacio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_espacio` (
  `id_tipo_espacio` int NOT NULL AUTO_INCREMENT,
  `nombre_tipo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_espacio`),
  UNIQUE KEY `nombre_tipo` (`nombre_tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_espacio`
--

LOCK TABLES `tipo_espacio` WRITE;
/*!40000 ALTER TABLE `tipo_espacio` DISABLE KEYS */;
INSERT INTO `tipo_espacio` VALUES (1,'Aula','Aula de clase','2025-11-16 23:32:40','2025-11-16 23:32:40'),(2,'Laboratorio','Laboratorio general','2025-11-16 23:32:40','2025-11-16 23:32:40'),(3,'Auditorio','Auditorio institucional','2025-11-16 23:32:40','2025-11-16 23:32:40'),(4,'Oficina','Oficinas administrativas','2025-11-16 23:32:40','2025-11-16 23:32:40'),(5,'Restaurante','Zona de comida','2025-11-16 23:32:40','2025-11-16 23:32:40'),(6,'Terraza','Zona abierta','2025-11-16 23:32:40','2025-11-16 23:32:40'),(7,'Sala de Estudio','Espacio de estudio','2025-11-16 23:32:40','2025-11-16 23:32:40'),(8,'Cubículo','Cubículos individuales','2025-11-16 23:32:40','2025-11-16 23:32:40'),(9,'Sala de Docentes','Sala exclusiva docentes','2025-11-16 23:32:40','2025-11-16 23:32:40'),(10,'Museo','Exhibiciones biológicas','2025-11-16 23:32:40','2025-11-16 23:32:40'),(11,'Sala de Música','Práctica musical','2025-11-16 23:32:40','2025-11-16 23:32:40'),(12,'Gimnasio','Actividad física','2025-11-16 23:32:40','2025-11-16 23:32:40'),(13,'Clínica Odontológica','Atención odontológica','2025-11-16 23:32:40','2025-11-16 23:32:40');
/*!40000 ALTER TABLE `tipo_espacio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `id_rol` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`),
  KEY `idx_usuario_rol` (`id_rol`),
  KEY `idx_usuario_correo` (`correo`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,'Administrador del Sistema','admin@unbosque.edu.co','scrypt:32768:8:1$gN3KxYQZ8vPCDpbJ$e8b6d2c3a4f5e6d7c8b9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5','2025-11-16 17:46:50','2025-11-16 17:46:50'),(2,2,'Carlos Rodríguez','carlos.rodriguez@unbosque.edu.co','scrypt:32768:8:1$gN3KxYQZ8vPCDpbJ$e8b6d2c3a4f5e6d7c8b9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5','2025-11-16 17:46:50','2025-11-16 17:46:50'),(3,3,'María González','maria.gonzalez@unbosque.edu.co','scrypt:32768:8:1$gN3KxYQZ8vPCDpbJ$e8b6d2c3a4f5e6d7c8b9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5','2025-11-16 17:46:50','2025-11-16 17:46:50'),(4,3,'Natalia','agalvisp@unbosque.edu.co','scrypt:32768:8:1$IFqELrAGKXR7WCTX$87d939c36b28bc22c1e1fafc2efec8b336dc90940833be787e18e2eca427dcd8b36f65bbc5c21dc397a673cb9dc1d874bf5f51e671a1ab2cd128b81168d5ec4d','2025-11-16 22:02:59','2025-11-16 22:02:59'),(6,1,'hola','administrador@unbosque.edu.co','scrypt:32768:8:1$Sz5ipQ4BjRs8zYFx$f9d3501c5270f2b9cacec1429ab4cd416c2b45887588d86c3ff8796744c5534b8aa1f8b1bc4548121490d4d80f2db561087f3a1e8981140eced7e1cd3ec7251f','2025-11-17 01:34:19','2025-11-17 01:34:19'),(7,3,'prueba','prueba@unbosque.edu.co','scrypt:32768:8:1$8DQoG3tDYTGbZBBR$4466d18d2196bd34f32e7e64972ba76caf6d699ce26f869e4a7d34813691a9c1074838b75e746eaff91f27f93725186353cb16b3578b7ce45a82189d12591693','2025-11-17 04:39:42','2025-11-17 04:39:42'),(8,2,'sergio','smahechar@unbosque.edu.co','scrypt:32768:8:1$qomvFRxoaCQorkYz$b311ae81933854c14a88d21a88218be5742ee6b4a1cc5ee88725efcd4d84384fa4b3241fa331740359c57591dd324e1b795de81de97f8caafdb5cc65a89edecb','2025-11-17 05:13:41','2025-11-17 05:13:41');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_espacios_disponibles`
--

DROP TABLE IF EXISTS `v_espacios_disponibles`;
/*!50001 DROP VIEW IF EXISTS `v_espacios_disponibles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_espacios_disponibles` AS SELECT 
 1 AS `id_espacio`,
 1 AS `nombre`,
 1 AS `capacidad`,
 1 AS `descripcion`,
 1 AS `estado`,
 1 AS `tipo_espacio`,
 1 AS `cantidad_recursos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_historial_completo`
--

DROP TABLE IF EXISTS `v_historial_completo`;
/*!50001 DROP VIEW IF EXISTS `v_historial_completo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_historial_completo` AS SELECT 
 1 AS `id_historial`,
 1 AS `espacio_nombre`,
 1 AS `estado_anterior`,
 1 AS `estado_nuevo`,
 1 AS `fecha_cambio`,
 1 AS `hora_cambio`,
 1 AS `hora_cierre`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_mantenimientos_pendientes`
--

DROP TABLE IF EXISTS `v_mantenimientos_pendientes`;
/*!50001 DROP VIEW IF EXISTS `v_mantenimientos_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_mantenimientos_pendientes` AS SELECT 
 1 AS `id_mantenimiento`,
 1 AS `espacio_nombre`,
 1 AS `responsable`,
 1 AS `fecha_inicio`,
 1 AS `fecha_fin`,
 1 AS `estado`,
 1 AS `dias_duracion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_reservas_activas`
--

DROP TABLE IF EXISTS `v_reservas_activas`;
/*!50001 DROP VIEW IF EXISTS `v_reservas_activas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_reservas_activas` AS SELECT 
 1 AS `id_reserva`,
 1 AS `fecha_reserva`,
 1 AS `hora_inicio`,
 1 AS `hora_fin`,
 1 AS `estado`,
 1 AS `espacio_nombre`,
 1 AS `espacio_capacidad`,
 1 AS `tipo_espacio`,
 1 AS `usuario_nombre`,
 1 AS `usuario_correo`,
 1 AS `usuario_rol`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'bdatos1'
--

--
-- Dumping routines for database 'bdatos1'
--
/*!50003 DROP PROCEDURE IF EXISTS `crear_reserva` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_reserva`(
    IN p_id_usuario INT,
    IN p_id_espacio INT,
    IN p_fecha_reserva DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME
)
BEGIN
    DECLARE conflicto INT DEFAULT 0;
    DECLARE espacio_nombre VARCHAR(100);
    DECLARE espacio_estado VARCHAR(20);
    
    -- Validar que la hora fin sea mayor que hora inicio
    IF p_hora_fin <= p_hora_inicio THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La hora de fin debe ser posterior a la hora de inicio';
    END IF;
    
    -- Verificar que el espacio existe y está disponible
    SELECT nombre, estado INTO espacio_nombre, espacio_estado
    FROM Espacio
    WHERE id_espacio = p_id_espacio;
    
    IF espacio_nombre IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El espacio especificado no existe';
    END IF;
    
    IF espacio_estado = 'Mantenimiento' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El espacio está en mantenimiento';
    END IF;
    
    -- Verificar conflictos de horario
    SELECT COUNT(*) INTO conflicto
    FROM Reserva
    WHERE id_espacio = p_id_espacio
      AND fecha_reserva = p_fecha_reserva
      AND estado = 'Activa'
      AND (
          (p_hora_inicio >= hora_inicio AND p_hora_inicio < hora_fin) OR
          (p_hora_fin > hora_inicio AND p_hora_fin <= hora_fin) OR
          (p_hora_inicio <= hora_inicio AND p_hora_fin >= hora_fin)
      );
    
    IF conflicto > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El espacio ya está reservado en ese horario';
    END IF;
    
    -- Insertar la reserva
    INSERT INTO Reserva (id_usuario, id_espacio, fecha_reserva, hora_inicio, hora_fin, estado)
    VALUES (p_id_usuario, p_id_espacio, p_fecha_reserva, p_hora_inicio, p_hora_fin, 'Activa');
    
    -- Actualizar estado del espacio si la reserva es para hoy
    IF p_fecha_reserva = CURDATE() AND CURTIME() BETWEEN p_hora_inicio AND p_hora_fin THEN
        UPDATE Espacio 
        SET estado = 'Reservado' 
        WHERE id_espacio = p_id_espacio;
    END IF;
    
    -- Registrar en log de acciones
    INSERT INTO log_acciones (id_usuario, accion, descripcion)
    VALUES (p_id_usuario, 'Crear Reserva', 
            CONCAT('Reserva creada para ', espacio_nombre, ' el ', p_fecha_reserva, ' de ', p_hora_inicio, ' a ', p_hora_fin));
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_espacios_disponibles`
--

/*!50001 DROP VIEW IF EXISTS `v_espacios_disponibles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_espacios_disponibles` AS select `e`.`id_espacio` AS `id_espacio`,`e`.`nombre` AS `nombre`,`e`.`capacidad` AS `capacidad`,`e`.`descripcion` AS `descripcion`,`e`.`estado` AS `estado`,`te`.`nombre_tipo` AS `tipo_espacio`,count(`r`.`id_recurso`) AS `cantidad_recursos` from ((`espacio` `e` left join `tipo_espacio` `te` on((`e`.`id_tipo_espacio` = `te`.`id_tipo_espacio`))) left join `recurso` `r` on((`e`.`id_espacio` = `r`.`id_espacio`))) where (`e`.`estado` = 'Disponible') group by `e`.`id_espacio`,`e`.`nombre`,`e`.`capacidad`,`e`.`descripcion`,`e`.`estado`,`te`.`nombre_tipo` order by `e`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_historial_completo`
--

/*!50001 DROP VIEW IF EXISTS `v_historial_completo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_historial_completo` AS select `h`.`id_historial` AS `id_historial`,`e`.`nombre` AS `espacio_nombre`,`h`.`estado_anterior` AS `estado_anterior`,`h`.`estado_nuevo` AS `estado_nuevo`,`h`.`fecha_cambio` AS `fecha_cambio`,`h`.`hora_cambio` AS `hora_cambio`,`h`.`hora_cierre` AS `hora_cierre` from (`historial` `h` join `espacio` `e` on((`h`.`id_espacio` = `e`.`id_espacio`))) order by `h`.`fecha_cambio` desc,`h`.`hora_cambio` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mantenimientos_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `v_mantenimientos_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mantenimientos_pendientes` AS select `m`.`id_mantenimiento` AS `id_mantenimiento`,`e`.`nombre` AS `espacio_nombre`,`u`.`nombre` AS `responsable`,`m`.`fecha_inicio` AS `fecha_inicio`,`m`.`fecha_fin` AS `fecha_fin`,`m`.`estado` AS `estado`,(to_days(coalesce(`m`.`fecha_fin`,curdate())) - to_days(`m`.`fecha_inicio`)) AS `dias_duracion` from ((`mantenimiento` `m` join `espacio` `e` on((`m`.`id_espacio` = `e`.`id_espacio`))) join `usuario` `u` on((`m`.`id_usuario` = `u`.`id_usuario`))) where (`m`.`estado` in ('Programado','En Proceso')) order by `m`.`fecha_inicio` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_reservas_activas`
--

/*!50001 DROP VIEW IF EXISTS `v_reservas_activas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_reservas_activas` AS select `r`.`id_reserva` AS `id_reserva`,`r`.`fecha_reserva` AS `fecha_reserva`,`r`.`hora_inicio` AS `hora_inicio`,`r`.`hora_fin` AS `hora_fin`,`r`.`estado` AS `estado`,`e`.`nombre` AS `espacio_nombre`,`e`.`capacidad` AS `espacio_capacidad`,`te`.`nombre_tipo` AS `tipo_espacio`,`u`.`nombre` AS `usuario_nombre`,`u`.`correo` AS `usuario_correo`,`rol`.`nombre_rol` AS `usuario_rol` from ((((`reserva` `r` join `espacio` `e` on((`r`.`id_espacio` = `e`.`id_espacio`))) left join `tipo_espacio` `te` on((`e`.`id_tipo_espacio` = `te`.`id_tipo_espacio`))) join `usuario` `u` on((`r`.`id_usuario` = `u`.`id_usuario`))) join `rol` on((`u`.`id_rol` = `rol`.`id_rol`))) where ((`r`.`estado` = 'Activa') and (`r`.`fecha_reserva` >= curdate())) order by `r`.`fecha_reserva`,`r`.`hora_inicio` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-17 16:51:02
