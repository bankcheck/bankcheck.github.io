create or replace FUNCTION "NHS_ACT_PATIENT_REG" (
	v_action        IN      VARCHAR2,
	v_extslpno      IN      VARCHAR2,
	--INPAT-------------------------
	v_BedCode       IN      VARCHAR2,
	v_acmcode       IN      VARCHAR2,
	v_doccode_a     IN      VARCHAR2,
	v_srccode       IN      VARCHAR2,
	v_amtId         IN      VARCHAR2,
	v_inpremark     IN      VARCHAR2,
	--SLIP--------------------------
	v_patno         IN      VARCHAR2,
	v_slptype       IN      VARCHAR2,
	v_doccode       IN      VARCHAR2,
	v_arccode       IN      VARCHAR2,
	v_slpplyno      IN      VARCHAR2,
	v_slpvchno      IN      VARCHAR2,
	v_slpauthno     IN      VARCHAR2,
	v_pcyid         IN      VARCHAR2, --cvs to NUMBER
	v_patrefno      IN      VARCHAR2,
	v_Source        IN      VARCHAR2,
	v_Sourceno      IN      VARCHAR2,
	v_misc          IN      VARCHAR2,
	v_Sprqtid       IN      VARCHAR2,
	v_ISRECLG       IN      VARCHAR2,
	v_ARACMCODE     IN      VARCHAR2,
	v_PBPKGCODE     IN      VARCHAR2,
	v_ESTGIVEN      IN      VARCHAR2,
	v_arlmtamt      IN      VARCHAR2, --cvs to NUMBER
	v_cvredate      IN      VARCHAR2,
	v_itmtyped      IN      VARCHAR2,
	v_itmtypeh      IN      VARCHAR2,
	v_itmtypes      IN      VARCHAR2,
	v_itmtypeo      IN      VARCHAR2,
	v_furgrtamt     IN      VARCHAR2, --cvs to NUMBER
	v_furgrtdate    IN      VARCHAR2,
	v_copaytyp      IN      VARCHAR2,
	v_copayamt      IN      VARCHAR2, --cvs to NUMBER
	v_printdate     IN      VARCHAR2,
	--REG---------------------------
	v_regdate       IN      VARCHAR2,
	v_regtype       IN      VARCHAR2,
	v_regopcat      IN      VARCHAR2,
	v_regnb         IN      VARCHAR2,
	--REGPKGLINK--------------------
	v_pkgcode       IN      VARCHAR2,
	v_bkgid         IN      VARCHAR2,
	v_isMainland    IN      VARCHAR2,
	v_memActID      IN      VARCHAR2,
	v_actstaylen    IN      VARCHAR2,
	v_ticketNo      IN      VARCHAR2,
	v_PBORemark     IN      VARCHAR2,
	v_pbpid         IN      VARCHAR2,
	v_PRINT_MRRPT   IN      VARCHAR2,
	v_deductible    IN      VARCHAR2,
	v_FESTID        IN      VARCHAR2,
	v_BE            IN      VARCHAR2,
	--OTHERS------------------------
	i_siteCode      IN      VARCHAR2,
	i_usrid         IN      VARCHAR2,
	i_ComputerName  IN      VARCHAR2,
	i_skipCheckBed  IN      VARCHAR2,
	i_skipCreateSlp IN      VARCHAR2,
	i_refDoccode1    IN      VARCHAR2,
	i_refDoccode2    IN      VARCHAR2,
	i_docRoom       IN       VARCHAR2,
  o_errmsg        OUT     VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode NUMBER;
	v_inpid NUMBER;
	v_regid Reg.RegID%TYPE;
	v_regid_c Patient.RegID_C%TYPE;
	v_regid_current_ip REG.RegID%TYPE;
	v_yearday VARCHAR2(15);
	v_slpno VARCHAR2(15);
	v_bkgpname VARCHAR2(40);
	v_cvredate1 DATE;
	v_furgrtdate1 DATE;
	v_regdate1 DATE;
	v_arlmtamt1 NUMBER;
	v_furgrtamt1 NUMBER;
	v_copayamt1 NUMBER;
	v_extregid NUMBER;
	v_extinp_id NUMBER;
	v_daypid NUMBER;
	v_regnb1 NUMBER;
	v_bkgid1 NUMBER;
	v_pbpid1 NUMBER;
	v_isMainlandl NUMBER;
	v_lBedCode BED.BEDCODE%TYPE;
	v_discharge_date VARCHAR2(22);
	v_curr_doccode VARCHAR2(10);
	v_max_dhsid NUMBER;
	v_max_bhsid NUMBER;
	bRegNB NUMBER;
	tmpMBLinkID NUMBER;
	tmpPatNo_M VARCHAR2(10);
	tmpMotherREGID_C NUMBER;
	v_PatientEName VARCHAR2(81);
	v_PatientFName PATIENT.PATFNAME%TYPE;
	v_PatientGName PATIENT.PATGNAME%TYPE;
	v_PatientCName PATIENT.PATCNAME%TYPE;
	v_PatIdNo VARCHAR2(20);
	v_PatHTel VARCHAR2(20);
	v_PatPager VARCHAR2(20);
	v_rplid NUMBER;
	v_count NUMBER;
	v_countRegPkgLink NUMBER;
	v_pkgcode1 Package.pkgcode%Type;
	v_trackCode VARCHAR2(1000);
	v_amtId1 NUMBER;
	v_dptCode VARCHAR2(10);
	v_ticketNo1 NUMBER(22);
	v_patNB NUMBER(22);
	v_index NUMBER;
	v_pkgcodeMultiple BOOLEAN;
	v_ticketgenmth VARCHAR2(1);
	v_slpsid NUMBER;
	v_ComputerName Booking.BkgMAC%Type;
	v_expirydate VARCHAR2(50);
	o_acmcode ROOM.ACMCODE%TYPE;
	o_bedcode BED.BEDCODE%TYPE;
	OUTCUR types.CURSOR_TYPE;
	v_sex Patient.PATSEX%type;
	v_Fid Fin_Est_Hosp.Festid%Type;
	i_BE FIN_EST_HOSP.OSB_BE%TYPE;
	v_regopcat2 Slip.regopcat%TYPE;
	v_BKACODE BOOKINGALERT.BKACODE%TYPE;
	v_PBORemark2 SLIP.SLPREMARK%TYPE;

	Enhancement_01 NUMBER(1) := 1;
	SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
	SCH_CONFIRM VARCHAR2(1) := 'F';
	BED_STS_FREE VARCHAR2(1) := 'F';
	BED_STS_OCCUPY VARCHAR2(1) := 'O';
	REG_TYPE_INPATIENT VARCHAR2(1) := 'I';
	REG_TYPE_OUTPATIENT VARCHAR2(1) := 'O';
	REG_TYPE_DAYCASE VARCHAR2(1) := 'D';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	v_trackCode := '0000';
	v_Fid := v_FESTID;

	BEGIN
		v_trackCode := '0001';
		SELECT REGID_C INTO v_regid_c FROM PATIENT WHERE patno = v_patno;
	EXCEPTION WHEN OTHERS THEN
		v_regid_c := NULL;
	END;

	IF v_action = 'ADD' OR v_action = 'MOD' THEN
		IF v_ARCCODE IS NOT NULL AND LENGTH(v_ARCCODE) > 0 THEN
			SELECT COUNT(1) INTO v_noOfRec
			FROM ARCODE
			WHERE UPPER(ARCCODE) = UPPER(v_ARCCODE);

			IF v_NOOFREC = 0 THEN
				o_errcode := -100;
				o_errmsg := 'AR Code does not exist.';
				RETURN o_errcode;
			END IF;
		END IF;

		IF v_BedCode IS NOT NULL AND LENGTH(v_BedCode) > 0 THEN
			SELECT COUNT(1) INTO v_noOfRec
			FROM Bed
			WHERE UPPER(BedCode) = UPPER(v_BedCode);

			IF v_NOOFREC = 0 THEN
				o_errcode := -200;
				o_errmsg := 'Invalid Bed Code.';
				RETURN o_errcode;
			END IF;

			SELECT PATSEX INTO v_sex
			FROM PATIENT
			WHERE PATNO = v_patno;

			BEGIN
				SELECT R.REGID INTO v_regid_current_ip
				FROM REG R
				JOIN INPAT I ON R.INPID = I.INPID
				WHERE R.patno = v_patno
				AND   R.REGSTS = 'N'
				AND   I.INPDDATE IS NULL
				AND   ROWNUM = 1
				ORDER BY R.REGDATE DESC;
			EXCEPTION WHEN OTHERS THEN
				v_regid_current_ip := NULL;
			END;

			IF v_regid_current_ip IS NOT NULL THEN
				BEGIN
					SELECT BEDCODE INTO o_bedcode
					FROM REG R, INPAT I
					WHERE I.INPID = R.INPID
					AND   R.REGID = v_regid_current_ip;
				EXCEPTION WHEN OTHERS THEN
					o_bedcode := NULL;
				END;
			END IF;

			IF i_skipCheckBed = 0 AND v_BedCode IS NOT NULL AND (o_bedcode IS NULL OR o_bedcode <> v_BedCode) THEN
				OUTCUR := NHS_LIS_CHECKBEDSTATUS('F', v_BedCode, v_sex, i_ComputerName, i_usrid);
				LOOP
					FETCH OUTCUR INTO o_errcode, o_errmsg;
					EXIT WHEN OUTCUR%NOTFOUND;
				END LOOP;
				CLOSE OUTCUR;

				IF o_errcode <> 0 THEN
					o_errcode := o_errcode * -1;
					RETURN o_errcode;
				END IF;
			END IF;

			IF v_acmcode IS NULL OR LENGTH(v_acmcode) = 0 THEN
				SELECT R.ACMCODE INTO o_acmcode
				FROM BED B, ROOM R
				WHERE B.ROMCODE = R.ROMCODE
				AND UPPER(BedCode) = UPPER(v_BedCode);
			ELSE
				o_acmcode := v_acmcode;
			END IF;
		END IF;

		IF v_doccode IS NULL THEN
			o_errcode := -300;
			o_errmsg := 'Inactive Doctor Code.';
			RETURN o_errcode;
		ELSIF GET_CURRENT_STECODE = 'HKAH' AND v_doccode = 'PBOG' THEN
			o_errcode := -300;
			o_errmsg := 'Cannot confirm PBOG doctor.';
			RETURN o_errcode;
		ELSE
			SELECT COUNT(1) INTO v_noOfRec
			FROM Doctor
			WHERE UPPER(DocCode) = UPPER(v_doccode) AND DocSts = -1;

			IF v_NOOFREC = 0 THEN
				SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expirydate
				FROM Doctor
				WHERE UPPER(DocCode) = UPPER(v_doccode);

				o_errcode := -300;
				o_errmsg := 'Invalid Doctor Code.<br/>Admission Expiry Date: '||v_expirydate;
				RETURN o_errcode;
			END IF;
		END IF;

		IF v_regtype = REG_TYPE_INPATIENT THEN
			IF v_doccode_a IS NULL THEN
				o_errcode := -400;
				o_errmsg := 'Inactive Admission Doctor.';
				RETURN o_errcode;
			ELSE
				SELECT COUNT(1) INTO v_noOfRec
				FROM Doctor
				WHERE UPPER(DocCode) = UPPER(v_doccode_a) AND DocSts = -1;

				IF v_NOOFREC = 0 THEN
					 SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expirydate
					 FROM Doctor
					 WHERE UPPER(DocCode) = UPPER(v_doccode_a);

					o_errcode := -400;
					o_errmsg := 'Invalid Admission Doctor.<br/>Admission Expiry Date: '||v_expirydate;
					RETURN o_errcode;
				END IF;
			END IF;
		END IF;
	END IF;

	IF Enhancement_01 <> 1 THEN
		BEGIN
			SELECT PATNB INTO v_patNB FROM PATIENT WHERE patno = v_patno;
		EXCEPTION WHEN OTHERS THEN
			v_patNB := NULL;
		END;

		IF v_patNB = -1 THEN
			v_regnb1 := -1;
		ELSE
			v_regnb1 := 0;
		END IF;
	END IF;

	IF TRIM(v_arlmtamt) IS NULL OR TRIM(v_arlmtamt) = '' THEN
		v_arlmtamt1 := 0;
	ELSE
		v_arlmtamt1 := TO_NUMBER(v_arlmtamt);
	END IF;

	IF TRIM(v_furgrtamt) IS NULL OR TRIM(v_furgrtamt) = '' THEN
		v_furgrtamt1 := 0;
	ELSE
		v_furgrtamt1 := TO_NUMBER(v_furgrtamt);
	END IF;

	IF TRIM(v_copayamt) IS NULL OR TRIM(v_copayamt) = '' THEN
		v_copayamt1 := 0;
	ELSE
		v_copayamt1 := TO_NUMBER( v_copayamt);
	END IF;

	IF TRIM(v_cvredate) IS NULL OR TRIM(v_cvredate) = '' THEN
		v_cvredate1 := NULL;
	ELSE
		v_cvredate1 := TO_DATE (v_cvredate, 'DD/MM/YYYY');
	END IF;

	IF TRIM(v_furgrtdate) IS NULL OR TRIM(v_furgrtdate) = '' THEN
		v_furgrtdate1 := NULL;
	ELSE
		v_furgrtdate1 := TO_DATE (v_furgrtdate, 'DD/MM/YYYY');
	END IF;

	IF TRIM(v_regdate) IS NULL OR TRIM (v_regdate) = '' THEN
		v_regdate1 := NULL;
	ELSE
		v_regdate1 := TO_DATE (v_regdate, 'DD/MM/YYYY HH24:MI:SS');
	END IF;

	v_trackCode := '0002';
	v_pkgcodeMultiple := FALSE;
	IF TRIM(v_pkgcode) IS NULL THEN
		v_pkgcode1 := 'GEN';
	ELSE
		v_index := INSTR(TRIM(v_pkgcode), ',');
		IF v_index = 0 THEN
			-- only one pkgcode
			v_pkgcode1 := TRIM(v_pkgcode);
		ELSE
			-- more than one pkgcode
			v_pkgcode1 := SUBSTR(TRIM(v_pkgcode), 1, v_index - 1);
			v_pkgcodeMultiple := TRUE;
		END IF;
	END IF;

	v_trackCode := '0003';
	IF TRIM(v_regnb) IS NULL THEN
		v_regnb1 := NULL;
	ELSE
		SELECT DECODE(LENGTH(PATMOTHER), NULL, 0, LENGTH(PATMOTHER)) INTO v_noOfRec
		FROM PATIENT
		WHERE PATNO = v_patno;

		IF v_noOfRec = 0 AND TO_NUMBER(v_regnb) = -1 THEN
			o_errcode := -10;
			o_errmsg := 'Mother Record (Master) should not be empty.';
			RETURN o_errcode;
		END IF;

		v_regnb1 := TO_NUMBER(v_regnb);
	END IF;

	v_trackCode := '0004';
	IF TRIM(v_bkgid) IS NULL THEN
		v_bkgid1 := NULL;
	ELSE
		v_bkgid1 := TO_NUMBER(v_bkgid);
	END IF;

	IF TRIM(v_pbpid) IS NULL THEN
		v_pbpid1 := NULL;
	ELSE
		v_pbpid1 := TO_NUMBER(v_pbpid);
	END IF;

	IF TRIM(v_isMainland) IS NULL THEN
		v_isMainlandl := NULL;
	ELSE
		v_isMainlandl := TO_NUMBER(v_isMainland);
	END IF;

	IF TRIM(v_amtId) IS NULL THEN
		v_amtId1 := NULL;
	ELSE
		v_amtId1 := TO_NUMBER(v_amtId);
	END IF;

	IF TRIM(v_ticketNo) IS NULL THEN
		v_ticketNo1 := NULL;
	ELSE
		v_ticketNo1 := TO_NUMBER(v_ticketNo);
	END IF;

	BEGIN
		v_trackCode := '0005';
		SELECT regnb INTO bRegNB FROM reg WHERE regid = v_regid_c;
	EXCEPTION WHEN OTHERS THEN
		bRegNB := 0;
	END;

	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	END IF;

	IF v_Source IS NOT NULL THEN
--		SELECT COUNT(1) INTO v_noOfRec FROM BookingSrc WHERE Bksid = v_Source AND BKSSTS = -1 AND BKSID in ('61','62', '8', '65');
		SELECT COUNT(1) INTO v_noOfRec FROM BookingSrc WHERE Bksid = v_Source AND BKSSTS = -1 AND BKSCARRYFWD = -1;
		IF v_noOfRec > 0 THEN
--			SELECT Bksid INTO v_slpsid FROM BookingSrc WHERE Bksid = v_Source AND BKSSTS = -1 AND BKSID in ('61','62', '8', '65');
			SELECT Bksid INTO v_slpsid FROM BookingSrc WHERE Bksid = v_Source AND BKSSTS = -1 AND BKSCARRYFWD = -1;
		ELSE
			SELECT COUNT(1) INTO v_noOfRec FROM BookingSrc WHERE Bksid = v_Source AND BKSID in ('0');
			IF v_noOfRec > 0 THEN
				SELECT Bksid INTO v_slpsid FROM BookingSrc WHERE Bksid = v_Source AND BKSID in ('0');
			END IF;
		END IF;
	END IF;

	v_trackCode := '0006';
	SELECT COUNT(1) INTO v_noOfRec FROM REG WHERE slpno = v_extslpno;

	IF v_action = 'ADD' THEN
		IF TRIM(v_extslpno) IS NULL OR TRIM(v_extslpno) = '' THEN
			--savepoint my_savepoint;
			IF v_regtype = REG_TYPE_INPATIENT THEN
				v_trackCode := '0007';
				--INPAT
--				SELECT SEQ_DAYPAT.NEXTVAL INTO v_daypid FROM DUAL;

				v_trackCode := '0008';
				SELECT SEQ_INPAT.NEXTVAL INTO v_inpid FROM DUAL;

				v_trackCode := '0009';
				UPDATE patient SET lastprtdate = NULL WHERE patno = v_patno;

			ELSIF v_regtype = REG_TYPE_DAYCASE THEN
				--daypat
				SELECT SEQ_DAYPAT.NEXTVAL INTO v_daypid FROM DUAL;

				v_trackCode := '0010';
				INSERT INTO daypat(
					daypid,
					DESCODE,
					RSNCODE,
					SDSCODE,
					RECVDT,
					CODEDT
				) values(
					v_daypid,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL
				);
			ELSIF v_regtype = REG_TYPE_OUTPATIENT THEN
				--outpat
				SELECT SEQ_DAYPAT.NEXTVAL INTO v_daypid FROM DUAL;
				SELECT PARAM1 INTO v_ticketgenmth FROM SYSPARAM WHERE PARCDE = 'TicketGen';

				IF v_ticketNo1 IS NOT NULL AND v_ticketgenmth = 'A' THEN
					v_trackCode := '0011';
					INSERT INTO dailyticketNo (
						ticketid,
						ticketNo,
						regdate
					) VALUES (
						SEQ_DAILYTICKETNO.NEXTVAL,
						v_ticketNo1,
						v_regdate1
					);
				END IF;
			END IF;

			-- Check Slip
			IF v_patno IS NOT NULL THEN
				SELECT COUNT(1) INTO v_count FROM SLIP S
				INNER JOIN SLIP_EXTRA E ON S.SLPNO = E.SLPNO
				WHERE S.PATNO = v_patno AND S.SLPTYPE = v_slptype AND S.DOCCODE = v_doccode AND E.SLPDATE IS NOT NULL AND E.SLPDATE > SYSDATE - (1 / 86400);

				IF v_count > 0 THEN
					O_ERRCODE := -1;
					O_ERRMSG := 'Fail to create new slip in short period of time. Please try again later!';
					RETURN O_ERRCODE;
				END IF;
			END IF;

			v_regopcat2 := v_regopcat;
			IF v_regtype = REG_TYPE_OUTPATIENT THEN
				IF v_bkgid IS NOT NULL AND v_bkgid > 0 THEN
					SELECT COUNT(1) INTO v_count
					FROM   Booking B, DOCLOCATION L
					WHERE  B.DOCLOCID = L.DOCLOCID
					AND    B.BKGID = v_bkgid;

					IF v_count = 1 THEN
						SELECT L.REGOPCAT INTO v_regopcat2
						FROM   Booking B, DOCLOCATION L
						WHERE  B.DOCLOCID = L.DOCLOCID
						AND    B.BKGID = v_bkgid;
					END IF;

					IF GET_CURRENT_STECODE = 'TWAH' THEN
						SELECT COUNT(1) INTO v_count
						FROM   Booking B, BOOKINGALERT A
						WHERE  B.BKGALERT = A.BKAID
						AND    B.BKGID = v_bkgid;

						IF v_count = 1 THEN
							SELECT A.BKACODE INTO v_BKACODE
							FROM   Booking B, BOOKINGALERT A
							WHERE  B.BKGALERT = A.BKAID
							AND    B.BKGID = v_bkgid;

							IF TRIM(v_pkgcode) IS NULL AND TRIM(v_BKACODE) IS NOT NULL THEN
								v_pkgcode1 := v_BKACODE;
							END IF;
						END IF;
					END IF;
				END IF;

				-- default value if empty
				IF v_regopcat2 IS NULL THEN
					v_regopcat2 := 'N';
				END IF;
			END IF;

			v_trackCode := '0012';
			IF TRIM(v_inpid) IS NOT NULL THEN
				SELECT DptCode
				INTO   v_dptCode
				FROM   Bed, Room, Ward
				WHERE  Bed.RomCode = Room.RomCode
				AND    Room.WrdCode = Ward.WrdCode
				AND    Bed.BedCode = v_BedCode;
			ELSE
				v_dptCode := '0';
			END IF;

			v_trackCode := '0013';
			--IF bkgid IS NOT NULL UPDATE booking SET bkgsts='F'
			IF v_bkgid1 IS NOT NULL AND v_bkgid1 > 0 THEN
				v_trackCode := '0014';
				SELECT patfname || ' ' || patgname, patcname, pathtel
				INTO   v_PatientEName, v_PatientCName, v_PatHTel
				FROM   patient
				WHERE  patno = v_patno;

				SELECT COUNT(1) INTO v_count
				FROM   BOOKING
				WHERE  BKGID = v_bkgid1
				AND    BKGRMK IS NOT NULL
				AND    BKGALERT IN ('61', '62', '63');

				IF v_count = 1 THEN
					SELECT BKGRMK INTO v_PBORemark2
					FROM   BOOKING
					WHERE  BKGID = v_bkgid1
					AND    BKGRMK IS NOT NULL
					AND    BKGALERT IN ('61', '62', '63');
				END IF;

				v_trackCode := '0015';
				UPDATE Booking
				SET BkgSts = SCH_CONFIRM,
					PatNo = v_patno,
					BKGPCNAME = v_PatientCName,
					BKGPNAME = v_PatientEName,
					BKGPTEL = v_PatHTel,
					BkgFDate = SYSDATE,
					BkgMAC = v_ComputerName
				WHERE BkgID = v_bkgid1
				AND BkgSts != SCH_CONFIRM;

				SELECT COUNT(1) INTO v_count
				FROM   REG
				WHERE  BkgID = v_bkgid1
				AND    PATNO = v_patno
				AND    REGSTS = 'N';

				IF v_count > 0 THEN
					o_errcode := -10;
					o_errmsg := 'Booking already registered. Cannot duplicate registration.';
					ROLLBACK;
					RETURN o_errcode;
				END IF;
			END IF;

			-- SLIP
			v_trackCode := '0016';
			v_slpno := GENERATE_SLIP_NO;

			INSERT INTO Slip(
				slpno,
				patno,
				regid,
				slpfname,
				slpgname,
				patcname,
				slptype,
				doccode,
				dptcode,
				slpsts,
				slphdisc,
				slpddisc,
				slpsdisc,
				slpadoc,
				slpseq,
				slppseq,
				slppamt,
				slpcamt,
				slpdamt,
				slphdamt,
				slpddamt,
				slpsdamt,
				slpohdamt,
				slpoddamt,
				slposdamt,
				stecode,
				slpusear,
				arccode,
				slpplyno,
				slpvchno,
				pcyid,
				slpmanall,
				slpseqfm,
				patrefno,
				slpascm,
				usrid,
				slpremark,
				arlmtamt,
				cvredate,
				itmtyped,
				itmtypeh,
				itmtypes,
				itmtypeo,
				furgrtamt,
				furgrtdate,
				copaytyp,
				printdate,
				copayamtact,
				copayamt,
				edc,
				firstprtdt,
				issuedt,
				rmkmodusr,
				rmkmoddt,
				depfirstprtdt,
				depissuedt,
				bpbno,
				edcuserid,
				edceditdate,
				bpbnouserid,
				bpbeditdate,
				actid,
				slpsid,
				regopcat
			) VALUES (
				v_slpno,
				v_patno,
				NULL, --REGID
				NULL, --UN
				NULL, --UN
				NULL, --UN
				v_slptype,
				v_doccode,
				v_dptCode, --DptCode
				SLIP_STATUS_OPEN,  --COMFIRM SLPSTS
				0, --COMFIRM SLPHDISC
				0, --COMFIRM SLPDDISC
				0, --COMFIRM SLPSDISC
				NULL, --UN
				1,
				1, --COMFIRM SLPPSEQ
				0, --COMFIRM SLPPAMT
				0, --COMFIRM SLPCAMT
				0, --COMFIRM SLPDAMT
				NULL, --UN
				NULL, --UN
				NULL, --UN
				NULL, --UN
				NULL, --UN
				NULL, --UN
				i_siteCode,
				NULL, --UN
				v_arccode,
				v_slpplyno,
				v_slpvchno,
				v_pcyid,
				NULL, --UN
				NULL, --UN
				v_patrefno,
				NULL, --COMFIRM SLPASCM NO FIELD IN DB
				i_usrid, --COMFIRM USERID NO FIELD IN DB
				NULL, --COMFIRM SLPREMARK NO FIELD IN DB
				v_arlmtamt1,
				v_cvredate1,
				TO_NUMBER(v_itmtyped),
				TO_NUMBER(v_itmtypeh),
				TO_NUMBER(v_itmtypes),
				TO_NUMBER(v_itmtypeo),
				v_furgrtamt1,
				v_furgrtdate1,
				v_copaytyp,
				NULL, --UN
				v_deductible,  --COPAYAMTACT
				v_copayamt1,
				NULL, --COMFIRM EDC NO FIELD IN DB
				NULL, --COMFIRM FRISTPRTDT NO FIELD IN DB
				NULL, --COMFIRM ISSUEDT NO FIELD IN DB
				NULL, --COMFIRM RMKMODUSR NO FIELD IN DB
				NULL, --COMFIRM RMKMODDT NO FIELD IN DB
				NULL, --COMFIRM DEPFRISTPRTDT NO FIELD IN DB
				NULL, --COMFIRM DEPISSUEDT NO FIELD IN DB
				NULL, --COMFIRM BPBNO NO FIELD IN DB
				NULL, --COMFIRM EDCUSERID NO FIELD IN DB
				NULL, --COMFIRM EDCEDITDATE NO FIELD IN DB
				NULL, --COMFIRM BPBNOUSERID NO FIELD IN DB
				NULL, --COMFIRM BPBEDITDATE NO FIELD IN DB
				v_memActID,
				v_slpsid,
				v_regopcat2
			);

			IF v_BE = '-1' AND v_FESTID IS NULL THEN
				Insert Into Fin_Est_Hosp (
					Festid, Slpno, Patno, Osb_Be
				) Values (
					Seq_Fest.Nextval, v_slpno, v_patno, v_BE
				);
			ELSIF v_BE IS NOT NULL AND v_FESTID IS NOT NULL THEN
				SELECT OSB_BE INTO i_BE FROM FIN_EST_HOSP WHERE FESTID = v_FESTID;
				IF i_BE IS NOT NULL AND i_BE = '-1' AND v_BE = '0' THEN
					DELETE FROM FIN_EST_HOSP
					WHERE FESTID = v_FESTID;
				ELSE
					v_Fid := v_FESTID;
					Update Fin_Est_Hosp
					Set
						Osb_Be = v_BE,
						Slpno = v_Slpno,
						Patno = v_Patno
					WHERE FESTID = v_Fid;
				END IF;
			END IF;

			-- insert extra
			INSERT INTO SLIP_EXTRA(
				slpno,
				slpsno,
				slpdate,
				SLPMID,
				SPRQTID,
				ISRECLG,
				ARACMCODE,
				PBPKGCODE,
				ESTGIVN,
				INSPREAUTHNO
			) VALUES (
				v_slpno,
				v_Sourceno,
				SYSDATE,
				v_misc,
				v_Sprqtid,
				v_ISRECLG,
				v_ARACMCODE,
				v_PBPKGCODE,
				v_ESTGIVEN,
				v_slpauthno
			);

			-- Automate Slip Category
			v_count := NHS_UTL_AUTOSLIPCAT(v_slpno, NULL);

			IF TRIM(v_PBORemark) IS NOT NULL THEN
				UPDATE slip
				SET
					SlpRemark = v_PBORemark,
					RmkModUsr = i_usrid,
					RmkModDt = sysdate
				WHERE slpno = v_slpno;
			END IF;

			IF v_PBORemark2 IS NOT NULL THEN
				UPDATE slip
				SET
					SlpRemark = v_PBORemark2,
					RmkModUsr = i_usrid,
					RmkModDt = sysdate
				WHERE slpno = v_slpno;
			END IF;

			v_trackCode := '0017';
			--REG
			SELECT SEQ_REG.NEXTVAL INTO v_regid FROM DUAL;

			IF v_regnb1 = -1 THEN
				-- Get Mother Patno, MBLink ID
				v_trackCode := '0018';
				BEGIN
					SELECT PATNO_M, MBLID INTO tmpPatNo_M, tmpMBLinkID
					FROM   MBLINK
					WHERE  Patno_B = v_patno;
				EXCEPTION WHEN OTHERS THEN
					tmpPatNo_M := NULL;
				END;

				v_trackCode := '0019';
				-- Get Mother RECID_C and BB RECID_C
				IF tmpPatNo_M IS NOT NULL THEN
					v_trackCode := '0020';
					SELECT REGID_C INTO tmpMotherREGID_C
					FROM   patient
					WHERE  patno = tmpPatNo_M;
				END IF ;

				v_trackCode := '0021';
				IF TRIM(tmpMBLinkID) IS NOT NULL AND TRIM(tmpMotherREGID_C) IS NOT NULL AND v_regid IS NOT NULL THEN
					v_trackCode := '0022';
					UPDATE MBLink
					SET    M_REGID = tmpMotherREGID_C, B_REGID = v_regid
					WHERE  MBLID = tmpMBLinkID;
				END IF;
			END IF;

			v_trackCode := '0023';
			UPDATE patient
			SET RegID_L = v_regid_c,
				RegID_C = v_regid,
				PatVCnt = PatVCnt + 1
			WHERE patno = v_patno;

			v_trackCode := '0024';
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
				ismainland,
				PRINT_MRRPT
			) VALUES (
				v_regid,
				v_patno,
				v_slpno,
				v_regdate1, --REGDATEDnI?
				v_regtype,
				v_regopcat2, --COMFIRM REGOPCAT HAVE VALUE
				'N', --COMFIRM REGSTS HAVE VALUE
				v_inpid,
				v_doccode, --COMFIRM DOCCODE UN HAVE VALUE
				v_pkgcode1, --COMFIRM PKGCODE UN HAVE VALUE
				i_siteCode,
				NULL, --UN
				v_regnb1,
				v_bkgid1,
				v_pbpid, --COMFIRM BPBID NO FIELD IN DB?
				v_ticketNo1,
				v_daypid,
				v_isMainlandl,
				v_PRINT_MRRPT
			);

			INSERT INTO REG_EXTRA(
				REGID,
				CREATE_DATE,
				CREATE_USER,
				CREATE_LOC,
				MODIFY_DATE,
				MODIFY_USER,
				DOCCODE_REF1,
				DOCCODE_REF2,
        RMID
			) VALUES (
				v_regid,
				SYSDATE,
				i_usrid,
				i_ComputerName,
				SYSDATE,
				i_usrid,
				i_refDoccode1,
				i_refDoccode2,
        i_docRoom
			);

			--update InPat
			v_trackCode := '0025';
			IF v_regtype = REG_TYPE_INPATIENT THEN
				INSERT INTO InPat(
					inpid,
					BedCode,
					acmcode,
					doccode_a,
					doccode_d,
					InpdDate, --UN
					srccode,
					sckcode, --UN
					descode, --UN
					rsncode, --UN
					sdscode, --UN
					inpremark, --UN
					inpsbcnt, --UN
					recvdt, --UN
					nursery, --UN
					codedt, --UN
					complication, --UN
					ACTSTAYLEN,
					amtid
				) VALUES (
					v_inpid,
					v_BedCode,
					o_acmcode,
					v_doccode_a,
					NULL,
					NULL,
					v_srccode,
					NULL,
					NULL,
					NULL,
					NULL,
					v_inpremark,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					v_actstaylen,
					v_amtid1);
			END IF;

			--update SLIP
			v_trackCode := '0026';
			UPDATE slip SET regid = v_regid WHERE slpno = v_slpno;

			--RegPkgLink
			v_trackCode := '0027';
			INSERT INTO RegPkgLink (RPLID, REGID, PkgCode)
			VALUES (SEQ_RegPkgLink.NEXTVAL, v_regid, v_pkgcode1);

			IF v_pkgcodeMultiple = TRUE THEN
				-- insert new pkgcode
				FOR r IN (
					SELECT PkgCode
					FROM   Package
					WHERE  PkgCode IN (
						SELECT REGEXP_SUBSTR(TRIM(v_pkgcode),'[^,]+', 1, LEVEL) FROM DUAL
						CONNECT BY REGEXP_SUBSTR(TRIM(v_pkgcode), '[^,]+', 1, LEVEL) IS NOT NULL
					)
					AND    PkgCode NOT IN (
						SELECT PkgCode FROM RegPkgLink WHERE REGID = v_regid
					)
				) LOOP
					--RegPkgLink
					v_trackCode := '0028';
					INSERT INTO RegPkgLink (RPLID, REGID, PkgCode)
					VALUES (SEQ_RegPkgLink.NEXTVAL, v_regid, r.PkgCode);
				END LOOP;
			END IF;

			IF v_pbpid1 IS NOT NULL AND v_pbpid1 > 0 THEN
				SELECT patfname, patgname, patcname, PatIdNo, PatHTel, PatPager
				INTO v_PatientFName, v_PatientGName, v_PatientCName, v_PatIdNo, v_PatHTel, v_PatPager
				FROM patient WHERE patno = v_patno;

				v_trackCode := '0029';

				UPDATE bedPreBok
				SET patNo = v_patno,
					bpbpname = v_PatientFName || ' ' || v_PatientGName,
					patfname = v_PatientFName,
					patgname = v_PatientGName,
					bpbcname = v_PatientCName,
					PatIdNo = v_PatIdNo,
					PatKHTel = v_PatHTel,
					PatPager = v_PatPager,
					BPBSTS = SCH_CONFIRM
				WHERE pbpId = v_pbpid1;
			END IF;

			v_trackCode := '0030';

			IF i_skipCreateSlp = 1 THEN
				UPDATE Slip
				SET SLPSTS = 'R'
				WHERE SLPNO = v_slpno;
			ELSIF (GET_CURRENT_STECODE = 'HKAH' AND i_usrid <> 'HACCESS') OR (GET_CURRENT_STECODE = 'TWAH' AND v_regtype = REG_TYPE_OUTPATIENT) THEN
				o_errcode := NHS_UTL_AddDefaultItems(v_DOCCODE, v_slpno, v_REGTYPE, o_acmcode, v_BedCode, i_usrid, o_errmsg);
				IF o_errcode < 0 THEN
					o_errcode := 0;
				END IF;
			END IF;

			v_trackCode := '0031';

			IF v_ARCCODE IS NOT NULL AND LENGTH(v_ARCCODE) > 0 THEN
				IF SUBSTR(v_arccode,0,1) = 'G' THEN
					UPDATE GOVREG
					SET REGID = v_regid
					WHERE BKGID = v_bkgid;
				END IF;
			ELSIF GET_CURRENT_STECODE = 'HKAH' AND v_doccode = 'COVID' THEN
				--update slip
				UPDATE SLIP
				SET arccode = 'HACOV'
				WHERE slpno = v_slpno;
			END IF;

			o_errcode := v_slpno;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
			RETURN o_errcode;
		END IF;

	-- MODIFY RECORD
	ELSIF v_action = 'MOD' THEN
		v_regid := v_regid_c;

		IF v_noOfRec > 0 THEN
			IF v_regtype = REG_TYPE_INPATIENT THEN
				v_trackCode := '0032';
				SELECT COUNT(1) INTO v_noOfRec FROM reg WHERE regid = v_regid;
				IF v_noOfRec = 1 THEN
					SELECT DOCCODE INTO v_curr_doccode
					FROM REG WHERE REGID = v_regid;
				ELSE
					IF TRIM(v_regid_c) IS NOT NULL THEN
						SELECT COUNT(1) INTO v_noOfRec FROM REG WHERE REGID = v_regid_c;

						IF v_noOfRec = 1 THEN
							SELECT DOCCODE INTO v_curr_doccode
							FROM REG WHERE REGID = v_regid_c;
						END IF;
					END IF;
				END IF;

				v_trackCode := '0033';
				IF v_inpid IS NOT NULL THEN
					SELECT BedCode, TO_CHAR(InpdDate, 'DD/MM/YYYY HH24:MI:SS')
					INTO v_lBedCode, v_discharge_date
					FROM InPat
					WHERE INPID = v_inpid;
				ELSE
					SELECT BedCode, TO_CHAR(InpdDate, 'DD/MM/YYYY HH24:MI:SS'), InpID
					INTO v_lBedCode, v_discharge_date, v_inpid
					FROM InPat
					WHERE INPID = (SELECT INPID FROM reg WHERE SLPNO = v_extslpno);
				END IF;
			END IF;

			v_trackCode := '0034';
			--update slip
			UPDATE SLIP
			SET doccode = v_doccode,
				arccode = v_arccode,
				slpplyno = v_slpplyno,
				slpvchno = v_slpvchno,
				pcyid = v_pcyid,
				patrefno = v_patrefno,
				arlmtamt = v_arlmtamt1,
				cvredate = v_cvredate1,
				itmtyped = TO_NUMBER(v_itmtyped),
				itmtypeh = TO_NUMBER(v_itmtypeh),
				itmtypes = TO_NUMBER(v_itmtypes),
				itmtypeo = TO_NUMBER(v_itmtypeo),
				furgrtamt = v_furgrtamt1,
				furgrtdate = v_furgrtdate1,
				copaytyp = v_copaytyp,
				COPAYAMT = v_COPAYAMT1,
				COPAYAMTACT = v_deductible,
				printdate = v_printdate,
				slpsid = v_slpsid
			WHERE slpno = v_extslpno;

			-- update AR Card Type is available
			IF TRIM(v_memActID) IS NOT NULL THEN
				v_trackCode := '0035';
				UPDATE slip SET actid = v_memActID
				WHERE slpno = v_extslpno;
			END IF;

			v_trackCode := '0036';
			SELECT regid INTO v_extregid FROM reg WHERE slpno = v_extslpno;

			v_trackCode := '0037';
			SELECT COUNT(1) INTO v_countRegPkgLink FROM RegPkgLink
			WHERE regid = v_extregid;

			v_trackCode := '0038';
			IF v_countRegPkgLink > 0 THEN
				v_trackCode := '0039';
				
				-- delete removed pkgcode
				delete from RegPkgLink
				WHERE  REGID = v_extregid
				AND    PkgCode NOT IN (
						SELECT REGEXP_SUBSTR(TRIM(v_pkgcode),'[^,]+', 1, LEVEL) FROM DUAL
						CONNECT BY REGEXP_SUBSTR(TRIM(v_pkgcode), '[^,]+', 1, LEVEL) IS NOT NULL
				);

				IF v_pkgcodeMultiple = TRUE THEN
					-- insert new pkgcode
					FOR r IN (
						SELECT PkgCode
						FROM   Package
						WHERE  PkgCode IN (
							SELECT REGEXP_SUBSTR(TRIM(v_pkgcode),'[^,]+', 1, LEVEL) FROM DUAL
							CONNECT BY REGEXP_SUBSTR(TRIM(v_pkgcode), '[^,]+', 1, LEVEL) IS NOT NULL
						)
						AND    PkgCode NOT IN (
							SELECT PkgCode FROM RegPkgLink WHERE REGID = v_extregid
						)
					) LOOP
						--RegPkgLink
						v_trackCode := '0040';
						INSERT INTO RegPkgLink (RPLID, REGID, PkgCode)
						VALUES (SEQ_RegPkgLink.NEXTVAL, v_extregid, r.PkgCode);
					END LOOP;
				ELSE
					SELECT MIN(RPLID) INTO v_rplid FROM RegPkgLink
					WHERE regid = v_extregid;

					--update RegPkgLink
					UPDATE RegPkgLink SET pkgcode = v_pkgcode1
					WHERE RPLID = v_rplid AND regid = v_extregid;
				END IF;
			ELSE
				v_trackCode := '0041';
				INSERT INTO RegPkgLink (RPLID, REGID, PkgCode)
				VALUES (SEQ_RegPkgLink.NEXTVAL, v_extregid, v_pkgcode1);
			END IF;

			v_trackCode := '0042';
			--update reg
			UPDATE REG
			SET regdate = v_regdate1,
				regtype = v_regtype,
				doccode = v_doccode,
				pkgcode = v_pkgcode1,
				regnb = v_regnb1,
