CREATE OR REPLACE FUNCTION "NHS_ACT_CANCELPACKAGE" (
	v_action  IN VARCHAR2,
	v_slpno   IN VARCHAR2,
	v_stnid   IN VARCHAR2,
	i_usrid   IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_chkpt VARCHAR2(10) := '0000';
	v_pkgcode VARCHAR2(10);
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
BEGIN
	SELECT pkgcode INTO v_pkgcode FROM sliptx WHERE slpno = v_slpno AND stnid = v_stnid AND (stnsts = SLIPTX_STATUS_NORMAL OR stnsts = SLIPTX_STATUS_ADJUST);

	v_chkpt := '0010';
	IF v_pkgcode IS NULL THEN
		o_errmsg := 'Fail to cancel package due to NULL pkgcode.';
		RETURN o_errcode;
	END IF;

	v_chkpt := '0020';
	FOR slp IN (
		SELECT sx.stnid, sx.stntdate
		FROM   sliptx sx
		LEFT JOIN xreg xr ON sx.dixref = xr.stnid
		WHERE  sx.slpno = v_slpno
		AND    sx.pkgcode = v_pkgcode
		AND   (sx.stnsts = SLIPTX_STATUS_NORMAL OR sx.stnsts = SLIPTX_STATUS_ADJUST)
		AND    xr.stnID IS NULL
	)
	LOOP
		o_errcode := NHS_ACT_REVERSEENTRY( 'ADD', v_slpno, slp.stnid,
			TO_CHAR(sysdate,'dd/mm/yyyy HH24:MI:SS'), TO_CHAR(slp.stntdate,'dd/mm/yyyy HH24:MI:SS'),
			'1', i_usrid, o_errmsg);
		IF o_errcode = -1 THEN
			ROLLBACK;
			RETURN o_errcode;
		END IF;
	END LOOP;

	NHS_UTL_UPDATESLIP(v_slpno);

	o_errcode := 0;
	RETURN o_errcode;
END NHS_ACT_CANCELPACKAGE;
/
