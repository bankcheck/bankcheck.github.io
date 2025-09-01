CREATE OR REPLACE FUNCTION "NHS_ACT_TRANTOINPAT"(
	v_ACTION        IN VARCHAR2,
	v_REGID         IN VARCHAR2,
	v_REGDATE       IN VARCHAR2,
	v_STECODE       IN VARCHAR2,
	v_USRID         IN VARCHAR2,
	v_COMPUTERNAME  IN VARCHAR2,
	o_ERRMSG        OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ERRCODE NUMBER;
	RS_REG REG%ROWTYPE;
	v_inpid NUMBER;
	v_REGID_NEW NUMBER(22);
	v_REGDATE_D DATE;
	v_SLIP_TYPE_INPATIENT VARCHAR2(1) := 'I';
	v_REG_TYPE_INPATIENT VARCHAR2(1) := 'I';
	v_REG_STS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	o_ERRCODE := -1;

	SELECT *
	INTO RS_REG
	FROM REG
	WHERE REGID = v_REGID;

	SELECT SEQ_INPAT.NEXTVAL INTO v_inpid FROM DUAL;
	INSERT INTO inpat(
		inpid,
		bedcode,
		acmcode,
		doccode_a,
		srccode
	) VALUES (
		v_inpid,
		'',
		'',
		RS_REG.DocCode,
		'HOME');

	o_ERRCODE := NHS_ACT_CREATESLIP('ADD',
				v_SLIP_TYPE_INPATIENT,
				RS_REG.DocCode,
				'',
				'DEPT',
				'',
				'',
				RS_REG.PATNO,
				NULL,
				NULL,
				v_STECODE,
				v_USRID,
				o_ERRMSG);

	IF o_ERRCODE <> -1 THEN
		SELECT SEQ_REG.NEXTVAL INTO v_REGID_NEW FROM DUAL;

		-- o_ERRCODE: new slip no
		IF v_REGDATE IS NULL OR TRIM(v_REGDATE) = '' THEN
			v_REGDATE_D := SYSDATE;
		ELSE
			v_REGDATE_D := TO_DATE(v_REGDATE, 'DD/MM/YYYY HH24:MI:SS');
		END IF;

		INSERT INTO reg(
			regid,
			patno,
			slpno,
			regdate,
			regtype,
			regopcat,
			regsts,
			inpid,
			doccode,
			pkgcode,
			stecode,
			regmddate,
			regnb,
			bkgid,
			pbpid,
			ticketno,
			daypid,
			ismainland
		) VALUES (
			v_REGID_NEW,
			RS_REG.patno,
			o_ERRCODE,
			v_REGDATE_D,
			v_REG_TYPE_INPATIENT,
			NULL,
			v_REG_STS_NORMAL,
			v_inpid,
			RS_REG.doccode,
			RS_REG.pkgcode,
			RS_REG.stecode,
			RS_REG.regmddate,
			RS_REG.regnb,
			RS_REG.bkgid,
			RS_REG.pbpid,
			RS_REG.ticketno,
			RS_REG.daypid,
			RS_REG.ismainland
		);

		INSERT INTO REG_EXTRA(
			REGID,
			CREATE_DATE,
			CREATE_USER,
			CREATE_LOC,
			MODIFY_DATE,
			MODIFY_USER
		) VALUES (
			v_REGID_NEW,
			SYSDATE,
			v_USRID,
			v_COMPUTERNAME,
			SYSDATE,
			v_USRID
		);

		-- update regid of slip created above
		UPDATE SLIP SET REGID = v_REGID_NEW WHERE SLPNO = o_ERRCODE;

		UPDATE Patient SET RegID_L = v_regid, RegID_C = v_REGID_NEW WHERE PatNo = RS_REG.patno;
	  END IF;
  RETURN o_ERRCODE;
END NHS_ACT_TRANTOINPAT;
/
