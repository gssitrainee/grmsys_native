﻿-- Script was generated by Devart dbForge Studio for MySQL, Version 6.0.128.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 9/5/2015 9:28:59 PM
-- Server version: 5.6.26-log
-- Client version: 4.1

-- 
-- Disable foreign keys
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

-- 
-- Set default database
--
USE grmsys_db;

--
-- Definition for table user
--
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(45) NOT NULL,
  password VARCHAR(100) NOT NULL,
  firstname VARCHAR(45) NOT NULL,
  lastname VARCHAR(45) NOT NULL,
  middlename VARCHAR(45) DEFAULT NULL,
  contactno VARCHAR(25) DEFAULT NULL,
  address MEDIUMTEXT DEFAULT NULL,
  birthdate DATE DEFAULT NULL,
  gender CHAR(1) NOT NULL DEFAULT 'M',
  is_active TINYINT(4) NOT NULL DEFAULT 1,
  role_type VARCHAR(50) NOT NULL DEFAULT 'attendant',
  creation_date DATETIME NOT NULL,
  last_modified_date DATETIME DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id),
  UNIQUE INDEX username_UNIQUE (username)
)
ENGINE = INNODB
AUTO_INCREMENT = 1019
AVG_ROW_LENGTH = 1365
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'System Users Table containing user information. This table could be divided into plain user login info and user profile infos.';

--
-- Definition for table item
--
DROP TABLE IF EXISTS item;
CREATE TABLE item (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  price DECIMAL(11, 2) NOT NULL DEFAULT 0.00,
  other_info TEXT DEFAULT NULL,
  user_id INT(10) UNSIGNED NOT NULL DEFAULT 1,
  creation_date DATETIME DEFAULT NULL,
  last_modified_date DATETIME DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id),
  CONSTRAINT FK_item_user_id FOREIGN KEY (user_id)
    REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 104
AVG_ROW_LENGTH = 4096
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Definition for table member
--
DROP TABLE IF EXISTS member;
CREATE TABLE member (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  firstname VARCHAR(45) NOT NULL,
  lastname VARCHAR(45) NOT NULL,
  middlename VARCHAR(45) DEFAULT NULL,
  contactno VARCHAR(25) DEFAULT NULL,
  address TEXT DEFAULT NULL,
  birthdate DATE DEFAULT NULL,
  gender CHAR(1) DEFAULT 'M',
  emergency_contact_person VARCHAR(125) NOT NULL,
  emergency_contact_number VARCHAR(25) NOT NULL,
  emergency_contact_relationship VARCHAR(45) NOT NULL,
  creation_date DATETIME NOT NULL,
  last_modified_date DATETIME DEFAULT NULL,
  user_id INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id),
  CONSTRAINT fk_member_user_id FOREIGN KEY (user_id)
    REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1012
AVG_ROW_LENGTH = 1638
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'System members table. This table holds info regarding membership profile(s).';

