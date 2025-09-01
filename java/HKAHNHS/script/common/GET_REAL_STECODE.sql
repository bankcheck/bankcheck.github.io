create or replace
function GET_REAL_STECODE
return varchar2
as
	V_STESNAME SITE.STESNAME%TYPE;
begin
  select STESNAME into V_STESNAME from site where stecode = GET_CURRENT_STECODE;
  return V_STESNAME;
END;
/