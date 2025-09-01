create or replace
FUNCTION NHS_GET_MEDREC_FILL_PAPERPRI (
	v_PATNO IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_medrec_refcur TYPES.CURSOR_TYPE;
	v_fillMedicalRecord NUMBER := -1;
	v_MRLocation MEDRECLOC.MRLDESC%TYPE;
	v_MediaType VARCHAR2(10);
	v_tmpIsAutoAdd NUMBER;
	v_isSameDate NUMBER := 0; -- default false
	v_MedRecGetCur NUMBER := 0; -- default false
	v_LastCreateDate DATE;

	TYPE rt IS record (
		v_MedRecGetCur number,
		v_CurrentLocation MEDRECLOC.MRLDESC%TYPE,
		v_MediaType VARCHAR2(10),
		v_isAuto number,
		v_mrhVolLab VARCHAR2(5),
		v_mrhid MEDRECHDR.MRHID%TYPE  --dental 20180122
	);
	rtnCur rt;
	v_isAuto number :=1;
	v_mrhVolLab VARCHAR2(5);
	v_mrhid MEDRECHDR.MRHID%TYPE; --dental 20180122

	MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';
	MEDICAL_RECORD_X_CREATEC VARCHAR2(1) := 'C';
BEGIN
	IF TRIM(v_PATNO) IS NOT NULL THEN
		v_medrec_refcur := NHS_GET_MEDREC_CUR_PAPERPRI(v_PATNO);
		LOOP
			FETCH v_medrec_refcur INTO rtnCur;
				v_MedRecGetCur := rtnCur.v_MedRecGetCur; -- -1 is true
				v_MRLocation := rtnCur.v_CurrentLocation;
				v_MediaType := rtnCur.v_MediaType;
				v_tmpIsAutoAdd := rtnCur.v_isAuto; -- -1 is true
				v_mrhVolLab := rtnCur.v_mrhVolLab;
				 v_mrhid :=rtncur.v_mrhid; --dental 20180122
			EXIT WHEN v_medrec_refcur%NOTFOUND;
		END LOOP;
		CLOSE v_medrec_refcur;

		IF v_MedRecGetCur = -1 THEN
			IF v_tmpIsAutoAdd = 0 THEN -- -1 is true
				v_fillMedicalRecord := -1;
			ELSE
				BEGIN
					SELECT max(d.mrdddate)
					INTO   v_LastCreateDate
					FROM   MedRecHdr h, MedRecDtl d
					WHERE  h.PatNo = v_PATNO
					and    h.mrhid = d.mrhid
					and    h.mrhsts = MEDICAL_RECORD_NORMAL
					and    d.mrdsts = MEDICAL_RECORD_X_CREATEC;
				EXCEPTION
					WHEN OTHERS THEN
					v_LastCreateDate := NULL;
				END;

				IF TRIM(v_LastCreateDate) IS NOT NULL THEN
					IF TRUNC(v_LastCreateDate,'dd') = TRUNC(sysdate, 'dd') THEN
						v_isSameDate := -1;
					ELSE
						v_LastCreateDate := NULL;
						v_isSameDate := 0;
					END IF;
				END IF;

				v_fillMedicalRecord := -1;
			END IF;
			v_isAuto := v_tmpIsAutoAdd;
		ELSE
			v_fillMedicalRecord := 0;
			v_MRLocation := NULL;
			v_MediaType := NULL;
		END IF;
	ELSE
		v_MRLocation := NULL;
		v_MediaType := NULL;
	END IF;

	OPEN OUTCUR FOR
		SELECT v_fillMedicalRecord, v_MRLocation, v_MediaType, v_isAuto, v_isSameDate, v_mrhVolLab, v_mrhid --dental 20180122
		FROM DUAL;
	RETURN OUTCUR;
END NHS_GET_MEDREC_FILL_PAPERPRI;
/
