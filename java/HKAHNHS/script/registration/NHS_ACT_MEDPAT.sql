CREATE OR REPLACE FUNCTION "NHS_ACT_MEDPAT" (
	v_action IN VARCHAR2,
	v_patno  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_noOfRec2 NUMBER;
	v_NextMrhID number;
	v_NextMrdID number;
	v_MrhVolLab varchar2(5);

	v_mrmid VARCHAR2(10);
	v_mrlid_s VARCHAR2(10);
	v_mrlid_l VARCHAR2(10);

	MEDICAL_RECORD_X_CREATE VARCHAR2(1) := 'C';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
		v_mrlid_s := '25';

		SELECT mrmid INTO v_mrmid FROM MEDRECMED WHERE mrmdesc = 'PAPER';
		SELECT l.mrlid INTO v_mrlid_l FROM MEDRECLOC l WHERE l.mrldesc = 'REGISTRATION';
		SELECT seq_medrecdtl.NextVAL, seq_MedRecHdr.NextVAL into v_NextMrdID, v_NextMrhID FROM DUAL;
		SELECT COUNT(1) INTO v_noOfRec FROM MedRecHdr WHERE mrhid = v_NextMrhID;
		SELECT COUNT(1) INTO v_noOfRec2 FROM medrecdtl WHERE mrdid = v_NextMrdID;

		IF v_noOfRec = 0 AND v_noOfRec2 = 0 THEN
			SELECT MAX(MrhVolLab) INTO v_MrhVolLab FROM MedRecHdr;
			IF v_MrhVolLab IS NOT NULL THEN
				v_MrhVolLab := '0' || (TO_NUMBER (v_MrhVolLab) + 1);
			ELSE
				v_MrhVolLab := '01';
			END IF;

			INSERT INTO MedRecHdr (
				MRHID,
				PATNO,
				MRHVOLLAB,
				MRHSTS,
				MRMID,
				STECODE,
				MRDID,
				ISAUTOCRT
			) VALUES (
				v_NextMrhID,
				v_patno,
				v_MrhVolLab,
				'N',
				v_mrmid,
				GET_CURRENT_STECODE,
				v_NextMrdID,
				NULL
			);

			INSERT INTO medrecdtl (
				MRDID,
				MRHID,
				MRDSTS,
				MRDDDATE,
				MRDRDATE,
				MRLID_S,
				MRLID_L,
				DOCCODE,
				MRDRMK,
				USRID,
				MRLID_R,
				REQLOC
			) VALUES (
				v_NextMrdID,
				v_NextMrhID,
				MEDICAL_RECORD_X_CREATE,
				SYSDATE,
				NULL,
				v_mrlid_s,
				v_mrlid_l,
				NULL,
				NULL,
				GET_CURRENT_STECODE,
				NULL,
				NULL
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_MEDPAT;
/
