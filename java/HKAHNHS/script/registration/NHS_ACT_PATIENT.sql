create or replace FUNCTION "NHS_ACT_PATIENT" (
	v_Action        IN VARCHAR2,
	v_PatNo         IN VARCHAR2,
	v_PatIDNo       IN VARCHAR2,
	v_PatIDCoun     IN VARCHAR2,
	v_PatFName      IN VARCHAR2,
	v_TitDesc       IN VARCHAR2,
	v_PatGName      IN VARCHAR2,
	v_PatCName      IN VARCHAR2,
	v_PatMSTS       IN VARCHAR2,
	v_PatMName      IN VARCHAR2,
	v_RacDesc       IN VARCHAR2,
	v_PatBDate      IN VARCHAR2,
	v_MothCode      IN VARCHAR2,
	v_PatSex        IN VARCHAR2,
	v_EduLevel      IN VARCHAR2,
	v_Religious     IN VARCHAR2,
	v_Death         IN VARCHAR2,
	v_Occupation    IN VARCHAR2,
	v_PatMother     IN VARCHAR2,
	v_PatNB         IN VARCHAR2,
	v_PatSTS        IN VARCHAR2,
	v_PatITP        IN VARCHAR2,
	v_PatStaff      IN VARCHAR2,
	v_PatSMSCheck   IN VARCHAR2,
	v_PatCheckID    IN VARCHAR2,
	v_PatEmail      IN VARCHAR2,
	v_PatHTel       IN VARCHAR2,
	v_PatOTel       IN VARCHAR2,
	v_PatPager      IN VARCHAR2,
	v_PatFaxNo      IN VARCHAR2,
	v_PatAdd1       IN VARCHAR2,
	v_PatAdd2       IN VARCHAR2,
	v_PatAdd3       IN VARCHAR2,
	v_LocCode       IN VARCHAR2,
	v_CouCode       IN VARCHAR2,
	v_PatRmk        IN VARCHAR2,
	v_PatKName      IN VARCHAR2,
	v_PatKHTel      IN VARCHAR2,
	v_PatKPTel      IN VARCHAR2,
	v_PatKRELA      IN VARCHAR2,
	v_PatKOTel      IN VARCHAR2,
	v_PatKMTel      IN VARCHAR2,
	v_PatKEmail     IN VARCHAR2,
	v_PatKAdd       IN VARCHAR2,
	v_MBLDESC       IN VARCHAR2,
	v_PatLFName     IN VARCHAR2,
	v_PatLGName     IN VARCHAR2,
	v_PatAddRmk     IN VARCHAR2,
	v_PatDocType    IN VARCHAR2,
	v_MktSource     IN VARCHAR2,
	v_MktRmk        IN VARCHAR2,
	v_DentNo        IN VARCHAR2,
	v_MiscRmk       IN VARCHAR2,
	i_UsrID         IN VARCHAR2,
	v_BirthOrdSPG   IN VARCHAR2,
	v_AddIDNo1      IN VARCHAR2,
	v_AddIDDocType1 IN VARCHAR2,
	v_AddIDCouCode1 IN VARCHAR2,
	v_AddIDNo2      IN VARCHAR2,
	v_AddIDDocType2 IN VARCHAR2,
	v_AddIDCouCode2 IN VARCHAR2,
	v_mobCouCode    IN VARCHAR2,
	o_errmsg        OUT VARCHAR2
)
	RETURN VARCHAR2
