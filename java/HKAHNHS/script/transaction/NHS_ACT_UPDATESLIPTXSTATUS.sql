-- Transaction.bas \ UpdateSliptxStatus
CREATE OR REPLACE FUNCTION "NHS_ACT_UPDATESLIPTXSTATUS" (
	v_action	IN VARCHAR2,
	v_slpno     IN VARCHAR2,
	v_ntxtype   IN VARCHAR2,
	v_otxtype   IN VARCHAR2,
	v_stnid     IN VARCHAR2,	-- TransactionID
	v_dpsid     IN VARCHAR2,	-- DepositID
	o_errmsg	OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
 BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	NHS_UTL_UPDATESLIPTXSTATUS(v_slpno, v_ntxtype, v_otxtype, v_stnid, v_dpsid);

	RETURN o_errcode;
end NHS_ACT_UPDATESLIPTXSTATUS;
/


