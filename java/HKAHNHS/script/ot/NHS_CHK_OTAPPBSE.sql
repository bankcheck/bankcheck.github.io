CREATE OR REPLACE FUNCTION "NHS_CHK_OTAPPBSE"
(
v_otaid IN BEDPREBOK.Otaid%TYPE
)
return types.cursor_type AS
sqlstr varchar2(2000);
outcur types.cursor_type;
begin
      sqlstr:='select count(*) from BEDPREBOK where Otaid='||v_otaid ||' and BPBSTS=''N''';
       OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
end NHS_CHK_OTAPPBSE;
/
