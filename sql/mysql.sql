DROP DATABASE IF EXISTS set_of_test;
CREATE DATABASE set_of_test;
use set_of_test

-- first_name.csv

CREATE TABLE firstName (
	fn_label varchar(254),
	id_firstName int(11) NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (`id_firstName`)
);


LOAD DATA LOCAL INFILE 'csv/first_name.csv' INTO TABLE firstName LINES TERMINATED BY '\n' ;

CREATE TABLE lastName (
	ln_label varchar(254),
	id_lastName int(11) NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (`id_lastName`)
);

LOAD DATA LOCAL INFILE 'csv/last_name.csv' INTO TABLE lastName LINES TERMINATED BY '\n' ;


CREATE TABLE frenchCity (
	fc_label varchar(254),
	id_frenchCity int(11) NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (`id_frenchCity`)
);

LOAD DATA LOCAL INFILE 'csv/french_city.csv' INTO TABLE frenchCity LINES TERMINATED BY '\n' ;

-- 
CREATE TABLE addressBook (
	id_addressBook int(11) NOT NULL AUTO_INCREMENT,
	ab_firstName varchar(254),
	ab_lastName varchar(254),
	ab_cityName varchar(254),
	PRIMARY KEY (`id_addressBook`)
);


DROP PROCEDURE IF EXISTS generate_addressBook;

DELIMITER ;;

CREATE PROCEDURE generate_addressBook(IN lot INT)  
BEGIN
	DECLARE v1 INT DEFAULT lot;
	WHILE v1 > 0 DO
		DROP TABLE IF EXISTS tmp_lastName;
		DROP TABLE IF EXISTS tmp_firstName;
		DROP TABLE IF EXISTS tmp_frenchCity;

		CREATE TABLE tmp_lastName (
			id_tmp int(11) NOT NULL AUTO_INCREMENT,
			tmln_label varchar(254),
			PRIMARY KEY (`id_tmp`)
		);

		INSERT INTO tmp_lastName ( tmln_label ) 
			SELECT 
				ln_label 
			FROM
				lastName
			ORDER BY rand()
			LIMIT 10000;

		CREATE TABLE tmp_firstName (
			id_tmp int(11) NOT NULL AUTO_INCREMENT,
			tmfn_label varchar(254),
			PRIMARY KEY (`id_tmp`)
		);

		INSERT INTO tmp_firstName ( tmfn_label ) 
			SELECT 
				fn_label 
			FROM
				firstName
			ORDER BY rand()
			LIMIT 10000;

		CREATE TABLE tmp_frenchCity (
			id_tmp int(11) NOT NULL AUTO_INCREMENT,
			tmfc_label varchar(254),
			PRIMARY KEY (`id_tmp`)
		);

		INSERT INTO tmp_frenchCity ( tmfc_label ) 
			SELECT 
				fc_label 
			FROM
				frenchCity
			ORDER BY rand()
			LIMIT 10000;

		INSERT INTO addressBook ( ab_firstName , ab_lastName , ab_cityName ) 
			SELECT 
				tmfn_label,
				tmln_label,
				tmfc_label
			FROM 
				tmp_frenchCity
			NATURAL JOIN 
				tmp_firstName
			NATURAL JOIN 
				tmp_lastName
		; 

		DROP TABLE IF EXISTS tmp_lastName;
		DROP TABLE IF EXISTS tmp_firstName;
		DROP TABLE IF EXISTS tmp_frenchCity;

		SET v1 = v1 - 1;
	END WHILE;
END ;;	


DELIMITER ;






