CREATE OR REPLACE
FUNCTION "NHS_RPT_RPTARAGING" (
  v_SyDate VARCHAR2,
  v_ArCode VARCHAR2,
  v_SteCode varchar2
)
  RETURN Types.cursor_type
AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    SELECT  at.arccode, am.arcname, at.patno as pnum,
            decode(at.patno, null,sp.slpfname,pt.patfname)
            ||' '||
            DECODE(AT.PATNO,NULL,SP.SLPGNAME,PT.PATGNAME)AS PATIENT,
            at.slpno||DECODE(GET_REAL_STECODE(),'AMC1','CWB','AMC2','TKP','') as ref, to_char(at.atxcdate, 'DDMONYYYY', 'nls_date_language=ENGLISH') as atxcdate,--
            at.atxamt - at.atxsamt as amt,
            SC.STENAME,
            SP.SLPTYPE AS PTYPE,
            TO_DATE(V_SYDATE, 'dd/mm/yyyy') - AT.ATXCDATE AS AGE  
    FROM    SITE SC, ARTX AT, ARCODE AM, SLIP SP, PATIENT PT
    WHERE   (AM.ARCCODE= V_ARCODE OR V_ARCODE IS NULL)
    AND     AM.STECODE= V_STECODE
    AND     AT.ARCCODE = AM.ARCCODE
    AND     AT.ATXSTS = 'N'
    AND     AT.ATXAMT - AT.ATXSAMT <> 0
    AND     AT.SLPNO = SP.SLPNO(+)
    AND     AM.STECODE = SC.STECODE
    AND     AT.PATNO = PT.PATNO(+)
    ORDER BY at.arccode,  am.arcname, at.atxcdate;

RETURN OUTCUR;
END NHS_RPT_RPTARAGING;
/