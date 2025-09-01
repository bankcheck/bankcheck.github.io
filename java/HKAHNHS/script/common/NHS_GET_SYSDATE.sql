CREATE OR REPLACE FUNCTION "NHS_GET_SYSDATE" (
	v_userID IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR Types.cursor_type;
BEGIN
   OPEN OUTCUR FOR
   SELECT TO_CHAR(SYSDATE, 'dd/mm/yyyy'),
          TO_CHAR(SYSDATE, 'HH24:MI:SS'),
          TO_CHAR(SYSDATE, 'dd/mm/yyyy HH24:MI:SS'),
          TO_CHAR(SYSDATE, 'yyyyDDD')
   FROM   DUAL;
   RETURN OUTCUR;
end NHS_GET_SYSDATE;
/


