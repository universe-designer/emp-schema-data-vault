BEGIN
   --datavault.truncate_vault;
   --datavault.load_vault;
   --datavault.random_update_emp(7369);
END;
/


SELECT *
FROM emp;

UPDATE emp
SET ename='SMITHERS'
WHERE ename='SMITH';