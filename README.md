# PARCIALC1_BD2
1-construya un trigger que se ejecute posterior a
la inserción, modificación o eliminación de un empleado. Este trigger debe tener como
función persistir de forma totalmente denormalizada en la tabla EmployeeAudit las
diferentes versiones de este registro a lo largo del tiempo.

SOLUCION:

/*CREACION DE LA FUNCION */
CREATE OR REPLACE FUNCTION mov_employee() RETURNS TRIGGER AS $$
/*DECLARACION DE VARIABLES */
DECLARE
	enameemployee VARCHAR(50) ;
	eidemployee integer;
	enamebranch VARCHAR(50) ;
	enamedepartment VARCHAR(50) ;
	eposition VARCHAR(50) ;
	eadress VARCHAR(50) ;
	ecity VARCHAR(50) ;
	enamecountry VARCHAR(50) ;
	
BEGIN
		SELECT 
			 employee.idemployee,
			 employee.nameemployee,
			 Branchoffice.namebranch,
			 department.name,
			 position.name,
			 adress.line1,
			 city.namecity,
			 country.namecountry
		 INTO 
			eidemployee,
			enameemployee,
			enamebranch,
			enamedepartment,
			eposition,
			eadress,
			ecity,
			enamecountry
		 FROM 
			employee INNER JOIN 
			branchoffice on Branchoffice.idbranch = employee.idbranch  INNER JOIN 
			department on department.iddepartment = employee.iddepartment INNER JOIN 
			position on position.idposition = employee.idposition INNER JOIN 
			adress on adress.idaddress = employee.idaddress INNER JOIN 
			city on city.idcity = adress.idcity INNER JOIN 
			country on country.idcountry = city.fk_idcountry
		WHERE 
			employee.idemployee = old.idemployee;
			
	IF (TG_OP='DELETE') THEN
		INSERT INTO employeeaudit(
			idemployee, 
			nameemployee, 
			branchoffice, 
			department, 
			supervisor, 
			position, 
			address, 
			city, 
			country)
		VALUES (eidemployee,
				enameemployee, 
				enamebranch, 
				enamedepartment, 
				enameemployee, 
				eposition, 
				eadress, 
				ecity, 
				enamecountry);		
	RETURN NEW;
	END IF;
	
	IF (TG_OP='UPDATE') THEN
		INSERT INTO employeeaudit(
			idemployee, 
			nameemployee, 
			branchoffice, 
			department, 
			supervisor, 
			position, 
			address, 
			city, 
			country)
		VALUES (eidemployee,
				enameemployee, 
				enamebranch, 
				enamedepartment, 
				enameemployee, 
				eposition, 
				eadress, 
				ecity, 
				enamecountry);
	RETURN NEW;
	END IF;

	IF (TG_OP='INSERT') THEN
		INSERT INTO employeeaudit
			SELECT
				 employee.idemployee,
				 employee.nameemployee,
				 Branchoffice.namebranch,
				 department.name,
				 employee.nameemployee,
				 position.name,
				 adress.line1,
				 city.namecity,
				 country.namecountry
			 FROM 
				employee INNER JOIN 
				branchoffice on Branchoffice.idbranch = employee.idbranch  INNER JOIN 
				department on department.iddepartment = employee.iddepartment INNER JOIN 
				position on position.idposition = employee.idposition INNER JOIN 
				adress on adress.idaddress = employee.idaddress INNER JOIN 
				city on city.idcity = adress.idcity INNER JOIN 
				country on country.idcountry = city.fk_idcountry
			ORDER BY 
				employee.idemployee DESC
			limit 1	;
	RETURN NEW;
	END IF;
	
END
$$
LANGUAGE PLPGSQL;

/*CREACION TRIGGER */

CREATE TRIGGER mov_employee_triggerAFTER AFTER INSERT OR UPDATE OR DELETE ON employee
FOR EACH ROW
EXECUTE PROCEDURE mov_employee()


