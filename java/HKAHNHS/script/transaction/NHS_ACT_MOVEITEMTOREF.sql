CREATE OR REPLACE FUNCTION "NHS_ACT_MOVEITEMTOREF" (
	v_action    IN VARCHAR2,
	v_SlpNo     IN VARCHAR2,
	v_StnID     IN VARCHAR2,
	v_PkgCode   IN VARCHAR2,
	v_MovePkg   IN VARCHAR2,
	v_UsrID     IN VARCHAR2,
	o_ErrMsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_NoOfRec NUMBER;
	o_ErrCode NUMBER;
	v_BedCode Inpat.BedCode%TYPE;
	v_StnDesc SlipTx.StnDesc%TYPE;
	v_StnSeq NUMBER;
	v_indicator VARCHAR2(10);

	PKGTX_TYPE_NATUREOFVISIT VARCHAR2(1) := 'N';
	SLIP_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIP_STATUS_ADJUST VARCHAR2(1) := 'A';
BEGIN
	o_ErrCode := -1;
	o_ErrMsg := 'OK';

	SELECT COUNT(1) INTO v_NoOfRec FROM PACKAGE WHERE PKGCODE = v_MovePkg and pkgtype <> PKGTX_TYPE_NATUREOFVISIT;
	IF v_NoOfRec = 0 THEN
		o_ErrMsg := 'Invalid Package Code.';
		RETURN o_ErrCode;
	END IF;

	-- get bed code
	SELECT I.BedCode INTO v_BedCode
	FROM Slip S
	LEFT JOIN Reg R ON S.Regid = R.Regid
	LEFT JOIN Inpat I ON R.Inpid = I.Inpid
	WHERE  S.SlpNo = v_SlpNo;

	IF v_PkgCode IS NOT NULL THEN
		FOR R1 IN (SELECT StnID FROM SlipTx WHERE SlpNo = v_SlpNo AND PKGCODE = v_PkgCode AND StnSts IN (SLIP_STATUS_NORMAL, SLIP_STATUS_ADJUST) ORDER BY StnSeq)
		LOOP
			o_ErrCode := NHS_UTL_MOVESLIPTOPACKAGE(v_SlpNo, R1.StnID, v_BedCode, v_MovePkg, v_UsrID);
			IF o_ErrCode < 0 THEN
				ROLLBACK;
				o_ErrMsg := 'Fail to move item';
				RETURN o_ErrCode;
			END IF;
		END LOOP;
	ELSIF v_StnID IS NOT NULL THEN
		SELECT COUNT(1) INTO v_NoOfRec FROM SlipTx WHERE SlpNo = v_SlpNo AND StnID = v_StnID AND StnSts = SLIP_STATUS_NORMAL;
		IF v_NoOfRec = 0 THEN
			ROLLBACK;
			o_ErrMsg := 'Fail to move item.1' || v_indicator;
			RETURN o_ErrCode;
		END IF;

		SELECT StnSeq, StnDesc INTO v_StnSeq, v_StnDesc FROM SlipTx WHERE SlpNo = v_SlpNo AND StnID = v_StnID AND StnSts = SLIP_STATUS_NORMAL;

		o_ErrCode := NHS_UTL_MOVESLIPTOPACKAGE(v_SlpNo, v_StnID, v_BedCode, v_MovePkg, v_UsrID);
		IF o_ErrCode < 0 THEN
			ROLLBACK;
			o_ErrMsg := 'Fail to move item';
			RETURN o_ErrCode;
		END IF;

		FOR R2 IN (SELECT StnID FROM SlipTx WHERE SlpNo = v_SlpNo AND StnDesc = TO_CHAR(v_StnSeq) || ' ' || v_StnDesc AND StnSts = SLIP_STATUS_ADJUST)
		LOOP
			o_ErrCode := NHS_UTL_MOVESLIPTOPACKAGE(v_SlpNo, R2.StnID, v_BedCode, v_MovePkg, v_UsrID);
			IF o_ErrCode < 0 THEN
				ROLLBACK;
				o_ErrMsg := 'Fail to move item.2' || v_indicator;
				RETURN o_ErrCode;
			END IF;
		END LOOP;
	ELSE
		ROLLBACK;
		o_ErrMsg := 'Fail to move item';
		RETURN o_ErrCode;
	END IF;

	NHS_UTL_UPDATESLIP(v_SlpNo);

	o_ErrCode := 0;
	RETURN o_ErrCode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_ErrCode := -1;
	o_errMsg := 'Fail to move item.3' || v_indicator;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_ErrCode;
end NHS_ACT_MOVEITEMTOREF;
/
