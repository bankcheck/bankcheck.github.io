CREATE OR REPLACE FUNCTION "NHS_ACT_SLIP_SETPRIMARY" (
	i_action   IN VARCHAR2,
	i_SlpNo    IN VARCHAR2,
	i_UsrID    IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_CNT     NUMBER;
	v_SEQID   NUMBER;
BEGIN
	o_errcode := -1;

	SELECT COUNT(1) INTO v_CNT FROM SLIPMERGE WHERE SLPNO = i_SlpNo;
	IF v_CNT > 0 THEN
		SELECT SEQID
		INTO   v_SEQID
		FROM   SLIPMERGE
		WHERE  SLPNO = i_SlpNo
		ORDER BY MRGDATE DESC;
	ELSE
		o_errmsg := 'Please do the slip merge before setup primary slip!';
		RETURN o_errcode;
	END IF;

	-- reset previous primary slip
	UPDATE SLIPMERGE
	SET    USRID = i_UsrID
	WHERE  SEQID = v_SEQID
	AND    USRID = 'PRIMARYSLP';

	-- set primary slip
	UPDATE SLIPMERGE
	SET    USRID = 'PRIMARYSLP'
	WHERE  SEQID = v_SEQID
	AND    SLPNO = i_SlpNo;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM || o_errmsg;

	RETURN -999;
END NHS_ACT_SLIP_SETPRIMARY;
/