AS
	v_noOfRec NUMBER;
	o_errCode VARCHAR2(10);
	v_PatNo1 VARCHAR2(10);
	v_patno_hk Patient.patno%TYPE;
	v_PatBDate1 Date;
	v_Death1 Date;
	iPatNB NUMBER;
	sPatNo VARCHAR2(20);
	iCount NUMBER;
	v_PatLFName1 VARCHAR2(160);
	v_PatLGName1 VARCHAR2(160);
	v_oldPatChkID Patient.PatChkID%TYPE;
	v_oldPatAddRmk Patient.PatAddRmk%TYPE;
	v_oldPatPager Patient.PatPager%TYPE;
	v_oldPatHTel Patient.PatHTel%TYPE;
	v_oldPatOTel Patient.PatOTel%TYPE;
	v_oldPatFaxNo Patient.PatFaxNo%TYPE;
	v_oldPatAdd1 Patient.PatAdd1%TYPE;
	v_oldPatAdd2 Patient.PatAdd2%TYPE;
	v_oldPatAdd3 Patient.PatAdd3%TYPE;
	v_oldPatRmk Patient.PatRmk%TYPE;
	RTNCURSOR TYPES.CURSOR_TYPE;
	v_MRHVOLLAB VARCHAR2(5);
	CREATE_PATIENT_ERR EXCEPTION;
	TYPE rt IS record (
		PARCDE VARCHAR2(10),
		PARAM1 varchar2(50),
		PARAM2 VARCHAR2(50),
		PARDESC VARCHAR2(30)
	);
	rtnType rt;
	v_REGF2 VARCHAR2(5) := 'REGF2';
	v_AltID_REGF1 VARCHAR2(5);
	v_PalID VARCHAR2(10);
	v_PatSTS2 VARCHAR2(10);
	v_CURRENT_STECODE VARCHAR2(10);
	v_REAL_STECODE VARCHAR2(10);
BEGIN
	o_errCode := -1;
	o_errmsg := 'Fail to process.';

	v_CURRENT_STECODE := GET_CURRENT_STECODE;
	v_REAL_STECODE := GET_REAL_STECODE;

	IF trim(v_PatBDate) = '' THEN
		v_PatBDate1:= NULL;
	ELSE
		v_PatBDate1 := TO_DATE(v_PatBDate, 'dd/MM/yyyy');
	END IF;

	IF trim(v_Death) = '' THEN
		v_Death1 := NULL;
	ELSE
		v_Death1 := TO_DATE(v_Death, 'dd/MM/yyyy');
	END IF;

	IF LENGTH(v_PatFName) > 40 THEN
		o_errCode := -1;
		o_errmsg := 'Patient Family Name too long (max 40).';
		RAISE CREATE_PATIENT_ERR;
	END IF;

	IF LENGTH(v_PatGName) > 40 THEN
		o_errCode := -1;
		o_errmsg := 'Patient Given Name too long (max 40).';
		RAISE CREATE_PATIENT_ERR;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM Patient WHERE PatNo = v_PatNo;
	IF v_Action = 'ADD' THEN
		IF v_REAL_STECODE = 'HKAH' THEN
			o_errCode := NHS_ACT_RECORDLOCK('ADD', 'Patient', i_UsrID, '127.0.0.1', i_UsrID, o_errmsg);
		ELSE
			o_errCode := 0;
		END IF;

		IF o_errCode <> 0 THEN
			o_errCode := -1;
			o_errmsg := 'Same user is adding a new patient. Please try again.';
			RAISE CREATE_PATIENT_ERR;
		END IF;

		IF v_REAL_STECODE = 'AMC1' OR v_REAL_STECODE = 'AMC2' THEN
			-- do nothing
			SELECT COUNT(1) INTO iCount FROM DUAL;
		ELSE
			-- check duplicate vol
			rtnCursor := NHS_GET_MEDRECDEFSET(3);
			LOOP
				FETCH rtnCursor INTO rtnType;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_MrhVolLab := rtnType.PARAM1;

			SELECT COUNT(1) INTO iCount
			FROM MedRechdr
			WHERE PatNo = v_patNo
			AND MRHVOLLAB = v_MRHVOLLAB
			and MrhSts <> 'P';
			IF iCount > 0 Then
				o_errCode := -2;
				o_errmsg := '[Volume number exists!]';
				RAISE CREATE_PATIENT_ERR;
			END IF;
		END IF;

		-- check hkid
		IF v_PatIDNo IS NOT NULL THEN
			SELECT COUNT(1) INTO v_noOfRec FROM PATIENT WHERE PATIDNO = v_PatIDNo;
			IF v_noOfRec > 0 THEN
				o_errCode := -1;
				o_errmsg := 'ID/Passport No. is already existed.';
				RAISE CREATE_PATIENT_ERR;
			END IF;
		END IF;

		-- check duplicate patno (within 1 minute)
		SELECT COUNT(1) INTO v_noOfRec FROM PATIENT P, PATIENT_EXTRA E
		WHERE  P.PATNO = E.PATNO AND P.PATFNAME = v_PatFName AND P.PATGNAME = v_PatGName
		AND    E.PATCDATE IS NOT NULL AND E.PATCDATE > SYSDATE - (1 / 1440);
		IF v_noOfRec > 0 THEN
			o_errCode := -1;
			o_errmsg := 'Duplicate patient info. Please try again later.';
			RAISE CREATE_PATIENT_ERR;
		END IF;

		IF v_noOfRec = 0 THEN
