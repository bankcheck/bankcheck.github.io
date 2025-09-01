CREATE OR REPLACE FUNCTION "NHS_ACT_REVERSEENTRY" (
	v_action     IN VARCHAR2,--'ADD'
	v_slpno      IN VARCHAR2,
	v_stnid      IN VARCHAR2,
	v_stncdate   IN VARCHAR2,
	v_stntdate   IN VARCHAR2,
	v_userCancel IN VARCHAR2, --1-yes,0-no
	i_usrid      IN VARCHAR2,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_stnid1  NUMBER;
	rs_slpTx  sliptx%ROWTYPE;
	v_nextstnseq NUMBER;
	v_stndesc VARCHAR2(200);

	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
	SLIPTX_STATUS_USER_REVERSE VARCHAR2(1) := 'U';
	SLIPTX_STATUS_REVERSE VARCHAR2(1) := 'R';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
		SELECT COUNT(1) INTO v_noOfRec FROM sliptx where stnid = TO_NUMBER(v_stnid) AND (Stnsts = SLIPTX_STATUS_NORMAL OR Stnsts = SLIPTX_STATUS_ADJUST);
		IF v_noOfRec > 0 THEN
			SELECT * INTO rs_slpTx FROM sliptx where stnid = TO_NUMBER(v_stnid);
			SELECT seq_sliptx.NEXTVAL INTO v_stnid1 FROM dual;

			v_stndesc := rs_slpTx.Stndesc;

			rs_slpTx.Stndiflag := '';
			rs_slpTx.Stnid := v_stnid1;
			rs_slpTx.Stnadoc := '';
			rs_slpTx.Stndidoc := '';
			rs_slpTx.Stnascm := '';
			rs_slpTx.Stndesc := rs_slpTx.Stnseq;

			--stnseq
			UPDATE SLIP SET slpseq = slpseq + 1 WHERE slpno = v_slpno;

			SELECT slpseq - 1 INTO v_nextstnseq FROM SLIP WHERE slpno = v_slpno;

			rs_slpTx.Stnseq := v_nextstnseq;
			rs_slpTx.Stnoamt := -rs_slpTx.Stnoamt;
			rs_slpTx.Stnbamt := -rs_slpTx.Stnbamt;
			rs_slpTx.Stnnamt := -rs_slpTx.Stnnamt;

			IF v_stncdate IS NULL OR TRIM(v_stncdate) = '' THEN
				rs_slpTx.Stncdate := sysdate;
			ELSE
				IF LENGTH(v_stncdate)>10 THEN
					rs_slpTx.Stncdate := TO_DATE(v_stncdate,'dd/mm/yyyy hh24:mi:ss');
				ELSE
					rs_slpTx.Stncdate := TO_DATE(v_stncdate,'dd/mm/yyyy');
				END IF;
			END IF;

			IF v_stntdate IS NULL OR TRIM(v_stntdate) = '' THEN
				rs_slpTx.Stntdate := sysdate;
			ELSE
				IF LENGTH(v_stntdate) > 10 THEN
					rs_slpTx.Stntdate := TO_DATE(v_stntdate,'dd/mm/yyyy hh24:mi:ss');
				ELSE
					rs_slpTx.Stntdate := TO_DATE(v_stntdate,'dd/mm/yyyy');
				END IF;
			END IF;

			rs_slpTx.Usrid := i_usrid;
			IF v_userCancel = '1' THEN
				rs_slpTx.Stnsts := SLIPTX_STATUS_USER_REVERSE;
			ELSE
				rs_slpTx.Stnsts := SLIPTX_STATUS_REVERSE;
			END IF;

			rs_slpTx.Stndidoc := '';

			--tx start
			INSERT INTO sliptx(
				STNID       ,
				SLPNO       ,
				STNSEQ      ,
				STNSTS      ,
				PKGCODE     ,
				ITMCODE     ,
				ITMTYPE     ,
				STNDISC     ,
				STNOAMT     ,
				STNBAMT     ,
				STNNAMT     ,
				DOCCODE     ,
				ACMCODE     ,
				GLCCODE     ,
				USRID       ,
				STNTDATE    ,
				STNCDATE    ,
				STNADOC     ,
				STNDESC     ,
				STNRLVL     ,
				STNTYPE     ,
				STNXREF     ,
				DSCCODE     ,
				DIXREF      ,
				STNDIDOC    ,
				STNDIFLAG   ,
				STNCPSFLAG  ,
				PCYID       ,
				STNASCM     ,
				UNIT        ,
				PCYID_O     ,
				TRANSVER    ,
				STNDESC1    ,
				CARDRATE    ,
				PAYMETHOD   ,
				IREFNO
			) VALUES (
				rs_slpTx.Stnid,
				rs_slpTx.Slpno,
				rs_slpTx.Stnseq,
				rs_slpTx.Stnsts ,
				rs_slpTx.PKGCODE,
				rs_slpTx.ITMCODE,
				rs_slpTx.ITMTYPE,
				rs_slpTx.STNDISC,
				rs_slpTx.Stnoamt,
				rs_slpTx.Stnbamt,
				rs_slpTx.Stnnamt,
				rs_slpTx.DOCCODE,
				rs_slpTx.ACMCODE,
				rs_slpTx.GLCCODE,
				rs_slpTx.USRID,
				rs_slpTx.Stntdate,
				rs_slpTx.Stncdate,
				rs_slpTx.STNADOC ,
				rs_slpTx.Stndesc,
				rs_slpTx.STNRLVL,
				rs_slpTx.STNTYPE,
				rs_slpTx.STNXREF,
				rs_slpTx.DSCCODE,
				rs_slpTx.DIXREF,
				rs_slpTx.STNDIDOC,
				rs_slpTx.STNDIFLAG,
				rs_slpTx.STNCPSFLAG,
				rs_slpTx.PCYID,
				rs_slpTx.STNASCM,
				rs_slpTx.UNIT,
				rs_slpTx.PCYID_O,
				rs_slpTx.TRANSVER,
				rs_slpTx.STNDESC1,
				rs_slpTx.CARDRATE,
				rs_slpTx.PAYMETHOD,
				rs_slpTx.IREFNO
			);

			-- sliptx extra
			INSERT INTO SLIPTX_EXTRA(STNID, SLPNO, STNSEQ) VALUES (rs_slpTx.Stnid, rs_slpTx.Slpno, rs_slpTx.Stnseq);

			o_errcode := NHS_ACT_SETENTRY('MOD', v_stnid, 'C', v_stndesc, o_errmsg);
			IF o_errcode = -1 THEN
				rollback;
				RETURN o_errcode;
			END IF;

			o_errcode := NHS_ACT_SLPPAYALLSLIPTXREVERSE(v_action, v_stnid, rs_slpTx.Stntype, o_errmsg);
			IF o_errcode = -1 THEN
				rollback;
				RETURN o_errcode;
			END IF;

			o_errcode := NHS_ACT_SCMSLIPTXREVERSE(v_action, v_stnid, rs_slpTx.Stntype, o_errmsg);
			IF o_errcode = -1 THEN
				rollback;
				RETURN o_errcode;
			END IF;

			NHS_UTL_UPDATESLIP(v_slpno);
		ELSE
			o_errcode := -1;
			o_errmsg := 'No record found.';
		END IF;
	END IF;

	IF o_errcode = 0 THEN
		o_errcode := v_nextstnseq;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to reverse entry due to ' || SQLERRM || '.';
	ROLLBACK;
	RETURN o_errcode;
end NHS_ACT_REVERSEENTRY;
/
