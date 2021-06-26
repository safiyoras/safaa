-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 06, 2021 at 02:00 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `acc_rec` ()  NO SQL
BEGIN
CREATE TEMPORARY TABLE d 
select name,phon,SUM(food.price*orderss.quintity)  n FROM costomer,orderss,food WHERE costomer.cust_no=orderss.cust_no AND food.fd_no=orderss.fd_no GROUP BY costomer.name;
CREATE TEMPORARY TABLE f 
SELECT name, sum(payment.amount) s FROM costomer,payment WHERE payment.ord_no=costomer.cust_no GROUP BY name;
select d.name,d.phon Phone, ((ifnull(n,0))-(ifnull(s,0))) amount FROM d LEFT JOIN f on d.name=f.name ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `acc_rece` (IN `magaca` VARCHAR(40))  NO SQL
BEGIN
CREATE TEMPORARY TABLE d 
select name,phon,SUM(food.price*orderss.quintity)  n FROM costomer,orderss,food WHERE costomer.cust_no=orderss.cust_no AND food.fd_no=orderss.fd_no and name=magaca GROUP BY costomer.name;
CREATE TEMPORARY TABLE f 
SELECT name, sum(payment.amount) s FROM costomer,payment WHERE payment.ord_no=costomer.cust_no  and name = magaca GROUP BY name;
select d.name,d.phon Phone, ((ifnull(n,0))-(ifnull(s,0))) amount FROM d LEFT JOIN f on d.name=f.name ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_proc` (IN `degmo` VARCHAR(40), IN `xafad` VARCHAR(40), IN `zone` VARCHAR(40), IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
when (oper='insert')THEN
if EXISTS(SELECT* from address where add_no=id)THEN
SELECT 'already exists' as result;
else 
insert into address VALUES(null,degmo,xafad,zone);
select 'successfully' as result;
end if;
WHEN (oper='update')THEN
if EXISTS(SELECT*from address where add_no=id)THEN
UPDATE address SET district=degmo,village=xafad,area=zone WHERE add_no=id;
SELECT 'update seccesfully' as result;
ELSE
SELECT concat ('this',' ', id,' ', 'is not exists') as result;
END IF;
WHEN(oper='delete')THEN
if EXISTS(SELECT*FROM address WHERE add_no=id)THEN
DELETE from address WHERE add_no=id;
SELECT 'delete seccesfully' as result;
ELSE
SELECT concat ('this',' ',id,' ', 'is not exists') as result;
end IF;
end case;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_view` ()  NO SQL
SELECT add_no id,district ,village,area FROM address$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chef_proc` (IN `magaca` VARCHAR(40), IN `nooca` INT, IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
WHEN(oper='insert')THEN
if EXISTS(select * from orders where ord_no=nooca)then
if EXISTS (SELECT*from chef WHERE name=magaca and ord_no=nooca)THEN
SELECT 'all ready exsts' as result;
ELSE
insert INTO chef VALUES(null,magaca,nooca);
select 'insert successfully' as result;
end if;
else
select ('this orders is not exists') as result;
end if;
WHEN (oper='update')THEN
if EXISTS (SELECT*from chef WHERE chef_no=id)THEN
UPDATE chef SET name=magaca,ord_no=nooca WHERE chef_no=id;
SELECT 'update successfully' as result;
ELSE
SELECT concat('this' ,' ', id, ' ', 'is not exsts') as result;
end IF;
WHEN (oper='delete')THEN
if EXISTS (SELECT*from chef WHERE chef_no=id)THEN
DELETE FROM chef WHERE chef_no=id;
SELECT 'delete successfully' as result;
ELSE
SELECT concat('this' ,' ', id, ' ', 'is not exsts') as result;
end IF;
END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chef_view` ()  NO SQL
SELECT chef_no id,name,or_name from chef c,orderss o WHERE c.ord_no=o.or_no$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cost_proc` (IN `magaca` VARCHAR(40), IN `tell` VARCHAR(40), IN `gmail` VARCHAR(100), IN `meesha` INT, IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
WHEN oper='insert' THEN
if EXISTS(SELECT * FROM costomer WHERE name=magaca and add_no=meesha)THEN

SELECT 'all ready exists' as result;
ELSE
INSERT into costomer VALUES(null,magaca,tell,gmail,meesha);
SELECT 'insert successfull' as result;
end if;
WHEN oper='update' THEN
if EXISTS(SELECT*FROM costomer WHERE cust_no=id)THEN
UPDATE costomer set name=magaca,add_no=meesha WHERE cust_no=id;
SELECT 'update successfully' as result;

ELSE
SELECT concat(' this' ,' ', id, ' ', 'is not exsits') as result;
end if;
WHEN oper='delete' THEN
if EXISTS(SELECT * FROM costomer WHERE cust_no=id) THEN
DELETE FROM costomer WHERE cust_no=id;
SELECT 'delete successfull' as result;
ELSE
SELECT concat('this' ,' ', id, ' ', 'is not EXISTS') as result;
end IF;
end CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cost_view` ()  NO SQL
SELECT cust_no,name,phon,email,concat(district,' ',village,' ',area)address FROM costomer c,address a WHERE
c.add_no=a.add_no$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dev_proc` (IN `ord_id` INT, IN `meesha` VARCHAR(100), IN `lcgta_dev` DOUBLE, IN `taariikh` DATE, IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
WHEN(oper='insert')THEN
if EXISTS(SELECT*FROM orderss WHERE  or_no=ord_id)THEN
INSERT INTO deliver VALUES(null,ord_id,meesha,lcgta_dev,taariikh);
SELECT 'insert successfully' as result;
ELSE
SELECT ('this order is not exists') as result;
end if;
WHEN(oper='update')THEN
if EXISTS(SELECT*FROM deliver WHERE  dev_no=id)THEN
UPDATE deliver SET or_no=ord_id and stust=meesha and addition_cust=lcgta_dev and dev_date=taariikh WHERE dev_no=id;
SELECT 'update successfully' as result;
ELSE
SELECT concat('this' ,' ', id, ' ', 'is not exists') as result;
end if;
WHEN oper='delete' THEN
if EXISTS (SELECT * FROM deliver WHERE dev_no=id) THEN 
DELETE FROM deliver WHERE dev_no=id;
SELECT 'delete successfully' as result;
ELSE
SELECT concat('this', ' ', id, ' ', 'is not exists') as result;
end if;       
end CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dev_view` ()  NO SQL
SELECT dev_no id,or_name,stust,addition_cust,dev_date FROM deliver D,orderss O WHERE D.ord_no=O.or_no$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fd_proc` (IN `magaca` VARCHAR(40), IN `qiimah` DOUBLE, IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
WHEN(oper='insert')THEN
if EXISTS(SELECT*FROM food WHERE fd_no=id and price=qiimah)THEN
SELECT 'all ready exists' as result;
ELSE
INSERT INTO food VALUES(null,magaca,qiimah);
SELECT 'insert successfully' as result;
end if;
WHEN(oper='update')THEN
if EXISTS(SELECT*FROM food WHERE  fd_no=id)THEN
UPDATE food SET fd_name=magaca AND price=qiimah WHERE fd_no=id;
SELECT 'update successfully' as result;
ELSE
SELECT concat('this' ,' ', id, ' ', 'is not exists') as result;
end if;
WHEN oper='delete' THEN
if EXISTS (SELECT * FROM food WHERE fd_no=id) THEN 
DELETE FROM food WHERE fd_no=id;
SELECT 'delete successfully' as result;
ELSE
SELECT concat('this', ' ', id, ' ', 'is not exists') as result;
end if;       
end CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `food_view` ()  NO SQL
SELECT fd_no id,fd_name,price FROM food$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_proce` (IN `magac` VARCHAR(40), IN `taariikh` DATE, IN `cust_id` INT, IN `fd_id` INT, IN `qty` INT, IN `oper` VARCHAR(40), IN `id` INT)  NO SQL
BEGIN
CASE
when oper='update' THEN
if EXISTS(SELECT * FROM orderss WHERE or_no=id) THEN
UPDATE orderss set or_name=magac , or_data=taariikh, cust_no=cust_id, fd_no=fd_id, quaintity=qty WHERE or_no=id;
SELECT 'updated successfulyy' as result;
ELSE
SELECT 'id is not exists' as result;
end if;
when oper='delete' THEN
if EXISTS(SELECT * FROM orderss WHERE or_no=id) THEN
DELETE FROM orderss  WHERE or_no=id;
SELECT 'deleted successfulyy' as result;
ELSE
SELECT 'id is not exists' as result;
end if;
when oper='insert' THEN
#if EXISTS(SELECT * FROM orders WHERE ord_no=id) THEN
#SELECT 'already exists' as result;
#ELSE
INSERT into orderss VALUES(null,magac,taariikh,cust_id,fd_id,qty) ;
SELECT 'insert successfulyy' as result;
#end if;
end case;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_view` ()  NO SQL
BEGIN
SELECT or_no id ,or_name ordername,or_date ,name customer, fd_name food, quintity FROM orderss o,costomer c,food f  WHERE c.cust_no=o.cust_no and f.fd_no=o.fd_no;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pay_proc` (IN `ordername` VARCHAR(30), IN `tarikh` DATE, IN `Amount` DOUBLE, IN `oper` VARCHAR(30), IN `id` INT)  BEGIN
CASE
WHEN oper="insert"THEN
INSERT into payment VALUES (null,ordername,tarikh,Amount);
SELECT 'inserted seccessfully'as result;
end case;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pay_view` ()  NO SQL
SELECT py_no id, concat(name,' ',phon) customer,py_date, amount FROM payment p,costomer o WHERE o.cust_no=p.ord_no$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statemet` ()  NO SQL
BEGIN 
 
