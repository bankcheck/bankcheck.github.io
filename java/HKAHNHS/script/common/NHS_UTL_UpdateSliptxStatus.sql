-- Transaction.bas \ UpdateSliptxStatus
CREATE OR REPLACE PROCEDURE "NHS_UTL_UPDATESLIPTXSTATUS" (
	i_slpno     IN VARCHAR2,
	i_ntxtype   IN VARCHAR2,
	i_otxtype   IN VARCHAR2,
	i_stnid     IN VARCHAR2,	-- TransactionID
	i_dpsid     IN VARCHAR2		-- DepositID
)
IS
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
BEGIN
	IF TRIM(i_stnid) IS NOT NULL THEN
		UPDATE Sliptx
		SET    StnType = i_ntxtype
		WHERE  stnid = TO_NUMBER(i_stnid);
	ELSIF TRIM(i_dpsid) IS NOT NULL then
		UPDATE Sliptx
		SET    StnType = i_ntxtype
		WHERE  slpno = i_slpno
		AND    StnXRef = to_number(i_dpsid)
		AND    stntype = i_otxtype;
	ELSE
		UPDATE Sliptx
		SET    StnType = i_ntxtype
		WHERE  slpno = i_slpno
		AND   (stnsts = SLIPTX_STATUS_NORMAL
		OR     stnsts = SLIPTX_STATUS_ADJUST)
		AND    stntype = i_otxtype;
	END IF;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END NHS_UTL_UPDATESLIPTXSTATUS;
/
