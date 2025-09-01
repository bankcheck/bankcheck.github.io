CREATE OR REPLACE FUNCTION "NHS_ACT_DELETEDEPOSIT" (
 v_action	   IN VARCHAR2,
 v_dpsid     IN VARCHAR2,
 o_errmsg		OUT VARCHAR2
)RETURN NUMBER
AS
 o_errcode		NUMBER;
 v_noOfRec    NUMBER;

 BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  select count(1) into v_noOfRec from deposit where dpsid=to_number(v_dpsid);
  if v_noOfRec>0 then
      delete from deposit where dpsid=to_number(v_dpsid);
  else
    o_errcode := -1;
    o_errmsg := 'No record found.';
  end if;
  RETURN o_errcode;
end NHS_ACT_DELETEDEPOSIT;
/
