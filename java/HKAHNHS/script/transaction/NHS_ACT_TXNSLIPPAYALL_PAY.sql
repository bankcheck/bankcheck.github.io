CREATE OR REPLACE FUNCTION NHS_ACT_TXNSlIPPAYALL_PAY (
	v_action   IN VARCHAR2,
	v_stnid    IN VARCHAR2,
	v_slpno    IN VARCHAR2,
	v_amount   IN VARCHAR2,
	v_stntype  IN VARCHAR2,
	v_slptype  IN VARCHAR2,
	v_spdsts   IN VARCHAR2,
	v_doccode  IN VARCHAR2,
	v_spdcdate IN VARCHAR2,
	v_parref   IN VARCHAR2,
	v_ctnctype IN VARCHAR2,
	v_crarate  IN VARCHAR2,
	v_chgAmt   IN VARCHAR2,
	v_payAmt   IN VARCHAR2,
	v_spdid    IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_nextspdid number;

BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

  	IF v_action = 'ADD' THEN
  		SELECT seq_SLPPAYDTL.NEXTVAL INTO v_nextspdid FROM dual;
  		SELECT COUNT(1) INTO v_noOfRec FROM SLPPAYDTL d WHERE d.spdid = v_nextspdid;
	  	IF v_noOfRec = 0 THEN
	  		INSERT INTO SLPPAYDTL(
				SPDID,
				STNID,
				SLPNO ,
				STNTYPE,
				PAYREF,
				SPDAAMT,
				SLPTYPE,
				DOCCODE,
				SPDCDATE,
				CTNCTYPE,
				CRARATE,
				SPDSTS,
				SPDPCT ,
				SPDFAMT,
				SPHID,
				SPDPAMT,
				STNNAMT,
				SPDSAMT,
				SPDCAMT,
				PCYID,
				SPDID_R
			) VALUES(
				v_nextspdid,
				v_stnid,
				v_slpno,
				v_stntype,
				TO_NUMBER(v_parref),
				v_amount,
				v_slptype,
				v_doccode,
				TO_DATE(v_spdcdate,'dd/mm/yyyy'),
				v_ctnctype,
				v_crarate,
				'N',
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
		  	);
			---CHG STNTYPE
--			IF TO_NUMBER(v_chgAmt) = 0 THEN
--				UPDATE sliptx SET stntype = 'X' WHERE stnid = v_stnid;
--			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	END IF;
  	IF v_action = 'DEL' THEN
  		SELECT spdid INTO v_noOfRec FROM SLPPAYDTL WHERE spdid = v_spdid;
		IF v_noOfRec > 0 THEN
			UPDATE SLPPAYDTL
			SET    spdsts = 'C'
			WHERE  spdid = v_spdid;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
  	END IF;
  	RETURN o_errcode;
END NHS_ACT_TXNSlIPPAYALL_PAY;
/
