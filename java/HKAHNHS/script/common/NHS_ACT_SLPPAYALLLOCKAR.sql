CREATE OR REPLACE FUNCTION NHS_ACT_SlpPayAllLockAR (
	i_action       IN VARCHAR2,
	i_SlpNo        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_ErrMsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
BEGIN
	IF NHS_UTL_SlpPayAllLockAR(i_SlpNo, i_ComputerName, i_UserID, o_ErrMsg) THEN
		RETURN 0;
	ELSE
		RETURN -1;
	END IF;
END;
/
