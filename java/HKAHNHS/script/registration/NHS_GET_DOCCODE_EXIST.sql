CREATE OR REPLACE FUNCTION "NHS_GET_DOCCODE_EXIST" (
	i_DocCode VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT DocCode, DocFName || ' ' || DocGName
		FROM   Doctor
		WHERE  UPPER(DocCode) = UPPER(i_DocCode)
		AND    rownum = 1
		AND    DocSts = -1;
	RETURN outcur;
END NHS_GET_DOCCODE_EXIST;
/
