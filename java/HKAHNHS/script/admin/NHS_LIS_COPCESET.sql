CREATE OR REPLACE FUNCTION "NHS_LIS_COPCESET"
(
v_null out varchar2
)
return types.cursor_type
as
outcur types.cursor_type;
begin
      open outcur for
           SELECT '', CPSID,CPSCODE, CPSDESC,SteCode FROM conpceset;
      return outcur;
end NHS_LIS_COPCESET;
/