CREATE TEMPORARY TABLE qaadasho SELECT name magac, or_name ordername ,or_date taarikh,
(quintity*price)Dr ,0 Cr FROM costomer c,orderss o,food f 
WHERE c.cust_no=o.cust_no and f.fd_no=o.fd_no ORDER BY or_date ;

INSERT INTO qaadasho SELECT name magac, or_name ordername,py_date taarikh,0 
Dr,(amount) Cr FROM costomer c,orderss o,payment p 
WHERE c.cust_no=o.cust_no and p.ord_no=o.or_no ORDER BY py_date;

SET @bal=0;
SELECT magac ,ordername ,taarikh,Dr,Cr,@bal:=(@bal+Dr-Cr)Balance FROM qaadasho ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statemets` (IN `magaca` VARCHAR(40))  NO SQL
BEGIN 
 
CREATE TEMPORARY TABLE qaadasho SELECT name magac, or_name ordername ,or_date taarikh,
(quintity*price) Dr ,0 Cr FROM costomer c,orderss o,food f 
WHERE c.cust_no=o.cust_no and f.fd_no=o.fd_no  HAVING name=magaca ORDER BY or_date ;

INSERT INTO qaadasho SELECT name magac, or_name ordername,py_date taarikh,0 
Dr,(amount) Cr FROM costomer c,orderss o,payment p 
WHERE c.cust_no=o.cust_no and p.ord_no=o.or_no HAVING name=magaca ORDER BY py_date;

SET @bal=0;
SELECT magac ,ordername ,taarikh,Dr,Cr,@bal:=(@bal+Dr-Cr)Balance FROM qaadasho ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_proc` (IN `username` VARCHAR(30), IN `password` VARCHAR(40), IN `oper` VARCHAR(40), IN `id` INT)  BEGIN
CASE
WHEN oper="insert"THEN
INSERT INTO usres VALUES (null,username,password);
SELECT 'inserted seccesfuly'as result;

