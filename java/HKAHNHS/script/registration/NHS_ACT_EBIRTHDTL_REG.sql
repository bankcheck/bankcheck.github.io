create or replace
FUNCTION NHS_ACT_EBIRTHDTL_REG (
	v_action     IN VARCHAR2,
	v_updateType IN VARCHAR2,
	v_patno      IN VARCHAR2,
	v_isMainland IN VARCHAR2,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_EBIRTHID NUMBER;
	v_DHBIRTHID NUMBER;
	v_motherRecord VARCHAR2(10);
	v_regId NUMBER;
	v_BB_SEX VARCHAR2(1);
	v_KHTel VARCHAR2(20);
	v_KOTel VARCHAR2(20);
	v_KMTel VARCHAR2(20);
	v_Remarks VARCHAR2(255);
	v_moSlpNo VARCHAR2(15);
	v_PATFNAME VARCHAR2(20);
	v_PATGNAME VARCHAR2(20);
	v_PATCNAME VARCHAR2(10);
	v_bb_birthday VARCHAR2(10);
	v_MFname VARCHAR2(20);
	v_MGname VARCHAR2(20);
	v_MCname VARCHAR2(10);
	v_MHKID VARCHAR2(20);
	v_MBirth VARCHAR2(10);
	v_MO_TEL VARCHAR2(20);
	v_PBPID NUMBER;
	v_PatAdd1 VARCHAR2(40);
	v_PatAdd2 VARCHAR2(40);
	v_PatAdd3 VARCHAR2(40);
	v_LocCode VARCHAR2(20);
	v_DstName VARCHAR2(50);
	v_weightunit VARCHAR2(255);
	v_fa_patno  VARCHAR2(10);
	v_fa_hkic VARCHAR2(11);
	v_fa_hkidholder VARCHAR2(1);
	v_husfname VARCHAR2(80);
	v_husgname VARCHAR2(40);
	v_fa_cname VARCHAR2(10);
	v_fa_tel VARCHAR2(15);
	v_husdocno VARCHAR2(25);
	v_husdoctype VARCHAR2(1);
	v_fa_dob VARCHAR2(10);
	v_fa_birthexactflag VARCHAR2(1);
	v_fa_infosource VARCHAR2(1);
	v_fa_residence VARCHAR2(40);
	v_regdate DATE;
	v_birthdate DATE;
	vPBPID NUMBER;
	o_errcode NUMBER;
	sqlInsertString VARCHAR2(1000);
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	v_EBIRTHID := seq_ebirthdtl.NEXTVAL;

	SELECT patsex, patmother, TO_CHAR(patbdate,'DD/MM/YYYY'), REPLACE(patadd1, '''', '"'),
			replace(patadd2, '''', '"'), REPLACE(patadd3, '''', '"'), loccode, patbdate
	INTO   v_BB_SEX, v_motherRecord, v_bb_birthday, v_PatAdd1,
			v_PatAdd2, v_PatAdd3, v_LocCode, v_birthdate
	FROM   PATIENT
	WHERE  PATNO = v_patno;

	SELECT patFname, patGname, patidno, TO_CHAR(PatBDate,'DD/MM/YYYY'), NVL(PatHTel,PATPAGER), patCname
	INTO   v_MFname, v_MGname, v_MHKID, v_MBirth, v_MO_TEL, v_MCname
	FROM   Patient
	WHERE  patNo = v_motherRecord;

	SELECT District.DstName
	INTO   v_DstName
	FROM   Location, District
	WHERE  Location.DstCode = District.DstCode
	AND    Location.LocCode = v_LocCode;

	BEGIN
		SELECT MAX(regid) INTO v_regId
		FROM   reg
		WHERE  regsts = 'N'
		AND    inpid IS NOT NULL
		AND    patno = v_motherrecord
		AND    regtype = 'I';
	EXCEPTION
	WHEN OTHERS THEN
		v_regId := NULL;
	END;

	BEGIN
		SELECT slpNo, NVL(PBPID,0) INTO v_moSlpNo, v_PBPID
		FROM   reg
		WHERE  regid = v_regId;
	EXCEPTION
	WHEN OTHERS THEN
		v_moSlpNo := NULL;
		v_PBPID := 0;
	END;

	IF v_PBPID > 0 THEN
		SELECT  b.fa_patno, b.fa_hkic, b.fa_hkidholder,
				b.husfname, b.husgname, b.fa_cname, b.fa_tel,
				b.husdocno, b.husdoctype, TO_CHAR(b.fa_dob,'DD/MM/YYYY'), b.fa_birthexactflag,
				b.fa_infosource, b.fa_residence
		INTO    v_fa_patno, v_fa_hkic, v_fa_hkidholder,
				v_husfname, v_husgname, v_fa_cname, v_fa_tel,
				v_husdocno, v_husdoctype, v_fa_dob, v_fa_birthexactflag,
				v_fa_infosource, v_fa_residence
		FROM    bedprebok b
		WHERE   b.pbpid = v_PBPID;
	END IF;

	SELECT PatKHTel, PatKOTel, PatKMTel
	INTO   v_KHTel, v_KOTel, v_KMTel
	FROM   Patient
	WHERE  patno = v_patno;

	IF TRIM(v_KHTel) IS NOT NULL THEN
		v_Remarks := 'Home:'||v_KHTel;
	END IF;

	IF TRIM(v_KOTel) IS NOT NULL THEN
		IF TRIM(v_Remarks) IS NOT NULL THEN
			v_Remarks := v_Remarks || ', ' || 'Office:' || v_KOTel;
		ELSE
			v_Remarks := 'Home:' || v_KOTel;
		END IF;
	END IF;

	IF TRIM(v_KMTel) IS NOT NULL THEN
		IF TRIM(v_Remarks) IS NOT NULL THEN
			v_Remarks := v_Remarks || ', ' || 'Mobile:' || v_KMTel;
		ELSE
			v_Remarks := 'Mobile:' || v_KMTel;
		END IF;
	END IF;

	IF TRIM(v_Remarks) IS NOT NULL THEN
		v_Remarks := 'CONSENT (Emergency: ' || v_Remarks || ')';
	ELSE
		v_Remarks := 'CONSENT';
	END IF;

	IF v_updateType = 'EBIRTHDTL' THEN
		IF v_action = 'ADD' THEN
			sqlInsertString := NULL;
			sqlInsertString := 'INSERT INTO EBIRTHDTL (EBIRTHID, BB_PATNO,
							BB_SEX, MO_RELATION, BB_BIRTHTYPE, MO_PATNO, RecStatus, Add_Bldg,
							Add_Estate, Add_Street, Add_Distric';

			IF TRIM(v_bb_birthday) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', BB_DOB';
			END IF;

			IF TRIM(v_MO_TEL) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_TEL';
			END IF;

			IF TRIM(v_MFname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_FNAME';
			END IF;

			IF TRIM(v_MGname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_GNAME';
			END IF;

			IF TRIM(v_MCname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_CFNAME';
			END IF;

			IF LENGTH(TRIM(v_MHKID)) <= 11 THEN
				IF TRIM(v_MHKID) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', MO_HKIC';
				END IF;
				sqlInsertString := sqlInsertString || ', MO_HKIDHOLDER';
				sqlInsertString := sqlInsertString || ', MO_TRAVELDOCTYPE';
			END IF;

			IF TRIM(v_MBirth) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_DOB';
			END IF;

			IF TRIM(v_moSlpNo) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MO_SlpNo';
			END IF;

			IF vPBPID > 0 THEN
				IF TRIM(v_fa_patno) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_patno';
				END IF;

				IF TRIM(v_fa_hkic) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_hkic';
				END IF;

				IF TRIM(v_fa_hkidholder) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_hkidholder';
				END IF;

				IF TRIM(v_husfname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', husfname';
				END IF;

				IF TRIM(v_husgname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', husgname';
				END IF;

				IF TRIM(v_fa_cname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_cname';
				END IF;

				IF TRIM(v_fa_tel) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_tel';
				END IF;

				IF TRIM(v_husdocno) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', husdocno';
				END IF;

				IF TRIM(v_husdoctype) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', husdoctype';
				END IF;

				IF TRIM(v_fa_dob) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_dob';
				END IF;

				IF TRIM(v_fa_birthexactflag) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_birthexactflag';
				END IF;

				IF TRIM(v_fa_infosource) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_infosource';
				END IF;

				IF TRIM(v_fa_residence) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', fa_residence';
				END IF;
			END IF;

			IF TRIM(v_Remarks) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', Remarks';
			END IF;

			sqlInsertString := sqlInsertString || ') VALUES ('||v_EBIRTHID||', ''' || v_patno||''', '''||
							v_BB_SEX||''',''M'',1,''' || v_motherRecord||''',''N'', ''' || v_PatAdd1||
							''', ''' || v_PatAdd2||''', ''' || v_PatAdd3||''', ''' || v_DstName || '''';

			IF TRIM(v_bb_birthday) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', TO_DATE(''' || v_bb_birthday || ''', ''DD/MM/YYYY'')';
			END IF;

			IF TRIM(v_MO_TEL) IS NOT NULL THEN
				IF LENGTH(TRIM(v_MO_TEL))>15 THEN
					v_MO_TEL := SUBSTR(TRIM(v_MO_TEL),1,15);
				END IF;
				sqlInsertString := sqlInsertString || ', ''' || v_MO_TEL || '''';
			END IF;

			IF TRIM(v_MFname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', ''' || v_MFname || '''';
			END IF;

			IF TRIM(v_MGname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', ''' || v_MGname || '''';
			END IF;

			IF TRIM(v_MCname) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', ''' || v_MCname || '''';
			END IF;

			IF LENGTH(TRIM(v_MHKID)) <= 11 THEN
				IF TRIM(v_MHKID) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_MHKID || '''';
				END IF;
					sqlInsertString := sqlInsertString || ', ''Y'',9';
				END IF;

				IF TRIM(v_MBirth) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', TO_DATE(''' || v_MBirth|| ''', ''DD/MM/YYYY'')';
				END IF;

				IF TRIM(v_moSlpNo) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_moSlpNo || '''';
			END IF;

			IF vPBPID > 0 THEN
				IF TRIM(v_fa_patno) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_patno || '''';
				END IF;

				IF TRIM(v_fa_hkic) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_hkic || '''';
				END IF;

				IF TRIM(v_fa_hkidholder) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_hkidholder || '''';
				END IF;

				IF TRIM(v_husfname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_husfname || '''';
				END IF;

				IF TRIM(v_husgname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_husgname || '''';
				END IF;

				IF TRIM(v_fa_cname) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_cname || '''';
				END IF;

				IF TRIM(v_fa_tel) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_tel || '''';
				END IF;

				IF TRIM(v_husdocno) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_husdocno || '''';
				END IF;

				IF TRIM(v_husdoctype) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_husdoctype || '''';
				END IF;

				IF TRIM(v_fa_dob) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', TO_DATE(''' || v_fa_dob ||''', ''DD/MM/YYYY'')';
				END IF;

				IF TRIM(v_fa_birthexactflag) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_birthexactflag || '''';
				END IF;

				IF TRIM(v_fa_infosource) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_infosource || '''';
				END IF;

				IF TRIM(v_fa_residence) IS NOT NULL THEN
					sqlInsertString := sqlInsertString || ', ''' || v_fa_residence || '''';
				END IF;
			END IF;

			IF TRIM(v_isMainland) = '1' Then
				sqlInsertString := sqlInsertString || ', ''' || v_Remarks || '''';
	  		ELSE
				sqlInsertString := sqlInsertString || ', ''''';
			END IF;

			sqlInsertString := sqlInsertString || ')';
			
			O_ERRCODE := NHS_ACT_SYSLOG(V_ACTION, 'EBIRTHDTL_REG', 'EBIRTHDTL', sqlInsertString, 'SYSUSER', NULL, O_ERRMSG);
			
			execute immediate sqlInsertString;
			o_errcode := 11;
			o_errmsg := sqlInsertString;
		ELSIF v_action = 'MOD' THEN
			UPDATE ebirthdtl
			SET    Remarks = v_Remarks
			WHERE  bb_patno = v_patno;
		END IF;
	ELSIF v_updateType ='DHBIRTHDTL' THEN
		IF v_action = 'ADD' THEN
			SELECT seq_dhbirthdtl.NEXTVAL
			INTO v_DHBIRTHID
			FROM DUAL;

			sqlInsertString := 'INSERT INTO DHBIRTHDTL (DHBIRTHID, BBPATNO, MOPATNO, RecStatus, BIRTHORDER, childeverbornalive, BBWEIGHUNIT';
			IF TRIM(v_bb_birthday) IS NOT NULL THEN
			sqlInsertString := sqlInsertString || ',DATEOFLASTLIVEBIRTH';
			END IF;

			IF TRIM(v_moSlpNo) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', MOSlpNo';
			END IF;

			BEGIN
				SELECT PARAM1 INTO v_weightunit
				FROM   SYSPARAM
				WHERE  PARCDE = 'weightunit';
			EXCEPTION
			WHEN OTHERS THEN
				v_weightunit := NULL;
			END;

			sqlInsertString := sqlInsertString || ') VALUES ('''||v_DHBIRTHID||''', ''' || v_patno || ''', ''' || v_motherRecord || ''', ''N'', 1, 0, ''' || v_weightunit || '''';

			IF TRIM(v_bb_birthday) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', TO_DATE(''' || v_bb_birthday||''', ''DD/MM/YYYY'')';
			END IF;

			IF TRIM(v_moSlpNo) IS NOT NULL THEN
				sqlInsertString := sqlInsertString || ', ''' || v_moSlpNo || '''';
			END IF;

			sqlInsertString := sqlInsertString || ')';

      		O_ERRCODE := NHS_ACT_SYSLOG(V_ACTION, 'EBIRTHDTL_REG', 'BB PATNO: '||v_patno||', MOTHER SLP: '||v_moSlpNo, sqlInsertString, 'SYSUSER', NULL, O_ERRMSG);
			execute immediate sqlInsertString;
			o_errcode := 2;
			o_errmsg := sqlInsertString;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Parameter error.';
		END IF;
	END IF;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg:= 'EXCEPTION: OTHERS:'||SQLCODE||' -ERROR- '||SQLERRM||'['||o_errmsg||']';
	RETURN o_errcode;
END;
/