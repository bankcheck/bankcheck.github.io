create or replace
function "NHS_LIS_PATIENT_ALERT"
(v_PATNO VARCHAR2, v_userid varchar2 default 'HKAH')
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT A.ALTCODE, A.ALTDESC
    FROM   PATALTLINK@IWEB P, ALERT@IWEB A
    WHERE  P.ALTID = A.ALTID
    AND    P.PATNO = v_PATNO
    AND    P.USRID_C IS NULL
    AND    P.ALTID IN
    (
        SELECT DISTINCT R.ALTID
        FROM   USRROLE@IWEB U, ROLALTLINK@IWEB R
        WHERE  U.ROLID = R.ROLID
        AND    U.USRID = v_userid
    )
    AND    ROWNUM < 100
    ORDER  BY A.ALTCODE;
  RETURN OUTCUR;
END NHS_LIS_PATIENT_ALERT;
/