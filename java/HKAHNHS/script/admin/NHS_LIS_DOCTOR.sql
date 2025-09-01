CREATE OR REPLACE FUNCTION "NHS_LIS_DOCTOR"
(
  V_DOCCODE IN VARCHAR2,
  V_DOCFNAME IN VARCHAR2,
  V_DOCGNAME IN VARCHAR2,
  V_DOCSEX IN VARCHAR2,
  V_DOCTYPE IN VARCHAR2,
  V_SPCCODE IN VARCHAR2,
  V_DOCBDATE IN VARCHAR2,
  V_DOCSTS IN VARCHAR2
)
    RETURN types.CURSOR_TYPE
  AS
    OUTCUR types.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
      SELECT DR.DOCCODE,
             DR.DOCFNAME,
             DR.DOCGNAME,
             DR.DOCCNAME,
             DR.DOCIDNO,
             DR.DOCSEX,
             SP.SPCNAME,
             DR.SPCCODE,
             DECODE(DR.DOCSTS, -1, 'Y', 'N'),
             DR.DOCTYPE,
             DR.DOCPCT_I,
             DR.DOCPCT_O,
             DR.DOCPCT_D,
             DR.DOCADD1,
             DR.DOCADD2,
             DR.DOCADD3,
             DR.DOCHTEL,
             DR.DOCOTEL,
             DR.DOCPTEL,
             DR.DOCTSLOT,
             DR.DOCQUALI,
             TO_CHAR(DR.DOCTDATE, 'DD/MM/YYYY'),
             TO_CHAR(DR.DOCSDATE, 'DD/MM/YYYY'),
             DR.DOCHOMADD1,
             DR.DOCHOMADD2,
             DR.DOCHOMADD3,
             DR.DOCOFFADD1,
             DR.DOCOFFADD2,
             DR.DOCOFFADD3,
             DECODE(DR.DOCCSHOLY, -1, 'Y', 'N'),
             DR.DOCMTEL,
             DR.DOCEMAIL,
             DR.DOCFAXNO,
             DR.DOCHOMADD4,
             DR.DOCADD4,
             DR.DOCOFFADD4,
             DECODE(DR.DOCPICKLIST, -1, 'Y', 'N'),
             DECODE(DR.DOCQUALIFY, -1, 'Y', 'N'),
             TO_CHAR(DR.DOCBDATE, 'DD/MM/YYYY'),
             DR.RPTTO,
             DECODE(DR.ISDOCTOR, -1, 'Y', 'N'),
             DR.TITTLE,
             DECODE(DR.ISOTSURGEON,-1,'Y','N'),
             DECODE(DR.ISOTANESTHETIST,-1,'Y','N'),
             DECODE(DR.SHOWPROFILE,-1,'Y','N')
        FROM DOCTOR DR, SPEC SP
WHERE DR.SPCCODE=SP.SPCCODE(+)
AND ( UPPER(DR.DOCCODE) LIKE '%' || UPPER(V_DOCCODE) || '%' )
AND ( UPPER(DR.DOCFNAME) LIKE '%' || UPPER(V_DOCFNAME) || '%' )
AND ( UPPER(DR.DOCGNAME) LIKE '%' || UPPER(V_DOCGNAME) || '%' )
AND ( UPPER(DR.DOCSEX) LIKE '%' || UPPER(V_DOCSEX) || '%' )
AND ( UPPER(DR.DOCTYPE) LIKE '%' || UPPER(V_DOCTYPE) || '%' )
AND ( UPPER(DR.SPCCODE) LIKE '%' || UPPER(V_SPCCODE) || '%' )
AND ( (DR.DOCBDATE = TO_DATE(V_DOCBDATE,'DD/MM/YYYY')) OR V_DOCBDATE IS NULL)
AND ( UPPER(DR.DOCSTS) LIKE '%' || UPPER(V_DOCSTS) || '%' )
--AND ROWNUM <100
ORDER BY DR.DOCCODE;
 RETURN outcur;
END NHS_LIS_DOCTOR;
/
