CREATE OR REPLACE FUNCTION NHS_ACT_DELETE(
  v_action		IN VARCHAR2,
  v_table      IN varchar2,
  v_criteria   IN varchar2,
  o_errmsg		OUT VARCHAR2
 ) return number as
   sqlbuf varchar2(500);
   o_errcode	NUMBER;
begin
   o_errcode:=0;
   o_errmsg:='ok';
   if v_action='DEL' then
   sqlbuf:='delete from '||v_table||' where 1=1 ';
   if v_criteria is not null then
   sqlbuf:=sqlbuf||' and '||v_criteria;
   end if;
   execute immediate sqlbuf;
   if sql%rowcount=0 then
    o_errcode:=-1;
    o_errmsg:='fail to delete data.';
   end if;
   end if;
   return o_errcode;
end NHS_ACT_DELETE;
/


