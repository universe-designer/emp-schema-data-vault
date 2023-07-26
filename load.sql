--truncate stage emp
DELETE stg_hub_emp;

--Staging emp
INSERT INTO stg_hub_emp (load_date, empno_hashkey, recordsource, empno_bk)
SELECT sysdate, hashgen.hashkey(empno), 'scott', empno
FROM scott.emp;

--Hub emp
INSERT INTO hub_emp (load_date, empno_hashkey, recordsource, empno_bk)
SELECT load_date, empno_hashkey, recordsource, empno_bk
FROM stg_hub_emp s
WHERE NOT EXISTS (SELECT 1
                  FROM hub_emp h
                  WHERE h.empno_hashkey=s.empno_hashkey);



--truncate stage dept
DELETE stg_hub_dept;

--Staging dept
INSERT INTO stg_hub_dept (load_date, deptno_hashkey, recordsource, deptno_bk)
SELECT sysdate, hashgen.hashkey(deptno), 'scott', deptno
FROM scott.dept;

--Hub dept
INSERT INTO hub_dept (load_date, deptno_hashkey, recordsource, deptno_bk)
SELECT load_date, deptno_hashkey, recordsource, deptno_bk
FROM stg_hub_dept s
WHERE NOT EXISTS (SELECT 1
                  FROM hub_dept h
                  WHERE h.deptno_hashkey=s.deptno_hashkey);
                  


--truncate stage emp5
DELETE stg_sat_emp5;

--Load Stage sat_emp5
INSERT INTO stg_sat_emp5
SELECT hashgen.hashkey(empno), sysdate, 'scott', hashgen.hashdiff(TRIM(NVL(job,''))||','||TRIM(NVL(sal,''))||','||TRIM(NVL(comm,''))) hashdiff, job, sal, comm
FROM scott.emp;


--Load Core sat_emp5
INSERT INTO sat_emp5 c (empno_hashkey, load_date, recordsource, hashdiff, job, sal, comm)
SELECT *
FROM stg_sat_emp5 s
WHERE NOT EXISTS (SELECT 1
              FROM sat_emp5 r
              WHERE r.empno_hashkey=s.empno_hashkey
              AND r.hashdiff=s.hashdiff
              AND r.load_date=(SELECT MAX(load_date)
                               FROM sat_emp5 m
                               WHERE m.empno_hashkey=s.empno_hashkey));

--truncate stage emp20
DELETE stg_sat_emp20;

--Load Stage sat_emp20
INSERT INTO stg_sat_emp20
SELECT hashgen.hashkey(empno), sysdate, 'scott', hashgen.hashdiff(TRIM(NVL(ename,''))||','||TRIM(NVL(TO_CHAR(hiredate, 'dd.mm.yyyy'),''))) hashdiff, ename, hiredate
FROM scott.emp;


--Load Core sat_emp20
INSERT INTO sat_emp20 
SELECT *
FROM stg_sat_emp20 s
WHERE NOT EXISTS (SELECT 1
              FROM sat_emp20 r
              WHERE r.empno_hashkey=s.empno_hashkey
              AND r.hashdiff=s.hashdiff
              AND r.load_date=(SELECT MAX(load_date)
                               FROM sat_emp20 m
                               WHERE m.empno_hashkey=s.empno_hashkey));


--truncate stage dept
DELETE stg_sat_dept;

--Load Stage sat_dept
INSERT INTO stg_sat_dept
SELECT hashgen.hashkey(deptno), sysdate, 'scott', hashgen.hashdiff(TRIM(NVL(dname,''))||','||TRIM(NVL(loc,''))) hashdiff, dname, loc
FROM scott.dept;


--Load Core sat_dept
INSERT INTO sat_dept 
SELECT *
FROM stg_sat_dept s
WHERE NOT EXISTS (SELECT 1
              FROM sat_dept r
              WHERE r.deptno_hashkey=s.deptno_hashkey
              AND r.hashdiff=s.hashdiff
              AND r.load_date=(SELECT MAX(load_date)
                               FROM sat_dept m
                               WHERE m.deptno_hashkey=s.deptno_hashkey));


--truncate stage link_works
DELETE stg_link_works;

--load stage link_works
INSERT INTO stg_link_works
SELECT sysdate, hashgen.hashkey(empno, deptno), 'scott', hashgen.hashkey(empno), hashgen.hashkey(deptno)
FROM scott.emp e;

--Load Link_works
INSERT INTO link_works (load_date, works_hashkey, recordsource, empno_hashkey, deptno_hashkey)
SELECT load_date, works_hashkey, recordsource, empno_hashkey, deptno_hashkey
FROM stg_link_works s
WHERE NOT EXISTS (SELECT 1
                  FROM link_works r
                  WHERE r.works_hashkey=s.works_hashkey);




--truncate stg
DELETE stg_link_manager;


--load stage
INSERT INTO stg_link_manager
SELECT sysdate, hashgen.hashkey(empno, mgr), 'scott', hashgen.hashkey(empno), hashgen.hashkey(mgr)
FROM scott.emp e;


--Load Link_manager
INSERT INTO link_manager (load_date, manager_hashkey, recordsource, empno_hashkey, mgr_hashkey)
SELECT load_date, manager_hashkey, recordsource, empno_hashkey, mgr_hashkey
FROM stg_link_manager s
WHERE NOT EXISTS (SELECT 1
                  FROM link_manager r
                  WHERE r.manager_hashkey=s.manager_hashkey);
COMMIT;
