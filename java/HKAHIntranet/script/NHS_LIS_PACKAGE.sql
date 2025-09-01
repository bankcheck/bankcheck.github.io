create or replace
FUNCTION "NHS_LIS_PACKAGE"
(V_PKGCODE IN VARCHAR2,
V_PKGNAME  IN VARCHAR2,
v_PKGRLVL  IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  sqlBuf varchar2(500);
BEGIN
  sqlBuf:='SELECT P.PKGCODE,P.PKGNAME,P.PKGCNAME,P.DPTCODE,P.PKGRLVL,P.PKGTYPE,P.PKGALERT FROM PACKAGE@IWEB P where 1=1 ';
  if V_PKGCODE is not null then
   sqlBuf:=sqlBuf||' and P.PKGCODE = '''||v_PKGCODE||'''';
  end if;
  if V_PKGNAME is not null then
   sqlBuf:=sqlBuf||' and P.PKGNAME LIKE ''%'||V_PKGNAME||'%''';
  end if;
  if v_PKGRLVL is not null then
     if ltrim(v_PKGRLVL,'0123456789') is null then -- v_PKGRLVL is one number string
       sqlBuf:=sqlBuf||' and P.PKGRLVL='||to_number(v_PKGRLVL);
     end if;
  end if;
  OPEN outcur FOR sqlBuf;
  RETURN OUTCUR;
END NHS_LIS_PACKAGE;