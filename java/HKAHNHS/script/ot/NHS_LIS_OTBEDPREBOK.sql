CREATE OR REPLACE FUNCTION "NHS_LIS_OTBEDPREBOK"
(
 v_otaid	    IN BEDPREBOK.Otaid%TYPE,
 v_bpbsts     IN BEDPREBOK.Bpbsts%TYPE
)
return types.cursor_type AS
       sqlStr varchar2(2000);
       outcur types.cursor_type;
       begin
        sqlStr:='select count(*) from BEDPREBOK where Otaid= '||v_otaid ||' and Bpbsts='''||v_bpbsts||'''';
        open outcur for sqlstr;
        return outcur;
       end NHS_LIS_OTBEDPREBOK;
/