end CASE;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_view` ()  NO SQL
SELECT usr_no id,usr_name,PASSWORD FROM usres$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `deen` (`cname` VARCHAR(50)) RETURNS INT(11) BEGIN
SET @a=0;
CREATE TEMPORARY TABLE d select name,GROUP_CONCAT(orderss.or_name),SUM(food.price*orderss.quintity)  n FROM costomer,orderss,food WHERE costomer.cust_no=orderss.cust_no AND food.fd_no=orderss.fd_no AND concat(name,' ',phon)=cname GROUP BY costomer.name;
CREATE TEMPORARY TABLE f SELECT name, sum(payment.amount) s FROM costomer,payment WHERE payment.ord_no=costomer.cust_no AND concat(name,' ',phon)=cname GROUP BY name;
select ((ifnull(n,0))-(ifnull(s,0))) am FROM f LEFT JOIN d on d.name=f.name into @a;
RETURN @a;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `add_no` int(11) NOT NULL,
  `district` varchar(40) NOT NULL,
  `village` varchar(50) NOT NULL,
  `area` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`add_no`, `district`, `village`, `area`) VALUES
(28, 'ceelasha', 'ramadaan', 'maskidka ramaad'),
(6, 'ceelesha', 'quraca', 'jabadgeele'),
(2, 'hodan', 'albarako', 'masaajidka quraca'),
(23, 'hodan', 'albarako', 'quraca'),
(10, 'hodan', 'albarako', 'sheekh ali suufi'),
(7, 'hodan', 'albarako', 'xiraruush'),
(8, 'hodan', 'taleex', 'carwada'),
(16, 'hoooyo', 'wardhiigleey', 'hodan'),
(9, 'howlwadaag', 'isgooska ', 'jid mariixaan'),
(14, 'howlwadaag', 'jid mariixaan', 'syd'),
(27, 'howlwadaag', 'jidmariixaan', 'syd'),
(1, 'Karaan', 'aargada', 'neel'),
(12, 'madiino', 'suuqweeyn', 'macmacaanka'),
(11, 'madiino', 'suuqweeyn', 'masjidka qunbulusoow'),
(3, 'mogadisho', 'howlwdaag', 'bakaaro'),
(26, 'syd', 'level 3', 'room 4');

-- --------------------------------------------------------

--
-- Stand-in structure for view `adress`
-- (See below for the actual view)
--
CREATE TABLE `adress` (
`NO` int(11)
,`degmo` varchar(40)
,`xaafad` varchar(50)
,`Zone` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `chef`
--

CREATE TABLE `chef` (
  `chef_no` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `ord_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `costomer`
