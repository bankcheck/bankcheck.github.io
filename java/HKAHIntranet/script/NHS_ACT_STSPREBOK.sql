create or replace
function NHS_ACT_STSPREBOK
(
    v_action in varchar2,
    v_computername in varchar2,
    o_errmsg out varchar2
)
  return number AS
  o_errcode NUMBER;
Begin
  o_errcode := 0;
  o_errmsg  := 'OK';
  if v_action = 'MOD' then
    update stsprebok@IWEB set enddate= sysdate where computername=v_computername and enddate is null;
  else
    o_errmsg := 'update error.';
  end if;
  commit;
  return o_errcode;
End NHS_ACT_STSPREBOK;