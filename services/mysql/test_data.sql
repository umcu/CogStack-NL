-- MySQL dump 10.13  Distrib 8.0.23, for osx10.15 (x86_64)
--
-- Host: 127.0.0.1    Database: patient_data
-- ------------------------------------------------------
-- Server version	8.0.27

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
-- Table structure for table `test_data`
--

DROP TABLE IF EXISTS `test_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_data` (
  `id` nvarchar(50) DEFAULT NULL,
  `patient_id` nvarchar(50) DEFAULT NULL,
  `authored` datetime DEFAULT NULL,
  `type` nvarchar(50) DEFAULT NULL,
  `text` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_data`
--

LOCK TABLES `test_data` WRITE;
/*!40000 ALTER TABLE `test_data` DISABLE KEYS */;
INSERT INTO `test_data` (`id`, `patient_id`, `authored`, `type`, `text`) VALUES ('1000000000','1234567','2021-12-01 09:24:20','Ontslagbericht','Anne de Vries is een 22-jarige vrouw bij wie enige tijd geleden acute myeloïde leukemie was vastgesteld.'),('1000000001','1234567','2021-12-02 09:25:19','Poliklinische Brief','De patiënte was alleen als kind gevaccineerd.'),('1000000002','2345678','2021-12-04 09:25:48','Spoedeisende Hulp','Marie de Jong, een 53-jarige vrouw, bezoekt ons spreekuur vanwege een verhoogde bloeddruk.'),('1000000003','3456789','2021-12-10 09:26:12','Poliklinische Brief','Piet Jansen werd behandeld voor diabetes mellitus type 2 met metformine 2 dd 1000 mg, gliclazide 3 dd 80 mg en NPH-insuline 32 eenheden voor de nacht.'),('1000000004','3456789','2021-12-10 21:26:49','Spoedeisende Hulp','Een intensivering van de bloedglucoseverlagende behandeling was nodig, tot 4 maal daags insulinetherapie.');
/*!40000 ALTER TABLE `test_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-03 18:26:20