--

CREATE TABLE `costomer` (
  `cust_no` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `phon` varchar(40) NOT NULL,
  `email` varchar(30) NOT NULL,
  `add_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `costomer`
--

INSERT INTO `costomer` (`cust_no`, `name`, `phon`, `email`, `add_no`) VALUES
(3, 'xawo', '0615678789', 'xafso@gmail.com', 12),
(4, 'xaawo', '0615878379', 'safiyo@gmail.com', 3),
(5, 'samiir', '0614162799', 'samiir@gmail.com', 10),
(7, 'sahal', '0615679892', 'sahal@gmail.com', 6),
(8, 'kahiye', '0612119295', 'kaahiye@gmail.com', 1),
(10, 'zaki', '0613719505', 'zaki@gmail.com', 11),
(11, 'canab', '0612678267', 'canab@gmail.com', 11),
(27, 'abdiaziiz', '0615712961', 'abdi@gmail.com', 2),
(28, 'hooyomcnto', '0615878379', 'hooyo@gmail.com', 2),
(29, 'hani', '432423', 'hani@gmail.com', 6),
(30, 'cali', '43532', 'cali@gmail.com', 2),
(31, 'kaahiye', '061876543', 'kaahiye@gmail.com', 12),
(33, 'samiir', '061783627', 'samiir@gmail.com', 2),
(36, 'meeymuun', '0615878379', 'meeymuun', 2),
(37, 'kaahiye', '0614567', 'kaahiye@gmail.com', 6),
(38, 'samiir', '071467825', 'samiir@gmail.com', 26),
(39, 'abuubakar', '0612330992', 'abuubakar@gmail.com', 28);

-- --------------------------------------------------------

--
-- Stand-in structure for view `costview`
-- (See below for the actual view)
--
CREATE TABLE `costview` (
`cust_no` int(11)
,`name` varchar(40)
,`phon` varchar(40)
,`email` varchar(30)
,`address` varchar(142)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `customerview`
-- (See below for the actual view)
--
CREATE TABLE `customerview` (
`No` int(11)
,`Name` varchar(40)
,`Tell` varchar(40)
,`Email` varchar(30)
,`District` varchar(40)
,`Village` varchar(50)
,`Zone` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `deliver`
--

CREATE TABLE `deliver` (
  `dev_no` int(11) NOT NULL,
  `ord_no` int(11) NOT NULL,
  `stust` varchar(40) NOT NULL,
  `addition_cust` int(11) NOT NULL,
  `dev_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `deliver`
--

INSERT INTO `deliver` (`dev_no`, `ord_no`, `stust`, `addition_cust`, `dev_date`) VALUES
(1, 2, 'barkaaro', 18, '2021-02-10'),
(3, 1, '1', 2, '2424-08-09'),
(4, 2, '2', 2, '2424-08-09'),
(10, 2, '1', 3, '2021-02-23'),
(12, 1, 'ed', 23, '2021-04-30'),
(13, 1, 'ed', 23, '2021-04-30'),
(14, 5, 'ed', 23, '2021-04-30'),
(15, 1, 'ed', 23, '2021-04-30'),
(16, 14, 'syd ', 2, '2021-04-28'),
(17, 15, 'ceelasha masjidka ramadaa', 3, '2021-04-30');

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `fd_no` int(11) NOT NULL,
  `fd_name` varchar(40) NOT NULL,
  `price` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`fd_no`, `fd_name`, `price`) VALUES
