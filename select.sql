--SELECT e.empno_bk, s20.ename, s5.job, s20.hiredate,  sal, comm, d.deptno_bk
SELECT *
FROM hub_emp e INNER JOIN link_works w ON e.empno_hashkey=w.empno_hashkey
INNER JOIN hub_dept d ON w.deptno_hashkey=d.deptno_hashkey
INNER JOIN sat_emp5 s5 ON e.empno_hashkey=s5.empno_hashkey
INNER JOIN sat_emp20 s20 ON e.empno_hashkey=s20.empno_hashkey
INNER JOIN sat_dept sd ON d.deptno_hashkey=sd.deptno_hashkey
;

SELECT *
FROM emp;

SELECT *
FROM hub_emp;

SELECT *
FROM hub_dept;

SELECT *
FROM link_works;

SELECT *
FROM sat_emp5;

SELECT *
FROM sat_emp20;

SELECT *
FROM sat_dept;

--emp mit aktuellsten Daten
SELECT e.empno_bk, s20.ename, TO_CHAR(s5.load_date, 'dd.mm.yyyy hh:mi:ss') load_date, s5.job, s5.sal, s5.comm
FROM hub_emp e INNER JOIN sat_emp5 s5 ON e.empno_hashkey=s5.empno_hashkey
INNER JOIN sat_emp20 s20 ON e.empno_hashkey=s20.empno_hashkey
WHERE s5.load_date=(SELECT MAX(load_date)
                     FROM sat_emp5 i
                     WHERE i.empno_hashkey=s5.empno_hashkey)
                     
AND s20.load_date=(SELECT MAX(load_date)
                     FROM sat_emp20 i
                     WHERE i.empno_hashkey=s20.empno_hashkey)
ORDER BY e.empno_hashkey;


--emp mit Historie
SELECT e.empno_bk, s20.ename, TO_CHAR(s5.load_date, 'dd.mm.yyyy hh:mi:ss') load_date, s5.job, s5.sal, s5.comm
FROM hub_emp e INNER JOIN sat_emp5 s5 ON e.empno_hashkey=s5.empno_hashkey
INNER JOIN sat_emp20 s20 ON e.empno_hashkey=s20.empno_hashkey
ORDER BY e.empno_hashkey, s5.load_date;

SELECT empno_hashkey, TO_CHAR(load_date, 'dd.mm.yyyy HH24:mi:ss') AS load_date, recordsource, hashdiff, job, sal, comm
FROM sat_emp5
ORDER BY empno_hashkey, load_date ASC;


--emp mit Historie
SELECT e.empno_bk, s20.ename, s5.sal,
d.deptno_bk, sd.dname, sd.loc,
f.begin_date, f.end_date, current_record
FROM hub_emp e INNER JOIN sat_emp5 s5 ON e.empno_hashkey=s5.empno_hashkey
INNER JOIN sat_emp20 s20 ON e.empno_hashkey=s20.empno_hashkey --AND (s20.load_date > s5.load_date OR s20.load_date < s5.load_date)
INNER JOIN link_works l ON e.empno_hashkey=l.empno_hashkey
INNER JOIN v_sat_link_works_eff f ON l.works_hashkey=f.works_hashkey
INNER JOIN hub_dept d ON l.deptno_hashkey=d.deptno_hashkey
INNER JOIN sat_dept sd ON d.deptno_hashkey=sd.deptno_hashkey
ORDER BY e.empno_hashkey, f.load_date
