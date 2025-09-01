CREATE OR REPLACE FUNCTION "NHS_GET_LOOKUPITEMCHARGE" (
	p_slpNo   IN VARCHAR2,
	p_ItmCode IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	v_ItmRLvl NUMBER;
	v_memCPSPct NUMBER;
	v_TxDate DATE := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
	v_DefaultRate ItemChg.ItcAmt1%TYPE;
	v_SecondRate ItemChg.ItcAmt2%TYPE;
	v_CPS_DefaultRate ItemChg.ItcAmt1%TYPE;
	v_CPS_SecondRate ItemChg.ItcAmt2%TYPE;
	v_memSlpType reg.regtype%TYPE;
	v_memAcmCode inpat.acmcode%TYPE;
	v_memCPSID arcode.cpsid%TYPE;
	outcur types.cursor_type;
BEGIN
	SELECT r.regtype, i.acmcode, a.cpsid
	INTO   v_memSlpType, v_memAcmCode, v_memCPSID
	FROM   reg r, inpat i, slip s, arcode a
	WHERE  r.inpid = i.inpid (+)
	AND    s.arccode = a.arccode (+)
	AND    r.slpno = s.slpno
	AND    r.slpno = p_slpNo;

	IF NOT v_memSlpType IS NULL THEN
		NHS_SYS_LookupItemCharge( v_TxDate, p_ItmCode, v_memSlpType, v_memAcmCode, FALSE,
			v_ItmRLvl, v_DefaultRate, v_SecondRate, v_CPS_DefaultRate, v_CPS_SecondRate, v_memCPSID, v_memCPSPct, NULL);

		OPEN outcur FOR
			SELECT v_ItmRLvl, v_memCPSPct, v_DefaultRate, v_SecondRate, v_CPS_DefaultRate, v_CPS_SecondRate, v_memCPSID
			FROM DUAL;
		RETURN OUTCUR;
	ELSE
		RETURN NULL;
	END IF;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('SQL Error: '||SQLCODE||' - '||SQLERRM);
	RETURN NULL;
	ROLLBACK;
END NHS_GET_LOOKUPITEMCHARGE;
/
