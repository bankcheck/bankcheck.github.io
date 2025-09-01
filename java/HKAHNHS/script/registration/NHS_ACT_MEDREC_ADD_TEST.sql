CREATE OR REPLACE FUNCTION NHS_ACT_MEDREC_ADD (
	v_action IN VARCHAR2,
	v_step IN VARCHAR2,
	v_isReg IN VARCHAR2,
	v_regType IN VARCHAR2,
	v_patNo IN VARCHAR2,
	v_siteCode IN VARCHAR2,
	v_DocCode IN VARCHAR2,
	v_MrdRmk IN VARCHAR2,
	v_bedCode IN VARCHAR2,
	v_REGOPCAT IN VARCHAR2,
	v_UserID IN VARCHAR2,
	v_isYes1s IN VARCHAR2,
	v_isYes2s IN VARCHAR2,
	v_isButtonAdds IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	o_errcode NUMBER;
	OUTCUR TYPES.CURSOR_TYPE;
	v_MrhVolLab VARCHAR2(5);
	v_MrmID NUMBER(22);
	v_MrlID_S NUMBER(22);
	v_MrlID_L NUMBER(22);
	v_isYes1 NUMBER(1);
	v_isYes2 NUMBER(1);
	v_isButtonAdd NUMBER(1);
	v_fillMedicalRecord NUMBER;
	v_MRLocation MEDRECLOC.MRLDESC%TYPE;
	v_MediaType VARCHAR2(10);
	v_isAuto NUMBER;
	v_isSameDate NUMBER;
	v_fillMrhVolLab VARCHAR2(5);
	TYPE rt_fill IS record (
	v_fillMedicalRecord NUMBER,
	v_MRLocation MEDRECLOC.MRLDESC%TYPE,
	v_MediaType VARCHAR2(10),
	v_isAuto NUMBER,
	v_isSameDate NUMBER,
	v_mrhVolLab VARCHAR2(5));
	rtnTypeFill rt_fill;
	rtnCursor TYPES.CURSOR_TYPE;
	isInsertSuccess NUMBER(1);
	isAddTx NUMBER(1);
	v_isAutoAddVol NUMBER(1);
	isAutoAddedVol NUMBER(1);
	addMedicalRecord BOOLEAN := FALSE;
	addMedicalRecord1 NUMBER(1) := 0;
	v_isAdded BOOLEAN;
	v_isAdded1 NUMBER(1) := 0;
	bAddMRTx BOOLEAN := FALSE;
	addIsAutoAdd BOOLEAN;
	isAutoAddVol BOOLEAN;
	v_stepReturn NUMBER;
	v_LastCreateDate DATE;
	o_errmsg VARCHAR2(1000);
	MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';
	MEDICAL_RECORD_X_CREATE VARCHAR2(1) := 'C';
	MedRecNewPatStorageLocation NUMBER := 1;
	MedRecNewPatCurrentLocation NUMBER := 2;
	MedRecNewPatVolumeNo NUMBER := 3;
	MedRecNewPatMediaType NUMBER := 4;
	MedRecNewVolStorageLocation NUMBER := 5;
	MedRecNewVolCurrentLocation NUMBER := 6;
	MedRecNewVolVolumeNo NUMBER := 7;
	MedRecNewVolMediaType NUMBER := 8;
	MedRecIPStorageLocation NUMBER := 9;
	MedRecIPCurrentLocation NUMBER := 10;
	MedRecOPStorageLocation NUMBER := 11;
	MedRecOPCurrentLocation NUMBER := 12;
	MedRecDCStorageLocation NUMBER := 13;
	MedRecDCCurrentLocation NUMBER := 14;
	TYPE rt IS record (
		PARCDE VARCHAR2(10),
		PARAM1 varchar2(50),
		PARAM2 varchar2(50),
		PARDESC VARCHAR2(30));
	TYPE rt1 IS record (
		NEWVOL VARCHAR2(5));
	rtnType rt;
	rtnType1 rt1;
	DUPLICATE_VOL_LAB_ERR EXCEPTION;
	INTERNAL_FUNCTION_ERR EXCEPTION;
	EXIT_FOR_DIALOG EXCEPTION;
	v_trackCode VARCHAR2(1000);
BEGIN
	v_trackCode := '000a';
	IF v_isButtonAdds IS NOT NULL THEN
		v_isButtonAdd := TO_NUMBER(v_isButtonAdds); -- 1 is click by medical add button
	END IF;
	v_trackCode := v_trackCode||';'||'000b';
	IF v_isYes2s IS NOT NULL THEN
		v_isYes2 := TO_NUMBER(v_isYes2s);
	END IF;
	v_trackCode := v_trackCode||';'||'000c';
	IF v_isYes1s IS NOT NULL THEN
		v_isYes1 := TO_NUMBER(v_isYes1s);
	END IF;
	v_trackCode := v_trackCode||';'||'000d';
	o_errcode := 0;
	o_errmsg := 'OK';

	bAddMRTx := TRUE;
	addMedicalRecord := FALSE;
	isAutoAddedVol := 0;
	addIsAutoAdd := FALSE;

	IF v_isButtonAdd = 1 THEN	-- 1 is click by medical add button
		v_isAutoAddVol := 0;
		isAutoAddVol := FALSE;
	ELSE
		v_isAutoAddVol := -1;
		isAutoAddVol := TRUE;
		isAutoAddedVol := -1;
	END IF;

	addIsAutoAdd := isAutoAddVol;
	v_isAdded := FALSE;

	IF v_step = 0 THEN
		GOTO start_function;
	ELSIF v_step = 2 THEN
		v_fillMedicalRecord := -1;
	ELSIF v_step = 3 THEN
		v_fillMedicalRecord := -1;
	END IF;
	v_trackCode := v_trackCode||';'||'000d';
<<start_function>>
	IF v_isReg = 'P' THEN
		IF v_action = 'ADD' THEN
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewPatVolumeNo);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_MrhVolLab := rtnType.PARAM1;
	 		v_trackCode := v_trackCode||';'||'000e';
			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewPatMediaType);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_MrmID := rtnType.PARAM1;
	 		v_trackCode := v_trackCode||';'||'000f';
			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewPatStorageLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_MrlID_S := rtnType.PARAM1;
			v_trackCode := v_trackCode||';'||'000g';
			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewPatCurrentLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_MrlID_L := rtnType.PARAM1;
	 		v_trackCode := v_trackCode||';'||'000h';
			isInsertSuccess := NHS_ACT_MEDRECINSERT(v_patNo,v_siteCode,NULL,v_MrdRmk,v_UserID,v_isAutoAddVol,v_MrhVolLab,v_MrmID,v_MrlID_S,v_MrlID_L,o_errmsg);
			IF isInsertSuccess = 1 THEN
				addMedicalRecord := TRUE;
			ELSIF isInsertSuccess = -2 THEN
				RAISE DUPLICATE_VOL_LAB_ERR;
			ELSIF isInsertSuccess = -1 THEN
				RAISE INTERNAL_FUNCTION_ERR;
			END IF;
		END IF;
	ELSIF v_isReg = 'R' THEN
		v_trackCode := v_trackCode||';'||'000i';
		IF v_action = 'ADD' THEN
			v_trackCode := v_trackCode||';'||'000j';
			IF v_step = 0 THEN
				rtnCursor := NHS_GET_MEDREC_FILL (v_PATNO);
				LOOP
					FETCH rtnCursor INTO rtnTypeFill ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;

				v_fillMedicalRecord := rtnTypeFill.v_fillMedicalRecord;
				v_MRLocation := rtnTypeFill.v_MRLocation;
				v_MediaType := rtnTypeFill.v_MediaType;
				v_isAuto := rtnTypeFill.v_isAuto; -- -1 is true
				v_fillMrhVolLab := rtnTypeFill.v_mrhVolLab;
				v_isSameDate := rtnTypeFill.v_isSameDate;
				v_trackCode := v_trackCode||';[v_isSameDate]:'||v_isSameDate;
				v_trackCode := v_trackCode||';'||'000k';
				IF v_isAuto = -1 THEN
					isAutoAddVol := TRUE;
					v_isAutoAddVol := -1;
				ELSE
					isAutoAddVol := FALSE;
					v_isAutoAddVol := 0;
				END IF;
			ELSE
				v_fillMedicalRecord := -1;
			END IF;
		 	v_trackCode := v_trackCode||';'||'000L';
			IF v_fillMedicalRecord = 0 THEN -- false
				v_trackCode := v_trackCode||';'||'000Q';
				IF v_step = 0 THEN
					o_errcode := -100;
					o_errmsg := 'Add a new volume for the patient?';
					v_stepReturn := 1;
					RAISE EXIT_FOR_DIALOG;
				END IF;

