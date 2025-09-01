CREATE OR REPLACE FUNCTION "NHS_LIS_TXNSLIPPAYALL_CHG"(V_slpno slip.slpno%TYPE
                                                       )
  RETURN Types.cursor_type AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT '',
           TX.PKGCODE,
           TX.ITMCODE,
           TX.STNDESC,
           TX.DOCCODE,
           TX.STNNAMT - NVL(SUM(SPD.SPDAAMT), 0) AS STNNAMT,
           TX.STNID,
           to_char(TX.STNCDATE,'dd/mm/yyyy hh24:mi:ss')
      FROM SLIP S, SLIPTX TX, SLPPAYDTL SPD
     WHERE S.SLPNO = v_slpno
       AND TX.STNSEQ >= NVL(SLPSEQFM, 1)
       AND S.SLPNO = TX.SLPNO
       AND TX.STNTYPE = 'D'
       AND TX.ITMTYPE = 'D'
       AND TX.STNID = SPD.STNID(+)
       AND TX.STNSTS IN ('N', 'A')
       AND TX.STNADOC IS NULL
     GROUP BY TX.STNID,
              TX.PKGCODE,
              TX.ITMCODE,
              TX.STNDESC,
              TX.DOCCODE,
              TX.STNCDATE,
              TX.STNNAMT
    HAVING TX.STNNAMT - NVL(SUM(SPD.SPDAAMT), 0) <> 0;
     RETURN OUTCUR;
END NHS_LIS_TXNSLIPPAYALL_CHG;
/
