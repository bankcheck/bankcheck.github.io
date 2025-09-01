CREATE OR REPLACE FUNCTION "NHS_ACT_RECORDLOCKCHECK" (
  v_action   IN VARCHAR2,
  LockType    IN VARCHAR2,
  LockKey      IN VARCHAR2,
  o_errmsg	OUT VARCHAR2
  )
 RETURN  NUMBER
AS
  o_errcode NUMBER;
  v_noOfRec NUMBER;
begin

  select count(1) into v_noOfRec from rlock where RlkType=LockType and RlkKey=LockKey;
  if v_noOfRec>0 then
    o_errcode:=0;
    o_errmsg:='lock.';
  else
    o_errcode:=-1;
    o_errmsg:='unlock.';
  end if;

  return o_errcode;
end NHS_ACT_RECORDLOCKCHECK;
/

