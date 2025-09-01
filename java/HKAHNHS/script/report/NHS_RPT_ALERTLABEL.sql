create or replace
FUNCTION NHS_RPT_ALERTLABEL (
  V_USRID VARCHAR2,
  V_PATNO VARCHAR2
)
RETURN TYPES.CURSOR_TYPE
AS
    OUTCUR    TYPES.CURSOR_TYPE;
    ALERTMSG  VARCHAR2(1000 BYTE);
    NOOFMSG   NUMBER;
BEGIN
    ALERTMSG := '';
    NOOFMSG := 0;

    FOR ALT_MSG IN (
          SELECT ALT.ALTID, ALT.ALTCODE, ALT.ALTDESC,
                  TO_CHAR(PAL.PALDATE, 'DD/MM/YYYY') AS PALDATE, pal.patno
          FROM PATALTLINK PAL, ALERT ALT
          WHERE PAL.ALTID = ALT.ALTID
          AND ALT.ALTID IN
          (
          SELECT DISTINCT R.ALTID
          FROM USRROLE U, ROLALTLINK R
          WHERE U.ROLID = R.ROLID
          and u.usrid = V_USRID
          )
          AND ALT.ALTPRINT = -1
          and pal.patno = V_PATNO
          AND USRID_C IS NULL
          ORDER BY ALT.ALTCODE
    )
    LOOP
      IF LENGTH(ALERTMSG) > 0 THEN
        ALERTMSG := ALERTMSG || '<br/>';
      END IF;
      NOOFMSG := NOOFMSG + 1;

      IF NOOFMSG < 3 THEN
        ALERTMSG := ALERTMSG || ALT_MSG.ALTCODE || '  (' || ALT_MSG.PALDATE || ')';
      ELSE
        ALERTMSG := ALERTMSG || 'More ......';
        EXIT;
      END IF;
    END LOOP;

    OPEN OUTCUR FOR
          SELECT PATNO, PATSEX, PATFNAME || ' ' || PATGNAME,
                  TO_CHAR(PATBDATE, 'DD/MM/YYYY'), ALERTMSG
          FROM PATIENT
          WHERE PATNO = V_PATNO and alertmsg is not null;

    RETURN OUTCUR;
END NHS_RPT_ALERTLABEL;
/