-- <<return_point1>> -- return from dialog
				IF v_isYes1 = 1 THEN
					rtnCursor := NHS_GET_MEDRECNEXTVOL_REG(v_patNo);
					LOOP
					FETCH rtnCursor INTO rtnType1 ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrhVolLab := rtnType1.NEWVOL;
					v_trackCode := v_trackCode||';'||'000R';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolMediaType);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrmID := rtnType.PARAM1;
					v_trackCode := v_trackCode||';'||'000S';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolStorageLocation);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrlID_S := rtnType.PARAM1;
				 	v_trackCode := v_trackCode||';'||'000T';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolCurrentLocation);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrlID_L := rtnType.PARAM1;
				 	v_trackCode := v_trackCode||';'||'000U';
					isInsertSuccess := NHS_ACT_MEDRECINSERT(v_patNo,v_siteCode,NULL,v_MrdRmk,v_UserID,v_isAutoAddVol,v_MrhVolLab,v_MrmID,v_MrlID_S,v_MrlID_L,o_errmsg);
					v_isAdded := TRUE;
				ELSE
					bAddMRTx := FALSE;
				END IF;
			ELSE
				IF v_isAuto = -1 AND v_isSameDate != -1 THEN
					rtnCursor := NHS_GET_MEDRECNEXTVOL_REG(v_patNo);
					LOOP
					FETCH rtnCursor INTO rtnType1 ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrhVolLab := rtnType1.NEWVOL;
					v_trackCode := v_trackCode||';'||'000M';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolMediaType);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrmID := rtnType.PARAM1;
					v_trackCode := v_trackCode||';'||'000N';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolStorageLocation);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrlID_S := rtnType.PARAM1;
					v_trackCode := v_trackCode||';'||'000O';
					rtnCursor := NULL;
					rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolCurrentLocation);
					LOOP
						FETCH rtnCursor INTO rtnType ;
						EXIT WHEN rtnCursor%NOTFOUND;
					END LOOP;
					v_MrlID_L := rtnType.PARAM1;
				v_trackCode := v_trackCode||';'||'000P';
					isInsertSuccess := NHS_ACT_MEDRECINSERT(v_patNo,v_siteCode,NULL,v_MrdRmk,v_UserID,v_isAutoAddVol,v_MrhVolLab,v_MrmID,v_MrlID_S,v_MrlID_L,o_errmsg);
					v_isAdded := TRUE;
				END IF;
			END IF;
			v_trackCode := v_trackCode||';'||'000V';
			IF bAddMRTx = TRUE THEN
				v_trackCode := v_trackCode||';'||'000W';
				isAddTx := NHS_ACT_MEDRECADDTX(NULL,v_regType,v_bedCode,v_REGOPCAT,v_patNo,v_DocCode,v_UserID,o_errmsg); -- Here -1 is error
				IF isAddTx < 0 THEN
					RAISE INTERNAL_FUNCTION_ERR;
				END IF;
				v_trackCode := v_trackCode||';'||'000X';
				rtnCursor := NHS_GET_MEDREC_FILL (v_PATNO);
				LOOP
					FETCH rtnCursor INTO rtnTypeFill ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_trackCode := v_trackCode||';'||'000Y';
				v_fillMedicalRecord := rtnTypeFill.v_fillMedicalRecord;
				v_MRLocation := rtnTypeFill.v_MRLocation;
				v_MediaType := rtnTypeFill.v_MediaType;
				v_isAuto := rtnTypeFill.v_isAuto;
				v_isSameDate := rtnTypeFill.v_isSameDate;
				v_fillMrhVolLab := rtnTypeFill.v_mrhVolLab;
				addMedicalRecord := TRUE;
			END IF;
		END IF;
	END IF;

	IF v_isButtonAdd = 1 THEN
	v_trackCode := v_trackCode||';'||'0002';
		SELECT max(d.mrdddate)
		INTO v_LastCreateDate
		FROM MedRecHdr h, MedRecDtl d
		WHERE h.PatNo = v_patNo
		and h.mrhid = d.mrhid
		and d.mrdsts = MEDICAL_RECORD_X_CREATE
		and h.mrhsts = MEDICAL_RECORD_NORMAL;
		v_trackCode := v_trackCode||';'||'0003';
		IF v_LastCreateDate IS NOT NULL THEN
			v_trackCode := v_trackCode||';'||'0004';
			IF TRUNC(v_LastCreateDate,'dd')<>TRUNC(SYSDATE,'dd') THEN
				v_trackCode := v_trackCode||';'||'0005';
				v_LastCreateDate := NULL;
			END IF;
		END IF;
	 	v_trackCode := v_trackCode||';'||'0005A';
		IF v_LastCreateDate IS NULL THEN
			v_trackCode := v_trackCode||';'||'0006';
			IF v_step < 3 THEN
				o_errcode := -200;
				o_errmsg := 'Add a new volume for the patient?';
				v_stepReturn := 2;
				RAISE EXIT_FOR_DIALOG;
			END IF;

