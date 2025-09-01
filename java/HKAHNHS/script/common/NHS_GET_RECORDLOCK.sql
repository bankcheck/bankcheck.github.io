CREATE OR REPLACE FUNCTION "NHS_GET_RECORDLOCK" (
	v_LockType	IN VARCHAR2,
	v_LockKey	IN VARCHAR2,
	v_MAC       IN VARCHAR2,
	v_UserID    IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur Types.cursor_type;
begin
	open outcur for
	SELECT U.USRNAME, U.USRID
	FROM   RLOCK R, USR U
	where  R.USRID = U.USRID
	AND    UPPER(R.RLKTYPE) = UPPER(v_LockType)
	AND    R.RLKKEY = v_LockKey
	AND    R.USRID != v_UserID
	AND    R.RLKMAC != v_MAC;
	RETURN outcur;
end NHS_GET_RECORDLOCK;
/
