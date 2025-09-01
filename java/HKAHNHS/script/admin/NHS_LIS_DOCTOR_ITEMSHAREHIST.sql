create or replace
function "NHS_LIS_DOCTOR_ITEMSHAREHIST"
(V_DOCCODE DOCITMPCTHIST.DOCCODE%type,
 V_SHOWDIPHID 	VARCHAR)
    RETURN tYPES.CURSOR_TYPE
AS
    OUTCUR types.CURSOR_TYPE;
    sqlbuf varchar2(2000);
BEGIN
  sqlbuf := '
     SELECT
          TO_CHAR(CONSTARTDATE, ''DD/MM/YYYY''), 
          TO_CHAR(CONENDDATE, ''DD/MM/YYYY''),
          REPLACE(REPLACE( REPLACE(D.SLPTYPE, ''D'', ''Daycase''),''I'',''In-Patient''),''O'',''Out-Patient''),
          PCYDESC,
          DP.DSCCODE,
          I.ITMCODE,
          I.ITMNAME,
          D.DIPPCT,
          D.DIPFIX, ';
    if V_SHOWDIPHID = 'N' then
      SQLBUF := SQLBUF || '''''';
     else
      SQLBUF := SQLBUF || ' D.DIPHID';
     END IF;
    sqlbuf := sqlbuf || ' FROM DOCITMPCTHIST D, ITEM I, PATCAT P, DPSERV DP
     WHERE D.PCYID=P.PCYID(+)
     AND D.ITMCODE=I.ITMCODE(+)
     and  D.DOCCODE=''' || V_DOCCODE || '''
     AND  d.DSCCODE = DP.DSCCODE(+)
     ORDER BY D.DOCCODE, D.SLPTYPE, I.ITMCODE, PCYDESC, DP.DSCCODE, CONSTARTDATE DESC';
     OPEN outcur FOR sqlbuf;
  RETURN OUTCUR;
END NHS_LIS_DOCTOR_ITEMSHAREHIST;
/