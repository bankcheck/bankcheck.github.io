CREATE OR REPLACE FUNCTION NHS_ACT_MEDRECINSERT (
	v_patNo        IN VARCHAR2,
	v_siteCode     IN VARCHAR2,
	v_DocCode      IN VARCHAR2,
	v_MrdRmk       IN VARCHAR2,
	v_UserID       IN VARCHAR2,
	v_isAutoAddVol IN NUMBER,
	v_MrhVolLab    IN VARCHAR2,
	v_MrmID        IN VARCHAR2,
	v_MrlID_S      IN VARCHAR2,
	v_MrlID_L      IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_lMrhID NUMBER(22);
	v_lMrdID NUMBER(22);
	MEDICAL_RECORD_PERMANENT VARCHAR2(1) := 'P';
	MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';
	MEDICAL_RECORD_X_CREATE VARCHAR2(1) := 'C';
	v_ISAUTOCRT VARCHAR2(1);
	DUPLICATE_VOL_LAB_ERR EXCEPTION;
	i NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO i
	FROM   MedRechdr
	WHERE  PatNo = v_patNo
	AND    MrhVolLab = v_MrhVolLab
	AND    MrhSts <> MEDICAL_RECORD_PERMANENT;

	IF i > 0 Then
		RAISE DUPLICATE_VOL_LAB_ERR;
	END IF;

	SELECT SEQ_MEDRECHDR.NEXTVAL INTO v_lMrhID FROM DUAL;
	SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_lMrdID FROM DUAL;

	IF v_isAutoAddVol = 1 THEN
		v_ISAUTOCRT := 'Y';
	ELSE
		v_ISAUTOCRT := NULL;
	END IF;

	INSERT INTO MedRecHdr (
		MrhID, PatNo, MrhVolLab, MrhSts, SteCode, MrmID, MrdID, ISAUTOCRT
	) VALUES (
		v_lMrhID, v_patNo, v_MrhVolLab, MEDICAL_RECORD_NORMAL, v_siteCode, v_MrmID, v_lMrdID, v_ISAUTOCRT
	);

	INSERT INTO MedRecDtl (
		MrdID, MrhID, MrdSts, MrdDDate, DocCode, MrdRmk, UsrID, MrlID_S, MrlID_L
	) VALUES (
		v_lMrdID, v_lMrhID, MEDICAL_RECORD_X_CREATE, SYSDATE, v_DocCode, v_MrdRmk, v_UserID, v_MrlID_S, v_MrlID_L
	);

	o_errcode := 1;

	RETURN o_errcode;
EXCEPTION
WHEN DUPLICATE_VOL_LAB_ERR THEN
	ROLLBACK;
	o_errcode := -2;
	o_errmsg := '[Volume number exists!]';
	RETURN o_errcode;
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := ';An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM;
	RETURN o_errcode;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END NHS_ACT_MEDRECINSERT;
/
