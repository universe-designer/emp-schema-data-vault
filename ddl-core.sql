--------------------------------------------------------
--  Datei erstellt -Montag-November-30-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HUB_DEPT
--------------------------------------------------------

  CREATE TABLE "HUB_DEPT" 
   (	"LOAD_DATE" DATE, 
	"DEPTNO_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"DEPTNO_BK" NUMBER(2,0)
   ) ;
--------------------------------------------------------
--  DDL for Table HUB_EMP
--------------------------------------------------------

  CREATE TABLE "HUB_EMP" 
   (	"LOAD_DATE" DATE, 
	"EMPNO_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_BK" NUMBER(4,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SAT_DEPT
--------------------------------------------------------

  CREATE TABLE "SAT_DEPT" 
   (	"DEPTNO_HASHKEY" RAW(16), 
	"LOAD_DATE" DATE, 
	"RECORDSOURCE" VARCHAR2(20), 
	"HASHDIFF" RAW(16), 
	"DNAME" VARCHAR2(14), 
	"LOC" VARCHAR2(13)
   ) ;
--------------------------------------------------------
--  DDL for Table SAT_EMP20
--------------------------------------------------------

  CREATE TABLE "SAT_EMP20" 
   (	"EMPNO_HASHKEY" RAW(16), 
	"LOAD_DATE" DATE, 
	"RECORDSOURCE" VARCHAR2(20), 
	"HASHDIFF" RAW(16), 
	"ENAME" VARCHAR2(10), 
	"HIREDATE" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table SAT_EMP5
--------------------------------------------------------

  CREATE TABLE "SAT_EMP5" 
   (	"EMPNO_HASHKEY" RAW(16), 
	"LOAD_DATE" DATE, 
	"RECORDSOURCE" VARCHAR2(20), 
	"HASHDIFF" RAW(16), 
	"JOB" VARCHAR2(9), 
	"SAL" NUMBER(7,2), 
	"COMM" NUMBER(7,2)
   ) ;

--------------------------------------------------------
--  DDL for Table LINK_MANAGER
--------------------------------------------------------

  CREATE TABLE "LINK_MANAGER" 
   (	"LOAD_DATE" DATE, 
	"MANAGER_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_HASHKEY" RAW(16), 
	"MGR_HASHKEY" RAW(16)
   ) ;
--------------------------------------------------------
--  DDL for Table LINK_WORKS
--------------------------------------------------------

  CREATE TABLE "LINK_WORKS" 
   (	"LOAD_DATE" DATE, 
	"WORKS_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_HASHKEY" RAW(16), 
	"DEPTNO_HASHKEY" RAW(16)
   ) ;
--------------------------------------------------------
--  DDL for Table SAT_LINK_WORKS_EFF
--------------------------------------------------------

CREATE TABLE SAT_LINK_WORKS_EFF(
 "WORKS_HASHKEY" RAW(16), 
 "BEGIN_DATE" DATE,
 "END_DATE" DATE,
 "LOAD_DATE" DATE, 
 "RECORDSOURCE" VARCHAR2(20)
);

--------------------------------------------------------
--  DDL for View V_SAT_LINK_WORKS_EFF
--------------------------------------------------------
--complete history / current flag
CREATE OR REPLACE VIEW V_SAT_LINK_WORKS_EFF
AS
SELECT works_hashkey, TO_CHAR(begin_date, 'dd.mm.yyyy hh24:mi:ss') as begin_date, TO_CHAR(end_date, 'dd.mm.yyyy hh24:mi:ss') as end_date, load_date, current_record
FROM (  --current links
        SELECT e.*, 1 AS current_record
        FROM SAT_LINK_WORKS_EFF e INNER JOIN   (--most recent link records
                                                SELECT works_hashkey, MAX(load_date) AS load_date
                                                FROM sat_link_works_eff
                                                GROUP BY works_hashkey) c ON e.works_hashkey=c.works_hashkey AND e.load_date=c.load_date
        WHERE e.end_date > sysdate
        UNION ALL
        --historic links
        SELECT h.*, 0 AS current_record
        FROM SAT_LINK_WORKS_EFF h
        WHERE h.end_date < sysdate);

--------------------------------------------------------
--  DDL for View V_SAT_EMP5
--------------------------------------------------------        
--complete history / current flag
CREATE OR REPLACE VIEW v_sat_emp5
AS
SELECT s.empno_hashkey, s.load_date, s.recordsource,s.hashdiff,
s.load_date AS valid_from, 
LEAD(s.load_date, 1, TO_DATE('31.12.9999','dd.mm.yyyy')) OVER (PARTITION BY s.empno_hashkey ORDER BY s.load_date) AS valid_to,
CASE 
  LEAD('has_successor', 1, 'has_no_successor') OVER (PARTITION BY s.empno_hashkey ORDER BY s.load_date) 
  WHEN 'has_no_successor' THEN 1
  ELSE 0 
END AS current_flag,
s.job,
s.sal,
s.comm
FROM sat_emp5 s;
