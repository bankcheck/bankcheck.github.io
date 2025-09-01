SET SERVEROUTPUT ON
DECLARE
  in_id number; 
BEGIN
  dbms_output.put_line('a');
EXCEPTION WHEN OTHERS THEN
  null;
END;