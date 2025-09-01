CREATE OR REPLACE FUNCTION NHS_LIS_ITEMCHARGEVALIDATE (
	i_ItmCat   IN OUT VARCHAR2,
	i_ItmType  IN VARCHAR2,
	i_TxMode   IN VARCHAR2,
	i_SlpNo    IN VARCHAR2,
	i_ItmCode  IN VARCHAR2,
	i_SlpType  IN VARCHAR2,
	i_ChrgType IN VARCHAR2,
	i_AcmCode  IN VARCHAR2,
	i_Unit     IN NUMBER,
	i_Amount   IN NUMBER,
	i_SlpHDisc IN NUMBER,
	i_SlpDDisc IN NUMBER,
	i_SlpSDisc IN NUMBER,
	o_errmsg   OUT VARCHAR2
)
	RETURN Types.cursor_type
is
	outcur types.cursor_type;
	v_returnnum NUMBER;
	v_flagToDi2 VARCHAR2(2); -- Y IS TRUE
	SUB_PROC_ERR EXCEPTION;
	o_StnOAmt NUMBER;
	o_StnBAmt NUMBER;
	o_StnCpsFlag Sliptx.StnCpsFlag%TYPE;
	o_SlpCpsid NUMBER;
	o_flagToDi BOOLEAN;
	o_StnDisc NUMBER;
	o_StnRlvl NUMBER;
	v_DocCode SLIP.DOCCODE%TYPE;
	v_TxDate VARCHAR(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
begin
	v_returnnum := NHS_UTL_ITEMCHARGEVALIDATE(
		i_ItmCat,
		i_ItmType,
		i_TxMode,
		v_TxDate,
		i_SlpNo,
		i_ItmCode,
		i_SlpType,
		i_ChrgType,
		i_AcmCode,
		i_Unit,
		i_Amount,
		i_SlpHDisc,
		i_SlpDDisc,
		i_SlpSDisc,
		o_StnOAmt,
		o_StnBAmt,
		o_StnCpsFlag,
		o_SlpCpsid,
		o_flagToDi,
		o_StnDisc,
		o_StnRlvl,
		o_errmsg);

	IF v_returnnum = -1 THEN
--		dbms_output.put_line('CALL pNHS_UTL_ITEMCHARGEVALIDATE FAILED');
		RAISE SUB_PROC_ERR;
	END IF;

	IF o_flagToDi THEN
		v_flagToDi2 := 'Y';
	ELSE
		v_flagToDi2 := 'N';
	END IF;

	IF o_StnOAmt IS NULL THEN
		o_StnOAmt := 0;
	END IF;

	IF o_StnBAmt IS NULL THEN
		o_StnBAmt := 0;
	END IF;

	IF o_StnDisc IS NULL THEN
		o_StnDisc := 0;
	END IF;

	BEGIN
		SELECT DOCCODE
		INTO v_DocCode
		FROM SLIP
		WHERE SLPNO = i_SlpNo;
	EXCEPTION
	WHEN OTHERS THEN
		v_DocCode := NULL;
	END;

	OPEN outcur FOR
		SELECT NULL, i_ItmCode, i_ItmCat, o_StnOAmt, o_StnBAmt, o_StnDisc, NULL, v_DocCode, NULL, i_AcmCode, v_flagToDi2, o_StnCpsFlag, i_Unit, NULL, NULL, o_StnRlvl, i_ItmType
		FROM DUAL;
		RETURN OUTCUR;
EXCEPTION
WHEN SUB_PROC_ERR THEN
	dbms_output.put_line('[o_errmsg]:'||o_errmsg);
	OPEN outcur FOR
	SELECT 1 FROM dual WHERE 1=2;
	RETURN OUTCUR;
WHEN OTHERS THEN
	o_errmsg := '[ERROR@]' ||SQLCODE||' - '||SQLERRM;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM||';[o_errmsg]:'||o_errmsg);
	OPEN outcur FOR
	SELECT 1 FROM dual WHERE 1=2;
	RETURN OUTCUR;
END NHS_LIS_ITEMCHARGEVALIDATE;
/