(1, 'canjjera', 1),
(3, 'bariis', 2),
(5, 'pizza', 8),
(6, 'canjeero', 3),
(8, 'canbuulo', 8),
(9, 'lazanyo', 5),
(10, 'sanbuus', 2),
(11, 'ukun', 1),
(12, 'qamadi', 1),
(13, 'Shuwaarmo', 3),
(28, 'baasto', 1),
(29, 'bariis', 1),
(30, 'bariis', 3),
(32, 'baasto', 1),
(33, 'afur', 10),
(34, 'sanbuus', 10),
(35, 'pizz', 8),
(36, 'bariis,dooro,chips', 20);

-- --------------------------------------------------------

--
-- Table structure for table `orderss`
--

CREATE TABLE `orderss` (
  `or_no` int(11) NOT NULL,
  `or_name` varchar(30) NOT NULL,
  `or_date` date NOT NULL,
  `cust_no` int(11) NOT NULL,
  `fd_no` int(11) NOT NULL,
  `quintity` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orderss`
--

INSERT INTO `orderss` (`or_no`, `or_name`, `or_date`, `cust_no`, `fd_no`, `quintity`) VALUES
(1, 'hilib ', '2021-04-05', 11, 10, 5),
(2, 'casho', '2021-02-23', 11, 11, 2),
(5, 'casho', '2021-04-29', 27, 3, 2),
(6, 'casho', '2021-04-29', 27, 3, 2),
(7, 'casho', '2021-04-29', 27, 3, 2),
(8, 'qado', '2021-04-29', 8, 3, 3),
(9, 'casaryo', '2021-04-30', 5, 5, 8),
(10, 'quraac', '2021-04-03', 3, 10, 7),
(11, 'casho', '2021-04-15', 7, 5, 2),
(12, 'saxuur', '2021-04-30', 36, 28, 1),
(13, 'afur', '2021-04-29', 37, 10, 20),
(14, 'casho', '2021-04-28', 38, 35, 2),
(15, 'qado', '2021-04-30', 39, 36, 1);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `py_no` int(11) NOT NULL,
  `ord_no` int(11) NOT NULL,
  `py_date` date NOT NULL,
  `amount` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`py_no`, `ord_no`, `py_date`, `amount`) VALUES
(2, 3, '2021-04-28', 1),
(5, 4, '2021-04-08', 1),
(6, 7, '2021-04-29', 3),
(7, 30, '2021-04-30', 2),
(8, 31, '2021-04-30', 2),
(9, 11, '2021-04-16', 3),
(10, 11, '2021-04-28', 1),
(13, 3, '2021-04-23', 13),
(14, 4, '2021-04-23', -1),
(15, 36, '2021-04-30', 1),
(16, 37, '2021-04-29', 5),
(17, 38, '2021-04-28', 16),
(18, 39, '2021-04-30', 20);

-- --------------------------------------------------------

--
-- Table structure for table `usres`
--

CREATE TABLE `usres` (
  `usr_no` int(11) NOT NULL,
  `usr_name` varchar(30) NOT NULL,
  `PASSWORD` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `usres`
--

INSERT INTO `usres` (`usr_no`, `usr_name`, `PASSWORD`) VALUES
(1, 'ahmed', '1122'),
(2, 'safiyo', '1234'),
(3, 'ahmed', '123'),
(4, 'safiyo', '12345'),
(5, 'abdiaziiz', '1234');

-- --------------------------------------------------------

--
-- Structure for view `adress`
--
DROP TABLE IF EXISTS `adress`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `adress`  AS SELECT `address`.`add_no` AS `NO`, `address`.`district` AS `degmo`, `address`.`village` AS `xaafad`, `address`.`area` AS `Zone` FROM `address` ;

-- --------------------------------------------------------

--
-- Structure for view `costview`
--
DROP TABLE IF EXISTS `costview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `costview`  AS SELECT `c`.`cust_no` AS `cust_no`, `c`.`name` AS `name`, `c`.`phon` AS `phon`, `c`.`email` AS `email`, concat(`a`.`district`,' ',`a`.`village`,' ',`a`.`area`) AS `address` FROM (`costomer` `c` join `address` `a`) WHERE `c`.`add_no` = `a`.`add_no` ;

-- --------------------------------------------------------

--
-- Structure for view `customerview`
--
DROP TABLE IF EXISTS `customerview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customerview`  AS SELECT `costomer`.`cust_no` AS `No`, `costomer`.`name` AS `Name`, `costomer`.`phon` AS `Tell`, `costomer`.`email` AS `Email`, `address`.`district` AS `District`, `address`.`village` AS `Village`, `address`.`area` AS `Zone` FROM (`address` join `costomer`) WHERE `address`.`add_no` = `costomer`.`add_no` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`add_no`),
  ADD KEY `add_index` (`district`,`village`,`area`);