--<<return_point2>> -- return from dialog
			IF v_isYes2 = 1 THEN
				v_trackCode := v_trackCode||';'||'0007';
				rtnCursor := NHS_GET_MEDRECNEXTVOL_REG(v_patNo);
				LOOP
				FETCH rtnCursor INTO rtnType1 ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_MrhVolLab := rtnType1.NEWVOL;

				rtnCursor := NULL;
				rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolMediaType);
				LOOP
					FETCH rtnCursor INTO rtnType ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_MrmID := rtnType.PARAM1;

				rtnCursor := NULL;
				rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolStorageLocation);
				LOOP
					FETCH rtnCursor INTO rtnType ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_MrlID_S := rtnType.PARAM1;

				rtnCursor := NULL;
				rtnCursor := NHS_GET_MEDRECDEFSET(MedRecNewVolCurrentLocation);
				LOOP
					FETCH rtnCursor INTO rtnType ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_MrlID_L := rtnType.PARAM1;

				isInsertSuccess := NHS_ACT_MEDRECINSERT(v_patNo,v_siteCode,NULL,v_MrdRmk,v_UserID,v_isAutoAddVol,v_MrhVolLab,v_MrmID,v_MrlID_S,v_MrlID_L,o_errmsg);
				IF isInsertSuccess <> 1 THEN
					o_errcode := isInsertSuccess;
					RAISE INTERNAL_FUNCTION_ERR;
				END IF;

				rtnCursor:= NULL;
				rtnCursor := NHS_GET_MEDREC_FILL (v_PATNO);
				LOOP
					FETCH rtnCursor INTO rtnTypeFill ;
					EXIT WHEN rtnCursor%NOTFOUND;
				END LOOP;
				v_trackCode := v_trackCode||';'||'0008';
				v_fillMedicalRecord := rtnTypeFill.v_fillMedicalRecord;
				v_MRLocation := rtnTypeFill.v_MRLocation;
				v_MediaType := rtnTypeFill.v_MediaType;
				v_isAuto := rtnTypeFill.v_isAuto;
				v_isSameDate := rtnTypeFill.v_isSameDate;
				v_fillMrhVolLab := rtnTypeFill.v_mrhVolLab;
				addMedicalRecord := TRUE;
			END IF;
		END IF;
	END IF;
	v_trackCode := v_trackCode||';'||'0009';
	IF addIsAutoAdd THEN
	v_trackCode := v_trackCode||';'||'0010';

		IF v_isAdded THEN
			v_trackCode := v_trackCode||';[v_isAdded]:'||-1;
			v_isAdded1 := -1;
		ELSE
			v_trackCode := v_trackCode||';[v_isAdded]:'||0;
			v_isAdded1 := 0;
		END IF;

		IF v_isReg = 'R' AND v_action = 'ADD' AND v_isAdded THEN
			v_trackCode := v_trackCode||';'||'0011';
			isAutoAddedVol := -1;
			o_errmsg := 'A new Volume has been added';
		END IF;
		isAutoAddVol := FALSE;
		v_isAutoAddVol := 0;
		addIsAutoAdd := FALSE;
	END IF;

	IF addMedicalRecord THEN
		v_trackCode := v_trackCode||';'||'0012';
		addMedicalRecord1 := -1;
	ELSE
		v_trackCode := v_trackCode||';'||'0013';
		addMedicalRecord1 := 0;
	END IF;

	v_stepReturn := 0;

