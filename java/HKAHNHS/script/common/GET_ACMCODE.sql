create or replace function GET_ACMCODE
( v_acmcode in varchar2,
  v_itmcode in varchar2,
  v_pkgcode in varchar2,
  v_cpsid   in number
)
return varchar2 as
  o_acmcode varchar2(1);
begin

  select max(acmcode) into o_acmcode from itemchg
  where itmcode = v_itmcode
  and itctype = 'I'
  and acmcode <= v_acmcode
  and nvl(pkgcode,' ') = nvl(v_pkgcode,' ')
  and nvl(cpsid,-1) = nvl(v_cpsid,-1);

  return o_acmcode;
end;
/
