CREATE OR REPLACE FUNCTION "NHS_LIS_CREDITPACKAGE"
(V_PKGCODE IN PACKAGE.PKGCODE%TYPE,
V_PKGNAME  IN PACKAGE.PKGNAME%TYPE,
v_PKGRLVL  IN VARChAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  sqlBuf varchar2(500);
BEGIN
  sqlBuf:='SELECT P.PKGCODE,P.PKGNAME,P.PKGCNAME,P.DPTCODE,P.PKGRLVL,P.PKGTYPE,P.PKGALERT FROM CreditPkg P where 1=1 ';
  if V_PKGCODE is not null then
   sqlBuf:=sqlBuf||' and P.PKGCODE LIKE ''%'||v_PKGCODE||'%''';
  end if;
  if V_PKGNAME is not null then
   sqlBuf:=sqlBuf||' and P.PKGNAME LIKE ''%'||V_PKGNAME||'%''';
  end if;
  if v_PKGRLVL is not null then
     if ltrim(v_PKGRLVL,'0123456789') is null then -- v_PKGRLVL is one number string
       sqlBuf:=sqlBuf||' and P.PKGRLVL='||to_number(v_PKGRLVL);
     end if;
  end if;
  dbms_output.put_line('sqlBuf>>>>>'||sqlBuf);                 
  OPEN outcur FOR sqlBuf;
  RETURN OUTCUR;
END NHS_LIS_CREDITPACKAGE;
/
