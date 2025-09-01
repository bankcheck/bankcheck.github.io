CREATE OR REPLACE FUNCTION NHS_UTL_SCMAUTO (
	p_slpno VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN BOOLEAN
IS
	l_slptype slip.slptype%type;
	l_pcyid	slip.pcyid%type;
	l_sql VARCHAR2(32767);
	l_cnt NUMBER(5);
	l_arcount NUMBER(5);
	pay_cur TYPES.CURSOR_TYPE;
	chg_cur TYPES.CURSOR_TYPE;
	o_errcode NUMBER;

	pay_obj SPA_pay_obj := SPA_pay_obj( NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ) ;
	chg_obj SPA_chg_obj := SPA_chg_obj( NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ) ;

	pay_tab SPA_pay_tab := SPA_pay_tab();

	chg_tab SPA_chg_tab := SPA_chg_tab();
	l_chgTot NUMBER(12,4) := 0;
	l_payTot NUMBER(12,4) := 0;

	pay_chg SPA_pay_chg_row := SPA_pay_chg_row();

	l_ctnctype VARCHAR2(10);
	l_crarate FLOAT(126);

	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIP_PAYMENT_AUTO_ALLOCATE VARCHAR2(1) := 'A';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	SLIPTX_TYPE_DEPOSIT_I VARCHAR2(1) := 'I';
	SLIPTX_TYPE_PAYMENT_I VARCHAR2(1) := 'I';
BEGIN
	-- Debug
	o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMAuto', 'start', p_slpno, 'SYSTEM', null, o_errmsg);
	
	SELECT slptype, pcyid INTO l_slptype, l_pcyid FROM slip WHERE slpno = p_slpno;
	IF l_pcyid IS NULL THEN
		-- Debug
		o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMAuto', 'cp1', p_slpno || ' slip pcyid is null', 'SYSTEM', null, o_errmsg);
		RETURN TRUE;
	END IF;

	SELECT count(1) INTO l_arcount FROM artx WHERE slpno = p_slpno AND atxamt <> atxsamt AND atxsts = ARTX_STATUS_NORMAL AND arpid IS NULL;
	IF l_arcount > 0 THEN
		-- Debug
		o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMAuto', 'cp2', p_slpno || ' ar allocate not complete', 'SYSTEM', null, o_errmsg);
		RETURN TRUE;
	END IF;

	-- Payment
	pay_cur := NHS_UTL_SCMGetPay( p_slpno, FALSE );
	FETCH pay_cur INTO pay_obj.key, pay_obj.stntype, pay_obj.itmcode, pay_obj.stndesc, pay_obj.stnxref, pay_obj.stncdate, pay_obj.payref, pay_obj.arccode, pay_obj.stnnamt ;
	IF pay_cur%NOTFOUND THEN
		CLOSE pay_cur;
		chg_cur := NHS_UTL_SCMGetChg( p_slpno, FALSE );
		LOOP
            FETCH chg_cur INTO chg_obj.STNID, chg_obj.PKGCODE, chg_obj.ITMCODE, chg_obj.STNDESC, chg_obj.DOCCODE, chg_obj.STNCDATE, chg_obj.STNNAMT, chg_obj.PCYID ;
			EXIT WHEN chg_cur%NOTFOUND;
			l_chgTot := l_chgTot + chg_obj.stnnamt;
		END LOOP;
		CLOSE chg_cur;

		IF l_chgTot <= 0 THEN
			pay_cur := NHS_UTL_SCMGetPay( p_slpno, TRUE );
			FETCH pay_cur INTO pay_obj.key, pay_obj.stntype, pay_obj.itmcode, pay_obj.stndesc, pay_obj.stnxref, pay_obj.stncdate, pay_obj.payref, pay_obj.arccode, pay_obj.stnnamt ;
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
        pay_obj.pay_amt := - pay_obj.stnnamt ;
		pay_tab( pay_tab.LAST() ) := pay_obj ;

        l_payTot := l_payTot + pay_obj.stnnamt ;

		FETCH pay_cur INTO pay_obj.key, pay_obj.stntype, pay_obj.itmcode, pay_obj.stndesc, pay_obj.stnxref, pay_obj.stncdate, pay_obj.payref, pay_obj.arccode, pay_obj.stnnamt ;
		EXIT WHEN pay_cur%NOTFOUND;
	END LOOP;
	CLOSE pay_cur;

	-- Charge
	chg_cur := NHS_UTL_SCMGetChg( p_slpno, FALSE );
	FETCH chg_cur INTO chg_obj.STNID, chg_obj.PKGCODE, chg_obj.ITMCODE, chg_obj.STNDESC, chg_obj.DOCCODE, chg_obj.STNCDATE, chg_obj.STNNAMT, chg_obj.PCYID ;
	IF chg_cur%NOTFOUND THEN
		CLOSE chg_cur;
		RETURN TRUE;
	END IF;
	LOOP
		chg_tab.EXTEND();
		chg_tab(chg_tab.LAST()) := chg_obj ;
		l_chgTot := l_chgTot + chg_obj.stnnamt;

		FETCH chg_cur INTO chg_obj.STNID, chg_obj.PKGCODE, chg_obj.ITMCODE, chg_obj.STNDESC, chg_obj.DOCCODE, chg_obj.STNCDATE, chg_obj.STNNAMT, chg_obj.PCYID ;
		EXIT WHEN chg_cur%NOTFOUND;
	END LOOP;
	CLOSE chg_cur;
	l_payTot := abs( l_payTot );
	l_chgTot := abs( l_chgTot );

	FOR p in 1..pay_tab.last
	LOOP
		pay_chg.EXTEND;
		pay_chg(p) := SPA_pay_chg_col();
		pay_chg(p).EXTEND(chg_tab.LAST());
	END LOOP;

	NHS_UTL_SlpPayAllAutoCal( pay_tab, chg_tab, pay_chg ) ;
	
	-- Debug
	o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMAuto', 'cp3', p_slpno || ': loop chg_tab pay_tab', 'SYSTEM', null, o_errmsg);

	FOR c in reverse 1..chg_tab.last
	LOOP
		FOR p in 1..pay_tab.last
		LOOP
			l_ctnctype := NULL;
			l_crarate := NULL;
			
			BEGIN
				IF pay_tab(p).stntype = SLIPTX_TYPE_PAYMENT_C or ( pay_tab(p).stntype = SLIPTX_TYPE_REFUND AND pay_tab(p).stnxref is not NULL ) THEN
					SELECT craname, crarate INTO l_ctnctype, l_crarate FROM cashtx ctx, cardtx ctn, cardrate cr
					WHERE ctxid = pay_tab(p).stnxref AND ctx.ctnid = ctn.ctnid AND (
													( ctx.ctxmeth <> CASHTX_PAYTYPE_EPS AND upper(rtrim(ctn.ctnctype)) = cr.craname) or
													( ctx.ctxmeth = CASHTX_PAYTYPE_EPS AND cr.craname = 'EPS') );
				ELSIF pay_tab(p).stntype = SLIPTX_TYPE_PAYMENT_A THEN
					NHS_UTL_GetCreditCardRate( pay_tab(p).payref, l_ctnctype, l_crarate );
				ELSIF pay_tab(p).stntype = SLIPTX_TYPE_DEPOSIT_I THEN
					SELECT paymethod, cardrate INTO l_ctnctype, l_crarate FROM sliptx WHERE stnid = substr( pay_tab(p).key, 2);
				END IF;
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;

			INSERT INTO SPECOMDTL ( SYDID, SLPTYPE, SYDSTS, SLPNO, STNID, DOCCODE, SYDCDATE, PCYID, STNTYPE, PAYREF, SYDAAMT, CTNCTYPE, CRARATE )
			VALUES ( SEQ_SPECOMDTL.NEXTVAL, l_slptype, SLIP_PAYMENT_AUTO_ALLOCATE, p_slpno, chg_tab(c).stnid, chg_tab(c).doccode, sysdate,
				chg_tab(c).pcyid, pay_tab(p).stntype, pay_tab(p).payref, pay_chg(p)(c), l_ctnctype, l_crarate );
		END LOOP;
	END LOOP;

	RETURN TRUE;
EXCEPTION
WHEN OTHERS THEN
	-- Debug
	o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMAuto', 'error', p_slpno, 'SYSTEM', null, o_errmsg);
	
	o_errmsg := SQLERRM;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN FALSE;
END NHS_UTL_SCMAUTO;
/