--				bkgid = v_bkgid1,
				isMainland = v_isMainlandl,
				PRINT_MRRPT = v_PRINT_MRRPT
			WHERE regid = v_extregid;

			UPDATE REG_EXTRA
			SET MODIFY_DATE = SYSDATE,
				MODIFY_USER = i_usrid,
				DOCCODE_REF1 = i_refDoccode1,
				DOCCODE_REF2 = i_refDoccode2,
        RMID = i_docRoom
			WHERE regid = v_extregid;

			--update inpat
			IF v_regtype != REG_TYPE_OUTPATIENT THEN
				v_trackCode := '0043';
				SELECT inpid INTO v_extinp_id FROM reg
				WHERE regid = v_extregid;

				v_trackCode := '0044';
				UPDATE InPat
				SET BedCode = v_BedCode,
					acmcode = o_acmcode,
					doccode_a = v_doccode_a,
					srccode = v_srccode,
					inpremark = v_inpremark,
					amtid = v_amtId1
				WHERE inpid = v_extinp_id;
			END IF;

			IF (v_BE = '-1' AND v_FESTID IS NULL) THEN
				Select Seq_Fest.Nextval Into v_Fid From Dual;
				Insert Into Fin_Est_Hosp
				(Festid, Slpno, Patno, Osb_Be)
				Values (v_Fid,v_extslpno,v_patno,v_BE);
			ELSIF (v_BE IS NOT NULL AND v_FESTID IS NOT NULL) THEN
				SELECT OSB_BE INTO i_BE FROM FIN_EST_HOSP WHERE FESTID = v_FESTID;
				IF ( i_BE IS NOT NULL AND i_BE = '-1' AND v_BE = '0') THEN
					DELETE FROM FIN_EST_HOSP
					WHERE FESTID = v_FESTID;
				ELSE
					v_Fid := v_Festid;
					UPDATE FIN_EST_HOSP SET
							OSB_BE = v_BE,
							Slpno = v_Extslpno,
							Patno = v_Patno
					WHERE FESTID = v_Fid;
				END IF;
			END IF;


			--update extra
			SELECT COUNT(1) INTO v_noOfRec FROM Slip_Extra WHERE slpno = v_extslpno;
			IF v_noOfRec = 0 THEN
				INSERT INTO Slip_Extra (
					slpno,
					slpsno,
					SLPMID,
					SPRQTID,
					ISRECLG,
					ARACMCODE,
					PBPKGCODE,
					ESTGIVN,
					INSPREAUTHNO
				) VALUES (
					v_extslpno,
					v_Sourceno,
					v_misc,
					v_Sprqtid,
					v_ISRECLG,
					v_ARACMCODE,
					v_PBPKGCODE,
					v_ESTGIVEN,
					v_slpauthno
				);
			ELSE
				UPDATE Slip_Extra
				SET
					slpsno       = v_Sourceno,
					SLPMID       = v_misc,
					SPRQTID      = v_Sprqtid,
					ISRECLG      = v_ISRECLG,
					ARACMCODE    = v_ARACMCODE,
					PBPKGCODE    = v_PBPKGCODE,
					ESTGIVN      = v_ESTGIVEN,
					INSPREAUTHNO = v_slpauthno
				WHERE   slpno        = v_extslpno;
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
			RETURN o_errcode;
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			SELECT COUNT(1) INTO v_noOfRec FROM SLIPTX WHERE STNSTS IN ('N', 'A');

			IF v_noOfRec > 0 THEN
				v_trackCode := '0045';
				UPDATE slip SET SLPSTS = 'R' WHERE slpno = v_extslpno;

				v_trackCode := '0046';
				SELECT regid INTO v_extregid FROM reg WHERE slpno = v_extslpno;

				v_trackCode := '0047';
				UPDATE reg SET REGSTS = 'C' WHERE regid = v_extregid;

				v_trackCode := '0048';
				IF v_regtype != REG_TYPE_OUTPATIENT THEN
					v_trackCode := '0049';
					SELECT inpid INTO v_extinp_id FROM reg
					WHERE regid = v_extregid;

					v_trackCode := '0050';
