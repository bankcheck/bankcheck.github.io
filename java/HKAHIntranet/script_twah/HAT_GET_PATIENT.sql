/*
SET SERVEROUTPUT ON
DECLARE x Types.cursor_type;
BEGIN
	x := HAT_GET_PATIENT('','K133693(2)','30/03/1973');
END;
*/
CREATE OR REPLACE FUNCTION "HAT_GET_PATIENT"
(v_PATNO VARCHAR2, v_PATIDNO VARCHAR2, v_PATBDATE VARCHAR2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT
        P.PATNO,
        P.PATFNAME,
        P.PATGNAME,
        P.TITDESC,
        P.PATCNAME,
        P.PATIDNO,
        P.PATSEX,
        P.RACDESC,
        P.RELIGIOUS,
        to_char(P.PATBDATE,'dd/MM/yyyy'),
        P.PATMSTS,
        P.MOTHCODE,
        P.EDULEVEL,
        P.PATHTEL,
        P.PATOTEL,
        P.PATPAGER,
        P.PATFAXNO,
        P.OCCUPATION,
        P.PATEMAIL,
        P.PATADD1,
        P.PATADD2,
        P.PATADD3,
        P.PATKNAME,
        P.PATKRELA,
        P.PATKHTEL,
        P.PATKPTEL,
        P.PATKOTEL,
        P.PATKMTEL,
        P.PATKEMAIL,
        P.PATKADD,
        P.LOCCODE,
        P.COUCODE,
        P.PATMNAME,
        to_char(P.DEATH,'dd/MM/yyyy'),
        P.PATMOTHER,
        P.PATNB,
        P.PATSTS,
        P.PATITP,
        P.PATSTAFF,
        P.LOCCODE,
        P.PATRMK
    FROM  PATIENT@IWEB P,LOCATION@IWEB L
    WHERE (P.PATNO = v_PATNO
    OR     (P.PATIDNO = v_PATIDNO AND TO_CHAR(P.PATBDATE,'dd/MM/yyyy') = v_PATBDATE))
    AND   P.LOCCODE= L.LOCCODE
    AND   ROWNUM < 100
    ORDER BY PATNO;
  RETURN OUTCUR;
END HAT_GET_PATIENT;

/