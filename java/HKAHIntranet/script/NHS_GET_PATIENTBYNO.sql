create or replace
FUNCTION "NHS_GET_PATIENTBYNO"
(V_PATNO IN VARCHAR2)
RETURN
TYPES.cursor_type
AS
OUTCUR TYPES.cursor_type;
BEGIN
     OPEN OUTCUR FOR
          select
          Patfname,
          patgname,
          patidno,
          to_char(patbdate,'dd/mm/yyyy'),
          pathtel,
          patSex,
          patcname,
          patpager
          from Patient@IWEB
          where patno = V_PATNO;
     RETURN OUTCUR;
END NHS_GET_PATIENTBYNO;