CREATE OR REPLACE FUNCTION NHS_UTL_SlpPayAllLockAR (
	i_SlpNo        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_ErrMsg       OUT VARCHAR2
)
	RETURN BOOLEAN
AS
	v_sql VARCHAR2(1000);
	v_tmpArCode VARCHAR2(5);
	v_rslt NUMBER;
	v_tmpcur TYPES.CURSOR_TYPE;
	v_return BOOLEAN;
	e_lock_failed EXCEPTION;
	v_ErrMsg VARCHAR2(1000);

	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	MSG_ARCODE_LOCK VARCHAR2(31) := 'ArCode is locked by other user.';
BEGIN
    v_sql := 'SELECT DISTINCT a.arccode' ||
		' FROM Sliptx tx, Artx a' ||
		' WHERE tx.slpno = ''' || i_SlpNo || '''' ||
		' AND tx.stntype = ''' || SLIPTX_TYPE_PAYMENT_A || '''' ||
		' AND tx.stnxref = a.atxid' ||
		' AND a.atxsts = ''' || ARTX_STATUS_NORMAL || '''';

	OPEN v_tmpcur FOR v_sql;
		LOOP
			FETCH v_tmpcur INTO v_tmpArCode;
			EXIT WHEN v_tmpcur%NOTFOUND;
			v_rslt := NHS_ACT_RecordLock('', 'ArCode', v_tmpArCode, i_ComputerName, i_UserID, o_ErrMsg);
			IF v_rslt <> 0 THEN
				RAISE e_lock_failed;
			END IF;
		END LOOP;
	CLOSE v_tmpcur;

	RETURN TRUE;

EXCEPTION
WHEN e_lock_failed THEN
	v_return := NHS_UTL_SlpPayAllUnLockAR(i_SlpNo, i_ComputerName, i_UserID, v_ErrMsg);
	o_ErrMsg := MSG_ARCODE_LOCK || 'Please try later.' || ' ' || o_ErrMsg || ' ' || v_ErrMsg;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN FALSE;

WHEN OTHERS THEN
	v_return := NHS_UTL_SlpPayAllUnLockAR(i_SlpNo, i_ComputerName, i_UserID, v_ErrMsg);
	o_ErrMsg := MSG_ARCODE_LOCK || 'Please try later.' || ' ' || o_ErrMsg || ' ' || v_ErrMsg;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN FALSE;
END;
/