--
-- Definition for table item_sales
--
DROP TABLE IF EXISTS item_sales;
CREATE TABLE item_sales (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  item_id INT(10) UNSIGNED NOT NULL DEFAULT 0,
  qty INT(11) NOT NULL,
  amount DECIMAL(11, 2) NOT NULL,
  sales_date DATETIME NOT NULL,
  member_id INT(11) UNSIGNED DEFAULT NULL,
  user_id INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  INDEX fk_item_id_idx (item_id),
  UNIQUE INDEX id_UNIQUE (id),
  CONSTRAINT fk_item_sales_item_id FOREIGN KEY (item_id)
    REFERENCES item(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_item_sales_member_id FOREIGN KEY (member_id)
    REFERENCES member(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_item_sales_user_id FOREIGN KEY (user_id)
    REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Definition for table membership_type
--
DROP TABLE IF EXISTS membership_type;
CREATE TABLE membership_type (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  member_id INT(10) UNSIGNED NOT NULL,
  type VARCHAR(15) DEFAULT 'Walk-in',
  discounted TINYINT(1) DEFAULT 0,
  service_type VARCHAR(15) DEFAULT 'weights',
  monthly_startdate DATE DEFAULT NULL,
  monthly_enddate DATE DEFAULT NULL,
  creation_date DATETIME NOT NULL,
  last_modified_date DATETIME DEFAULT NULL,
  user_id INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id),
  CONSTRAINT fk_membership_type_member_id FOREIGN KEY (member_id)
    REFERENCES member(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_membership_type_user_id FOREIGN KEY (user_id)
    REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 11
AVG_ROW_LENGTH = 2048
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Membership Type table. Holds information about the type of membership like walk-in/monthly, services applied, discounted, etc.';

--
-- Definition for table workout_sales
--
DROP TABLE IF EXISTS workout_sales;
CREATE TABLE workout_sales (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  member_id INT(10) UNSIGNED NOT NULL DEFAULT 0,
  workout_date DATE NOT NULL,
  service_type VARCHAR(15) NOT NULL DEFAULT 'weights',
  rendered_amount DECIMAL(11, 2) NOT NULL DEFAULT 0.00,
  creation_date DATETIME DEFAULT NULL,
  user_id INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  INDEX fk_member_id_idx (member_id),
  INDEX fk_user_id_idx (user_id),
  UNIQUE INDEX id_UNIQUE (id),
  CONSTRAINT fk_workout_sales_member_id FOREIGN KEY (member_id)
    REFERENCES member(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_workout_sales_user_id FOREIGN KEY (user_id)
    REFERENCES user(id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DELIMITER $$

--
-- Definition for procedure pAddOrUpdateItem
--
DROP PROCEDURE IF EXISTS pAddOrUpdateItem$$
CREATE PROCEDURE pAddOrUpdateItem(IN pItemId INT, IN pItemName VARCHAR(100), IN pItemPrice DECIMAL(11,2), IN pOtherInfo TEXT, IN pUserId INT)
  SQL SECURITY INVOKER
BEGIN
  IF 0 < pItemId THEN
    UPDATE item SET
      name = pItemName,
      price = pItemPrice,
      other_info = pOtherInfo,
      last_modified_date = now()
    WHERE id = pItemId;
  ELSE
    INSERT INTO item(name, price, other_info, user_id, creation_date, last_modified_date) VALUES(pItemName, pItemPrice, pOtherInfo, pUserId, now(), now());
  END IF;

  COMMIT;
END
$$

--
-- Definition for procedure pAddOrUpdateMemberInfo
--
DROP PROCEDURE IF EXISTS pAddOrUpdateMemberInfo$$
CREATE PROCEDURE pAddOrUpdateMemberInfo(IN pMemberId varchar(255), IN pFirstname varchar(50), IN pLastname varchar(50), IN pMiddlename varchar(50), IN pContactNo varchar(50), IN pAddress text, IN pBirthdate VARCHAR(25), IN pGender char(1), IN pEmergencyContactPerson varchar(255), IN pEmergencyContactNo varchar(50), IN pEmergencyContactRelation varchar(50), IN pMemberType varchar(255), IN pHasDiscount tinyint, IN pMemberServiceType varchar(255), IN pMonthlyStartDate VARCHAR(25), IN pMonthlyEndDate varchar(25), IN pUserId int(10))
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for adding member and member type.'
BEGIN
  IF 0 < pMemberId THEN
    SET @sqlStmt = CONCAT('UPDATE member SET firstname= ''', pFirstname,''', lastname= ''', pLastname,''', middlename= ''', pMiddlename,''', contactno= ''', pContactNo,''', address= ''', pAddress,''', ');
    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, 'birthdate=''', pBirthdate, ''', ');
    END IF;
    SET @sqlStmt = CONCAT(@sqlStmt, 'gender=''', pGender, ''', emergency_contact_person=''', pEmergencyContactPerson, ''', emergency_contact_number=''', pEmergencyContactNo, ''', emergency_contact_relationship=''', pEmergencyContactRelation, ''', last_modified_date=now() WHERE id=', pMemberId);

    SET @sqlStmtType = CONCAT('UPDATE membership_type SET type= ''', pMemberType, ''', discounted=''', pHasDiscount, ''', service_type=''', pMemberServiceType, ''', ');
    IF !ISNULL(pMonthlyStartDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, 'monthly_startdate=''', pMonthlyStartDate, ''', ');
    END IF;
    IF !ISNULL(pMonthlyEndDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, 'monthly_enddate=''', pMonthlyEndDate, ''', ');
    END IF;
    SET @sqlStmtType = CONCAT(@sqlStmtType, 'last_modified_date=now() WHERE member_id=', pMemberId);
  ELSE
     SET @sqlStmt = CONCAT('INSERT INTO MEMBER (firstname, lastname, middlename, contactno, address, ');
    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, 'birthdate,');
    END IF;
    SET @sqlStmt = CONCAT(@sqlStmt, 'gender, emergency_contact_person, emergency_contact_number, emergency_contact_relationship, user_id, creation_date, last_modified_date)');
    SET @sqlStmt = CONCAT(@sqlStmt, ' VALUES (''', pFirstname, ''', ''', pLastname, ''', ''', pMiddlename, ''', ''', pContactNo, ''', ''', pAddress, ''',''');
    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, pBirthdate, ''', ''');
    END IF;
    SET @sqlStmt = CONCAT(@sqlStmt, pGender, ''', ''', pEmergencyContactPerson, ''', ''', pEmergencyContactNo, ''', ''', pEmergencyContactRelation, ''', ''', pUserId, ''', now(), now())');


    SET @sqlStmtType = CONCAT('INSERT INTO MEMBERSHIP_TYPE (member_id, type, discounted, service_type,');
    IF !ISNULL(pMonthlyStartDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, ' monthly_startdate,');
    END IF;
    IF !ISNULL(pMonthlyEndDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, ' monthly_enddate,');
    END IF;
    SET @sqlStmtType = CONCAT(@sqlStmtType, ' user_id, creation_date, last_modified_date) VALUES (LAST_INSERT_ID(),''');
    SET @sqlStmtType = CONCAT(@sqlStmtType, pMemberType, ''' , ''', pHasDiscount, ''', ''' , pMemberServiceType, ''', ''');
    IF !ISNULL(pMonthlyStartDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, pMonthlyStartDate, ''' , ''');
    END IF;
    IF !ISNULL(pMonthlyEndDate) THEN
      SET @sqlStmtType = CONCAT(@sqlStmtType, pMonthlyEndDate, ''' , ''');
    END IF;
    SET @sqlStmtType = CONCAT(@sqlStmtType, pUserId, ''', now(), now())');
  END IF;

  PREPARE stmt FROM @sqlStmt;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  PREPARE stmtType FROM @sqlStmtType;
  EXECUTE stmtType;
  DEALLOCATE PREPARE stmtType;

END
$$

--
-- Definition for procedure pAddOrUpdateUser
--
DROP PROCEDURE IF EXISTS pAddOrUpdateUser$$
CREATE PROCEDURE pAddOrUpdateUser(IN pUserId INT, IN pUsername VARCHAR(50), IN pPassword VARCHAR(255), IN pFirstname VARCHAR(50), IN pLastname VARCHAR(50), IN pMiddlename VARCHAR(50), IN pContactNo VARCHAR(25), IN pAddress TEXT, IN pBirthdate VARCHAR(25), IN pGender CHAR(1), IN pType VARCHAR(255))
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for Adding or Updating User'
BEGIN
  IF 0 < pUserId THEN
    SET @sqlStmt = CONCAT('UPDATE User SET ','firstname=''', pFirstname, ''', lastname=''', pLastname, ''', middlename=''', pMiddlename, ''', contactno=''', pContactNo, ''', address=''',  pAddress);

    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, ''', birthdate=''', pBirthdate);
    END IF;

    SET @sqlStmt = CONCAT(@sqlStmt, ''', gender=''', pGender, ''', role_type=''', pType, ''', last_modified_date=now() WHERE id=', pUserId);
  ELSE
    SET @sqlStmt = CONCAT('INSERT INTO User(username, password, firstname, lastname, middlename, contactno, address,');
    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, ' birthdate,');
    END IF;
    SET @sqlStmt = CONCAT(@sqlStmt, ' gender, is_active, role_type, creation_date, last_modified_date) VALUES (''', pUsername, ''', md5(''',pPassword,'''), ''',pFirstname,''', ''', pLastname,''', ''', pMiddlename,''', ''',pContactNo,''', ''', pAddress,''',''');
    IF !ISNULL(pBirthdate) THEN
      SET @sqlStmt = CONCAT(@sqlStmt, pBirthdate, ''', ''');
    END IF;
    SET @sqlStmt = CONCAT(@sqlStmt, pGender, ''', 1, ''', pType, ''', now(), now())');
  END IF;

  PREPARE stmt FROM @sqlStmt;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END
$$

--
-- Definition for procedure pAddSellItem
--
DROP PROCEDURE IF EXISTS pAddSellItem$$
CREATE PROCEDURE pAddSellItem(IN pItemId INT, IN pItemQty VARCHAR(255), IN pTotalAmount DECIMAL, IN pMemberId INT, IN pUserId INT)
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for Adding sell item'
BEGIN
  INSERT INTO item_sales(item_id, qty, amount, sales_date, member_id, user_id) VALUES(pItemId, pItemQty, pTotalAmount, now(), pMemberId, pUserId);
  COMMIT;
END
$$

--
-- Definition for procedure pRegisterMemberWorkout
--
DROP PROCEDURE IF EXISTS pRegisterMemberWorkout$$
CREATE PROCEDURE pRegisterMemberWorkout(IN pMemberId INT, IN pServiceType VARCHAR(255), IN pAmount DECIMAL)
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for Registering Member Workout'
BEGIN
  INSERT INTO workout_sales(member_id, workout_date, service_type, rendered_amount, creation_date, last_modified_date) VALUES(pMemberId, now(), pServiceType, pAmount, now(), now());
  COMMIT;
END
$$

--
-- Definition for procedure pRemoveItem
--
DROP PROCEDURE IF EXISTS pRemoveItem$$
CREATE PROCEDURE pRemoveItem(IN pItemId VARCHAR(255))
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for removing an item.'
BEGIN
  DECLARE nItemCount INT(10);

  DECLARE exit handler for sqlexception
    BEGIN
      -- ERROR
    ROLLBACK;
  END;
  
  DECLARE exit handler for sqlwarning
   BEGIN
      -- WARNING
   ROLLBACK;
  END;

  SELECT COUNT(is1.id) INTO nItemCount FROM item_sales is1 WHERE is1.item_id = pItemId;

  IF 0 = nItemCount THEN
    START TRANSACTION;
    DELETE FROM ITEM_SALES WHERE ITEM_ID = pItemId;
    DELETE FROM ITEM WHERE ID = pItemId;
    COMMIT;
  END IF;

END
$$

--
-- Definition for procedure pRemoveMember
--
DROP PROCEDURE IF EXISTS pRemoveMember$$
CREATE PROCEDURE pRemoveMember(IN pMemberId VARCHAR(255))
  SQL SECURITY INVOKER
BEGIN
  DECLARE nMemberCount INT(10);

  DECLARE exit handler for sqlexception
    BEGIN
      -- ERROR
    ROLLBACK;
  END;
  
  DECLARE exit handler for sqlwarning
   BEGIN
      -- WARNING
   ROLLBACK;
  END;

  SELECT COUNT(ws.id) INTO nMemberCount FROM workout_sales ws WHERE ws.member_id = pMemberId;

  IF 0 = nMemberCount THEN
    START TRANSACTION;
    DELETE FROM MEMBERSHIP_TYPE WHERE MEMBER_ID = pMemberId;
    DELETE FROM MEMBER WHERE ID = pMemberId;
    COMMIT;
  END IF;

END
$$

--
-- Definition for procedure pRemoveUser
--
DROP PROCEDURE IF EXISTS pRemoveUser$$
CREATE DEFINER = 'root'@'localhost'
PROCEDURE pRemoveUser(IN pUserId INT)
BEGIN
  UPDATE USER SET is_active = 0 WHERE id = pUserId;
  COMMIT;
END
$$

--
-- Definition for procedure pUpdateMasterPassword
--
DROP PROCEDURE IF EXISTS pUpdateMasterPassword$$
CREATE PROCEDURE pUpdateMasterPassword(IN pMasterPassword VARCHAR(255), IN pNewPassword VARCHAR(255))
  SQL SECURITY INVOKER
BEGIN
  IF !ISNULL(pMasterPassword) AND !ISNULL(pNewPassword) THEN
    IF 0 < fnCheckMasterPassword(pMasterPassword) THEN
      UPDATE user
      SET password = pNewPassword
      WHERE username = 'administrator';
      COMMIT;
    END IF;
  END IF;
END
$$

--
-- Definition for procedure pUpdateUserPassword
--
DROP PROCEDURE IF EXISTS pUpdateUserPassword$$
CREATE PROCEDURE pUpdateUserPassword(IN pUsername VARCHAR(50), IN pUserPassword VARCHAR(100), IN pNewPassword VARCHAR(100))
  SQL SECURITY INVOKER
  COMMENT 'Stored Procedure for changing user password'
BEGIN
  IF !ISNULL(pUsername) AND !ISNULL(pUserPassword) AND !ISNULL(pNewPassword) THEN
    IF 0 < fnCheckUserLogin(pUsername, pUserPassword) THEN
      UPDATE user
      SET password = md5(pNewPassword)
      WHERE username = pUsername;
      COMMIT;
    END IF;
  END IF;
END
$$

--
-- Definition for function fnCheckMasterPassword
--
DROP FUNCTION IF EXISTS fnCheckMasterPassword$$
CREATE FUNCTION fnCheckMasterPassword(masterPassword varchar(255))
  RETURNS tinyint(4)
  SQL SECURITY INVOKER
BEGIN
  DECLARE sPassword varchar(100);

  SELECT
    u.password INTO sPassword
  FROM user u
  WHERE u.username = 'administrator'
  LIMIT 1;

  RETURN IF(sPassword = masterPassword, 1, 0);
END
$$

--
-- Definition for function fnCheckUniqueUser
--
DROP FUNCTION IF EXISTS fnCheckUniqueUser$$
CREATE FUNCTION fnCheckUniqueUser(pFirstname VARCHAR(50), pLastname VARCHAR(50))
  RETURNS int(11)
  SQL SECURITY INVOKER
  COMMENT 'Function for checking for unique user first and last names.'
BEGIN
  DECLARE usersCount int(10);
  DECLARE nResult tinyint(1);

  SET nResult = 1;

  IF !ISNULL(pFirstname) AND !ISNULL(pLastname) THEN
    SELECT COUNT(u.id) INTO usersCount
    FROM user u
    WHERE
      lower(u.firstname) = lower(pFirstname) AND lower(u.lastname) = lower(pLastname)
      LIMIT 1;
    IF 0 < usersCount THEN
      SET nResult = 0;
    END IF;
  END IF;

RETURN nResult;
END
$$

--
-- Definition for function fnCheckUserLogin
--
DROP FUNCTION IF EXISTS fnCheckUserLogin$$
CREATE FUNCTION fnCheckUserLogin(pUsername varchar(100), pPassword varchar(100))
  RETURNS int(11)
  SQL SECURITY INVOKER
BEGIN
  DECLARE sPassword varchar(100);
  DECLARE nResult tinyint(1);

  SET nResult = 0;

  IF !ISNULL(pUsername) AND !ISNULL(pPassword) THEN
    SELECT
      u.password INTO sPassword
    FROM user u
    WHERE u.username = pUsername and is_active = 1
    LIMIT 1;
    SET nResult = IF(sPassword = md5(pPassword), 1, 0);
  END IF;

  RETURN nResult;
END
$$

DELIMITER ;

--
-- Definition for view vw_item_sales
--
DROP VIEW IF EXISTS vw_item_sales CASCADE;
CREATE OR REPLACE 
	DEFINER = 'root'@'localhost'
VIEW vw_item_sales
AS
	select `isl`.`id` AS `id`,`isl`.`item_id` AS `item_id`,`i`.`name` AS `item_name`,`i`.`price` AS `item_price`,`i`.`other_info` AS `item_infos`,`isl`.`qty` AS `qty`,`isl`.`amount` AS `item_total`,`isl`.`sales_date` AS `sales_date`,`isl`.`member_id` AS `member_id`,if(isnull(`isl`.`member_id`),'Anonymous',trim(concat(ifnull(`m`.`firstname`,''),' ',if((`m`.`middlename` is not null),concat(substr(`m`.`middlename`,1,1),'. '),''),ifnull(`m`.`lastname`,'')))) AS `customer_name`,`isl`.`user_id` AS `user_id` from ((`item_sales` `isl` join `item` `i` on((`i`.`id` = `isl`.`item_id`))) left join `member` `m` on((`m`.`id` = `isl`.`member_id`)));

--
-- Definition for view vw_items
--
DROP VIEW IF EXISTS vw_items CASCADE;
CREATE OR REPLACE 
	DEFINER = 'root'@'localhost'
VIEW vw_items
AS
	select `i`.`id` AS `item_id`,`i`.`name` AS `item_name`,`i`.`price` AS `item_price`,`i`.`other_info` AS `item_infos`,`i`.`user_id` AS `user_id` from `item` `i`;

--
-- Definition for view vw_members
--
DROP VIEW IF EXISTS vw_members CASCADE;
CREATE OR REPLACE 
	DEFINER = 'root'@'localhost'
VIEW vw_members
AS
	select `m`.`id` AS `member_id`,`m`.`firstname` AS `firstname`,`m`.`lastname` AS `lastname`,`m`.`middlename` AS `middlename`,trim(concat(ifnull(`m`.`firstname`,''),' ',if((`m`.`middlename` is not null),concat(substr(`m`.`middlename`,1,1),'. '),''),ifnull(`m`.`lastname`,''))) AS `member_name`,`m`.`contactno` AS `contactno`,`m`.`address` AS `address`,`m`.`birthdate` AS `birthdate`,`m`.`gender` AS `gender`,`m`.`emergency_contact_person` AS `emergency_contact_person`,`m`.`emergency_contact_number` AS `emergency_contact_number`,`m`.`emergency_contact_relationship` AS `emergency_contact_relationship`,`mt`.`id` AS `membership_type_id`,`mt`.`type` AS `membership_type`,if((0 < `mt`.`discounted`),'Yes','No') AS `has_discount`,`mt`.`service_type` AS `service_type`,`mt`.`monthly_startdate` AS `monthly_startdate`,`mt`.`monthly_enddate` AS `monthly_enddate` from (`member` `m` join `membership_type` `mt` on((`mt`.`member_id` = `m`.`id`)));

--
-- Definition for view vw_users
--
DROP VIEW IF EXISTS vw_users CASCADE;
CREATE OR REPLACE 
	DEFINER = 'root'@'localhost'
VIEW vw_users
AS
	select `u`.`id` AS `user_id`,`u`.`firstname` AS `firstname`,`u`.`lastname` AS `lastname`,`u`.`middlename` AS `middlename`,trim(concat(ifnull(`u`.`firstname`,''),' ',if((`u`.`middlename` is not null),concat(substr(`u`.`middlename`,1,1),'. '),''),ifnull(`u`.`lastname`,''))) AS `user_name`,`u`.`contactno` AS `contactno`,`u`.`address` AS `address`,`u`.`birthdate` AS `birthdate`,`u`.`gender` AS `gender`,`u`.`username` AS `username`,`u`.`password` AS `password`,`u`.`role_type` AS `role_type`,`u`.`creation_date` AS `creation_date`,`u`.`last_modified_date` AS `last_modified_date` from `user` `u` where ((`u`.`id` > 1) and (`u`.`is_active` = 1));

--
-- Definition for view vw_workout_sales
--
DROP VIEW IF EXISTS vw_workout_sales CASCADE;
CREATE OR REPLACE 
	DEFINER = 'root'@'localhost'
VIEW vw_workout_sales
AS
	select `ws`.`id` AS `id`,`ws`.`workout_date` AS `workout_date`,`ws`.`member_id` AS `member_id`,trim(concat(ifnull(`m`.`firstname`,''),' ',if((`m`.`middlename` is not null),concat(substr(`m`.`middlename`,1,1),'. '),''),ifnull(`m`.`lastname`,''))) AS `member_name`,`ws`.`service_type` AS `service_type`,`ws`.`rendered_amount` AS `rendered_amount`,`ws`.`user_id` AS `user_id`,trim(concat(ifnull(`u`.`firstname`,''),' ',if((`u`.`middlename` is not null),concat(substr(`u`.`middlename`,1,1),'. '),''),ifnull(`u`.`lastname`,''))) AS `user_name` from ((`workout_sales` `ws` join `member` `m` on((`m`.`id` = `ws`.`member_id`))) join `user` `u` on((`u`.`id` = `ws`.`user_id`)));

-- 
-- Dumping data for table user
--
INSERT INTO user VALUES
(1, 'administrator', 'bfa1644c97b4269d2327653c70dff4d5', 'GrmSys', 'Administrator', 'Admin', NULL, NULL, NULL, 'M', 1, 'administrator', '2015-08-21 23:49:07', '2015-08-21 23:49:09'),
(1000, 'juandelacruz', '5f4dcc3b5aa765d61d8327deb882cf99', 'Juan', 'Dela Cruz', 'Pedrito', '(0920) 987-1234', 'Davao City, Philippines', '1981-05-20', 'M', 1, 'attendant', '2015-08-31 23:27:01', '2015-08-31 23:27:01'),
(1001, 'jpagduma', '4ca7c5c27c2314eecc71f67501abb724', 'John Patrick', 'Agduma', 'Marcha', '(0915) 770-4511', 'Buhangin, Davao City 8000', '1997-09-24', 'M', 1, 'attendant', '2015-09-01 00:11:59', '2015-09-01 00:11:59'),
(1002, 'borgymanotoy', '47ce512be52df5a177a347cea4b1cafd', 'Borgy', 'Manotoy', 'Exaltacion', '(0908) 637-7800', 'Purok Pine Tree, KM 6 Buhangin, Davao City 8000', '1981-05-20', 'M', 1, 'administrator', '2015-09-01 00:35:21', '2015-09-01 00:35:21'),
(1003, 'lmsalipahmad', '4ca7c5c27c2314eecc71f67501abb724', 'Laarnie', 'Salip Ahmad', 'Marcha', '(0928) 283-6988', 'Phase 3 Block 3 Lot 9, NHA Bangkal, Bangkal, Davao City 8000', '1981-11-19', 'F', 1, 'attendant', '2015-09-01 09:57:21', '2015-09-01 09:57:21'),
(1004, 'jcanangga', '21232f297a57a5a743894a0e4a801fc3', 'Joseph Jones', 'Canangga', 'Palermo', '(0920) 212-1245', 'Agdao, Davao City', '1996-05-17', 'M', 1, 'attendant', '2015-09-01 12:26:09', '2015-09-01 12:26:09'),
(1005, 'acmarcha', '4ca7c5c27c2314eecc71f67501abb724', 'Angelie Claire', 'Marcha', 'Amper', '(0919) 233-1561', 'Bayron Street, Tabon, Mangagoy, Bislig City, Surigao Del Sur 8311', '1992-11-28', 'F', 1, 'attendant', '2015-09-02 09:45:00', '2015-09-02 09:45:00'),
(1006, 'fainocencio', '4ca7c5c27c2314eecc71f67501abb724', 'Francesca Alexandra', 'Inocencio', 'Salip Ahmad', '(0999) 214-1667', 'Phase 3 Block 3 Lot9, NHA Bangkal, Bangkal, Davao City 8000', '1995-08-03', 'F', 1, 'attendant', '2015-09-02 09:49:16', '2015-09-02 09:49:16'),
(1007, 'wongfeihong', '5d93ceb70e2bf5daa84ec3d0cd2c731a', 'Wong', 'Hong', 'Fei', '(888) 888-8888', 'Mainland China, China Subdivision, Agdao, Davao City 8000', '1974-11-21', 'M', 1, 'attendant', '2015-09-03 09:11:23', '2015-09-05 15:54:25'),
(1008, 'akorakot', '5d93ceb70e2bf5daa84ec3d0cd2c731a', 'Agupta', 'Korakot', 'Katolin', '(+164) 122-1055', 'Ghaziabad, India', '1976-12-31', 'F', 1, 'attendant', '2015-09-03 09:14:56', '2015-09-03 09:14:56'),
(1016, 'aaaaa', '827ccb0eea8a706c4c34a16891f84e7b', 'Constancia', 'Condensada', 'Krema', '(988) 888-8888', 'Philippines', '1961-06-16', 'F', 1, 'attendant', '2015-09-05 15:49:14', '2015-09-05 15:50:23'),
(1017, 'feahmad', '4ca7c5c27c2314eecc71f67501abb724', 'Florentina', 'Salip Ahmad', 'Exaltacion', '(932) 367-8888', 'Phase 3 Block 3 Lot 9, NHA Bangkal, Bangkal, Davao City 8000', '1946-09-17', 'F', 1, 'administrator', '2015-09-05 15:52:53', '2015-09-05 15:52:53'),
(1018, 'ssfgsgfd', '4ca7c5c27c2314eecc71f67501abb724', 'Dummy', 'User', 'Test', '(082) 222-5555', 'Davao City, Philippines', NULL, 'F', 1, 'attendant', '2015-09-05 20:38:48', '2015-09-05 20:39:39');

-- 
-- Dumping data for table item
--
INSERT INTO item VALUES
(100, 'Vitamilk', 28.00, 'Tag singko tag singko tag singko nalang...', 1, '2015-09-02 00:54:17', '2015-09-02 00:54:17'),
(101, 'Whey Protein Pro (5lbs)', 2500.00, '3pcs Whey Protein Pro (5lbs)', 1, '2015-09-02 09:54:01', '2015-09-02 09:54:01'),
(102, 'Twins Boxing Gloves 14oz (Red)', 3816.00, '* Material: Genuine leather\r\n* Built for superior protection and performance\r\n* Excellent ventilation keeps hands cool, dry, and comfortable\r\n* Lining: Repellent taffeta; Padding: Handcrafted high-density latex\r\n* Velcro closure\r\n* Ideal for sparring', 1002, '2015-09-05 16:35:20', '2015-09-05 16:35:20'),
(103, 'Standing Punching Bag (Red)', 7499.00, 'Freestanding bags offer the benefit of mobility and practicality. The Powercore bag has kept the best qualities inherent in freestanders and improved upon some of their common issues. The neck features a power transfer ring that helps absorb the impact of strikes while minimizing shifting of the entire bag. The base is wide and created with high-density plastic. It can contain sand or water for filling (weighs 250lb when full).', 1002, '2015-09-05 16:41:27', '2015-09-05 16:41:27');

-- 
-- Dumping data for table member
--
INSERT INTO member VALUES
(1000, 'Juan Federico', 'Bayuoc', 'Sarap', '(0920) 987-1234', 'Barrio Patay, Agdao, Davao City, Philippines', '1988-12-08', 'M', 'Elizabeth Y. Panglugod', '(0918) 232-1555)', 'The Other Woman', '2015-09-02 09:26:35', '2015-09-05 21:28:20', 1),
(1001, 'Eric Jose', 'Salip Ahmad', 'Exaltacion', '(0908) 637-7800', 'Phase 3 Block 3 Lot 9, NHA Bangkal, Bangkal, Davao City 8000', '1981-05-20', 'M', 'Laarnie M. Salip Ahmad', '(0928) 283-6988', 'Spouse', '2015-09-02 09:34:12', '2015-09-05 21:28:15', 1),
(1002, 'Laarnie', 'Marcha', 'Amper', '(0918) 232-1341', 'Aurora Street, Boulevard, Davao City', '1981-11-19', 'F', 'Rose A. Marcha', '(0909) 633-4155', 'Mother', '2015-09-02 09:53:12', '2015-09-05 21:28:11', 1),
(1003, 'Borgy', 'Manotoy', 'Exaltacion', '(0918) 122-2151', 'Garcia Heights, Bajada, Davao City 8000', '1981-05-20', 'M', 'Florentina Manotoy', '(082) 300-2155', 'Mother', '2015-09-02 23:42:36', '2015-09-05 21:28:08', 1),
(1004, 'recrets', 'winston', 'Pedrito', '(0920) 987-1234', 'test', '1973-07-08', 'F', 'apolinaria d. makaatras', '(082) 123-1541', 'silingan', '2015-09-03 08:34:38', '2015-09-05 21:28:04', 1),
(1005, 'Frederick John', 'Batumbakal', 'Pastilapan', '(082) 300-4444', 'Piapi, Boulevard, Davao City', '1978-11-30', 'M', 'Antoinette Batumbakal', '(082) 300-4444', 'Lost Distance Relationship', '2015-09-03 09:07:35', '2015-09-05 21:27:59', 1),
(1006, 'asfasfsadf', 'asdfsdafs', 'sadfasdfsad', '(232) 352-3523', 'asdfasdfsadfsda', NULL, 'F', 'asdfsadfsd', '(234) 243-2432', 'asdfsafsafsdfsd', '2015-09-05 20:44:13', '2015-09-05 20:44:13', 1002),
(1007, 'asfasfsadf', 'asdfsdafs', 'sadfasdfsad', '(232) 352-3523', 'asdfasdfsadfsda', NULL, 'F', 'asdfsadfsd', '(234) 243-2432', 'asdfsafsafsdfsd', '2015-09-05 20:44:31', '2015-09-05 20:44:31', 1002),
(1008, 'Geronimo', 'Matambaka', 'Bagoong', '(032) 300-4444', 'Mandaue City, Cebu', '1948-02-14', 'M', 'Mariposa X. Matambaka', '(032) 300-4444', 'Widowed wife', '2015-09-05 20:49:08', '2015-09-05 21:27:51', 1002),
(1011, 'John Patrick', 'Agduma', 'Marcha', '(915) 770-0404', 'Purok Pine Tree, KM 6 Buhangin, Buhangin, Davao City 8000', '1997-09-24', 'M', 'Donabel M. Agduma', '(920) 399-7880', 'Mother', '2015-09-05 21:27:09', '2015-09-05 21:27:36', 1002);

-- 
-- Dumping data for table item_sales
--

-- Table grmsys_db.item_sales does not contain any data (it is empty)

-- 
-- Dumping data for table membership_type
--
INSERT INTO membership_type VALUES
(1, 1000, 'walk-in', 0, 'weights', '2015-02-09', '2015-02-10', '2015-09-02 09:26:35', '2015-09-05 21:28:20', 1),
(2, 1001, 'monthly', 0, 'weights', '2015-02-09', '2015-02-10', '2015-09-02 09:34:12', '2015-09-05 21:28:15', 1),
(3, 1002, 'monthly', 1, 'boxing', '2015-03-09', '2015-03-10', '2015-09-02 09:53:12', '2015-09-05 21:28:12', 1),
(4, 1003, 'monthly', 1, 'boxing', '2015-02-09', '2015-02-10', '2015-09-02 23:42:36', '2015-09-05 21:28:08', 1),
(5, 1004, 'walk-in', 1, 'weights', '2015-03-09', '1970-01-01', '2015-09-03 08:34:38', '2015-09-05 21:28:04', 1),
(6, 1005, 'monthly', 1, 'boxing', '2015-09-03', '2015-09-30', '2015-09-03 09:07:35', '2015-09-05 21:28:00', 1),
(7, 1008, 'monthly', 0, 'weights', '2015-09-05', '2015-10-05', '2015-09-05 20:49:08', '2015-09-05 21:27:51', 1002),
(10, 1011, 'monthly', 1, 'boxing', '2015-09-05', '2015-10-05', '2015-09-05 21:27:09', '2015-09-05 21:27:36', 1002);

-- 
-- Dumping data for table workout_sales
--

-- Table grmsys_db.workout_sales does not contain any data (it is empty)

-- 
-- Enable foreign keys
-- 
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;