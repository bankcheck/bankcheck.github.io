create or replace
FUNCTION "NHS_LIS_DOCITMPCT"
(
  V_DOCCODE DOCTOR.DOCCODE%TYPE,
  V_STECODE DOCITMPCT.STECODE%TYPE
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT *
    FROM
    (
      (
        SELECT P.SLPTYPE||'~'||P.PCYID||'~'||NVL(P.DSCCODE, I.DSCCODE)||'~'||P.ITMCODE AS CODE, 
                NVL(P.DIPPCT, '-1') AS PCT, 
                NVL(P.DIPFIX, '-1') AS FIX
        FROM DOCITMPCT P, ITEM I
        WHERE P.DOCCODE = V_DOCCODE
        AND P.ITMCODE = I.ITMCODE(+)
        AND P.STECODE = I.STECODE(+)
        AND P.STECODE = V_STECODE
      )
      UNION 
      (
        SELECT 'I~~~' AS CODE, NVL(DOCPCT_I, '-1') AS PCT, 0 AS FIX
        FROM DOCTOR 
        WHERE DOCCODE = V_DOCCODE
      )
      UNION 
      (
        SELECT 'O~~~' AS CODE, NVL(DOCPCT_O, '-1') AS PCT, 0 AS FIX 
        FROM DOCTOR 
        WHERE DOCCODE = V_DOCCODE
      )
      UNION 
      (
        SELECT 'D~~~' AS CODE, NVL(DOCPCT_D, '-1') AS PCT, 0 AS FIX 
        FROM DOCTOR 
        WHERE DOCCODE = V_DOCCODE
      )
    );
  RETURN OUTCUR;
END NHS_LIS_DOCITMPCT;
/