CREATE OR REPLACE FUNCTION NHS_UTL_SlpPayAllAuto (
	i_SlpNo       VARCHAR2,
	i_capturedate DATE,
	o_errmsg      OUT VARCHAR2
)
	RETURN BOOLEAN
IS
	v_SlpType slip.SlpType%TYPE;
	v_arcount NUMBER(5);
	v_chgTot NUMBER(12,4) := 0;
	v_payTot NUMBER(12,4) := 0;
	v_CtnCType VARCHAR2(10);
	v_CraRate FLOAT(126);
	v_count NUMBER := 0;

	pay_cur TYPES.CURSOR_TYPE;
	pay_obj SPA_pay_obj := SPA_pay_obj( NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ) ;
	pay_tab SPA_pay_tab := SPA_pay_tab();
	pay_chg SPA_pay_chg_row := SPA_pay_chg_row();

	chg_obj SPA_chg_obj := SPA_chg_obj( NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ) ;
	chg_cur TYPES.CURSOR_TYPE;
	chg_tab SPA_chg_tab := SPA_chg_tab();

	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIP_PAYMENT_AUTO_ALLOCATE VARCHAR2(1) := 'A';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	SLIPTX_TYPE_DEPOSIT_I VARCHAR2(1) := 'I';
	SLIPTX_TYPE_PAYMENT_I VARCHAR2(1) := 'I';

	v_SpdCDate DATE ;
	o_errcode NUMBER;
