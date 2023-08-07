--------------------------------------------------------
--  Datei erstellt -Montag-November-30-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HUB_DEPT
--------------------------------------------------------

  CREATE TABLE "STG_HUB_DEPT" 
   (	"LOAD_DATE" DATE, 
	"DEPTNO_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"DEPTNO_BK" NUMBER(2,0)
   ) ;
--------------------------------------------------------
--  DDL for Table HUB_EMP
--------------------------------------------------------

  CREATE TABLE "STG_HUB_EMP" 
   (	"LOAD_DATE" DATE, 
	"EMPNO_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_BK" NUMBER(4,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SAT_DEPT
--------------------------------------------------------

  CREATE TABLE "STG_SAT_DEPT" 
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

  CREATE TABLE "STG_SAT_EMP20" 
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

  CREATE TABLE "STG_SAT_EMP5" 
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

  CREATE TABLE "STG_LINK_MANAGER" 
   (	"LOAD_DATE" DATE, 
	"MANAGER_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_HASHKEY" RAW(16), 
	"MGR_HASHKEY" RAW(16)
   ) ;
--------------------------------------------------------
--  DDL for Table LINK_WORKS
--------------------------------------------------------

  CREATE TABLE "STG_LINK_WORKS" 
   (	"LOAD_DATE" DATE, 
	"WORKS_HASHKEY" RAW(16), 
	"RECORDSOURCE" VARCHAR2(20), 
	"EMPNO_HASHKEY" RAW(16), 
	"DEPTNO_HASHKEY" RAW(16)
   ) ;
--------------------------------------------------------
--  DDL for Table STG_SAT_LINK_WORKS_EFF
--------------------------------------------------------

CREATE TABLE STG_SAT_LINK_WORKS_EFF(
 "WORKS_HASHKEY" RAW(16), 
 "BEGIN_DATE" DATE,
 "END_DATE" DATE,
 "LOAD_DATE" DATE, 
 "RECORDSOURCE" VARCHAR2(20)
);
