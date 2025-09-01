CREATE OR REPLACE FUNCTION NHS_UTL_AUTOSLIPCAT (
	i_SlpNo   IN VARCHAR2,
	i_ItmCode IN VARCHAR2
)
	RETURN NUMBER
IS
	o_errcode NUMBER := 0;
	o_errmsg VARCHAR2(1000);
	v_COUNT NUMBER := 0;
	v_PatNo Slip.PatNo%TYPE;
	v_SlpType Slip.SlpType%TYPE;
	v_pcyid_o Slip.PcyID%TYPE;
	v_pcyid_n Slip.PcyID%TYPE;
BEGIN
	SELECT COUNT(1) INTO v_COUNT FROM Slip WHERE SlpNo = i_SlpNo;
	IF v_COUNT = 1 THEN
		SELECT PatNo, SlpType, pcyid INTO v_PatNo, v_SlpType, v_pcyid_o FROM Slip WHERE SlpNo = i_SlpNo;

		IF GET_CURRENT_STECODE() = 'HKAH' AND v_PatNo IS NOT NULL AND v_SlpType = 'O' AND v_COUNT = 1 THEN
			v_pcyid_n := v_pcyid_o;

			SELECT COUNT(1) INTO v_COUNT FROM PATALTLINK P, ALERT A
			WHERE P.ALTID = A.ALTID AND P.PATNO = v_PatNo AND P.PALCDATE IS NULL AND A.ALTCODE IN ('Y1D');
			IF v_COUNT > 0 THEN
				v_pcyid_n := 5; -- D
			END IF;

			SELECT COUNT(1) INTO v_COUNT FROM PATALTLINK P, ALERT A
			WHERE P.ALTID = A.ALTID AND P.PATNO = v_PatNo AND P.PALCDATE IS NULL AND A.ALTCODE IN ('Y1S', 'Y2S', 'PTS');
			IF v_COUNT > 0 OR i_ItmCode IN ('DFSPE', 'ESC01', 'SMD') THEN
				v_pcyid_n := 1; -- S
			END IF;

			IF i_ItmCode IN ('UCS', 'UCSH') OR (i_ItmCode LIKE 'RE%U' AND i_ItmCode NOT IN ('RE70U', 'RE93U')) THEN
				v_pcyid_n := 7; -- UC
			END IF;

			IF (v_pcyid_o IS NULL AND v_pcyid_n IS NOT NULL) OR v_pcyid_n != v_pcyid_o THEN
				o_errcode := NHS_UTL_SCMUPDATE(i_SlpNo, v_pcyid_n);
				IF o_errcode >= 0 THEN
					UPDATE Slip set pcyid = v_pcyid_n WHERE SlpNo = i_SlpNo;

					-- Debug
					o_errcode := NHS_ACT_SYSLOG('ADD', 'AutoSlipCat', 'pcyid', i_SlpNo || ' update pcyid from ' || v_pcyid_n || ' to ' || v_pcyid_n, 'SYSTEM', null, o_errmsg);
				ELSE
					o_errcode := -1;
					o_errmsg := 'Invalid SCM update.';
				END IF;
			END IF;
		END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
END NHS_UTL_AUTOSLIPCAT;
/
