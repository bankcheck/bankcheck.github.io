-- Transaction.bas \ reCalculateCPS
CREATE OR REPLACE FUNCTION NHS_UTL_RECALCULATECPS(
	i_SlpNo  IN VARCHAR2,
	i_OUTCUR IN TYPES.CURSOR_TYPE,
	i_UsrId  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
IS
	r_ConPceChg Sys.NewConPceChange_Rec;

	o_errcode NUMBER := 0;
	v_errcode NUMBER := 0;
	v_errmsg VARCHAR2(1000) := 'OK';
BEGIN
	o_errmsg := 'OK';

	IF i_OUTCUR IS NOT NULL THEN
		-- lock re-calculate
		v_errcode := NHS_ACT_RECORDLOCK('ADD', 'RecalCPS', i_SlpNo, '127.0.0.1', i_UsrId, v_errmsg);
		IF v_errcode = 0 THEN
			LOOP
				FETCH i_OUTCUR INTO r_ConPceChg;
				EXIT WHEN i_OUTCUR%NOTFOUND ;

				dbms_output.put_line('[' || r_ConPceChg.StnID || '][' || r_ConPceChg.newAcmCode || ']' ||
	                        'Old:[' || r_ConPceChg.oldBAmt || ']%:[' || r_ConPceChg.oldDisc || ']' ||
	                        'New:[' || r_ConPceChg.newOAmt || ']:[' || r_ConPceChg.newBAmt || ']%:[' ||
	                        r_ConPceChg.newDisc || ']Flag:[' || r_ConPceChg.newCPSFlag || ']' ||
	                        r_ConPceChg.NewGlcCode || ']');

				-- AdjustCPSEntry
				o_errcode := NHS_ACT_ADJUSTCPSENTRY('ADD', i_SlpNo, r_ConPceChg.StnID,
					r_ConPceChg.newAcmCode, r_ConPceChg.oldBAmt, r_ConPceChg.oldDisc,
					r_ConPceChg.newOAmt, r_ConPceChg.newBAmt, r_ConPceChg.newDisc,
					r_ConPceChg.newCPSFlag, r_ConPceChg.NewGlcCode, i_UsrId, o_errmsg);
			END LOOP;

			-- unblock re-calculate
			v_errcode := NHS_ACT_RECORDUNLOCK('DEL', 'RecalCPS', i_SlpNo, '127.0.0.1', i_UsrId, v_errmsg);
		ELSE
			o_errcode := -1;
		END IF;
	ELSE
		o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	-- unblock
	v_errcode := NHS_ACT_RECORDUNLOCK('DEL', 'RecalCPS', i_SlpNo, '127.0.0.1', i_UsrId, v_errmsg);

	o_errcode := -1;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
END NHS_UTL_RECALCULATECPS;
/
