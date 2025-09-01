CREATE OR REPLACE FUNCTION DI_UTL_PRE_GEN_REPORT
(
  v_enddt in date
)
return number as
begin
  execute immediate 'truncate table temp_cardtx';
  insert into temp_cardtx
    select substr(ctnref,3),ctnctype from cardtx where ctnctype is not null;

  execute immediate 'truncate table temp_sliptx';
  insert into temp_sliptx  
    select * from sliptx 
    where dixref in (select stnid from xreg where trunc(xrgdate)<trunc(v_enddt)+1) 
    and (stndidoc is null 
    or (stndidoc is not null and nvl(pcyid,0) <>nvl(pcyid_o,0) and nvl(pcyid_o,0)<>-1));
  
  RETURN 2000;
EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
END DI_UTL_PRE_GEN_REPORT;