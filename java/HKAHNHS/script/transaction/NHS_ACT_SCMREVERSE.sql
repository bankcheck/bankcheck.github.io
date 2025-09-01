CREATE OR REPLACE FUNCTION "NHS_ACT_SCMREVERSE" (
	v_action   IN VARCHAR2,--ADD
	v_sydid    IN VARCHAR2,
	v_cdate    IN VARCHAR2,
	userCancel IN VARCHAR2, --1-yes,0-no
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	rs_specomdtl specomdtl%ROWTYPE;
	v_sydid1 NUMBER;

	SLIP_PAYMENT_B4_PAID_REVERSE VARCHAR2(1) := 'X';
	SLIP_PAYMENT_USER_REVERSE VARCHAR2(1) := 'U';
	SLIP_PAYMENT_REVERSE VARCHAR2(1) := 'R';
	SLIP_PAYMENT_CANCEL VARCHAR2(1) := 'C';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
		BEGIN
			SELECT * INTO rs_specomdtl  FROM specomdtl WHERE sydid = to_number(v_sydid);
		EXCEPTION
		WHEN OTHERS THEN
			rs_specomdtl := null;
		END;

		SELECT seq_specomdtl.NEXTVAL INTO v_sydid1 FROM dual;

		IF rs_specomdtl.SYHID IS NULL THEN
			rs_specomdtl.SYDSTS := SLIP_PAYMENT_B4_PAID_REVERSE;
		ELSE
			IF UserCancel = '1' THEN
				rs_specomdtl.SYDSTS := SLIP_PAYMENT_B4_PAID_REVERSE;
			ELSE
				rs_specomdtl.SYDSTS := SLIP_PAYMENT_B4_PAID_REVERSE;
			END IF;
		END IF;

		IF v_cdate IS NULL OR trim(v_cdate)='' THEN
			rs_specomdtl.sydcdate:=sysdate;
		ELSE
			IF length(v_cdate)=10 THEN
				rs_specomdtl.sydcdate:=to_date(v_cdate,'dd/mm/yyyy');
			ELSE
				rs_specomdtl.sydcdate:=to_date(v_cdate,'dd/mm/yyyy hh24:mi:ss');
			END IF;
		END IF;

		rs_specomdtl.SYHID := '';
		rs_specomdtl.SYDAAMT := -1*rs_specomdtl.SYDAAMT;
		rs_specomdtl.SYHID := NULL;
		rs_specomdtl.SYDPCT := NULL;
		rs_specomdtl.SYDFAMT := NULL;
		rs_specomdtl.SYDPAMT := NULL;
		rs_specomdtl.STNNAMT := NULL;
		rs_specomdtl.SYDSAMT := NULL;
		rs_specomdtl.SYDCAMT := NULL;
		rs_specomdtl.SYDID_R := v_sydid;

		INSERT INTO specomdtl (
			SYDID,
			STNID,
			SLPNO,
			STNTYPE,
			PAYREF,
			SYDAAMT,
			SLPTYPE,
			DOCCODE,
			SYDCDATE,
			CTNCTYPE,
			CRARATE,
			SYDSTS,
			SYDPCT,
			SYDFAMT,
			SYHID,
			SYDPAMT,
			STNNAMT,
			SYDSAMT,
			SYDCAMT,
			PCYID,
			SYDID_R
		) VALUES (
			rs_specomdtl.sydid,
			rs_specomdtl.stnid,
			rs_specomdtl.slpno,
			rs_specomdtl.stntype,
			rs_specomdtl.payref,
			rs_specomdtl.sydaamt,
			rs_specomdtl.slptype,
			rs_specomdtl.doccode,
			rs_specomdtl.sydcdate,
			rs_specomdtl.ctnctype,
			rs_specomdtl.crarate,
			rs_specomdtl.sydsts,
			rs_specomdtl.sydpct,
			rs_specomdtl.sydfamt,
			rs_specomdtl.syhid,
			rs_specomdtl.sydpamt,
			rs_specomdtl.stnnamt,
			rs_specomdtl.sydsamt,
			rs_specomdtl.sydcamt,
			rs_specomdtl.pcyid,
			rs_specomdtl.sydid_r
		);

		IF SQL%rowcount=0 THEN
			o_errcode := -1;
			o_errmsg := 'insert fail.';
			ROLLBACK;
			RETURN o_errcode;
		END IF;

		UPDATE SPECOMDTL
		SET SYDSTS = SLIP_PAYMENT_CANCEL
		WHERE SYDID = v_sydid;

		UPDATE SLIPTX
		SET stnascm = NULL
		WHERE stnid = rs_specomdtl.STNID;
	END IF;

	RETURN o_errcode;
END NHS_ACT_SCMREVERSE;
/