--
-- Indexes for table `chef`
--
ALTER TABLE `chef`
  ADD PRIMARY KEY (`chef_no`),
  ADD KEY `chef_ibfk_1` (`ord_no`);

--
-- Indexes for table `costomer`
--
ALTER TABLE `costomer`
  ADD PRIMARY KEY (`cust_no`),
  ADD KEY `con_pk_add1` (`add_no`);

--
-- Indexes for table `deliver`
--
ALTER TABLE `deliver`
  ADD PRIMARY KEY (`dev_no`),
  ADD KEY `con_pk_ord` (`ord_no`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`fd_no`);

--
-- Indexes for table `orderss`
--
ALTER TABLE `orderss`
  ADD PRIMARY KEY (`or_no`),
  ADD KEY `fk_cus1` (`cust_no`),
  ADD KEY `fk_fd1` (`fd_no`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`py_no`),
  ADD KEY `con_pk_ord2` (`ord_no`);

--
-- Indexes for table `usres`
--
ALTER TABLE `usres`
  ADD PRIMARY KEY (`usr_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `add_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `chef`
--
ALTER TABLE `chef`
  MODIFY `chef_no` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `costomer`
--
ALTER TABLE `costomer`
  MODIFY `cust_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `deliver`
--
ALTER TABLE `deliver`
  MODIFY `dev_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
  MODIFY `fd_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `orderss`
--
ALTER TABLE `orderss`
  MODIFY `or_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `py_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `usres`
--
ALTER TABLE `usres`
  MODIFY `usr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chef`
--
ALTER TABLE `chef`
  ADD CONSTRAINT `chef_ibfk_1` FOREIGN KEY (`ord_no`) REFERENCES `orderss` (`or_no`) ON UPDATE CASCADE;

--
-- Constraints for table `costomer`
--
ALTER TABLE `costomer`
  ADD CONSTRAINT `con_pk_add1` FOREIGN KEY (`add_no`) REFERENCES `address` (`add_no`) ON UPDATE CASCADE;

--
-- Constraints for table `deliver`
--
ALTER TABLE `deliver`
  ADD CONSTRAINT `con_pk_ord` FOREIGN KEY (`ord_no`) REFERENCES `orderss` (`or_no`) ON UPDATE CASCADE;

--
-- Constraints for table `orderss`
--
ALTER TABLE `orderss`
  ADD CONSTRAINT `fk_cus1` FOREIGN KEY (`cust_no`) REFERENCES `costomer` (`cust_no`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_fd1` FOREIGN KEY (`fd_no`) REFERENCES `food` (`fd_no`) ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `con_pk_ord2` FOREIGN KEY (`ord_no`) REFERENCES `costomer` (`cust_no`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
