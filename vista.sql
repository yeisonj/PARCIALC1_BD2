CREATE OR REPLACE VIEW public.historicocargos
    AS
     SELECT employeeaudit.nameemployee,
    employeeaudit.department,
    employeeaudit.branchoffice
   FROM employeeaudit; ;
  
	

