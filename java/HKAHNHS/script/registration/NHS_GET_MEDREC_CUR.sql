create or replace FUNCTION NHS_GET_MEDREC_CUR (
	v_PATNO VARCHAR2
)
RETURN
	TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_CurrentLocation MEDRECLOC.MRLDESC%TYPE := NULL;
	v_MediaType VARCHAR2(10) := NULL;
	v_isAuto NUMBER := 0; -- Default false
	v_MedRecGetCur NUMBER := 0; -- Default false
	v_mrhVolLab VARCHAR2(5);
	v_Count NUMBER;
	v_mrhID NUMBER;
  	v_ErrCode NUMBER := 0;
  	v_ErrMsg VARCHAR2(100) := 'OK';

	MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';
BEGIN
	BEGIN
		SELECT COUNT(1) INTO v_Count FROM MedRecHdr WHERE PatNo = v_PATNO AND mrhsts = MEDICAL_RECORD_NORMAL;

		IF v_Count > 0 THEN
			SELECT MAX(mrhid) INTO v_mrhID FROM MedRecHdr WHERE PatNo = v_PATNO AND mrhsts = MEDICAL_RECORD_NORMAL;

			SELECT	l.MrlDesc, m.MrmDesc, NVL(m.autoadd, 0), h.mrhvollab
			INTO    v_CurrentLocation, v_MediaType, v_isAuto, v_mrhVolLab
			FROM    MedRecHdr h, MedRecMed m, MedRecDtl d, MedRecLoc l
			WHERE   h.PATNO = v_PATNO
			AND     h.mrhID = v_mrhID
			AND     h.mrmID = m.mrmID
			AND     h.mrdid = d.mrdid
			AND     NVL(d.mrlid_r, d.mrlid_l) = l.mrlid
			AND     h.mrhsts = MEDICAL_RECORD_NORMAL
			ORDER BY h.mrhid DESC;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		v_CurrentLocation := NULL;
	END;

	IF TRIM(v_CurrentLocation) IS NOT NULL THEN
		v_MedRecGetCur := -1; -- set true
	ELSE
    IF v_MediaType = 1 THEN
      v_MedRecGetCur := -1; -- set true when paper type
    ELSE
      v_MedRecGetCur := 0;
    END IF;
		v_MediaType := NULL;
		v_isAuto := 0;
	END IF;

	OPEN OUTCUR FOR
		SELECT v_MedRecGetCur, v_CurrentLocation, v_MediaType, v_isAuto, v_mrhVolLab
		FROM DUAL;

	RETURN OUTCUR;
EXCEPTION
	WHEN OTHERS THEN
		v_MedRecGetCur := 0;
		v_CurrentLocation := NULL;
		v_MediaType := NULL;
		v_isAuto := 0;
	OPEN OUTCUR FOR
		SELECT v_MedRecGetCur, v_CurrentLocation, v_MediaType, v_isAuto, v_mrhVolLab
		FROM DUAL;
	RETURN OUTCUR;
END NHS_GET_MEDREC_CUR;
/