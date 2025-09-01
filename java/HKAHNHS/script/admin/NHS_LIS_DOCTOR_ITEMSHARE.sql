create or replace
function "NHS_LIS_DOCTOR_ITEMSHARE"
(V_DOCCODE DOCITMPCT.DOCCODE%type,
 V_SHOWDIPID 	VARCHAR)
    RETURN tYPES.CURSOR_TYPE
AS
    OUTCUR types.CURSOR_TYPE;
    sqlbuf varchar2(2000);
BEGIN
  sqlbuf := '
     SELECT
          REPLACE(REPLACE( REPLACE(D.SLPTYPE, ''D'', ''Daycase''),''I'',''In-Patient''),''O'',''Out-Patient''),
          PCYDESC,
          DP.DSCCODE,
          I.ITMCODE,
          I.ITMNAME,
          D.DIPPCT,
          D.DIPFIX, ';
    if V_SHOWDIPID = 'N' then
      SQLBUF := SQLBUF || '''''';
     else
      SQLBUF := SQLBUF || ' D.DIPID';
     END IF;
    sqlbuf := sqlbuf || ' FROM docitmpct D, ITEM I, PATCAT P, DPSERV DP
     WHERE D.pCYID=P.pCYID(+)
     AND D.ITMCODE=I.ITMCODE(+)
     and  D.DOCCODE=''' || V_DOCCODE || '''
     AND  d.DSCCODE = DP.DSCCODE(+)
     ORDER BY D.SLPTYPE';
     OPEN outcur FOR sqlbuf;
  RETURN OUTCUR;
END NHS_LIS_DOCTOR_ITEMSHARE;
/