/* Optional Grants if emp tables lay in another schema

GRANT SELECT ON dept TO DWH;
GRANT SELECT ON emp TO DWH;
GRANT SELECT ON bonus TO DWH;
GRANT SELECT ON salgrade TO DWH;
GRANT INSERT, UPDATE, DELETE ON emp TO DWH;
GRANT INSERT, UPDATE, DELETE ON dept TO DWH;
*/


--Load DWH

--Change Data
UPDATE emp
SET sal=6000
WHERE ename='SCOTT';

--Load DWH

--Change Data back
UPDATE emp
SET sal=3000
WHERE ename='SCOTT';

--Check historical SELECT statement


SELECT *
FROM emp;
