-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 15. Jun 2021 um 20:09
-- Server-Version: 10.1.48-MariaDB-0+deb9u2
-- PHP-Version: 7.4.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `autotestserver`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `keko_adminmenu`
--

CREATE TABLE `keko_adminmenu` (
  `token` longtext COLLATE utf8mb4_bin,
  `license` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetname` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourcename` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `expiration` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `keko_adminmenu`
--
ALTER TABLE `keko_adminmenu`
  ADD PRIMARY KEY (`license`) USING BTREE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