BEGIN
	BEGIN
		IF i_capturedate IS NOT NULL THEN
			v_SpdCDate := TRIM(i_capturedate);
		ELSE
			v_SpdCDate := TRIM(SYSDATE);
		END IF ;
	EXCEPTION WHEN OTHERS THEN
		v_SpdCDate := TRIM(SYSDATE);
	END;

	SELECT SlpType INTO v_SlpType FROM slip WHERE SlpNo = i_SlpNo;

	-- If slip has any unsettled AR Payment, auto calculation would be abort
	SELECT count(1) INTO v_arcount FROM Artx
	WHERE SlpNo = i_SlpNo AND Atxamt <> Atxsamt AND Atxsts = ARTX_STATUS_NORMAL AND Arpid IS NULL;
	
	o_errcode := NHS_ACT_SYSLOG('ADD', 'SlpPayAllAuto', 'Save', 'Unsettled AR Payment=' || v_arcount || ' (' || i_SlpNo || ')', null, null, o_errmsg);
	
	IF v_arcount > 0 THEN
		RETURN TRUE;
	END IF;

	-- Payment
	OPEN pay_cur FOR NHS_UTL_SLPPAYALLGETPAYSQL( i_SlpNo, FALSE );
	FETCH pay_cur INTO pay_obj.key, pay_obj.StnType, pay_obj.ItmCode, pay_obj.StnDesc, pay_obj.StnXRef, pay_obj.StnCDate, pay_obj.PayRef, pay_obj.arccode, pay_obj.StnNAmt ;
	IF pay_cur%NOTFOUND THEN
		CLOSE pay_cur;

		-- If total payment is Zero,
		-- Zero Case
		OPEN chg_cur FOR 'SELECT NVL(SUM(StnNAmt),0) FROM (' || NHS_UTL_SlpPayAllGetChgSQL(i_SlpNo) || ') tmp';
			LOOP
				FETCH chg_cur INTO v_chgTot;
				EXIT WHEN chg_cur%NOTFOUND;
			END LOOP;
		CLOSE chg_cur;

		-- If total charge is negative (reverse) or zero (adjustment of +N -N)
		-- Then get original payment to settle all remained charges.
		IF v_chgTot <= 0 THEN
			OPEN pay_cur FOR NHS_UTL_SLPPAYALLGETPAYSQL( i_SlpNo, TRUE );
			FETCH pay_cur INTO pay_obj.key, pay_obj.StnType, pay_obj.ItmCode, pay_obj.StnDesc, pay_obj.StnXRef, pay_obj.StnCDate, pay_obj.PayRef, pay_obj.arccode, pay_obj.StnNAmt ;
			IF pay_cur%NOTFOUND THEN
				CLOSE pay_cur;
				RETURN TRUE;
			END IF;
		ELSE
			RETURN TRUE;
		END IF;
	END IF;
	LOOP
		pay_tab.EXTEND();
        pay_obj.pay_amt := - pay_obj.StnNAmt ;
		pay_tab( pay_tab.LAST() ) := pay_obj ;

        v_payTot := v_payTot + pay_obj.StnNAmt ;

		FETCH pay_cur INTO pay_obj.key, pay_obj.StnType, pay_obj.ItmCode, pay_obj.StnDesc, pay_obj.StnXRef, pay_obj.StnCDate, pay_obj.PayRef, pay_obj.arccode, pay_obj.StnNAmt ;
		EXIT WHEN pay_cur%NOTFOUND;
	END LOOP;
	CLOSE pay_cur;

	-- Charge
	OPEN chg_cur FOR NHS_UTL_SlpPayAllGetChgSQL(i_SlpNo);
	FETCH chg_cur INTO chg_obj.StnID, chg_obj.PkgCode, chg_obj.ItmCode, chg_obj.StnDesc, chg_obj.DocCode, chg_obj.StnCDate, chg_obj.StnNAmt, chg_obj.PcyID ;
	IF chg_cur%NOTFOUND THEN
		CLOSE chg_cur;
		RETURN TRUE;
	END IF;
	LOOP
		chg_tab.EXTEND();
		chg_tab(chg_tab.LAST()) := chg_obj ;
		v_chgTot := v_chgTot + chg_obj.StnNAmt;

		FETCH chg_cur INTO chg_obj.StnID, chg_obj.PkgCode, chg_obj.ItmCode, chg_obj.StnDesc, chg_obj.DocCode, chg_obj.StnCDate, chg_obj.StnNAmt, chg_obj.PcyID ;
		EXIT WHEN chg_cur%NOTFOUND;
	END LOOP;
	CLOSE chg_cur;

	v_payTot := ABS( v_payTot );
	v_chgTot := ABS( v_chgTot );

	FOR p in 1..pay_tab.last
	LOOP
		pay_chg.EXTEND;
		pay_chg(p) := SPA_pay_chg_col();
		pay_chg(p).EXTEND(chg_tab.LAST());
	END LOOP;

	NHS_UTL_SlpPayAllAutoCal( pay_tab, chg_tab, pay_chg ) ;

	FOR c IN reverse 1..chg_tab.last
	LOOP
		FOR p IN 1..pay_tab.last
		LOOP
			v_CtnCType := NULL;
			v_CraRate := NULL;
				
			BEGIN
				IF pay_chg(p)(c) <> 0 THEN
					IF pay_tab(p).StnType = SLIPTX_TYPE_PAYMENT_C or ( pay_tab(p).StnType = SLIPTX_TYPE_REFUND AND pay_tab(p).StnXRef is not NULL ) THEN
						SELECT CraName, CraRate INTO v_CtnCType, v_CraRate FROM cashtx ctx, cardtx ctn, cardrate cr
						WHERE CtxID = pay_tab(p).StnXRef AND ctx.CtnID = ctn.CtnID AND (
													( ctx.ctxmeth <> CASHTX_PAYTYPE_EPS AND upper(rtrim(ctn.CtnCType)) = cr.CraName) or
													( ctx.ctxmeth = CASHTX_PAYTYPE_EPS AND cr.CraName = 'EPS') );
					ELSIF pay_tab(p).StnType = SLIPTX_TYPE_PAYMENT_A THEN
						NHS_UTL_GetCreditCardRate( pay_tab(p).PayRef, v_CtnCType, v_CraRate );
					ELSIF pay_tab(p).StnType = SLIPTX_TYPE_DEPOSIT_I THEN
						SELECT paymethod, cardrate INTO v_CtnCType, v_CraRate FROM sliptx WHERE StnID = substr( pay_tab(p).key, 2);
					END IF;
				ELSE
					IF pay_tab(p).StnType = SLIPTX_TYPE_PAYMENT_A THEN
						NHS_UTL_GetCreditCardRate( pay_tab(p).PayRef, v_CtnCType, v_CraRate );
					ELSIF pay_tab(p).StnType = SLIPTX_TYPE_DEPOSIT_I THEN
						SELECT paymethod, cardrate INTO v_CtnCType, v_CraRate FROM sliptx WHERE StnID = substr( pay_tab(p).key, 2);
					END IF ;
				END IF ;
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;

			INSERT INTO SLPPAYDTL ( SpdID, SlpType, SpdSts, SlpNo, StnID, DocCode, SpdCDate, PcyID, StnType, PayRef, SPDAAMT, CtnCType, CraRate )
			VALUES ( SEQ_SLPPAYDTL.NEXTVAL, v_SlpType, SLIP_PAYMENT_AUTO_ALLOCATE, i_SlpNo, chg_tab(c).StnID, chg_tab(c).DocCode, v_SpdCDate,
				chg_tab(c).PcyID, pay_tab(p).StnType, pay_tab(p).PayRef, pay_chg(p)(c), v_CtnCType, v_CraRate );
		END LOOP;
	END LOOP;

	RETURN TRUE;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN FALSE;
END NHS_UTL_SlpPayAllAuto;
/