--					DELETE InPat WHERE inpid = v_extinp_id;
				END IF;
			ELSE
				o_errcode := -1;
				o_errmsg := 'Fail to delete due to slip has active detail.';
				RETURN o_errcode;
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
			RETURN o_errcode;
		END IF;
	END IF;

	IF v_action = 'ADD' OR v_action = 'MOD' THEN
		IF v_regtype = REG_TYPE_INPATIENT THEN
			v_trackCode := '0051';
			IF v_actstaylen = 0 OR v_actstaylen IS NULL THEN
				v_trackCode := '0052';
				UPDATE InPat SET ACTSTAYLEN = NULL WHERE InpID = v_inpid;
			ELSE
				UPDATE InPat SET ACTSTAYLEN = v_actstaylen WHERE InpID = v_inpid;
			END IF;

			v_trackCode := '0053';
			IF v_discharge_date IS NULL THEN
				v_trackCode := '0054';
				IF v_lBedCode IS NOT NULL THEN
					v_trackCode := '0055';
					UPDATE bed SET BedSts = BED_STS_FREE
					WHERE BedCode = v_lBedCode;
				END IF;

				v_trackCode := '0056';
				UPDATE bed SET BedSts = BED_STS_OCCUPY
				WHERE BedCode = v_BedCode;

				IF v_action = 'ADD' OR v_doccode <> v_curr_doccode THEN
					v_trackCode := '0057';
					SELECT NVL(max(dhsid), 0) INTO v_max_dhsid FROM dochist WHERE regid = v_regid;
					IF v_max_dhsid > 0 THEN
						v_trackCode := '0058';
						IF NHS_ACT_DOCTORTRANSFER('MOD', v_max_dhsid, v_regid, v_patno, v_doccode, v_regdate, NULL, NULL, o_errmsg) = -1 THEN
							o_errcode := -1;
							o_errmsg := 'update doctor transfer failed';
							RETURN o_errcode;
						END IF;
					ELSE
						v_trackCode := '0059';
						IF NHS_ACT_DOCTORTRANSFER('ADD', NULL, v_regid, v_patno, v_doccode, v_regdate, NULL, NULL, o_errmsg) = -1 THEN
							o_errcode := -1;
							o_errmsg := 'add doctor transfer failed';
							RETURN o_errcode;
						END IF;
					END IF;
				END IF;

				v_trackCode := '0060';
				IF v_action = 'ADD' OR v_BedCode <> v_lBedCode THEN
					v_trackCode := '0061';
					SELECT NVL(max(bhsid), 0) INTO v_max_bhsid FROM bedhist WHERE regid = v_regid;
					IF v_max_bhsid > 0 THEN
						v_trackCode := '0062';
						IF NHS_ACT_BEDTRANSFER('MOD', v_max_bhsid, v_regid, v_patno, v_BedCode, v_regdate, NULL, v_discharge_date, NULL, o_errmsg) = -1 THEN
							o_errcode := -1;
							o_errmsg := 'update bed transfer failed';
							RETURN o_errcode;
						END IF;
					ELSE
						v_trackCode := '0063';
						IF NHS_ACT_BEDTRANSFER('ADD', NULL, v_regid, v_patno, v_BedCode, v_regdate, NULL, v_discharge_date, NULL, o_errmsg) = -1 THEN
							v_trackCode := '0064';
							o_errcode := -1;
							o_errmsg := 'add bed transfer failed';
							RETURN o_errcode;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	IF v_action = 'ADD' THEN
		o_errcode := -1;
		o_errmsg := 'Fail to insert record.';
	END IF;
	o_errmsg := o_errmsg || ' v_trackCode:['||v_trackCode||']['||SQLERRM||']';
	ROLLBACK;

	RETURN o_errcode;
END NHS_ACT_PATIENT_REG;
/
