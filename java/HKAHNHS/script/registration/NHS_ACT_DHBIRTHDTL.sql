create or replace
FUNCTION NHS_ACT_DHBIRTHDTL (
	v_action    IN VARCHAR2,
	v_patno     IN VARCHAR2,
	v_patmother IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	sMO_SlpNo VARCHAR2(50);
	strUnit VARCHAR2(50);
	iRegid NUMBER;
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	rs_dhbirthdtl DHBIRTHDTL%ROWTYPE;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
		rs_dhbirthdtl.dhbirthid := seq_dhbirthdtl.NEXTVAL;
		rs_dhbirthdtl.bbpatno := v_patno;
		rs_dhbirthdtl.mopatno := v_patmother;

--		SELECT COUNT(1) INTO v_noOfRec FROM reg WHERE regsts = 'N' AND inpid IS NOT NULL AND patNo = v_patmother;
		SELECT COUNT(1) INTO v_noofrec
		FROM   reg
		WHERE  regsts = 'N'
		AND    inpid IS NOT NULL
		AND    patno = v_patmother
		AND    regtype = 'I';

		IF v_noOfRec > 0 THEN
--			SELECT MAX(regid) INTO iRegid FROM reg WHERE regsts = 'N' AND inpid IS NOT NULL AND patNo = v_patmother;
			SELECT TO_CHAR(MAX(regid)) INTO iRegid
			FROM   reg
			WHERE  regsts = 'N'
			AND    inpid IS NOT NULL
			AND    patno = v_patmother
			AND    regtype = 'I';

			SELECT slpNo INTO sMO_SlpNo FROM reg WHERE regid = iRegid;
			IF LENGTH(sMO_SlpNo) > 0 THEN
				 rs_dhbirthdtl.moslpno := sMO_SlpNo;
			END IF;
		END IF;

		rs_dhbirthdtl.recstatus := 'N';
		rs_dhbirthdtl.birthorder := 1;
		rs_dhbirthdtl.childeverbornalive := 0;

		SELECT COUNT(1) INTO v_noOfRec FROM sysparam WHERE parcde = 'weightunit';
		IF v_noOfRec > 0 THEN
			SELECT param1 INTO strUnit FROM sysparam WHERE parcde = 'weightunit';
		END IF;
		rs_dhbirthdtl.bbweighunit := strUnit;
    
    	O_ERRCODE := NHS_ACT_SYSLOG(V_ACTION, 'DHBIRTHDTL', 'BB PATNO: '||rs_dhbirthdtl.BBPATNO, rs_dhbirthdtl.MOSLPNO || ' is mother slpno, '||iRegid || ' is RegID', 'SYSUSER', NULL, O_ERRMSG);

		INSERT INTO DHBIRTHDTL (
			 DHBIRTHID,
			 DHBIRTHNO,
			 BBPATNO,
			 MOPATNO,
			 MOSLPNO,
			 HOSPITALCODE,
			 WEIGHTATBIRTH,
			 BBWEIGHUNIT,
			 CHILDEVERBORNALIVE,
			 DATEOFLASTLIVEBIRTH,
			 BIRTHORDER,
			 MALF_DET,
			 MALF1,
			 MALF2,
			 MALF3,
			 MALF4,
			 MALF5,
			 MALF6,
			 MALF7,
			 MALF8,
			 MALF9,
			 MO_DOCNO,
			 MO_TRAVELDOCTYPE,
			 BATCHNO,
			 RECSTATUS,
			 FORCE_SEND,
			 CONFIRMBY,
			 CONFIRMDATE,
			 SENDDATE
		) VALUES (
			 rs_dhbirthdtl.DHBIRTHID,
			 rs_dhbirthdtl.DHBIRTHNO,
			 rs_dhbirthdtl.BBPATNO,
			 rs_dhbirthdtl.MOPATNO,
			 rs_dhbirthdtl.MOSLPNO,
			 rs_dhbirthdtl.HOSPITALCODE,
			 rs_dhbirthdtl.WEIGHTATBIRTH,
			 rs_dhbirthdtl.BBWEIGHUNIT,
			 rs_dhbirthdtl.CHILDEVERBORNALIVE,
			 rs_dhbirthdtl.DATEOFLASTLIVEBIRTH,
			 rs_dhbirthdtl.BIRTHORDER,
			 rs_dhbirthdtl.MALF_DET,
			 rs_dhbirthdtl.MALF1,
			 rs_dhbirthdtl.MALF2,
			 rs_dhbirthdtl.MALF3,
			 rs_dhbirthdtl.MALF4,
			 rs_dhbirthdtl.MALF5,
			 rs_dhbirthdtl.MALF6,
			 rs_dhbirthdtl.MALF7,
			 rs_dhbirthdtl.MALF8,
			 rs_dhbirthdtl.MALF9,
			 rs_dhbirthdtl.MO_DOCNO,
			 rs_dhbirthdtl.MO_TRAVELDOCTYPE,
			 rs_dhbirthdtl.BATCHNO,
			 rs_dhbirthdtl.RECSTATUS,
			 rs_dhbirthdtl.FORCE_SEND,
			 rs_dhbirthdtl.CONFIRMBY,
			 rs_dhbirthdtl.CONFIRMDATE,
			 rs_dhbirthdtl.SENDDATE
		);
	ELSE
		o_errcode := -1;
		o_errmsg := 'Parameter error.';
	END IF;

	RETURN o_errcode;
end NHS_ACT_DHBIRTHDTL;
/