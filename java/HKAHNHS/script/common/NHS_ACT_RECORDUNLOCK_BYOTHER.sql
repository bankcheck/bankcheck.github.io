CREATE OR REPLACE FUNCTION "NHS_ACT_RECORDUNLOCK_BYOTHER" (
	i_action       IN VARCHAR2,
	i_LockType     IN VARCHAR2,
	i_LockKey      IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	o_errmsg	   OUT VARCHAR2
)
	RETURN  NUMBER
AS
	o_errcode NUMBER;
	v_rlkid NUMBER;
begin
	o_errmsg := 'OK';
	o_errcode := 0;

	DELETE FROM RLock
	WHERE UPPER(RlkType) = UPPER(i_LockType)
	AND   UPPER(RlkKey)  = UPPER(i_LockKey);

	o_errcode := NHS_ACT_SYSLOG('DEL', 'Rlock', i_LockType || '-' || i_LockKey, 'Unlock ' || i_LockType || ' by user', i_UsrID, i_ComputerName, o_errmsg);

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
end NHS_ACT_RECORDUNLOCK_BYOTHER;
/