--			IF TRIM(v_PatLFName) IS NULL THEN
--				v_PatLFName1 := v_PatFName;
--			ELSE
				v_PatLFName1 := v_PatLFName;
--			END IF;

--			IF TRIM(v_PatLGName) IS NULL THEN
--				v_PatLGName1 := v_PatGName;
--			ELSE
				v_PatLGName1 := v_PatLGName;
--			END IF;

			v_PatNo1 := TO_CHAR(HAT_GET_NEXT_PATNO);

			IF v_PATNO1 IS NULL THEN
				-- use manual input patient no
				v_PatNo1 := v_PatNo;
			ELSE
				-- use auto gen Patient no
				SELECT COUNT(1) INTO v_noOfRec FROM Patient WHERE PatNo = TO_CHAR(v_PatNo1);

				IF v_noOfRec > 0 THEN
					WHILE v_noOfRec > 0 LOOP
						v_PatNo1 := TO_CHAR(HAT_GET_NEXT_PATNO);

						SELECT COUNT(1) INTO v_noOfRec FROM Patient WHERE PatNo = TO_CHAR(v_PatNo1);
					END LOOP;
				END IF;
			END IF;

			IF v_PatNo1 = '0' THEN
				o_errCode := -1;
				o_errmsg := 'Patient No. cannot be 0.';
				RAISE CREATE_PATIENT_ERR;
			END IF;

			IF v_PatNB = '-1' THEN
				SELECT COUNT(1) into v_noOfRec FROM Patient WHERE PatNo = v_PatNo;
				if v_noOfRec > 0 THEN
					SELECT PatNo, PatNB into sPatNo, iPatNB FROM Patient WHERE PatNo = v_PatNo;
				END IF;
				SELECT COUNT(1) INTO iCount FROM EBIRTHDTL WHERE BB_PatNo = v_PatNo;
				if iCount < 1 THEN
					if sPatNo is NULL or trim(sPatNo)='' THEN
						o_errCode := NHS_ACT_EBIRTHDTL(
							'ADD',
							v_PatNo1,
							v_PatSex,
							v_PatBDate,
							v_PatMother,
							v_PatAdd1,
							v_PatAdd2,
							v_PatAdd3,
							v_LocCode,
							o_errmsg
						);
					END IF;
				END IF;

				SELECT COUNT(1) INTO iCount FROM DHBIRTHDTL WHERE BBPatNo = v_PatNo;
				IF iCount < 1 THEN
					if sPatNo is NULL OR trim(sPatNo) = '' THEN
						o_errCode := NHS_ACT_DHBIRTHDTL(
							'ADD',
							v_PatNo1,
							v_PatMother,
							o_errmsg
						);
					END IF;
				END IF;

				v_PatSTS2 := '0';
			ELSE
				v_PatSTS2 := v_PatSTS;
			END IF;

			INSERT INTO Patient(
				PatNo,
				PatIDNo,
				PatIDCouCode,
				PatFName,
				PatGName,
				PatCName,
				PatMName,
				PatFNameSDX,
				PatGNameSDX,
				PatMNameSDX,
				TitDesc,
				PatMSTS,
				PatBDate,
				RacDesc,
				MothCode,
				PatSex,
				EduLevel,
				PatMktSrc,
				Religious,
				Death,
				Occupation,
				PatMother,
				PatNB,
				PatSTS,
				PatITP,
				PatStaff,
				PatSMS,
				PatChkID,
				PatEmail,
				PatPager,
				PatHTel,
				PatOTel,
				PatFaxNo,
				PatAdd1,
				PatAdd2,
				PatAdd3,
				LocCode,
				CouCode,
				PatKName,
				PatKRELA,
				PatKHTel,
				PatKOTel,
				PatKPTel,
				PatKMTel,
				PatKEmail,
				PatKAdd,
				PatRmk,
				SteCode,
				PatVCNT,
				PatRDate,
				PatLFName,
				PatLGName,
				UsrID,
				LastUpd,
				PatPagerUpUsr,
				PatPagerUpDT,
				PatHTelUpUsr,
				PatHTelUpDT,
				PatOTelUpUsr,
				PatOTelUpDT,
				PatFaxNoUpUsr,
				PatFaxNoUpDT,
				PatAddUpUsr,
				PatAddUpDT,
				RmkUpUsr,
				RmkUpDT,
				PATCHKIDUPUSR,
				PATCHKIDUPDT
			) VALUES (
				v_PatNo1,
				v_PatIDNo,
				v_PatIDCoun,
				v_PatFName,
				v_PatGName,
				v_PatCName,
				v_PatMName,
				soundex(v_PatFName),
				soundex(v_PatGName),
				soundex(v_PatMName),
				v_TitDesc,
				v_PatMSTS,
				v_PatBDate1,
				v_RacDesc,
				v_MothCode,
				v_PatSex,
				v_EduLevel,
				v_MktSource,
				v_Religious,
				v_Death1,
				v_Occupation,
				v_PatMother,
				TO_NUMBER(v_PatNB),
				TO_NUMBER(v_PatSTS2),
				TO_NUMBER(v_PatITP),
				TO_NUMBER(v_PatStaff),
				TO_NUMBER(v_PatSMSCheck),
				TO_NUMBER(v_PatCheckID),
				v_PatEmail,
				v_PatPager,
				v_PatHTel,
				v_PatOTel,
				v_PatFaxNo,
				v_PatAdd1,
				v_PatAdd2,
				v_PatAdd3,
				v_LocCode,
				v_CouCode,
				v_PatKName,
				v_PatKRELA,
				v_PatKHTel,
				v_PatKOTel,
				v_PatKPTel,
				v_PatKMTel,
				v_PatKEmail,
				v_PatKAdd,
				v_PatRmk,
				GET_CURRENT_STECODE,
				0,
				TO_DATE(TO_CHAR(SYSDATE, 'dd/MM/yyyy'), 'dd/MM/yyyy'),
				v_PatLFName1,
				v_PatLGName1,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				i_UsrID,
				SYSDATE,
				decode(v_PatCheckID, '0', '', i_UsrID),
				decode(v_PatCheckID, '0', '', SYSDATE)
			);

			IF TRIM(v_PatMother) IS NOT NULL THEN
				INSERT INTO MBLINK (
					MBLID, PatNo_M, PatNo_B, MBLDESC, M_REGID, B_REGID
				) VALUES (
					SEQ_MBLINK.NEXTVAL, v_PatMother, v_PatNo1, v_MBLDESC, NULL, NULL
				);
			END IF;

			-- insert extra
			IF v_BirthOrdSPG IS NOT NULL AND v_BirthOrdSPG <> '<LINE/>' THEN
				INSERT INTO PATIENT_EXTRA(
					PATNO,
					DOCTYPE,
					PATMKTRMK,
					DENTALNO,
					PATMISCRMK,
					PATCDATE,
					BIRHTORDSPG,
					PATADDIDNO1,
					PATADDDOCTYPE1,
					PATADDIDCOUCODE1,
					PATADDIDNO2,
					PATADDDOCTYPE2,
					PATADDIDCOUCODE2,
					STECODE,
					PATPGRCOUCODE
				) VALUES (
					v_PatNo1,
					v_PatDocType,
					v_MktRmk,
					v_dentno,
					v_MiscRmk,
					SYSDATE,
					TO_NUMBER(v_BirthOrdSPG),
					v_AddIDNo1,
					v_AddIDDocType1,
					v_AddIDCouCode1,
					v_AddIDNo2,
					v_AddIDDocType2,
					v_AddIDCouCode2,
					v_REAL_STECODE,
					v_mobCouCode
				);
			ELSE
				INSERT INTO PATIENT_EXTRA(
					PATNO,
					DOCTYPE,
					PATMKTRMK,
					DENTALNO,
					PATMISCRMK,
					PATCDATE,
					PATADDIDNO1,
					PATADDDOCTYPE1,
					PATADDIDCOUCODE1,
					PATADDIDNO2,
					PATADDDOCTYPE2,
					PATADDIDCOUCODE2,
					STECODE,
					PATPGRCOUCODE
				) VALUES (
					v_PatNo1,
					v_PatDocType,
					v_MktRmk,
					v_dentno,
					v_MiscRmk,
					SYSDATE,
					v_AddIDNo1,
					v_AddIDDocType1,
					v_AddIDCouCode1,
					v_AddIDNo2,
					v_AddIDDocType2,
					v_AddIDCouCode2,
					v_REAL_STECODE,
					v_mobCouCode
				);
			END IF;

			IF v_REAL_STECODE <> 'TWAH' THEN
				INSERT INTO PATIENT_SYNC_PENDING(PATNO, ACTION, STECODE, LASTUPD) VALUES(v_PatNo1, 'INSERT', v_REAL_STECODE, SYSDATE);
			END IF;

			IF v_REAL_STECODE = 'HKAH' THEN
				SELECT AltID INTO v_AltID_REGF1 FROM Alert WHERE AltCode = v_REGF2;

				v_PalID := NHS_ACT_PATALERT('ADD', v_AltID_REGF1, v_PatNo1, 'PORTAL', NULL, NULL, o_errmsg);
			END IF;

			-- add chart
			IF v_REAL_STECODE = 'AMC1' OR v_REAL_STECODE = 'AMC2' THEN
				-- do nothing
				SELECT COUNT(1) INTO iCount FROM DUAL;
			ELSE
				RTNCURSOR := NHS_ACT_MEDREC_ADD('ADD', '0', 'P', 'C', v_PatNo1, v_CURRENT_STECODE, '', '', '', '', i_UsrID, '0', '0', '-1');
			END IF;

			IF v_REAL_STECODE = 'HKAH' THEN
				o_errCode := NHS_ACT_RECORDUNLOCK('ADD', 'Patient', i_UsrID, '127.0.0.1', i_UsrID, o_errmsg);
			ELSE
				o_errCode := 0;
			END IF;

			o_errCode := v_PatNo1;
			o_errmsg := 'OK';
		ELSE
			o_errCode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_Action = 'MOD' THEN
		IF v_noOfRec = 1 THEN
			SELECT COUNT(1) INTO v_noOfRec FROM PATIENT WHERE PATIDNO = v_PatIDNo AND PATNO <> v_PatNo;
			IF v_noOfRec > 0 THEN
				o_errCode := -1;
				o_errmsg := 'ID/Passport No. is already existed.';
				RAISE CREATE_PATIENT_ERR;
			END IF;

			SELECT PatChkID, PatAddRmk, PatPager, PatHTel, PatOTel, PatFaxNo, PatAdd1, PatAdd2, PatAdd3, PatRmk
			INTO v_oldPatChkID, v_oldPatAddRmk, v_oldPatPager, v_oldPatHTel, v_oldPatOTel, v_oldPatFaxNo, v_oldPatAdd1, v_oldPatAdd2, v_oldPatAdd3, v_oldPatRmk
			FROM Patient
			WHERE PatNo = v_PatNo;

			UPDate	Patient
			SET
				PatIDNo = v_PatIDNo,
				PatIDCouCode = v_PatIDCoun,
				PatFName = v_PatFName,
				PatGName = v_PatGName,
				PatCName = v_PatCName,
				PatMName = v_PatMName,
				PatFNameSDX = soundex(v_PatFName),
				PatGNameSDX = soundex(v_PatGName),
				PatMNameSDX = soundex(v_PatMName),
				TitDesc = v_TitDesc,
				PatMSTS = v_PatMSTS,
				PatBDate = v_PatBDate1,
				RacDesc = v_RacDesc,
				MothCode = v_MothCode,
				PatSex = v_PatSex,
				EduLevel = v_EduLevel,
				PatMktSrc = v_MktSource,
				Religious = v_Religious,
				DEATH = v_Death1,
				Occupation = v_Occupation,
				PatMother = v_PatMother,
				PatNB = TO_NUMBER(v_PatNB),
				PatSTS = TO_NUMBER(v_PatSTS),
				PatITP = TO_NUMBER(v_PatITP),
				PatStaff = TO_NUMBER(v_PatStaff),
				PatSMS = TO_NUMBER(v_PatSMSCheck),
				PatChkID = TO_NUMBER(v_PatCheckID),
				PatEmail = v_PatEmail,
				PatPager = v_PatPager,
				PatHTel = v_PatHTel,
				PatOTel = v_PatOTel,
				PatFaxNo = v_PatFaxNo,
				PatAdd1 = v_PatAdd1,
				PatAdd2 = v_PatAdd2,
				PatAdd3 = v_PatAdd3,
				LocCode = v_LocCode,
				CouCode = v_CouCode,
				PatKName = v_PatKName,
				PatKRELA = v_PatKRELA,
				PatKHTel = v_PatKHTel,
				PatKOTel = v_PatKOTel,
				PatKPTel = v_PatKPTel,
				PatKMTel = v_PatKMTel,
				PatKEmail = v_PatKEmail,
				PatKAdd = v_PatKAdd,
				PatRmk = v_PatRmk,
				SteCode = GET_CURRENT_STECODE,
