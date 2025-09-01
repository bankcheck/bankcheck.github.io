CREATE OR REPLACE FUNCTION NHS_ACT_EBIRTHDTL (
	v_action    IN VARCHAR2,
	v_patno     IN VARCHAR2,
	v_patsex    IN VARCHAR2,
	v_patbdate  IN VARCHAR2,
	v_patmother IN VARCHAR2,
	v_patadd1   IN VARCHAR2,
	v_patadd2   IN VARCHAR2,
	v_patadd3   IN VARCHAR2,
	v_loccode   IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	sMFname VARCHAR2(50);
	sMGname VARCHAR2(50);
	sCName VARCHAR2(50);
	sMHKID VARCHAR2(50);
	sMBirth DATE;
	sMO_TEL VARCHAR2(50);
	sMO_SlpNo VARCHAR2(50);
	sM_docCode VARCHAR2(50);
	DstName VARCHAR2(50);
	o_errcode NUMBER;
	iRegid VARCHAR2(22);
	v_noOfRec NUMBER;
	rs_ebirthdtl EBIRTHDTL%ROWTYPE;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
		rs_ebirthdtl.ebirthid := seq_ebirthdtl.NEXTVAL;

		rs_ebirthdtl.bb_patno := v_patno;
		rs_ebirthdtl.bb_sex := v_patsex;

		IF v_patbdate IS NOT NULL THEN
			rs_ebirthdtl.bb_dob := TO_DATE(v_patbdate,'dd/mm/yyyy');
		END IF;

		rs_ebirthdtl.mo_relation := 'M';
		rs_ebirthdtl.bb_birthtype := 1;
		rs_ebirthdtl.mo_patno := v_patmother;

		SELECT COUNT(1) INTO v_noOfRec FROM Patient WHERE patno = v_patmother;
		O_ERRCODE := NHS_ACT_SYSLOG(V_ACTION, 'EBIRTHDTL', 'Fetch', 'MO_PATNO = '||v_patmother, 'SYSUSER', NULL, O_ERRMSG);

		IF v_noOfRec >= 1 THEN
			SELECT patFname,patGname,patCname,patidno,PatBDate,NVL(PatHTel,PATPAGER)
			INTO   sMFname, sMGname, sCName, sMHKID, sMBirth, sMO_TEL
			FROM   Patient
			WHERE  patno = v_patmother;

			IF LENGTH(sMO_TEL) > 15 THEN
				sMO_TEL := SUBSTR(sMO_TEL, 15);
			END IF;
			rs_ebirthdtl.mo_tel := sMO_TEL;

			IF TRIM(sMFname) IS NOT NULL THEN
				rs_ebirthdtl.mo_fname := sMFname;
			END IF;

			IF TRIM(sMGname) IS NOT NULL THEN
				rs_ebirthdtl.mo_gname := sMGname;
			END IF;

			O_ERRCODE := NHS_ACT_SYSLOG(V_ACTION, 'EBIRTHDTL', 'Insert', 'MO_CFNAME = '||sCName, 'SYSUSER', NULL, O_ERRMSG);
			
	  		IF TRIM(sCName) IS NOT NULL THEN
				rs_ebirthdtl.MO_CFNAME := sCName;
	  		END IF;

			IF LENGTH(sMHKID) <= 11 THEN
				IF TRIM(sMHKID) IS NOT NULL THEN
					rs_ebirthdtl.mo_hkic := sMHKID;
				END IF;
				rs_ebirthdtl.mo_hkidholder := 'Y';
				rs_ebirthdtl.mo_traveldoctype := 9;
			END IF;

			IF TRIM(sMBirth) IS NOT NULL THEN
				rs_ebirthdtl.mo_dob := sMBirth;
			END IF;
		END IF;

		SELECT COUNT(1) INTO v_noofrec
		FROM   reg
		WHERE  regsts = 'N'
		AND    inpid IS NOT NULL
		AND    patno = v_patmother
		AND    regtype = 'I';

--		rs_ebirthdtl.mo_slpno := '1';

		IF v_noofrec >= 1 THEN
			SELECT TO_CHAR(MAX(regid)) INTO iRegid
			FROM   reg
			WHERE  regsts = 'N'
			AND    inpid IS NOT NULL
			AND    patno = v_patmother
			AND    regtype = 'I';

--			rs_ebirthdtl.mo_slpno := '2';
			SELECT slpno, doccode INTO smo_slpno, sm_doccode
			FROM   reg
			WHERE  regid = iregid;

			IF LENGTH(sMO_SlpNo) > 0 THEN
				rs_ebirthdtl.mo_slpno := sMO_SlpNo;
			END IF;
		END IF;

		rs_ebirthdtl.recstatus := 'N';
		rs_ebirthdtl.add_bldg := v_patadd1;
		rs_ebirthdtl.add_estate := v_patadd2;
		rs_ebirthdtl.add_street := v_patadd3;

		SELECT COUNT(1) into v_noofrec FROM location, district where location.dstcode = district.dstcode AND loccode =v_loccode;
		IF v_noOfRec >= 1 THEN
			 SELECT DstName into DstName
			 FROM   Location, District
			 WHERE  Location.DstCode = District.DstCode
			 AND    LocCode = v_loccode;

			 rs_ebirthdtl.add_distric := DstName;
		END IF;

		INSERT INTO EBIRTHDTL (
			EBIRTHID,
			BB_PATNO,
			BB_SLPNO,
			BB_GNAME,
			BB_FNAME,
			BB_CFNAME,
			BB_CGNAME,
			BB_NAMETYPE,
			BB_SEX,
			BB_DOB,
			BB_BIRTHTYPE,
			BB_BORNB4ARRIVAL,
			BB_BORNONARRIVAL,
			BB_CORDCUTPLACE,
			BB_CORDCUTPLACEDESC,
			BB_PREVIOUSBIRTH,
			BB_ALIVE,
			SIGNOFFUSER,
			REMARKS,
			MO_RELATION,
			MO_PATNO,
			MO_SLPNO,
			MO_TRAVELDOCNO,
			MO_TRAVELDOCTYPE,
			MO_GNAME,
			MO_FNAME,
			MO_CGNAME,
			MO_CFNAME,
			MO_NAMETYPE,
			MO_DOB,
			MO_TEL,
			MO_HKIDHOLDER,
			MO_RESIDENCE,
			FA_INFOSOURCE,
			MO_EMAIL,
			ATTDOC,
			FA_RELATION,
			FA_PATNO,
			FA_HKIC,
			FA_TRAVELDOCNO,
			FA_TRAVELDOCTYPE,
			FA_GNAME,
			FA_FNAME,
			FA_CGNAME,
			FA_CFNAME,
			FA_NAMETYPE,
			FA_DOB,
			FA_TEL,
			FA_HKIDHOLDER,
			FA_RESIDENCE,
			EMAIL,
			ADD_TYPE,
			ADD_FLAT,
			ADD_FLOOR,
			ADD_BLOCK,
			ADD_HOUSE,
			ADD_LOTPREFIX,
			ADD_LOTNO,
			ADD_BLDG,
			ADD_ESTATE,
			ADD_STREET,
			ADD_DISTRIC,
			ADD_AREA,
			CONFIRMBY,
			COMFIRMDATE,
			RECSTATUS,
			SENDDATE,
			BIRTHRETURNNO,
			BATCHNO,
			REFXMLNO,
			FORCE_SEND,
			FA_BIRTHEXACTFLAG,
			MO_BIRTHEXACTFLAG,
			REL_CASE_REF,
			MO_HKIC,
			BB_BIRTHORDER,
			BB_DOBTIME
		) VALUES (
			rs_ebirthdtl.EBIRTHID,
			rs_ebirthdtl.BB_PATNO,
			rs_ebirthdtl.BB_SLPNO,
			rs_ebirthdtl.BB_GNAME,
			rs_ebirthdtl.BB_FNAME,
			rs_ebirthdtl.BB_CFNAME,
			rs_ebirthdtl.BB_CGNAME,
			rs_ebirthdtl.BB_NAMETYPE,
			rs_ebirthdtl.BB_SEX,
			rs_ebirthdtl.BB_DOB,
			rs_ebirthdtl.BB_BIRTHTYPE,
			rs_ebirthdtl.BB_BORNB4ARRIVAL,
			rs_ebirthdtl.BB_BORNONARRIVAL,
			rs_ebirthdtl.BB_CORDCUTPLACE,
			rs_ebirthdtl.BB_CORDCUTPLACEDESC,
			rs_ebirthdtl.BB_PREVIOUSBIRTH,
			rs_ebirthdtl.BB_ALIVE,
			rs_ebirthdtl.SIGNOFFUSER,
			rs_ebirthdtl.REMARKS,
			rs_ebirthdtl.MO_RELATION,
			rs_ebirthdtl.MO_PATNO,
			rs_ebirthdtl.MO_SLPNO,
			rs_ebirthdtl.MO_TRAVELDOCNO,
			rs_ebirthdtl.MO_TRAVELDOCTYPE,
			rs_ebirthdtl.MO_GNAME,
			rs_ebirthdtl.MO_FNAME,
			rs_ebirthdtl.MO_CGNAME,
			rs_ebirthdtl.MO_CFNAME,
			rs_ebirthdtl.MO_NAMETYPE,
			rs_ebirthdtl.MO_DOB,
			rs_ebirthdtl.MO_TEL,
			rs_ebirthdtl.MO_HKIDHOLDER,
			rs_ebirthdtl.MO_RESIDENCE,
			rs_ebirthdtl.FA_INFOSOURCE,
			rs_ebirthdtl.MO_EMAIL,
			rs_ebirthdtl.ATTDOC,
			rs_ebirthdtl.FA_RELATION,
			rs_ebirthdtl.FA_PATNO,
			rs_ebirthdtl.FA_HKIC,
			rs_ebirthdtl.FA_TRAVELDOCNO,
			rs_ebirthdtl.FA_TRAVELDOCTYPE,
			rs_ebirthdtl.FA_GNAME,
			rs_ebirthdtl.FA_FNAME,
			rs_ebirthdtl.FA_CGNAME,
			rs_ebirthdtl.FA_CFNAME,
			rs_ebirthdtl.FA_NAMETYPE,
			rs_ebirthdtl.FA_DOB,
			rs_ebirthdtl.FA_TEL,
			rs_ebirthdtl.FA_HKIDHOLDER,
			rs_ebirthdtl.FA_RESIDENCE,
			rs_ebirthdtl.EMAIL,
			rs_ebirthdtl.ADD_TYPE,
			rs_ebirthdtl.ADD_FLAT,
			rs_ebirthdtl.ADD_FLOOR,
			rs_ebirthdtl.ADD_BLOCK,
			rs_ebirthdtl.ADD_HOUSE,
			rs_ebirthdtl.ADD_LOTPREFIX,
			rs_ebirthdtl.ADD_LOTNO,
			rs_ebirthdtl.ADD_BLDG,
			rs_ebirthdtl.ADD_ESTATE,
			rs_ebirthdtl.ADD_STREET,
			rs_ebirthdtl.ADD_DISTRIC,
			rs_ebirthdtl.ADD_AREA,
			rs_ebirthdtl.CONFIRMBY,
			rs_ebirthdtl.COMFIRMDATE,
			rs_ebirthdtl.RECSTATUS,
			rs_ebirthdtl.SENDDATE,
			rs_ebirthdtl.BIRTHRETURNNO,
			rs_ebirthdtl.BATCHNO,
			rs_ebirthdtl.REFXMLNO,
			rs_ebirthdtl.FORCE_SEND,
			rs_ebirthdtl.FA_BIRTHEXACTFLAG,
			rs_ebirthdtl.MO_BIRTHEXACTFLAG,
			rs_ebirthdtl.REL_CASE_REF,
			rs_ebirthdtl.MO_HKIC,
			rs_ebirthdtl.BB_BIRTHORDER,
			rs_ebirthdtl.BB_DOBTIME
		);
	ELSE
		o_errcode := -1;
		o_errmsg := 'Parameter error.';
	END IF;

	RETURN o_errcode;
END NHS_ACT_EBIRTHDTL;
/
