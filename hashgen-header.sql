CREATE OR REPLACE PACKAGE datavault
AS


   FUNCTION hashkey(
    p_key CHAR) RETURN CHAR;
    
   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR) RETURN CHAR;
   
   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR,
    p_key3 CHAR) RETURN CHAR;
   
   FUNCTION hashkey(
    p_key1 CHAR,
    p_key2 CHAR,
    p_key3 CHAR,
    p_key4 CHAR) RETURN CHAR;
    
    FUNCTION hashdiff(
    p_stream CHAR) RETURN CHAR;
    
    PROCEDURE load_hub_dept;
    
    PROCEDURE load_hub_emp;
    
    PROCEDURE load_hub_dept;
    
    PROCEDURE load_sat_dept;
    
    PROCEDURE load_sat_emp5;
    
    PROCEDURE load_hub_emp20;
    
    PROCEDURE load_link_manager;
    
    PROCEDURE load_link_works;
    
    PROCEDURE load_vault;
    
    PROCEDURE random_update_dept;
    
    PROCEDURE truncate_vault;

END;
/
