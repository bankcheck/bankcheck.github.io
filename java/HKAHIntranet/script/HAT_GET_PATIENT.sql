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
        PATNO,
        PATFNAME,
        PATGNAME,
        TITDESC,
        PATCNAME,
        PATIDNO,
        PATSEX,
        RACDESC,
        RELIGIOUS,
        TO_CHAR(PATBDATE, 'DD/MM/YYYY'),
        PATMSTS,
        MOTHCODE,
        EDULEVEL,
        PATHTEL,
        PATOTEL,
        PATPAGER,
        PATFAXNO,
        OCCUPATION,
        PATEMAIL,
        PATADD1,
        PATADD2,
        PATADD3,
        PATKNAME,
        PATKRELA,
        PATKHTEL,
        PATKPTEL,
        PATKOTEL,
        PATKMTEL,
        PATKEMAIL,
        PATKADD,
        LOCCODE,
        COUCODE,
        PATMNAME,
        TO_CHAR(DEATH, 'DD/MM/YYYY'),
        PATMOTHER,
        PATNB,
        PATSTS,
        PATITP,
        PATSTAFF,
        LOCCODE,
        PATRMK
    FROM  PATIENT@IWEB
    WHERE (PATNO = v_PATNO
    OR     (PATIDNO = v_PATIDNO AND TO_CHAR(PATBDATE,'dd/MM/yyyy') = v_PATBDATE))
    AND   ROWNUM < 100
    ORDER BY PATNO;
  RETURN OUTCUR;
END HAT_GET_PATIENT;

/