--				LastUpd = SYSDATE,  -- only update last update date and user when additional remark is not updated
--				UsrID = i_UsrID,
				PatLFName = v_PatLFName,
				PatLGName = v_PatLGName
			WHERE	PatNo = v_PatNo;

			IF (TRIM(v_PatCheckID) <> TRIM(v_oldPatChkID) OR (TRIM(v_PatCheckID) IS NOT NULL AND TRIM(v_oldPatChkID) IS NULL)) THEN
				IF v_PatCheckID = '-1' THEN
					UPDate Patient
					SET PATCHKIDUPUSR = i_UsrID,
						PATCHKIDUPDT = SYSDATE
					WHERE PatNo = v_PatNo;
				ELSE
					UPDate Patient
					SET PATCHKIDUPUSR = NULL,
						PATCHKIDUPDT = NULL
					WHERE PatNo = v_PatNo;
				END IF;
			END IF;

			IF TRIM(v_PatAddRmk) <> TRIM(v_oldPatAddRmk) OR (TRIM(v_PatAddRmk) IS NULL AND TRIM(v_oldPatAddRmk) IS NOT NULL)
					OR (TRIM(v_PatAddRmk) IS NOT NULL AND TRIM(v_oldPatAddRmk) IS NULL) THEN
				UPDate Patient
				SET PatAddRmk = TRIM(v_PatAddRmk),
					AddRmkModUsr = i_UsrID,
					AddRmkModDT = SYSDATE
				WHERE PatNo = v_PatNo;
			ELSE
				UPDate Patient
				SET LastUpd = SYSDATE, UsrID = i_UsrID
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatPager) <> TRIM(v_oldPatPager) OR (TRIM(v_PatPager) IS NULL AND TRIM(v_oldPatPager) IS NOT NULL)
					OR (TRIM(v_PatPager) IS NOT NULL AND TRIM(v_oldPatPager) IS NULL) THEN
				UPDate Patient
				SET PatPagerUpUsr = i_UsrID,
					PatPagerUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatHTel) <> TRIM(v_oldPatHTel) OR (TRIM(v_PatHTel) IS NULL AND TRIM(v_oldPatHTel) IS NOT NULL)
					OR (TRIM(v_PatHTel) IS NOT NULL AND TRIM(v_oldPatHTel) IS NULL) THEN
				UPDate Patient
				SET PatHTelUpUsr = i_UsrID,
					PatHTelUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatOTel) <> TRIM(v_oldPatOTel) OR (TRIM(v_PatOTel) IS NULL AND TRIM(v_oldPatOTel) IS NOT NULL)
					OR (TRIM(v_PatOTel) IS NOT NULL AND TRIM(v_oldPatOTel) IS NULL) THEN
				UPDate Patient
				SET PatOTelUpUsr = i_UsrID,
					PatOTelUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatFaxNo) <> TRIM(v_oldPatFaxNo) OR (TRIM(v_PatFaxNo) IS NULL AND TRIM(v_oldPatFaxNo) IS NOT NULL)
					OR (TRIM(v_PatFaxNo) IS NOT NULL AND TRIM(v_oldPatFaxNo) IS NULL) THEN
				UPDate Patient
				SET PatFaxNoUpUsr = i_UsrID,
					PatFaxNoUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatAdd1) <> TRIM(v_oldPatAdd1) OR (TRIM(v_PatAdd1) IS NULL AND TRIM(v_oldPatAdd1) IS NOT NULL)
					OR (TRIM(v_PatAdd1) IS NOT NULL AND TRIM(v_oldPatAdd1) IS NULL)
					OR TRIM(v_PatAdd2) <> TRIM(v_oldPatAdd2) OR (TRIM(v_PatAdd2) IS NULL AND TRIM(v_oldPatAdd2) IS NOT NULL)
					OR (TRIM(v_PatAdd2) IS NOT NULL AND TRIM(v_oldPatAdd2) IS NULL)
					OR TRIM(v_PatAdd3) <> TRIM(v_oldPatAdd3) OR (TRIM(v_PatAdd3) IS NULL AND TRIM(v_oldPatAdd3) IS NOT NULL)
					OR (TRIM(v_PatAdd3) IS NOT NULL AND TRIM(v_oldPatAdd3) IS NULL) THEN
				UPDate Patient
				SET PatAddUpUsr = i_UsrID,
					PatAddUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatRmk) <> TRIM(v_oldPatRmk) OR (TRIM(v_PatRmk) IS NULL AND TRIM(v_oldPatRmk) IS NOT NULL)
					OR (TRIM(v_PatRmk) IS NOT NULL AND TRIM(v_oldPatRmk) IS NULL) THEN
				UPDate Patient
				SET RmkUpUsr = i_UsrID,
					RmkUpDT = SYSDATE
				WHERE PatNo = v_PatNo;
			END IF;

			IF TRIM(v_PatMother) IS NOT NULL THEN
				SELECT COUNT(1) INTO v_noOfRec FROM MBLINK WHERE PatNo_B = v_PatNo;
				IF v_noOfRec = 0 THEN
					INSERT INTO MBLINK (
						MBLID, PatNo_M, PatNo_B, MBLDESC
					) VALUES (
						SEQ_MBLINK.NEXTVAL, v_PatMother, v_PatNo, v_MBLDESC
					);
				ELSE
					UPDATE MBLINK SET PatNo_M = v_PatMother, MBLDESC = v_MBLDESC
					WHERE PatNo_B = v_PatNo;
				END IF;
			ELSE
				DELETE FROM MBLINK WHERE PatNo_B = v_PatNo;
			END IF;

			--update extra
			SELECT COUNT(1) INTO v_noOfRec FROM PATIENT_EXTRA WHERE PATNO = v_PatNo;
			IF v_noOfRec = 0 THEN
				INSERT INTO PATIENT_EXTRA(
					PATNO,
					DOCTYPE,
					PATMKTRMK,
					DENTALNO,
					PATMISCRMK,
					PATCDATE,
					PATADDIDNO1,
					PATADDDOCTYPE1,
					PATADDIDCOUCODE1,
					PATADDIDNO2,
					PATADDDOCTYPE2,
					PATADDIDCOUCODE2,     
					STECODE,
				PATPGRCOUCODE
				) VALUES (
					v_PatNo,
					v_PatDocType,
					v_MktRmk,
					v_dentno,
					v_MiscRmk,
					SYSDATE,
					v_AddIDNo1,
					v_AddIDDocType1,
					v_AddIDCouCode1,
					v_AddIDNo2,
					v_AddIDDocType2,
					v_AddIDCouCode2,
					v_REAL_STECODE,
				v_mobCouCode
				);
			ELSE
				IF v_BirthOrdSPG IS NOT NULL AND v_BirthOrdSPG <> '<LINE/>' THEN
					UPDATE PATIENT_EXTRA
					SET
						DOCTYPE = v_PatDocType,
						PATMKTRMK = v_MktRmk,
						DENTALNO = v_dentno,
						PATMISCRMK = v_MiscRmk,
						PATADDIDNO1 = v_AddIDNo1,
						PATADDDOCTYPE1 = v_AddIDDocType1,
						PATADDIDCOUCODE1 = v_AddIDCouCode1,
						PATADDIDNO2 = v_AddIDNo2,
						PATADDDOCTYPE2 = v_AddIDDocType2,
						PATADDIDCOUCODE2 = v_AddIDCouCode2,
						BIRHTORDSPG = TO_NUMBER(v_BirthOrdSPG),
				PATPGRCOUCODE = v_mobCouCode
					WHERE PATNO = v_PatNo;
				ELSE
					UPDATE PATIENT_EXTRA
					SET
						DOCTYPE = v_PatDocType,
						PATMKTRMK = v_MktRmk,
						DENTALNO = v_dentno,
						PATMISCRMK = v_MiscRmk,
						PATADDIDNO1 = v_AddIDNo1,
						PATADDDOCTYPE1 = v_AddIDDocType1,
						PATADDIDCOUCODE1 = v_AddIDCouCode1,
						PATADDIDNO2 = v_AddIDNo2,
						PATADDDOCTYPE2 = v_AddIDDocType2,
						PATADDIDCOUCODE2 = v_AddIDCouCode2,
						BIRHTORDSPG = null,
						PATPGRCOUCODE = v_mobCouCode
					WHERE PATNO = v_PatNo;
				END IF;
			END IF;

			IF v_REAL_STECODE <> 'TWAH' THEN
				INSERT INTO PATIENT_SYNC_PENDING(PATNO, ACTION, STECODE, LASTUPD) VALUES(v_PatNo, 'UPDATE', v_REAL_STECODE, SYSDATE);
			END IF;

			o_errCode := v_PatNo;
			o_errmsg := 'OK';
		ELSE
			o_errCode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;

		SELECT COUNT(1) INTO v_noOfRec FROM MBLINK WHERE PatNo_B = v_PatNo;
	ELSIF v_Action = 'DEL' THEN
		o_errCode := -1;
		o_errmsg := 'Fail to delete due to no access right.';
	END IF;

	RETURN o_errCode;
EXCEPTION
WHEN CREATE_PATIENT_ERR THEN
	ROLLBACK;
	RETURN o_errCode;
WHEN OTHERS THEN
	o_errCode := -1;
	o_errmsg:= o_errmsg || SQLERRM;
	ROLLBACK;
	RETURN o_errCode;
END NHS_ACT_PATIENT;
/
