create or replace FUNCTION NHS_ACT_ADJUSTARDRCHGENTRY (
	v_Action        IN VARCHAR2,
	v_SlipNo        IN VARCHAR2,
	v_TransactionID IN VARCHAR2,
	i_doccode       IN VARCHAR2,
	i_arccode       IN VARCHAR2,
	v_usrid         IN VARCHAR2,
	o_errmsg        OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	rs_sliptx sliptx%ROWTYPE;
	v_StnID NUMBER;
	v_slpseq NUMBER;
	lDixref NUMBER;
	v_stntdate VARCHAR2(20);

	v_arccode SLIP.ARCCODE%TYPE;
	v_CursorType 	TYPES.CURSOR_TYPE;
	v_stdamt ITEMCHG.ITCAMT1%TYPE;
	v_ardrchgamt ITEMCHG.ITCAMT1%TYPE;
	v_ardrchgpct ITEMCHG.CPSPCT%TYPE;
	v_NewBillAmt ITEMCHG.ITCAMT1%TYPE;
	v_NewDiscAmt ITEMCHG.CPSPCT%TYPE;

	incur types.cursor_type;
begin
	o_errcode := 0;
	o_errmsg := 'OK';

--	if (i_arccode is null or i_arccode = '') THEN
--		SELECT COUNT(1) INTO v_noOfRec FROM SLIP WHERE slpno = v_SlipNo and arccode is not null;
--		IF v_noOfRec > 0 THEN
--			SELECT ARCCODE INTO v_arccode FROM SLIP WHERE slpno = v_SlipNo;
--		ELSE
--			v_arccode := i_arccode;
--		END IF;
--	ELSE
--		v_arccode := i_arccode;
--	END IF;

	IF v_Action = 'ADD' THEN
		SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE StnID = v_TransactionID;
		IF v_noOfRec <= 0 THEN
			o_errcode := -1;
			o_errmsg := 'no record found.';
			RETURN o_errcode;
		END IF;
		SELECT DIXREF INTO LDIXREF FROM SLIPTX WHERE StnID = v_TransactionID;

		SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE dixref = lDixref AND StnSts = 'N';
		IF v_noOfRec <= 0 THEN
			o_errcode := -1;
			o_errmsg := 'no record found.';
			RETURN o_errcode;
		END IF;
		SELECT * INTO RS_SLIPTX FROM SLIPTX WHERE DIXREF = LDIXREF AND STNSTS = 'N';
    		--CHECK ARDRCHG--
	  	V_Cursortype := NHS_LIS_ARDRCHG_DTL(RS_SLIPTX.slpno, RS_SLIPTX.ITMCODE,RS_SLIPTX.PKGCODE,RS_SLIPTX.ACMCODE, i_doccode,i_arccode, to_char(RS_SLIPTX.STNTDATE,'dd/mm/yyyy'),v_usrid);
		LOOP
			FETCH v_CursorType INTO
			v_ardrchgamt,
			v_ardrchgpct,
			V_STDAMT;

			V_NOOFREC:= v_CursorType%ROWCOUNT;
			Exit When V_Cursortype%Notfound;
		End Loop;


		IF NHS_UTL_ARDRCHG_EXIST1(RS_SLIPTX.ITMCODE, RS_SLIPTX.PKGCODE, RS_SLIPTX.SLPNO, RS_SLIPTX.ACMCODE, i_docCode, RS_SLIPTX.STNTDATE, i_arccode) > 0 Then
			IF v_ardrchgamt IS NOT null then
				v_NewBillAmt := v_ardrchgamt;
				v_NewDiscAmt := '0';
			ELSIF v_ardrchgpct IS NOT NULL THEN
				v_NewBillAmt := v_stdamt;
				v_NewDiscAmt := v_ardrchgpct;
			ELSE
				v_NewBillAmt := RS_SLIPTX.stnbamt;
				v_NewDiscAmt := RS_SLIPTX.STNDISC;
			end if;
		ELSE
			v_NewBillAmt := v_stdamt;
			v_NewDiscAmt := '0';
		END IF;

		SELECT COUNT(1) INTO v_NOOFREC FROM SLIPTX WHERE StnID = v_TransactionID;
		OPEN incur FOR SELECT StnID FROM sliptx WHERE slpno = v_SlipNo AND dixref = lDixref AND StnSts in ('N', 'A');
		DBMS_OUTPUT.PUT_LINE('v_noOfRec>>>>'||v_NOOFREC);

		WHILE v_NOOFREC > 0 LOOP
			SELECT SEQ_SLIPTX.NEXTVAL INTO v_StnID FROM DUAL;
			SELECT COUNT(1) INTO v_NOOFREC FROM SLIPTX WHERE StnID = v_StnID;
		END LOOP;

		rs_sliptx.StnID := v_StnID;
		UPDATE SLIP SET SLPSEQ = SLPSEQ + 1 WHERE SLPNO = v_SLIPNO;

		SELECT slpseq - 1 INTO v_slpseq FROM SLIP WHERE slpno = v_SlipNo;
		rs_sliptx.slpno := v_SlipNo;
		rs_sliptx.stnseq := v_slpseq;
		--rs_sliptx.acmcode := v_AccomodationCode;
		RS_SLIPTX.STNDISC := TO_NUMBER(v_NewDiscAmt);
		--rs_sliptx.stnoamt := TO_NUMBER(v_NewOriAmt);
		RS_SLIPTX.STNBAMT := TO_NUMBER(v_NewBillAmt);
		IF rs_sliptx.UNIT > 0 THEN
			IF rs_sliptx.stndisc > 0 THEN
				rs_sliptx.stnnamt := ROUND((rs_sliptx.stnbamt/rs_sliptx.UNIT)*(1-rs_sliptx.stndisc/100))* rs_sliptx.UNIT;
			ELSE
				rs_sliptx.stnnamt := rs_sliptx.stnbamt;
			END IF;
		ELSE
			rs_sliptx.stnnamt := ROUND(rs_sliptx.stnbamt*(1-rs_sliptx.stndisc/100));
		END IF;
		rs_sliptx.stncdate := SYSDATE;
		rs_sliptx.usrid := v_usrid;
		rs_sliptx.stnadoc := NULL;
		rs_sliptx.stnascm := NULL;
--		rs_sliptx.stncpsflag := v_NewCPSFlag;
--		rs_sliptx.glccode := v_NewGlcCode;
		select COUNT(1) INTO v_noOfRec FROM xreg WHERE StnID = v_TransactionID;

		IF v_noOfRec > 0 THEN
			rs_sliptx.stndidoc := NULL;
			rs_sliptx.stndiflag := NULL;
			rs_sliptx.stnascm := NULL;
		END IF;
		rs_sliptx.STNDESC := rs_sliptx.STNDESC;
		--rs_sliptx.STNDESC := 'NHS_LIS_ARDRCHG_DTL('||RS_SLIPTX.slpno||', '||RS_SLIPTX.ITMCODE||','
		--                      ||RS_SLIPTX.PKGCODE||','||RS_SLIPTX.ACMCODE||', '||i_doccode||', '||RS_SLIPTX.STNTDATE||','||v_usrid||')';
		INSERT INTO sliptx(
			StnID,
			SLPNO,
			STNSEQ,
			StnSts,
			PKGCODE,
			ITMCODE,
			ITMTYPE,
			STNDISC,
			STNOAMT,
			STNBAMT,
			STNNAMT,
			DOCCODE,
			ACMCODE,
			GLCCODE,
			USRID,
			STNTDATE,
			STNCDATE,
			STNADOC,
			STNDESC,
			STNRLVL,
			STNTYPE,
			STNXREF,
			DSCCODE,
			DIXREF,
			STNDIDOC,
			STNDIFLAG,
			STNCPSFLAG,
			PCYID,
			STNASCM,
			UNIT,
			PCYID_O,
			TRANSVER,
			STNDESC1,
			CARDRATE,
			PAYMETHOD,
			IREFNO
		) VALUES(
			rs_sliptx.StnID,
			rs_sliptx.SLPNO,
			rs_sliptx.STNSEQ,
			rs_sliptx.StnSts,
			rs_sliptx.PKGCODE,
			rs_sliptx.ITMCODE,
			rs_sliptx.ITMTYPE,
			rs_sliptx.STNDISC,
			rs_sliptx.STNOAMT,
			rs_sliptx.STNBAMT,
			rs_sliptx.STNNAMT,
			rs_sliptx.DOCCODE,
			rs_sliptx.ACMCODE,
			rs_sliptx.GLCCODE,
			rs_sliptx.USRID,
			rs_sliptx.STNTDATE,
			rs_sliptx.STNCDATE,
			rs_sliptx.STNADOC,
			rs_sliptx.STNDESC,
			rs_sliptx.STNRLVL,
			rs_sliptx.STNTYPE,
			rs_sliptx.STNXREF,
			rs_sliptx.DSCCODE,
			rs_sliptx.DIXREF,
			rs_sliptx.STNDIDOC,
			rs_sliptx.STNDIFLAG,
			rs_sliptx.STNCPSFLAG,
			rs_sliptx.PCYID,
			rs_sliptx.STNASCM,
			rs_sliptx.UNIT,
			rs_sliptx.PCYID_O,
			rs_sliptx.TRANSVER,
			rs_sliptx.STNDESC1,
			rs_sliptx.CARDRATE,
			rs_sliptx.PAYMETHOD,
			rs_sliptx.IREFNO
		);

		IF SQL%rowcount = 0 THEN
			o_errcode := -1;
			o_errmsg := 'insert fail.';
			ROLLBACK;
			RETURN o_errcode;
		END IF;

		-- sliptx extra
		INSERT INTO SLIPTX_EXTRA(STNID, SLPNO, STNSEQ) VALUES (rs_sliptx.StnID, rs_sliptx.SLPNO, rs_sliptx.STNSEQ);

		LOOP
			FETCH incur INTO v_StnID ;
			EXIT WHEN incur%NOTFOUND;
			SELECT TO_CHAR(stntdate,'dd/mm/yyyy hh24:mi:ss') INTO v_stntdate FROM Sliptx WHERE StnID = v_StnID;

			o_errcode := NHS_ACT_REVERSEENTRY('ADD', v_SlipNo, v_StnID, NULL, v_stntdate, '0', v_usrid, o_errmsg);
			IF o_errcode = -1 THEN
				return o_errcode;
			END IF;
		END LOOP;
	ELSE
		o_errcode := -1;
		o_errmsg := 'parameter error.';
	END IF;
	return(o_errcode);

end NHS_ACT_ADJUSTARDRCHGENTRY;
/
