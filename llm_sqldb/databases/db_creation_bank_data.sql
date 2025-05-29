CREATE DATABASE data_bank;
USE data_bank;

CREATE TABLE IF NOT EXISTS `bankers` (
    `banker_id` INT,
    `banker_name` VARCHAR(7) CHARACTER SET utf8,
    `branch_email` VARCHAR(19) CHARACTER SET utf8,
    `branch_id` INT
);
INSERT INTO `bankers` VALUES (1,'Rosana','rosana@abcbank.com',2),
	(2,'Carina','carina@abcbank.com',5),
	(3,'Gloria','gloria@abcbank.com',3),
	(4,'Elaine','elaine@abcbank.com',6),
	(5,'Wynne','wynne@abcbank.com',1),
	(6,'Shirley','shirley@abcbank.com',5),
	(7,'Kadora','kadora@abcbank.com',4);
    
CREATE TABLE IF NOT EXISTS `branch` (
    `branch_id` INT,
    `branch_name` VARCHAR(15) CHARACTER SET utf8,
    `branch_city` VARCHAR(9) CHARACTER SET utf8
);
INSERT INTO `branch` VALUES (1,'Clear Water Bay','Hong Kong'),
	(2,'Downtown','Edmonton'),
	(3,'Howe','Vancouver'),
	(4,'McEwan','Calgary'),
	(5,'Signal Hill','Calgary'),
	(6,'Tsuen Wan','Hong Kong');
    
CREATE TABLE IF NOT EXISTS `credit_card` (
    `credit_card_number` VARCHAR(19) CHARACTER SET utf8,
    `customer_id` INT,
    `currency` VARCHAR(3) CHARACTER SET utf8,
    `credit_limit` INT,
    `expiry_date` DATETIME
);
INSERT INTO `credit_card` VALUES ('0000-1111-1111-1111',1,'HKD',5000,'2002-03-01 00:00:00'),
	('0000-1111-1111-2222',1,'HKD',10000,'2003-01-01 00:00:00'),
	('0000-2222-2222-2222',2,'HKD',5000,'2005-12-01 00:00:00'),
	('0000-3333-3333-3333',3,'CAD',3000,'2003-12-01 00:00:00'),
	('0000-4444-4444-4444',4,'CAD',20000,'2004-11-01 00:00:00'),
	('0000-5555-5555-5555',5,'CAD',10000,'2003-01-01 00:00:00'),
	('0000-6666-6666-6666',6,'CAD',10000,'2005-01-01 00:00:00'),
	('0000-7777-7777-7777',7,'CAD',10000,'2004-04-01 00:00:00'),
	('0000-8888-8888-8888',8,'CAD',20000,'2005-01-01 00:00:00'),
	('0000-9999-9999-0000',9,'CAD',3000,'2002-01-01 00:00:00'),
	('0000-9999-9999-1111',9,'CAD',10000,'2002-01-01 00:00:00');
    
CREATE TABLE IF NOT EXISTS `customer` (
    `customer_id` INT,
    `customer_name` VARCHAR(6) CHARACTER SET utf8,
    `branch_id` INT,
    `customer_street` VARCHAR(15) CHARACTER SET utf8,
    `customer_city` VARCHAR(9) CHARACTER SET utf8
);
INSERT INTO `customer` VALUES (1,'Amy',1,'Ping Ting Road','Hong Kong'),
	(2,'Bob',6,'Texaco Road','Hong Kong'),
	(3,'Carson',4,'Deerfoot Trail','Calgary'),
	(4,'David',5,'Unversity Drive','Calgary'),
	(5,'John',5,'Ogden Road','Calgary'),
	(6,'Linda',2,'Kingsway Drive','Edmonton'),
	(7,'Mandy',2,'Victoria Road','Edmonton'),
	(8,'Paul',3,'Hornby Road','Vancouver'),
	(9,'Ricky',3,'Howe Road','Vancouver');
    
CREATE TABLE IF NOT EXISTS `loan` (
    `loan_id` INT,
    `customer_id` INT,
    `amount` INT
);
INSERT INTO `loan` VALUES (1,1,150000),
	(2,9,20000),
	(3,8,600000),
	(4,3,80000),
	(5,4,90000),
	(6,5,20000),
	(7,6,30000),
	(8,7,10000),
	(9,1,250000),
	(10,2,10000);
    
CREATE TABLE IF NOT EXISTS `savings_account` (
    `account_number` VARCHAR(18) CHARACTER SET utf8,
    `customer_id` INT,
    `currency` VARCHAR(3) CHARACTER SET utf8,
    `balance_savings` INT
);
INSERT INTO `savings_account` VALUES ('0-1-2222-3333-4444',1,'HKD',10000),
	('0-1-2222-2222-2222',3,'HKD',2000),
	('0-1-3333-3333-3333',4,'CAD',1000),
	('0-1-4444-4444-4444',2,'CAD',5000),
	('0-1-5555-5555-5555',5,'CAD',5000),
	('0-1-6666-6666-6666',9,'CAD',3000),
	('0-1-7777-7777-7777',8,'CAD',2000),
	('0-1-8888-8888-8888',7,'CAD',1000),
	('0-1-9999-9999-0000',6,'CAD',1000);