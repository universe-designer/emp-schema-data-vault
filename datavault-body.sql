CREATE OR REPLACE PACKAGE BODY datavault
AS

   FUNCTION hashkey(
    p_key CHAR) RETURN CHAR
   AS
    v_hashkey CHAR (32);
   
   BEGIN
     
     SELECT standard_hash(UPPER(TRIM(NVL(p_key,''))), 'MD5')
     INTO v_hashkey
     FROM dual;
     
     RETURN v_hashkey;
   END hashkey;
   
   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR) RETURN CHAR
   AS
    v_hashkey CHAR (32);
   
   BEGIN
     
     SELECT standard_hash(UPPER(TRIM(NVL(p_key1,''))||','||TRIM(NVL(p_key2,''))), 'MD5')
     INTO v_hashkey
     FROM dual;
     
     RETURN v_hashkey;
   END hashkey;
   
   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR,
    p_key3 CHAR) RETURN CHAR
   AS
    v_hashkey CHAR (32);
   
   BEGIN
     
     SELECT standard_hash(UPPER(TRIM(NVL(p_key1,''))||','||TRIM(NVL(p_key2,''))||','||TRIM(NVL(p_key3,''))), 'MD5')
     INTO v_hashkey
     FROM dual;
     
     RETURN v_hashkey;
   END hashkey;   

   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR,
    p_key3 CHAR,
    p_key4 CHAR) RETURN CHAR
   AS
    v_hashkey CHAR (32);
   
   BEGIN
     
     SELECT standard_hash(UPPER(TRIM(NVL(p_key1,''))||','||TRIM(NVL(p_key2,''))||','||TRIM(NVL(p_key3,''))||','||TRIM(NVL(p_key4,''))), 'MD5')
     INTO v_hashkey
     FROM dual;
     
     RETURN v_hashkey;
   END hashkey;   

   FUNCTION hashdiff(
    p_stream CHAR) RETURN CHAR
   AS
    v_hashkey CHAR (32);
   
   BEGIN
     
     SELECT standard_hash(p_stream, 'MD5')
     INTO v_hashkey
     FROM dual;
     
     RETURN v_hashkey;
   END hashdiff;   
   
   
   
   PROCEDURE load_hub_emp
   AS
   BEGIN
   
   
      --truncate stage emp
      DELETE stg_hub_emp;
      
      --Staging emp
      INSERT INTO stg_hub_emp (load_date, empno_hashkey, recordsource, empno_bk)
      SELECT sysdate, datavault.hashkey(empno), 'scott.emp', empno
      FROM emp;
      
      --Hub emp
      INSERT INTO hub_emp (load_date, empno_hashkey, recordsource, empno_bk)
      SELECT load_date, empno_hashkey, recordsource, empno_bk
      FROM stg_hub_emp s
      WHERE NOT EXISTS (SELECT 1
                        FROM hub_emp h
                        WHERE h.empno_hashkey=s.empno_hashkey);
      
   END load_hub_emp;
   
   PROCEDURE load_hub_dept
   AS
   BEGIN
   
   
      --truncate stage dept
      DELETE stg_hub_dept;
      
      --Staging dept
      INSERT INTO stg_hub_dept (load_date, deptno_hashkey, recordsource, deptno_bk)
      SELECT sysdate, datavault.hashkey(deptno), 'scott.dept', deptno
      FROM dept;
      
      --Hub dept
      INSERT INTO hub_dept (load_date, deptno_hashkey, recordsource, deptno_bk)
      SELECT load_date, deptno_hashkey, recordsource, deptno_bk
      FROM stg_hub_dept s
      WHERE NOT EXISTS (SELECT 1
                        FROM hub_dept h
                        WHERE h.deptno_hashkey=s.deptno_hashkey);
      
   END load_hub_dept;
   
   PROCEDURE load_sat_emp5
   AS
   BEGIN
   
   
      --truncate stage emp5
      DELETE stg_sat_emp5;
      
      --Load Stage sat_emp5
      INSERT INTO stg_sat_emp5
      SELECT datavault.hashkey(empno), sysdate, 'scott.emp', datavault.hashdiff(TRIM(NVL(job,''))||','||TRIM(NVL(sal,''))||','||TRIM(NVL(comm,''))) hashdiff, job, sal, comm
      FROM emp;
      
      
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
      
   END load_sat_emp5;

   PROCEDURE load_sat_emp20
   AS
   BEGIN
   
   
      --truncate stage emp20
      DELETE stg_sat_emp20;
      
      --Load Stage sat_emp20
      INSERT INTO stg_sat_emp20
      SELECT datavault.hashkey(empno), sysdate, 'scott.emp', datavault.hashdiff(TRIM(NVL(ename,''))||','||TRIM(NVL(TO_CHAR(hiredate, 'dd.mm.yyyy'),''))) hashdiff, ename, hiredate
      FROM emp;
      
      
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
      
   END load_sat_emp20;
       
   PROCEDURE load_sat_dept
   AS
   BEGIN
   
   
      --truncate stage dept
      DELETE stg_sat_dept;
      
      --Load Stage sat_dept
      INSERT INTO stg_sat_dept
      SELECT datavault.hashkey(deptno), sysdate, 'scott.dept', datavault.hashdiff(TRIM(NVL(dname,''))||','||TRIM(NVL(loc,''))) hashdiff, dname, loc
      FROM dept;
      
      
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
      
   END load_sat_dept;

   PROCEDURE load_link_works
   AS
   BEGIN
   
   
      DELETE stg_link_works;
      
      --load stage link_works
      INSERT INTO stg_link_works
      SELECT sysdate, datavault.hashkey(empno, deptno), 'scott.emp', datavault.hashkey(empno), datavault.hashkey(deptno)
      FROM emp e;
      
      --Load Link_works
      INSERT INTO link_works (load_date, works_hashkey, recordsource, empno_hashkey, deptno_hashkey)
      SELECT load_date, works_hashkey, recordsource, empno_hashkey, deptno_hashkey
      FROM stg_link_works s
      WHERE NOT EXISTS (SELECT 1
                        FROM link_works r
                        WHERE r.works_hashkey=s.works_hashkey);
      
   END load_link_works;

   PROCEDURE load_link_manager
   AS
   BEGIN
   
   
      --truncate stg
      DELETE stg_link_manager;
      
      
      --load stage
      INSERT INTO stg_link_manager
      SELECT sysdate, datavault.hashkey(empno, mgr), 'scott.emp', datavault.hashkey(empno), datavault.hashkey(mgr)
      FROM emp e;
      
      
      --Load Link_manager
      INSERT INTO link_manager (load_date, manager_hashkey, recordsource, empno_hashkey, mgr_hashkey)
      SELECT load_date, manager_hashkey, recordsource, empno_hashkey, mgr_hashkey
      FROM stg_link_manager s
      WHERE NOT EXISTS (SELECT 1
                        FROM link_manager r
                        WHERE r.manager_hashkey=s.manager_hashkey);
      
   END load_link_manager;

   PROCEDURE load_sat_link_works_eff
   AS
   BEGIN
    /* Für den Link-Effectivity-Satellite müssen 4 Szenarien abgebildet werden
    --1. Link ist neu
    --2. Link ist weg
    --3. Link ist wieder da
    --4. Link ist noch da
    Daraus ergeben sich 4 Insert-Operationen. Ihre richtige Reihenfolge ist wichtig für die Historie
    */

       
    
    --1. Link ist neu:       Schau ob Link aus Quellsystem auch im Core ist --> Nein: begin_date (heute) end_date (offen)
    --4. Link ist noch da:   Schau ob Link aus Quellsystem auch im Core ist --> Ja: Tu nichts
    --3. Link ist wieder da: Schau ob Link im Core auch im Quellsystem ist --> Ja: Gibt es einen offenen Link eff. Sat.-Eintrag? Nein: begin_date (heute) end_date (offen)
    --4. Lin ist noch da:    Schau ob Link im Core auch im Quellsystem ist --> Ja: Gibt es einen offenen Link eff. Sat.-Eintrag? Ja: Tu nichts
    --2. Link ist weg:       Schau ob Link im Core auch im Quellsystem ist --> Nein: begin_date (bisheriges) end_date (heute)
    
    DELETE stg_sat_link_works_eff;

    --2. Link ist weg:       Schau ob Link im Core auch im Quellsystem ist --> Nein: begin_date (bisheriges) end_date (heute)
    INSERT INTO stg_sat_link_works_eff (WORKS_HASHKEY, BEGIN_DATE, END_DATE, LOAD_DATE, RECORDSOURCE)
    
    SELECT w.works_hashkey, f.begin_date AS begin_date, sysdate AS END_DATE, sysdate AS LOAD_DATE, 'DWH' AS recordsource
    FROM hub_emp e 
    INNER JOIN link_works w ON e.empno_hashkey=w.empno_hashkey
    INNER JOIN hub_dept d ON w.deptno_hashkey=d.deptno_hashkey
    INNER JOIN sat_link_works_eff f ON f.works_hashkey=w.works_hashkey
    INNER JOIN (SELECT works_hashkey, MAX(load_date) AS load_date
                FROM sat_link_works_eff
                GROUP BY works_hashkey) c ON c.works_hashkey=f.works_hashkey 
                                         AND c.load_date=f.load_date 
                                         AND f.end_date >= TO_DATE('31.12.9999','dd.mm.yyyy')
    WHERE NOT EXISTS (SELECT 1
                      FROM emp
                      WHERE emp.empno=e.empno_bk AND emp.deptno=d.deptno_bk)
    
    
    --3. Link ist wieder da: Schau ob Link im Core auch im Quellsystem ist --> Ja: Gibt es einen offenen Link eff. Sat.-Eintrag? Nein: begin_date (heute) end_date (offen)
    --INSERT INTO sat_link_works_eff (WORKS_HASHKEY, BEGIN_DATE, END_DATE, LOAD_DATE, RECORDSOURCE)
    UNION ALL
    SELECT w.works_hashkey,  sysdate AS begin_date, TO_DATE('31.12.9999','dd.mm.yyyy') AS END_DATE, sysdate AS LOAD_DATE, 'DWH' AS recordsource
    FROM hub_emp e 
    INNER JOIN link_works w ON e.empno_hashkey=w.empno_hashkey
    INNER JOIN hub_dept d ON w.deptno_hashkey=d.deptno_hashkey
    INNER JOIN sat_link_works_eff f ON f.works_hashkey=w.works_hashkey
    INNER JOIN (SELECT works_hashkey, MAX(load_date) AS load_date
                FROM sat_link_works_eff
                GROUP BY works_hashkey) c ON c.works_hashkey=f.works_hashkey 
                                         AND c.load_date=f.load_date 
                                         AND f.end_date < sysdate
    WHERE EXISTS (SELECT 1
                      FROM emp
                      WHERE emp.empno=e.empno_bk AND emp.deptno=d.deptno_bk);


    --1. Link ist neu:       Schau ob Link aus Quellsystem auch im Core ist --> Nein: begin_date (heute) end_date (offen)
    INSERT INTO stg_sat_link_works_eff (WORKS_HASHKEY, BEGIN_DATE, END_DATE, LOAD_DATE, RECORDSOURCE)
    --UNION ALL
    --SELECT  utl_raw.cast_to_raw(datavault.hashkey(empno, deptno)) AS works_hashkey, sysdate AS begin_date, TO_DATE('31.12.9999','dd.mm.yyyy') AS END_DATE, sysdate AS LOAD_DATE, 'DWH' AS recordsource   
    (SELECT  datavault.hashkey(empno, deptno) AS works_hashkey, sysdate AS begin_date, TO_DATE('31.12.9999','dd.mm.yyyy') AS END_DATE, sysdate AS LOAD_DATE, 'DWH' AS recordsource   
    FROM emp e
    WHERE NOT EXISTS (SELECT 1
                      FROM sat_link_works_eff f                
                      WHERE datavault.hashkey(e.empno, e.deptno) = f.works_hashkey));
    
    INSERT INTO sat_link_works_eff (WORKS_HASHKEY, BEGIN_DATE, END_DATE, LOAD_DATE, RECORDSOURCE)
    SELECT WORKS_HASHKEY, BEGIN_DATE, END_DATE, LOAD_DATE, RECORDSOURCE
    FROM stg_sat_link_works_eff;
    
   END load_sat_link_works_eff;

   PROCEDURE load_vault
   AS
   BEGIN
      
      load_hub_dept;
      load_hub_emp;
      load_sat_dept;
      load_sat_emp5;
      load_sat_emp20;
      load_link_manager;
      load_link_works;
      load_sat_link_works_eff;
      COMMIT;
      
   END load_vault;
   
   --Zufällige Änderung des Gehalts.
   PROCEDURE random_update_emp( 
      p_empno emp.empno%TYPE
   )
   AS
   BEGIN
      
      UPDATE emp
      SET sal=ROUND(DBMS_RANDOM.VALUE(500, 5000),0)
      WHERE empno=p_empno;
      COMMIT;

      
   END random_update_emp;

   PROCEDURE truncate_vault
   AS
   BEGIN
      
      --leere alle Tabellen
      
      BEGIN
         FOR i IN (SELECT table_name
                   FROM user_tables
                   WHERE table_name LIKE 'SAT%'
                   OR table_name LIKE 'LINK%'
                   OR table_name LIKE 'HUB%'
                   OR table_name LIKE 'STG%')
         LOOP
            EXECUTE IMMEDIATE ('TRUNCATE TABLE '||i.table_name);
         END LOOP;
      END;

      
   END truncate_vault;
         
END;
/
