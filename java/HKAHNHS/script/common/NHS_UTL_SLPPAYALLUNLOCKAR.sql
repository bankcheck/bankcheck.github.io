CREATE OR REPLACE FUNCTION NHS_UTL_SlpPayAllUnLockAR (
	i_SlpNo        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_ErrMsg       OUT VARCHAR2
)
	RETURN BOOLEAN
AS
	v_sql VARCHAR2(1000);
	v_tmpArCode VARCHAR2(5);
	v_tmpcur TYPES.CURSOR_TYPE;
	o_errcode NUMBER;

	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	v_sql := 'SELECT distinct a.arccode' ||
		' FROM Sliptx tx, Artx a' ||
		' WHERE tx.slpno = ''' || i_SlpNo || '''' ||
		' AND tx.stntype = ''' || SLIPTX_TYPE_PAYMENT_A || '''' ||
		' AND tx.stnxref = a.atxid' ||
		' AND a.atxsts = ''' || ARTX_STATUS_NORMAL || '''';

	OPEN v_tmpcur FOR v_sql;
		LOOP
			FETCH v_tmpcur INTO v_tmpArCode;
			EXIT WHEN v_tmpcur%NOTFOUND;
			o_errcode := NHS_ACT_RecordUnLock('', 'ArCode', v_tmpArCode, i_ComputerName, i_UserID, o_ErrMsg);
		END LOOP;
	CLOSE v_tmpcur;

	RETURN TRUE;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	o_ErrMsg := SQLERRM || ' ' || o_ErrMsg;
	RETURN FALSE;
END;
/
