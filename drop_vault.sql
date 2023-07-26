--Lösche alle Tabellen

BEGIN
   FOR i IN (SELECT table_name
             FROM user_tables
             WHERE table_name LIKE 'SAT%'
             OR table_name LIKE 'LINK%'
             OR table_name LIKE 'HUB%'
             OR table_name LIKE 'STG%')
   LOOP
      EXECUTE IMMEDIATE ('DROP TABLE '||i.table_name);
   END LOOP;
END;
/