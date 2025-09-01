create or replace
FUNCTION "NHS_GET_MEDICALRECORDID"
(v_recordid IN VARCHAR2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
	select count(1) from MedRecHdr
	where patno = substr(v_recordid, 1, 6) and
	      mrhvollab = substr(v_recordid, 8);
   RETURN OUTCUR;
END NHS_GET_MEDICALRECORDID;
/
