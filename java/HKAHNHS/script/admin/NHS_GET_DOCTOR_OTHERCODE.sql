CREATE OR REPLACE FUNCTION "NHS_GET_DOCTOR_OTHERCODE" (
	v_doccode VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	open outcur for
	SELECT
		doccode,decode(doccode,'7019','Foundation',(NVL(company,docadd1)))as docCom
	FROM  DOCTOR
	WHERE mstrdoccode = v_doccode;

	RETURN OUTCUR;
END NHS_GET_DOCTOR_OTHERCODE;
/
