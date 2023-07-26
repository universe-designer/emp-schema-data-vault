CREATE OR REPLACE PACKAGE BODY hashgen
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
      
END;
/