--	o_errmsg := '[v_trackCode]'||v_trackCode||';[v_isAdded]'|| (CASE v_isAdded when true then 'Y' ELSE 'N' END)||';[o_errmsg]:'||o_errmsg;

	OPEN OUTCUR FOR
			SELECT o_errcode, v_stepReturn, v_MRLocation, v_MediaType, isAutoAddedVol, v_isYes1, addMedicalRecord1, v_fillMrhVolLab, v_isAdded1, o_errmsg||v_trackCode
			FROM DUAL;
	RETURN OUTCUR;
--	RETURN o_errcode;
EXCEPTION
WHEN EXIT_FOR_DIALOG THEN
	ROLLBACK;
	OPEN OUTCUR FOR
			SELECT o_errcode, v_stepReturn, v_MRLocation, v_MediaType, isAutoAddedVol, v_isYes1, addMedicalRecord1, v_fillMrhVolLab, v_isAdded1, o_errmsg
			FROM DUAL;
	RETURN OUTCUR;
--	RETURN o_errcode;
WHEN INTERNAL_FUNCTION_ERR THEN
	ROLLBACK;
	o_errcode := -3;
	OPEN OUTCUR FOR
			SELECT o_errcode, v_stepReturn, v_MRLocation, v_MediaType, isAutoAddedVol, v_isYes1, addMedicalRecord1, v_fillMrhVolLab, v_isAdded1, o_errmsg
			FROM DUAL;
	RETURN OUTCUR;
--	RETURN o_errcode;
WHEN DUPLICATE_VOL_LAB_ERR THEN
	ROLLBACK;
	o_errcode := -2;
	OPEN OUTCUR FOR
			SELECT o_errcode, v_stepReturn, v_MRLocation, v_MediaType, isAutoAddedVol, v_isYes1, addMedicalRecord1, v_fillMrhVolLab, v_isAdded1, o_errmsg
			FROM DUAL;
	RETURN OUTCUR;
--	RETURN o_errcode;
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := 'An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM;
	v_stepReturn := 0;
	OPEN OUTCUR FOR
			SELECT o_errcode, v_stepReturn, v_MRLocation, v_MediaType, isAutoAddedVol, v_isYes1, addMedicalRecord1, v_fillMrhVolLab, '[v_trackCode]'||v_trackCode||'[o_errmsg]'||o_errmsg
			FROM DUAL;
	RETURN OUTCUR;
--	RETURN o_errcode;
END NHS_ACT_MEDREC_ADD;
/
