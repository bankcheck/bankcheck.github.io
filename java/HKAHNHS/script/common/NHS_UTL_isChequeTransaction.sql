-- GlobalConst / getChequeCommitBuffer
create or replace FUNCTION "NHS_UTL_ISCHEQUETRANSACTION"(
	i_Stnxref IN NUMBER
)
	RETURN NUMBER
AS
	v_ChqComBuf NUMBER;
	v_Count     NUMBER;
	gChqComBuf  VARCHAR2(10) := 'CHQCOMBUF';

	CASHTX_PAYTYPE_CHEQUE VARCHAR2(1) := 'Q';
BEGIN
    -- getChequeCommitBuffer
    SELECT TO_NUMBER(Param1) INTO v_ChqComBuf FROM sysparam WHERE parcde = gChqComBuf;

	-- isChequeTransactionWithBuffer
	SELECT COUNT(1) INTO v_Count FROM Cashtx WHERE Ctxid = i_Stnxref AND CTXMETH = CASHTX_PAYTYPE_CHEQUE;
	IF v_Count = 1 THEN
		SELECT TRUNC(SYSDATE) - TRUNC(CTXCDATE) INTO v_Count FROM Cashtx WHERE Ctxid = i_Stnxref AND CTXMETH = CASHTX_PAYTYPE_CHEQUE;
		IF v_Count <= v_ChqComBuf THEN
			RETURN 1;
		END IF;
	END IF;

	RETURN -1;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_ISCHEQUETRANSACTION;
/
