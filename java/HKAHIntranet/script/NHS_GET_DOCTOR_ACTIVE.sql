create or replace
FUNCTION "NHS_GET_DOCTOR_ACTIVE"
(
  V_DOCCODE IN DOCTOR.DOCCODE@IWEB%TYPE
)
  RETURN types.CURSOR_TYPE
AS
  OUTCUR types.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    select docgname||' '||docfname from doctor@IWEB where doccode=V_DOCCODE
    and docsts='-1';
  RETURN OUTCUR;
END NHS_GET_DOCTOR_ACTIVE;