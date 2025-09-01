create or replace
function "NHS_LIS_REGPRINTCALLCHART1"
(
    v_SGName varchar2,
    v_patNum varchar2,
    v_stecode varchar2,
    v_doccode varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
    v_patnoF varchar2(50);
begin
select lpad(v_patNum,10,' ') into v_patnoF from dual;
open outcur for
    select
       v_SGName as bkgpname,
       v_patNum as patno,
       substr(v_patnoF,1,2) as patnoA,
       substr(v_patnoF,3,2) as patnoB,
       substr(v_patnoF,5,2) as patnoC,
       substr(v_patnoF,7,2) as patnoD,
       substr(v_patnoF,9,2) as patnoE,
       d.docfname || ' ' || d.docgname as docname,
       d.doccode,
       sp.spcname,
       to_char(sysdate, 'DD/MM/YYYY HH24:MI') as bkgsdate2,
       to_char(sysdate, 'DD/MM/YYYY HH24:MI') as bkgsdate,
       s.stename,
       s.stelogo
  from
       doctor@IWEB d,
       spec@IWEB sp,
       site@IWEB s
  where
      d.spccode = sp.spccode
      and s.stecode = v_stecode
      and d.doccode = v_doccode;
  return outcur;
end NHS_LIS_REGPRINTCALLCHART1;