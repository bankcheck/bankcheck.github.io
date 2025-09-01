create or replace FUNCTION NHS_ACT_MEDRECADDTX (
	v_action IN VARCHAR2,
	v_regType IN VARCHAR2,
	v_bedCode IN VARCHAR2,
	v_REGOPCAT IN VARCHAR2,
	v_patNo IN VARCHAR2,
	v_DocCode IN VARCHAR2,
	v_UserID IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_lMrhID NUMBER(22);
	v_lMrdID NUMBER(22);
	v_Value NUMBER(22);
	REG_TYPE_INPATIENT VARCHAR2(1) := 'I';
	REG_TYPE_OUTPATIENT VARCHAR2(1) := 'O';
	REG_TYPE_DAYCASE VARCHAR2(1) := 'D';
	REG_TYPE_CANCEL VARCHAR2(1) := 'C';
	REG_PRIORITY VARCHAR2(1) := 'P';
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
	v_MEDICAL_RECORD_NORMAL VARCHAR2(1) := 'N';
	v_MEDICAL_RECORD_X_TRANSFER VARCHAR2(1) := 'T';
	OTP2 NUMBER := 1;  --Conditionally compiles variables
	v_tmpRemark VARCHAR2(4);
	v_strAutoTxparm VARCHAR2(50);
	v_tmpStorageLocation NUMBER(22);
	v_tmpCurrentLocation NUMBER(22);
	TYPE rt IS record (
	PARCDE VARCHAR2(10),
	PARAM1 varchar2(50),
	PARAM2 varchar2(50),
	PARDESC VARCHAR2(30));
	V_PAPERCOUNT NUMBER;
	rtnType rt;
	rtnCursor TYPES.CURSOR_TYPE;
	v_trackCode VARCHAR2(1000);
	O_ERRMSG1 VARCHAR2(100);
	O_ERRCODE1 number;
  ISDISADDVOL VARCHAR2(1) :='Y';
  
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
  

	SELECT MAX(MrhID)
	INTO v_Value
	FROM MEDRECHDR
	WHERE Mrhsts = v_MEDICAL_RECORD_NORMAL
	AND PATNO = v_patNo
	AND MRMID = 1;
  
  SELECT PARAM1 INTO ISDISADDVOL FROM SYSPARAM WHERE PARCDE='DISADDVOL';

	IF v_Value IS NOT NULL THEN
		IF v_regType = REG_TYPE_INPATIENT THEN
			v_trackCode := '0001';
			O_ERRCODE1 := NHS_ACT_SYSLOG('ADD','MEDREC' ,'MEDRECADDTX' ,'[v_patNo]:'||v_patNo||';[v_regType]: '||v_regType, 'SYSUSER', NULL, O_ERRMSG1);
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecIPStorageLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpStorageLocation := rtnType.PARAM1;

			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecIPCurrentLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpCurrentLocation := rtnType.PARAM1;

			SELECT r.wrdcode
			INTO v_tmpRemark
			FROM bed b, room r
			WHERE b.romcode = r.romcode
			AND b.bedcode = v_bedCode;

		ELSIF v_regType = REG_TYPE_OUTPATIENT THEN
			v_trackCode :=  v_trackCode||';'||'0002';
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecOPStorageLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpStorageLocation := rtnType.PARAM1;

			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecOPCurrentLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpCurrentLocation := rtnType.PARAM1;
		ELSIF v_regType = REG_TYPE_DAYCASE THEN
			v_trackCode :=  v_trackCode||';'||'0003';
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecDCStorageLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpStorageLocation := rtnType.PARAM1;

			rtnCursor := NULL;
			rtnCursor := NHS_GET_MEDRECDEFSET(MedRecDCCurrentLocation);
			LOOP
				FETCH rtnCursor INTO rtnType ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_tmpCurrentLocation := rtnType.PARAM1;
		END IF;

		IF OTP2 = 1 THEN
			v_trackCode :=  v_trackCode||';'||'0004';
			SELECT UPPER(Param1)
			INTO v_strAutoTxparm
			FROM sysparam
			WHERE ParCde = 'AUTOTXMR';

			IF v_regType = REG_TYPE_OUTPATIENT THEN
				v_trackCode :=  v_trackCode||';'||'0005';
				IF instr(v_strAutoTxparm, v_REGOPCAT) <> 0 THEN
					v_trackCode :=  v_trackCode||';'||'005A';
	/*				Check at begin
					SELECT max(MrhID)
					INTO v_Value
					FROM MedRecHdr
					WHERE Mrhsts = v_MEDICAL_RECORD_NORMAL
					and PatNo = v_patNo
					order by mrhid desc;
	*/

	--				IF v_Value IS NOT NULL THEN
						v_trackCode :=  v_trackCode||';'||'0006';
						v_lMrhID := v_Value;
						SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_lMrdID FROM DUAL;

						INSERT INTO MedRecDtl (
							MrdID,
							MrhID,
							MrdSts,
							MrdDDate,
							UsrID,
							DocCode,
							MrlID_S,
							MrlID_L,
							MRDRMK
						) VALUES (
							v_lMrdID,
							v_lMrhID,
							v_MEDICAL_RECORD_X_TRANSFER,
							SYSDATE,
							v_UserID,
							v_DocCode,
							v_tmpStorageLocation,
							v_tmpCurrentLocation,
							v_tmpRemark
						);

						UPDATE MedRecHdr
						SET MrdID = v_lMrdID
						where MrhID = v_lMrhID;
	--				END IF;
				END IF;
			ELSE
				v_trackCode :=  v_trackCode||';'||'0007';
				IF (v_regType = REG_TYPE_INPATIENT) OR (v_regType = REG_TYPE_DAYCASE) THEN
					O_ERRCODE1 := NHS_ACT_SYSLOG('ADD','MEDREC' ,'MEDRECADDTX' ,'1[v_patNo]:'||v_patNo||';[v_regType]: '||v_regType||';[v_strAutoTxparm]:'||v_strAutoTxparm, 'SYSUSER', NULL, O_ERRMSG1);
					v_trackCode :=  v_trackCode||';'||'0008';
	--				IF InStr(v_strAutoTxparm, v_regType) <> 0 Then
						v_trackCode :=  v_trackCode||';'||'0009';
	/*					Check at begin
						SELECT max(MrhID)
						INTO v_Value
						FROM MedRecHdr
						WHERE Mrhsts = v_MEDICAL_RECORD_NORMAL
						and PatNo = v_patNo
						order by mrhid desc;
	*/
	--					O_ERRCODE1 := NHS_ACT_SYSLOG('ADD','MEDREC' ,'MEDRECADDTX' ,'2[v_regType]: '||v_regType||';[v_strAutoTxparm]:'||v_strAutoTxparm||';[v_Value]:'||v_Value||';[v_tmpCurrentLocation]:'||v_tmpCurrentLocation||';[v_tmpCurrentLocation]:'||v_tmpCurrentLocation, 'SYSUSER', NULL, O_ERRMSG1);
	--					IF v_Value IS NOT NULL THEN
							v_trackCode :=  v_trackCode||';'||'0010';
							v_lMrhID := v_Value;
							SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_lMrdID FROM DUAL;

							INSERT INTO MedRecDtl (
								MrdID,
								MrhID,
								MrdSts,
								MrdDDate,
								UsrID,
								DocCode,
								MrlID_S,
								MrlID_L,
								MRDRMK
							) VALUES (
								v_lMrdID,
								v_lMrhID,
								v_MEDICAL_RECORD_X_TRANSFER,
								SYSDATE,
								v_UserID,
								v_DocCode,
								v_tmpStorageLocation,
								v_tmpCurrentLocation,
								v_tmpRemark
							);

							UPDATE MedRecHdr
							SET MrdID = v_lMrdID
							where MrhID = v_lMrhID;
	--					END IF;
	--				END IF;
				END IF;
			END IF;
		ELSE
			v_trackCode :=  v_trackCode||';'||'0011';
			O_ERRCODE1 := NHS_ACT_SYSLOG('ADD','MEDREC' ,'MEDRECADDTX' ,'3[v_patNo]:'||v_patNo||';[v_regType]: '||v_regType||';[v_REGOPCAT]:'||v_REGOPCAT||';[v_strAutoTxparm]:'||v_strAutoTxparm||';[v_tmpCurrentLocation]:'||v_tmpCurrentLocation||';[v_tmpCurrentLocation]:'||v_tmpCurrentLocation, 'SYSUSER', NULL, O_ERRMSG1);
			IF (v_regType = REG_TYPE_INPATIENT) OR (v_regType = REG_TYPE_OUTPATIENT AND v_REGOPCAT = REG_PRIORITY) THEN
	/*			Check at begin
				SELECT max(MrhID)
				INTO v_Value
				FROM MedRecHdr
				WHERE Mrhsts = v_MEDICAL_RECORD_NORMAL
				and PatNo = v_patNo
				order by mrhid desc;
	*/
	--			O_ERRCODE1 := NHS_ACT_SYSLOG('ADD','MEDREC' ,'MEDRECADDTX' ,'4[v_patNo]:'||v_patNo||';[v_regType]: '||v_regType||';[v_REGOPCAT]:'||v_REGOPCAT||';[v_strAutoTxparm]:'||v_strAutoTxparm||';[v_Value]:'||v_Value, 'SYSUSER', NULL, O_ERRMSG1);
	--			IF v_Value IS NOT NULL THEN
					v_trackCode :=  v_trackCode||';'||'0012';
					v_lMrhID := v_Value;
					SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_lMrdID FROM DUAL;

					INSERT INTO MedRecDtl (
						MrdID,
						MrhID,
						MrdSts,
						MrdDDate,
						UsrID,
						DocCode,
						MrlID_S,
						MrlID_L,
						MRDRMK
					) VALUES (
						v_lMrdID,
						v_lMrhID,
						v_MEDICAL_RECORD_X_TRANSFER,
						SYSDATE,
						v_UserID,
						v_DocCode,
						v_tmpStorageLocation,
						v_tmpCurrentLocation,
						v_tmpRemark
					);

					UPDATE MedRecHdr
					SET MrdID = v_lMrdID
					where MrhID = v_lMrhID;
	--			END IF;
			END IF;
		END IF;
	--	o_errmsg := '[v_trackCode]'||v_trackCode||'[o_errmsg]'||o_errmsg;
	ELSE
      IF (ISDISADDVOL = 'Y') THEN
        o_errcode := -1;
        o_errmsg := 'NO PAPER EXISTING';
      END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := 'An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM;
	RETURN o_errcode;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END NHS_ACT_MEDRECADDTX;
/
