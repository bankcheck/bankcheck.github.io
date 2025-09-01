CREATE OR REPLACE FUNCTION NHS_UTL_MEDREC_CUR_WCOL (
	v_PATNO VARCHAR2,
	v_COL VARCHAR2
)
	RETURN VARCHAR2
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_RESULT VARCHAR2(20);
	v_CurrentLocation MEDRECLOC.MRLDESC%TYPE := NULL;
	v_MediaType VARCHAR2(10) := NULL;
	v_isAuto NUMBER := 0; -- Default false
	v_MedRecGetCur NUMBER := 0; -- Default false
	v_mrhVolLab VARCHAR2(5);
	v_Count NUMBER;
	v_mrhID NUMBER;

	v_MRMID VARCHAR2(200);
	HASPAPER VARCHAR2(1) := '0';
	MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';

	CURSOR RUN_OUTCUR IS
		SELECT L.MRLDESC, M.MRMDESC, NVL(m.autoadd, 0), H.MRHVOLLAB, M.MRMID
		FROM   MEDRECHDR H, MEDRECMED M, MEDRECDTL D, MEDRECLOC L
		WHERE  h.PatNo = v_PATNO
		AND    h.MrmID = m.MrmID
		AND    h.MrdID = d.MrdID
		AND    NVL(D.MRLID_R, D.MRLID_L) = L.MRLID
		AND    H.MRHSTS = MEDICAL_RECORD_NORMAL
		ORDER BY h.mrhvollab DESC;
BEGIN
	OPEN RUN_OUTCUR;
	LOOP
	FETCH RUN_OUTCUR INTO v_CurrentLocation, v_MediaType, v_isAuto, v_mrhVolLab, v_MRMID;
	EXIT WHEN RUN_OUTCUR%NOTFOUND;
		IF v_MRMID = 1 THEN
			HASPAPER := '1';
			EXIT;
		END IF;
	END LOOP;

	IF HASPAPER = '1' THEN
		IF TRIM(v_CurrentLocation) IS NOT NULL THEN
			v_MedRecGetCur := -1; -- set true
		ELSE
			v_MedRecGetCur := 0;
			v_MediaType := NULL;
			v_ISAUTO := 0;
		END IF;

		OPEN OUTCUR FOR
			SELECT v_MedRecGetCur, v_CurrentLocation, v_MediaType, v_isAuto, v_mrhVolLab FROM DUAL;
	ELSE
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
	END IF;

	IF TRIM(v_CurrentLocation) IS NOT NULL THEN
		v_MedRecGetCur := -1; -- set true
	ELSE
		v_MedRecGetCur := 0;
		v_MediaType := NULL;
		v_isAuto := 0;
	END IF;

	IF v_COL = 'MEDRECGETCUR' THEN
		v_RESULT := v_MEDRECGETCUR;
	ELSIF v_COL = 'CURRENTLOCATION' THEN
		v_RESULT := v_CURRENTLOCATION;
	ELSIF v_COL = 'MEDIATYPE' THEN
		v_RESULT := v_MEDIATYPE;
	ELSIF v_COL = 'ISAUTO' THEN
		v_RESULT := v_ISAUTO;
	ELSIF v_COL = 'MRHVOLLAB' THEN
		v_RESULT := v_MRHVOLLAB;
	ELSE
		v_RESULT := NULL;
	END IF;

	RETURN v_RESULT;
EXCEPTION
	WHEN OTHERS THEN
		v_RESULT := NULL;
	RETURN v_RESULT;
END NHS_UTL_MEDREC_CUR_WCOL;
/
