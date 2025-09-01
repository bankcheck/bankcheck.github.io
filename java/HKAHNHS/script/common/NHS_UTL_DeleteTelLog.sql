CREATE OR REPLACE PROCEDURE NHS_UTL_DeleteTelLog(
	i_logid  IN VARCHAR2,
	i_UserID IN VARCHAR2
)
IS
BEGIN
	UPDATE TelLog
	SET Status = 'D', Delusr = i_UserID, LastUpDt = SYSDATE
	WHERE Logid = i_logid;
END NHS_UTL_DeleteTelLog;
/
