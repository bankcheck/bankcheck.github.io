create or replace
function NHS_LIS_PRINTAPP
(
   v_temp in varchar2
)
return types.cursor_type
as
  outcur types.cursor_type;
  sqlstr VARCHAR2(1000);
begin
  if v_temp = '1' then
     sqlstr := 'Select '''',doccode,docfname || '' '' || docgname as docname
     from doctor@IWEB
     where (docpicklist = 0 or docpicklist is null) and docsts = -1
     order by docname';
  else
     sqlstr := 'Select '''',doccode,docfname || '' '' || docgname as docname
     from doctor@IWEB
     where docpicklist = -1
     order by docname';
  end if;
   open outcur for sqlstr;
return outcur;
end NHS_LIS_PRINTAPP;