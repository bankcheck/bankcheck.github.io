create or replace
FUNCTION "NHS_LIS_BOOKING"(V_STECODE  IN VARCHAR2,
                                             V_BKGSDATE IN VARCHAR2,
                                             V_BKGEDATE IN VARCHAR2,
                                             V_DOCCODE  IN VARCHAR2,
                                             V_BKGSTS   IN VARCHAR2,
                                             V_PATNO    IN VARCHAR2,
                                             V_BGKPNAME IN VARCHAR2,
                                             V_USRID    IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN

  OPEN OUTCUR FOR
    SELECT GET_ALERT_CODE(B.PATNO, V_USRID) AS ALERT,
           B.BKGID,
           TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY HH24:MI'),
           TO_CHAR(B.BKGEDATE, 'HH24:MI'),
           B.BKGSCNT,
           B.PATNO,
           B.BKGPNAME,
           DECODE(B.PATNO, NULL, '', P.PATSEX || '/' || TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, P.PATBDATE)) / 12)) AS AGE,
           B.BKGRMK,
           S.DOCCODE,
           D.DOCFNAME,
           D.DOCGNAME,
           B.BKGPTEL,
           B.BKGMTEL,
           B.BKGSTS,
           B.USRID,
           TO_CHAR(B.BKGCDATE, 'DD/MM/YYYY HH24:MI'),
           B.BKGPCNAME,
           DECODE(NVL(P.PATITP, 0), -1, 'Yes', 'No') PATITP,
           B.CANCELBY,
           B.SMS,
           TO_CHAR(B.SMSSDT, 'DD/MM/YYYY HH24:MI'),
           TO_CHAR(B.SMSSDTOK, 'DD/MM/YYYY HH24:MI'),
           B.SMSRTNMSG
      FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P
     WHERE B.SCHID = S.SCHID
       AND S.DOCCODE = D.DOCCODE
       AND B.PATNO = P.PATNO(+)
       AND B.STECODE = V_STECODE
       AND (B.PATNO = V_PATNO OR V_PATNO IS NULL)
       AND (S.DOCCODE = V_DOCCODE OR V_DOCCODE IS NULL)
       AND B.BKGPNAME LIKE V_BGKPNAME || '%'
       AND B.BKGSDATE >= TO_DATE(V_BKGSDATE || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
       AND (B.BKGEDATE <= TO_DATE(V_BKGEDATE || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') OR V_BKGEDATE IS NULL)
       AND (BKGSTS = V_BKGSTS OR V_BKGSTS IS NULL)
     ORDER BY B.BKGSDATE;
  RETURN OUTCUR;
END NHS_LIS_BOOKING;