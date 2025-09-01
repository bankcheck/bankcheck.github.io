-- Transaction.bas \ LookupItemCharge
CREATE OR REPLACE PROCEDURE NHS_SYS_LookupItemCharge (
	i_TxDate  IN VARCHAR2,
	i_ItmCode IN VARCHAR2,
	i_ItcType IN VARCHAR2,
	i_AcmCode IN VARCHAR2,
	i_Credit  IN BOOLEAN DEFAULT FALSE,
	i_ItmRLvl OUT NUMBER,
	i_Rate1   IN OUT ItemChg.ItcAmt1%TYPE,
	i_Rate2   IN OUT ItemChg.ItcAmt2%TYPE,
	i_Rate3   IN OUT ItemChg.ItcAmt1%TYPE,
	i_Rate4   IN OUT ItemChg.ItcAmt2%TYPE,
	i_Cpsid   IN OUT VARCHAR2,
	i_Cpspct  IN OUT NUMBER,
	i_PkgCode IN VARCHAR2)
IS
	v_cnt NUMBER(5);
	v_stntdate DATE;
	v_AcmCode CreditChg.AcmCode%TYPE;
BEGIN
	v_cnt := 0;
	v_AcmCode := NHS_UTL_LookupAcmCode(i_TxDate, i_AcmCode, i_ItmCode, i_PkgCode, i_Credit, NULL );

	IF i_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(i_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	IF i_ItcType = 'O' AND v_AcmCode LIKE 'ZZ%' THEN
		IF i_Credit THEN
			FOR r IN (
				SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
				FROM   Item i, CreditChg ic
				WHERE  i.ItmCode = i_ItmCode
				AND    i.itmcode = ic.itmcode
				AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
				AND    ic.ItcType = i_ItcType
				AND    ic.AcmCode = v_AcmCode
				AND    ic.Cpsid IS NULL
				AND  ( ic.cicsdt IS NULL OR ic.cicsdt <= v_stntdate )
				AND  ( ic.cicedt IS NULL OR ic.cicedt >= v_stntdate )
			) LOOP
				v_cnt := v_cnt + 1;
				i_Rate1 := r.ItcAmt1;
				i_Rate2 := r.ItcAmt2;
				i_Rate3 := r.ItcAmt1;
				i_Rate4 := r.ItcAmt2;
				i_ItmRLvl := r.ItmRLvl;
				EXIT;
			END LOOP;
		ELSE
			FOR r IN (
				SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
				FROM   Item i, ItemChg ic
				WHERE  i.ItmCode = i_ItmCode
				AND    i.itmcode = ic.itmcode
				AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
				AND    ic.ItcType = i_ItcType
				AND    ic.AcmCode = v_AcmCode
				AND    ic.Cpsid IS NULL
				AND  ( ic.itcsdt IS NULL OR ic.itcsdt <= v_stntdate )
				AND  ( ic.itcedt IS NULL OR ic.itcedt >= v_stntdate )
			) LOOP
				v_cnt := v_cnt + 1;
				i_Rate1 := r.ItcAmt1;
				i_Rate2 := r.ItcAmt2;
				i_Rate3 := r.ItcAmt1;
				i_Rate4 := r.ItcAmt2;
				i_ItmRLvl := r.ItmRLvl;
				EXIT;
			END LOOP;
		END IF;

		IF v_cnt = 1 AND i_Cpsid IS NOT NULL THEN
			v_AcmCode := NHS_UTL_LookupAcmCode(i_TxDate, i_AcmCode, i_ItmCode, i_PkgCode, i_Credit, i_Cpsid );
			IF i_Credit THEN
				FOR r IN (
					SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
					FROM   Item i, CreditChg ic
					WHERE  i.ItmCode = i_ItmCode
					AND    i.itmcode = ic.itmcode
					AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
					AND    ic.ItcType = i_ItcType
					AND    ic.AcmCode = v_AcmCode
					AND    ic.Cpsid = i_Cpsid
					AND  ( ic.cicsdt IS NULL OR ic.cicsdt <= v_stntdate )
					AND  ( ic.cicedt IS NULL OR ic.cicedt >= v_stntdate )
				) LOOP
					v_cnt := v_cnt + 1;
					IF r.ItcAmt1 IS NOT NULL THEN
						i_Rate3 := r.ItcAmt1;
					END IF;
					IF r.ItcAmt2 IS NOT NULL THEN
						i_Rate4 := r.ItcAmt2;
					END IF;
					IF r.Cpspct IS NOT NULL THEN
						i_Cpspct := r.Cpspct;
					END IF;
					IF r.ItmRLvl IS NOT NULL THEN
						i_ItmRLvl := r.ItmRLvl;
					END IF;
					EXIT;
				END LOOP;
			ELSE
				FOR r IN (
					SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
					FROM   Item i, ItemChg ic
					WHERE  i.ItmCode = i_ItmCode
					AND    i.itmcode = ic.itmcode
					AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
					AND    ic.ItcType = i_ItcType
					AND    ic.AcmCode = v_AcmCode
					AND    ic.Cpsid = i_Cpsid
					AND  ( ic.itcsdt IS NULL OR ic.itcsdt <= v_stntdate )
					AND  ( ic.itcedt IS NULL OR ic.itcedt >= v_stntdate )
				) LOOP
					v_cnt := v_cnt + 1;
					IF r.ItcAmt1 IS NOT NULL THEN
						i_Rate3 := r.ItcAmt1;
					END IF;
					IF r.ItcAmt2 IS NOT NULL THEN
						i_Rate4 := r.ItcAmt2;
					END IF;
					IF r.Cpspct IS NOT NULL THEN
						i_Cpspct := r.Cpspct;
					END IF;
					IF r.ItmRLvl IS NOT NULL THEN
						i_ItmRLvl := r.ItmRLvl;
					END IF;
					EXIT;
				END LOOP;
			END IF;

			IF v_cnt = 1 THEN
				i_Cpsid := NULL;
				i_Cpspct := NULL;
			END IF;
		END IF;
	END IF;

	IF v_cnt = 0 THEN
		IF i_Credit THEN
			FOR r IN (
				SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
				FROM   Item i, CreditChg ic
				WHERE  i.ItmCode = i_ItmCode
				AND    i.itmcode = ic.itmcode
				AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
				AND    ic.ItcType = i_ItcType
				AND (( ic.ItcType = 'I' AND ic.AcmCode = v_AcmCode )
				OR   ( ic.ItcType != 'I' AND ic.AcmCode IS NULL ))
				AND    ic.Cpsid IS NULL
				AND  ( ic.cicsdt IS NULL OR ic.cicsdt <= v_stntdate )
				AND  ( ic.cicedt IS NULL OR ic.cicedt >= v_stntdate )
			) LOOP
				v_cnt := v_cnt + 1;
				i_Rate1 := r.ItcAmt1;
				i_Rate2 := r.ItcAmt2;
				i_Rate3 := r.ItcAmt1;
				i_Rate4 := r.ItcAmt2;
				i_ItmRLvl := r.ItmRLvl;
				EXIT;
			END LOOP;
		ELSE
			FOR r IN (
				SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
				FROM   Item i, ItemChg ic
				WHERE  i.ItmCode = i_ItmCode
				AND    i.itmcode = ic.itmcode
				AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
				AND    ic.ItcType = i_ItcType
				AND (( ic.ItcType = 'I' AND ic.AcmCode = v_AcmCode )
				OR   ( ic.ItcType != 'I' AND ic.AcmCode IS NULL ))
				AND    ic.Cpsid IS NULL
				AND  ( ic.itcsdt IS NULL OR ic.itcsdt <= v_stntdate )
				AND  ( ic.itcedt IS NULL OR ic.itcedt >= v_stntdate )
			) LOOP
				v_cnt := v_cnt + 1;
				i_Rate1 := r.ItcAmt1;
				i_Rate2 := r.ItcAmt2;
				i_Rate3 := r.ItcAmt1;
				i_Rate4 := r.ItcAmt2;
				i_ItmRLvl := r.ItmRLvl;
				EXIT;
			END LOOP;
		END IF;

		IF v_cnt = 1 AND i_Cpsid IS NOT NULL THEN
			v_AcmCode := NHS_UTL_LookupAcmCode(i_TxDate, i_AcmCode, i_ItmCode, i_PkgCode, i_Credit, i_Cpsid );
			IF i_Credit THEN
				FOR r IN (
					SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
					FROM   Item i, CreditChg ic
					WHERE  i.ItmCode = i_ItmCode
					AND    i.itmcode = ic.itmcode
					AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
					AND    ic.ItcType = i_ItcType
					AND (( ic.ItcType = 'I' AND ic.AcmCode = v_AcmCode )
					OR   ( ic.ItcType != 'I' AND ic.AcmCode IS NULL ))
					AND    ic.Cpsid = i_Cpsid
					AND  ( ic.cicsdt IS NULL OR ic.cicsdt <= v_stntdate )
					AND  ( ic.cicedt IS NULL OR ic.cicedt >= v_stntdate )
				) LOOP
					v_cnt := v_cnt + 1;
					IF r.ItcAmt1 IS NOT NULL THEN
						i_Rate3 := r.ItcAmt1;
					END IF;
					IF r.ItcAmt2 IS NOT NULL THEN
						i_Rate4 := r.ItcAmt2;
					END IF;
					IF r.Cpspct IS NOT NULL THEN
						i_Cpspct := r.Cpspct;
					END IF;
					IF r.ItmRLvl IS NOT NULL THEN
						i_ItmRLvl := r.ItmRLvl;
					END IF;
					EXIT;
				END LOOP;
			ELSE
				FOR r IN (
					SELECT ItcAmt1, ItcAmt2, ItmRLvl, Cpspct
					FROM   Item i, ItemChg ic
					WHERE  i.ItmCode = i_ItmCode
					AND    i.itmcode = ic.itmcode
					AND (( i_PkgCode IS NULL AND ic.PkgCode IS NULL ) OR ( i_PkgCode IS NOT NULL AND ic.PkgCode = i_PkgCode ))
					AND    ic.ItcType = i_ItcType
					AND (( ic.ItcType = 'I' AND ic.AcmCode = v_AcmCode )
					OR   ( ic.ItcType != 'I' AND ic.AcmCode IS NULL ))
					AND    ic.Cpsid = i_Cpsid
					AND  ( ic.itcsdt IS NULL OR ic.itcsdt <= v_stntdate )
					AND  ( ic.itcedt IS NULL OR ic.itcedt >= v_stntdate )
				) LOOP
					v_cnt := v_cnt + 1;
					IF r.ItcAmt1 IS NOT NULL THEN
						i_Rate3 := r.ItcAmt1;
					END IF;
					IF r.ItcAmt2 IS NOT NULL THEN
						i_Rate4 := r.ItcAmt2;
					END IF;
					IF r.Cpspct IS NOT NULL THEN
						i_Cpspct := r.Cpspct;
					END IF;
					IF r.ItmRLvl IS NOT NULL THEN
						i_ItmRLvl := r.ItmRLvl;
					END IF;
					EXIT;
				END LOOP;
			END IF;

			IF v_cnt = 1 THEN
				i_Cpsid := NULL;
				i_Cpspct := NULL;
			END IF;
		END IF;
	END IF;

	IF v_cnt = 0 THEN
		i_Rate1 := NULL;
		i_Rate2 := NULL;
		i_Rate3 := NULL;
		i_Rate4 := NULL;
		i_ItmRLvl := NULL;
		i_Cpsid := NULL;
		i_Cpspct := NULL;
	END IF;
END;
/
