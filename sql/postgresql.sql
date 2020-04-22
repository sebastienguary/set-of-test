DROP DATABASE IF EXISTS set_of_test;
CREATE DATABASE set_of_test;
\c set_of_test

-- first_name.csv

CREATE TABLE firstName (
	fn_label varchar(254),
	id_firstName SERIAL
);

CREATE TABLE lastName (
	ln_label varchar(254),
	id_lastName SERIAL
);

CREATE TABLE frenchCity (
	fc_label varchar(254),
	id_frenchCity SERIAL
);



-- 
CREATE TABLE addressBook (
	id_addressBook SERIAL,
	ab_firstName varchar(254),
	ab_lastName varchar(254),
	ab_cityName varchar(254)
);



CREATE OR REPLACE PROCEDURE generate_addressBook(INT)
LANGUAGE plpgsql    
AS $$
DECLARE
   counter INTEGER := 0 ;
BEGIN
	LOOP 
		DROP TABLE IF EXISTS tmp_lastName;
		DROP TABLE IF EXISTS tmp_firstName;
		DROP TABLE IF EXISTS tmp_frenchCity;

		CREATE TABLE tmp_lastName (
			id_tmp SERIAL,
			tmln_label varchar(254)
		);

		INSERT INTO tmp_lastName ( tmln_label ) 
			SELECT 
				ln_label 
			FROM
				lastName
			ORDER BY random()
			LIMIT 10000;    

		CREATE TABLE tmp_firstName (
			id_tmp SERIAL,
			tmfn_label varchar(254)
		);

		INSERT INTO tmp_firstName ( tmfn_label ) 
			SELECT 
				fn_label 
			FROM
				firstName
			ORDER BY random()
			LIMIT 10000;

		CREATE TABLE tmp_frenchCity (
			id_tmp SERIAL,
			tmfc_label varchar(254)
		);

		INSERT INTO tmp_frenchCity ( tmfc_label ) 
			SELECT 
				fc_label 
			FROM
				frenchCity
			ORDER BY random()
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

		EXIT WHEN counter = $1 ; 
		counter := counter + 1 ; 
	END LOOP ; 

    COMMIT;
END;
$$;


SELECT 'cat csv/first_name.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY firstName(fn_label) FROM STDIN"' as foo
UNION
SELECT 'cat csv/french_city.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY frenchCity(fc_label) FROM STDIN"' as foo2
UNION
SELECT 'cat csv/last_name.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY lastName(ln_label) FROM STDIN"' as foo3;
/*


*/
