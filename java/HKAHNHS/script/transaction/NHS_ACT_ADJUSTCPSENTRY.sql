CREATE OR REPLACE FUNCTION NHS_ACT_ADJUSTCPSENTRY (
	v_Action	       IN VARCHAR2,
	v_SlipNo           IN VARCHAR2,
	v_TransactionID    IN VARCHAR2,
	v_AccomodationCode IN VARCHAR2,
	v_OldBillAmt       IN VARCHAR2,
	v_OldDisAmt        IN VARCHAR2,
	v_NewOriAmt        IN VARCHAR2,
	v_NewBillAmt       IN VARCHAR2,
	v_NewDiscAmt       IN VARCHAR2,
	v_NewCPSFlag       IN VARCHAR2,
	v_NewGlcCode       IN VARCHAR2,
	v_usrid            IN VARCHAR2,
	o_errmsg	       OUT VARCHAR2
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
	incur types.cursor_type;
begin
	o_errcode := 0;
	o_errmsg := 'OK';

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

		SELECT * INTO RS_SLIPTX FROM SLIPTX WHERE DIXREF = LDIXREF AND StnSts = 'N';

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
		rs_sliptx.acmcode := v_AccomodationCode;
		RS_SLIPTX.STNDISC := TO_NUMBER(v_NewDiscAmt);
		rs_sliptx.stnoamt := TO_NUMBER(v_NewOriAmt);
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
		rs_sliptx.stncpsflag := v_NewCPSFlag;
		rs_sliptx.glccode := v_NewGlcCode;
		select COUNT(1) INTO v_noOfRec FROM xreg WHERE StnID = v_TransactionID;

		IF v_noOfRec > 0 THEN
			rs_sliptx.stndidoc := NULL;
			rs_sliptx.stndiflag := NULL;
			rs_sliptx.stnascm := NULL;
		END IF;

		dbms_output.put_line(rs_sliptx.StnSts);
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

end NHS_ACT_ADJUSTCPSENTRY;
/
