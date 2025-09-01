CREATE OR REPLACE FUNCTION NHS_LIS_ITEMITMCODE
(
   v_itmCode in varchar2,
   v_userId in varchar2
)
return types.cursor_type
as
  outcur types.cursor_type;
begin
  open outcur for


  select i.ItmType,i.ItmName,i.ItmCName,i.ItmCat
  from Item i
      where i.ItmCode = v_itmCode and i.ItmCat <> 'C'
      and
       i.dsccode IN (select DSCCODE from ROLE_DEPT_SERV r, usrrole u WHERE r.ROLE_ID = u.ROLID and u.USRID = v_userId);
  return outcur;
end NHS_LIS_ITEMITMCODE;
/
