CREATE OR REPLACE FUNCTION NHS_ACT_CONFIRMDEPOSIT(
	v_action    IN VARCHAR2,
	v_slpno     IN VARCHAR2,
	v_dpsid     IN VARCHAR2,
	v_cdate     IN VARCHAR2,
	v_tdate     IN VARCHAR2,
	o_errmsg	OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	rs_Deposit Deposit%ROWTYPE;
	DEPOSIT_STATUS_AVAILABLE VARCHAR2(1) := 'A';
	DEPOSIT_STATUS_NORMAL VARCHAR2(1) := 'N';
begin
	o_errmsg := 'OK';
	o_errcode := 0;

	IF v_action = 'MOD' THEN
		rs_Deposit.Dpssts := DEPOSIT_STATUS_AVAILABLE;
		IF v_cdate IS NULL THEN
			rs_Deposit.Dpslcdate := SYSDATE;
		ELSE
			rs_Deposit.Dpslcdate := TO_DATE(v_cdate,'dd/mm/yyyy HH24:MI:SS');
		END IF;
		IF v_tdate IS NULL THEN
			rs_Deposit.Dpsltdate := TRIM(SYSDATE);
		ELSE
			IF LENGTH(v_tdate) = 10 THEN
				rs_Deposit.Dpsltdate := TRIM(TO_DATE(v_tdate,'dd/mm/yyyy'));
			ELSE
				rs_Deposit.Dpsltdate := TRIM(TO_DATE(v_tdate,'dd/mm/yyyy HH24:MI:SS'));
			END IF;
		END IF;

		IF v_dpsid IS NULL THEN
			UPDATE	Deposit
			SET		Dpssts = rs_Deposit.Dpssts,
					Dpslcdate = rs_Deposit.Dpslcdate,
					Dpsltdate = rs_Deposit.Dpsltdate
			WHERE	SlpNo_S = v_slpno
			AND		DpsSts = DEPOSIT_STATUS_NORMAL
			AND		DpsLCDate = DpsCDate;
		ELSE
			UPDATE	Deposit
			SET		Dpssts = rs_Deposit.Dpssts,
					Dpslcdate = rs_Deposit.Dpslcdate,
					Dpsltdate = rs_Deposit.Dpsltdate
			WHERE	DpsID = TO_NUMBER(v_dpsid)
			AND		DpsLCDate = DpsCDate;
		END IF;

		UPDATE	Deposit
		SET		Dpssts = rs_Deposit.Dpssts,
				Dpsltdate = rs_Deposit.Dpsltdate
		WHERE	SlpNo_S = v_slpno
		AND		DpsSts = DEPOSIT_STATUS_NORMAL
		AND		DpsLCDate <> DpsCDate;
	ELSE
		o_errcode := -1;
		o_errmsg := 'parameter error.';
	END IF;

	RETURN o_errcode;
END NHS_ACT_CONFIRMDEPOSIT;
/
