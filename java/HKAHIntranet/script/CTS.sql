ALTER TABLE CTS_RECORD DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_RECORD CASCADE CONSTRAINTS;

CREATE TABLE CTS_RECORD
(
	CTS_NO VARCHAR2(10 BYTE) NOT NULL ENABLE,
	DOCCODE VARCHAR2(4 BYTE) NOT NULL ENABLE,
	RECORD_TYPE VARCHAR2(1 BYTE) NOT NULL ENABLE,
	RECORD_STATUS VARCHAR2(1 BYTE) NOT NULL ENABLE,
	LAST_STNCDATE DATE,
	PASSWORD VARCHAR2(10 BYTE) NOT NULL ENABLE,
	INSERT_BY VARCHAR2(30 BYTE) NOT NULL ENABLE,
	INSERT_DATE DATE,
	MODIFIED_DATE DATE,
	INIT_CONTRACT_DATE DATE,
	CORR_ADDR VARCHAR2(200 BYTE),
	HEALTH_STATUS VARCHAR2(500 BYTE),
	FOLDER_ID NUMBER,
	ASSIGN_APPROVER VARCHAR2(4 BYTE),
	HKMC_LICNO VARCHAR2(50 BYTE),
	HKMC_LIC_EXPDATE DATE,
	MICD_INS_CARRIER VARCHAR2(50 BYTE),
	MICD_INS_EXPDATE DATE,
	PRIMARY KEY (CTS_NO)
);

DROP TABLE CTS_RECORD_APPROVER CASCADE CONSTRAINTS;

CREATE TABLE CTS_RECORD_APPROVER
(
	CTS_NO VARCHAR2(10 BYTE) NOT NULL ENABLE,
	RECORD_STATUS VARCHAR2(1 BYTE) NOT NULL ENABLE,
	ASSIGN_APPROVER VARCHAR2(10 BYTE) NOT NULL ENABLE,
	INSERT_DATE DATE DEFAULT SYSDATE,
	MODIFIED_DATE DATE,
	PRIMARY KEY (CTS_NO, ASSIGN_APPROVER)
);

DROP TABLE CTS_RECORD_LOG CASCADE CONSTRAINTS;

CREATE TABLE CTS_RECORD_LOG
(
	CTS_NO VARCHAR2(10 BYTE) NOT NULL ENABLE,
	RECORD_STATUS VARCHAR2(1 BYTE) NOT NULL ENABLE,
	INSERT_BY VARCHAR2(30 BYTE) NOT NULL ENABLE,
	INSERT_DATE DATE
)

DROP SEQUENCE CTS_RECORD_SEQ;

CREATE SEQUENCE CTS_RECORD_SEQ MINVALUE 1 MAXVALUE 999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

DROP SEQUENCE CTS_DOCTOR_SEQ;

CREATE SEQUENCE CTS_DOCTOR_SEQ MINVALUE 1 MAXVALUE 999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

ALTER TABLE CTS_DOCTOR DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_DOCTOR CASCADE CONSTRAINTS;

CREATE TABLE CTS_DOCTOR
(
	DOCCODE VARCHAR2(4 BYTE) NOT NULL ENABLE,
	DOCFNAME VARCHAR2(20 BYTE) NOT NULL ENABLE,
	DOCGNAME VARCHAR2(20 BYTE) NOT NULL ENABLE,
	DOCCNAME VARCHAR2(15 BYTE),
	DOCIDNO VARCHAR2(15 BYTE),
	DOCSEX VARCHAR2(1 BYTE) NOT NULL ENABLE,
	SPCCODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
	DOCSTS NUMBER(22),
	DOCTYPE VARCHAR2(1 BYTE),
	DOCPCT_I NUMBER(3) NOT NULL ENABLE,
	DOCPCT_O NUMBER(3) NOT NULL ENABLE,
	DOCPCT_D NUMBER(3) NOT NULL ENABLE,
	DOCADD1 VARCHAR2(40 BYTE),
	DOCADD2 VARCHAR2(40 BYTE),
	DOCADD3 VARCHAR2(40 BYTE),
	DOCHTEL VARCHAR2(20 BYTE),
	DOCOTEL VARCHAR2(20 BYTE),
	DOCPTEL VARCHAR2(20 BYTE),
	DOCTSLOT NUMBER(22),
	DOCQUALI VARCHAR2(40 BYTE),
	DOCTDATE DATE,
	DOCSDATE DATE,
	DOCHOMADD1 VARCHAR2(40 BYTE),
	DOCHOMADD2 VARCHAR2(40 BYTE),
	DOCHOMADD3 VARCHAR2(40 BYTE),
	DOCOFFADD1 VARCHAR2(40 BYTE),
	DOCOFFADD2 VARCHAR2(40 BYTE),
	DOCOFFADD3 VARCHAR2(40 BYTE),
	DOCCSHOLY NUMBER(22),
	DOCMTEL VARCHAR2(20 BYTE),
	DOCEMAIL VARCHAR2(70 BYTE),
	DOCFAXNO VARCHAR2(20 BYTE),
	DOCHOMADD4 VARCHAR2(40 BYTE),
	DOCADD4 VARCHAR2(40 BYTE),
	DOCOFFADD4 VARCHAR2(40 BYTE),
	DOCPICKLIST NUMBER(1),
	USRID VARCHAR2(10 BYTE),
	DOCQUALIFY NUMBER(1),
	DOCBDATE DATE,
	RPTTO VARCHAR2(1 BYTE),
	ISDOCTOR NUMBER(1),
	TITTLE VARCHAR2(10 BYTE),
	ISOTSURGEON NUMBER(1)DEFAULT 0,
	ISOTANESTHETIST NUMBER(1),
	SHOWPROFILE NUMBER(1),
	DAYINSTRUCTION VARCHAR2(200 BYTE),
	INPINSTRUCTION VARCHAR2(200 BYTE),
	OUPINSTRUCTION VARCHAR2(200 BYTE),
	PAYINSTRUCTION VARCHAR2(200 BYTE),
	BRNO VARCHAR2(30 BYTE),
	DOCREMARK VARCHAR2(75 BYTE),
	CPSDATE DATE,
	APLDATE DATE,
	MPSCDATE DATE,
	SLDATE DATE,
	ISOTENDOSCOPIST NUMBER(1),
	DOCID NUMBER,
	PRIMARY KEY (DOCCODE)
);

ALTER TABLE DOCCODE_MAP DROP PRIMARY KEY CASCADE;

DROP TABLE DOCCODE_MAP CASCADE CONSTRAINTS;

CREATE TABLE DOCCODE_MAP
(
	DOCCODE VARCHAR2(4 BYTE) NOT NULL ENABLE,
	SUB_DOCCODE VARCHAR2(4 BYTE) NOT NULL ENABLE,
	PRIMARY KEY (DOCCODE,SUB_DOCCODE)
);

ALTER TABLE CTS_FORM DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_FORM CASCADE CONSTRAINTS;

CREATE TABLE CTS_FORM
(
	FORMID VARCHAR2(10 BYTE) NOT NULL ENABLE,
	FORMDESC VARCHAR2(200 BYTE),
	ENABLED NUMBER(1) DEFAULT 0,
	PRIMARY KEY (FORMID)
);

INSERT INTO CTS_FORM (FORMID, FORMDESC, ENABLED) VALUES ('F0001','MEDICAL/DENTAL STAFF PRIVILEGE RENEWAL',1);

ALTER TABLE CTS_FORM_DATA DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_FORM_DATA CASCADE CONSTRAINTS;

CREATE TABLE CTS_FORM_DATA
(
	CTS_NO VARCHAR2(10 BYTE) NOT NULL ENABLE,
	FORMID VARCHAR2(10 BYTE) NOT NULL ENABLE,
	FIELDID VARCHAR2(10 BYTE) NOT NULL ENABLE,
	FIELD_VALUE  VARCHAR2(1000 BYTE),
	PRIMARY KEY (FORMID,FIELDID)
);


ALTER TABLE CTS_QUESTION_DETAIL DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_QUESTION_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE CTS_QUESTION_DETAIL
(
	CTS_NO VARCHAR2(10 BYTE) NOT NULL ENABLE,
	QUESTID VARCHAR2(50 BYTE) NOT NULL ENABLE,
	ANSWER VARCHAR2(10 BYTE),
	SUPPORT_DETAIL VARCHAR2(500 BYTE),
	PRIMARY KEY (CTS_NO,QUESTID)
);

ALTER TABLE CTS_QUESTION DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_QUESTION CASCADE CONSTRAINTS;

CREATE TABLE CTS_QUESTION
(
	FORMID VARCHAR2(10 BYTE) NOT NULL ENABLE,
	QUESTID VARCHAR2(50 BYTE) NOT NULL ENABLE,
	QUESTSEQ NUMBER,
	QUESTDESC VARCHAR2(500 BYTE),
	ENABLED NUMBER(1) DEFAULT 1,
	DEFAULT_VAL VARCHAR2(1 BYTE),
	PRIMARY KEY (FORMID,QUESTID)
);

INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0001',1,'A. Are you still on the specialist list of the Medical Council of Hong Kong?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0002',2,'B. Are you covered by malpractice insurance?(Please attach a copy)',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0003',3,'C. Since your last application, have you been convicted by the Medical/Dental Council of Hong Kong?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0004',4,'D. Has your licence to practice medicine/dentistry in any jurisdiction ever been limited, suspended or revoked?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0005',5,'E. Have you ever been refused membership on a hospital medical/dental staff?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0006',6,'F. Have your privileges at any hospital ever been suspended, diminished, revoked or not renewed?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0007',7,'G. Have you ever been denied membership or renewal thereof, or been subject to disciplinary action in any medical/dental organization?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0008',8,'H. Have you been convicted of any criminal offense?',1);
INSERT INTO CTS_QUESTION (FORMID, QUESTID, QUESTSEQ, QUESTDESC, ENABLED) VALUES ('F0001','Q0009',9,'I. Have you been involved with any medical or dental litigation in which an award has been made against you?',1);


ALTER TABLE CTS_DOC_APPROVER DROP PRIMARY KEY CASCADE;

DROP TABLE CTS_DOC_APPROVER CASCADE CONSTRAINTS;

CREATE TABLE CTS_DOC_APPROVER
(
	DOCCODE VARCHAR2(4 BYTE) NOT NULL ENABLE,
	ENABLED NUMBER(1) DEFAULT 0,
	EXPIRED_DATE DATE
);

DROP FUNCTION f_cts_password ;

CREATE OR REPLACE FUNCTION f_cts_password (
as_docCode varchar2,
ai_ctsRecordSeq varchar2)
RETURN varchar2
IS
ls_pwd varchar2(100);
ls_docCode varchar2(100);
li_len number;

BEGIN
	li_len := LENGTH(as_docCode);
  ls_docCode := SUBSTR(as_docCode,2,li_len-1);

	FOR i IN REVERSE 1..li_len
	LOOP
		IF i = 2 THEN
			IF SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2) >= 65 THEN
				ls_pwd := ls_pwd||UPPER(CHR(SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2)));
			ELSE
				ls_pwd := ls_pwd||TO_CHAR(MOD(SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2),7));
         DBMS_OUTPUT.PUT_LINE('ls_pwd = ' || ls_pwd);
			END IF;
		ELSE
			ls_pwd := ls_pwd||MOD(SUBSTR(ls_docCode, i-1, 1), 7);
		END IF;
	END LOOP;
	RETURN ls_pwd;
EXCEPTION
WHEN OTHERS THEN
      raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
      RETURN NULL;
END f_cts_password;


create or replace
PROCEDURE proc_cts_record
AS
ls_ctsNo varchar2(10);
ls_docCode varchar2(4);
li_ctsRecordSeq number := 0;
ls_recordType varchar2(1);
ls_recordStatus varchar2(1);
ld_docTDate date;
ld_lastStnCDate date;
ls_trackNo varchar2(10);

CURSOR c_getRenewal IS
SELECT d.doccode,d.doctdate,s.stncdate
FROM doctor@iweb d,
(SELECT doccode,max(stncdate) stncdate
FROM sliptx@iweb
GROUP BY doccode)s
WHERE d.doccode = s.doccode(+)
AND TRUNC(d.doctdate,'dd') BETWEEN TRUNC(sysdate,'dd') AND TRUNC(ADD_MONTHS(sysdate,3),'dd')
AND s.stncdate IS NOT NULL
AND TRUNC(s.stncdate,'dd') BETWEEN TRUNC(ADD_MONTHS(sysdate,-33),'dd') AND TRUNC(sysdate,'dd')
AND d.docsts = -1
AND NOT EXISTS (
	SELECT 1 FROM cts_record cr
	WHERE cr.doccode = d.doccode
	AND cr.record_status IN ('S','X','Y','Z','R','F','V','A','J'))
ORDER BY 2,1;

CURSOR c_getInactive IS
SELECT d.doccode,d.doctdate,s.stncdate
FROM doctor@iweb d,
(SELECT doccode,MAX(stncdate) stncdate
	FROM sliptx@iweb
	GROUP BY doccode)s
WHERE d.doccode = s.doccode(+)
AND TRUNC(doctdate,'dd') <= TRUNC(sysdate,'dd')
AND d.docsts = -1
AND (s.stncdate IS NULL
		OR TRUNC(s.stncdate,'dd') < TO_CHAR(ADD_MONTHS(sysdate,-36),'dd'))
AND NOT EXISTS (
	SELECT 1 FROM cts_record cr
	WHERE cr.doccode = d.doccode
	AND cr.record_status = 'A')
ORDER BY 2,1;

BEGIN
	OPEN c_getRenewal;
	LOOP
		FETCH c_getRenewal INTO ls_docCode,ld_docTDate,ld_lastStnCDate;
		EXIT WHEN c_getRenewal%NOTFOUND;

		SELECT cts_record_seq.nextval
		INTO li_ctsRecordSeq
		FROM dual;

		ls_ctsNo := 'R'||SUBSTR('0000000000'||li_ctsRecordSeq,-9,10);

		insert into cts_record (
		cts_no,
		doccode,
		record_type,
		record_status,
		last_stncdate,
		password,
		insert_date) VALUES (
		ls_ctsNo,
		ls_docCode,
		'R',
		'S',
		ld_lastStnCDate,
		f_cts_password (ls_docCode,li_ctsRecordSeq),
		sysdate
		);

	END LOOP;
	CLOSE c_getRenewal;

	li_ctsRecordSeq := 0;

	OPEN c_getInactive;
	LOOP
		FETCH c_getInactive INTO ls_docCode,ld_docTDate,ld_lastStnCDate;
		EXIT WHEN c_getInactive%NOTFOUND;

		SELECT cts_record_seq.nextval
		INTO li_ctsRecordSeq
		FROM dual;

		ls_ctsNo := 'D'||SUBSTR('0000000000'||li_ctsRecordSeq,-9,10);

		insert into cts_record (
		cts_no,
		doccode,
		record_type,
		record_status,
		last_stncdate,
		password,
		insert_date) VALUES (
		ls_ctsNo,
		ls_docCode,
		'D',
		'S',
		ld_lastStnCDate,
		f_cts_password (ls_docCode,li_ctsRecordSeq),
		sysdate
		);

	END LOOP;
	CLOSE c_getInactive;

	COMMIT;

EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
END;


create or replace
Procedure proc_get_inactive_list
AS
	ls_docCode varchar(4);
	ldt_lasttxDate date;
	ls_ctsNo varchar(10);
  li_countInAct number;
  ldt_doctDate date;
  ldt_tDate36 date;

	CURSOR c_renewdoc IS
	SELECT
	doccode,trunc(doctdate,'dd')
	FROM
	doctor@iweb
	WHERE trunc(sysdate, 'dd') = trunc(doctdate,'dd')
	AND docsts = -1
	;
BEGIN
	OPEN c_renewdoc;
	LOOP
	FETCH c_renewdoc INTO ls_docCode,ldt_doctDate;
	EXIT WHEN c_renewdoc%NOTFOUND;

--  THE DATE BEFORE 36MTH OF TERMINATION DATE
    ldt_tDate36 := add_months(ldt_doctDate, -36);

		SELECT
		COUNT(doccode)
		INTO li_countInAct
		FROM sliptx@iweb
		WHERE doccode = ls_docCode
		AND stnsts = 'N'
    AND stntype = 'D'
    AND trunc(stntdate,'dd') BETWEEN ldt_tDate36 AND ldt_doctDate
		;

		IF li_countInAct = 0 THEN
			SELECT
			'D'||substr('0000000000'||to_char(cts_record_seq.nextval),-9,9)
			INTO ls_ctsNo
			FROM dual;

			INSERT INTO cts_record (
			cts_no,
			doccode,
			record_type,
			record_status,
			last_stncdate,
			password,
			insert_by,
			insert_date,
			modified_date,
			init_contract_date,
			corr_addr,
			health_status,
      folder_id) VALUES (
			ls_ctsNo,
			ls_docCode,
			'D',
			'S',
			ldt_lasttxDate,
			f_cts_password(ls_docCode,ls_ctsNo),
			'SYSTEM',
			sysdate,
			NULL,
			NULL,
			(SELECT docadd1||' '||docadd2||' '||docadd3||' '||docadd4 FROM doctor@iweb WHERE doccode = ls_docCode),
			NULL,
      cts_doctor_seq.nextval)
			;

      DELETE FROM cts_doctor
      WHERE doccode = ls_docCode;

			INSERT INTO cts_doctor VALUE
			SELECT
			doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
			docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
			doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
			doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
			docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
			dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
			cpsdate,apldate,mpscdate,sldate,isotendoscopist,
			cts_doctor_seq.nextval
			FROM (
			SELECT
			doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
			docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
			doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
			doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
			docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
			dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
			cpsdate,apldate,mpscdate,sldate,isotendoscopist
			FROM doctor@iweb
			WHERE doccode = ls_docCode);

      INSERT INTO CTS_RECORD_LOG (
      CTS_NO,
      RECORD_STATUS,
      INSERT_BY,
      INSERT_DATE)
      VALUES (
      ls_ctsNo,
      'S',
      'SYSTEM',
      sysdate);

		END IF;
	END LOOP;

	COMMIT;

	CLOSE c_renewdoc;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;


create or replace
Procedure proc_get_renew_list
AS
	ls_docCode cts_doctor.doccode%TYPE;
	ls_ctsNo cts_record.cts_no%TYPE;

	CURSOR c_reNewList IS
	SELECT D.DOCCODE
	FROM DOCTOR@IWEB D
	WHERE TRUNC(DOCTDATE,'DD') = TRUNC(ADD_MONTHS(SYSDATE,3),'DD')
  AND D.DOCSTS = -1
	AND EXISTS (
	SELECT 1 FROM SLIPTX@IWEB S
	WHERE S.DOCCODE = D.DOCCODE
	);
BEGIN
	SELECT
	'R'||SUBSTR('00000000'||CTS_RECORD_SEQ.NEXTVAL,-9,10)
	INTO ls_ctsNo
	FROM
	DUAL;

	OPEN c_reNewList;
	LOOP
	FETCH c_reNewList INTO ls_docCode;

	EXIT WHEN c_reNewList%NOTFOUND;

	INSERT INTO CTS_RECORD (
	CTS_NO,
	DOCCODE,
	RECORD_TYPE,
	RECORD_STATUS,
	LAST_STNCDATE,
	PASSWORD,
	INSERT_BY,
	INSERT_DATE,
	MODIFIED_DATE,
	INIT_CONTRACT_DATE,
	CORR_ADDR,
	HEALTH_STATUS) VALUES (
	ls_ctsNo,
	ls_docCode,
	'R',
	'S',
	NULL,
	f_cts_password(ls_docCode,ls_ctsNo),
	'SYSTEM',
	SYSDATE,
	SYSDATE,
	NULL,
	NULL,
	NULL);

	INSERT INTO CTS_RECORD_LOG (
	CTS_NO, RECORD_STATUS, INSERT_BY, INSERT_DATE)
	VALUES (
	ls_ctsNo,
	'R',
	'SYSTEM',
	SYSDATE);
	END LOOP;

	CLOSE c_reNewList;
COMMIT;

EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;


create or replace
Procedure proc_getRenewDocList
AS
	ls_docCode varchar(4);
	ldt_lasttxDate date;
	ls_ctsNo varchar(10);
  li_exist number;
  ldt_doctDate date;
  ldt_tDate36 date;

	CURSOR c_renewdoc IS
	SELECT
	doccode,trunc(doctdate,'dd')
	FROM
	doctor@iweb
	WHERE trunc(sysdate, 'dd') = trunc(add_months(doctdate,-3),'dd')
	AND docsts = -1
	;
BEGIN
	OPEN c_renewdoc;
	LOOP
	FETCH c_renewdoc INTO ls_docCode,ldt_doctDate;
	EXIT WHEN c_renewdoc%NOTFOUND;

dbms_output.put_line('[doccode]:'||ls_docCode||'[ldt_doctDate]:'||TO_CHAR(ldt_doctDate,'YYYYMMDD'));

--  THE DATE BEFORE 36MTH OF TERMINATION DATE
    ldt_tDate36 := add_months(ldt_doctDate, -36);

		SELECT
		MAX(stntdate)
		INTO ldt_lasttxDate
		FROM sliptx@iweb
		WHERE doccode = ls_docCode
		AND stnsts = 'N'
    AND stntype = 'D'
    AND trunc(stntdate,'dd') BETWEEN ldt_tDate36 AND ldt_doctDate
		;

		li_exist := 0;

		SELECT count(cts_no)
		INTO li_exist
		FROM cts_record
		WHERE doccode = ls_docCode
		AND last_stncdate = ldt_lasttxDate
		AND record_type = 'R'
		;

dbms_output.put_line('[li_exist]:'||TO_CHAR(li_exist)||'[ldt_lasttxDate]'||TO_CHAR(ldt_lasttxDate,'YYYYMMDD'));

		IF li_exist = 0 AND ldt_lasttxDate IS NOT NULL THEN
			SELECT
			'R'||substr('0000000000'||to_char(cts_record_seq.nextval),-9,9)
			INTO ls_ctsNo
			FROM dual;

dbms_output.put_line('[ls_ctsNo]:'||ls_ctsNo);

			INSERT INTO cts_record (
			cts_no,
			doccode,
			record_type,
			record_status,
			last_stncdate,
			password,
			insert_by,
			insert_date,
			modified_date,
			init_contract_date,
			corr_addr,
			health_status,
      folder_id) VALUES (
			ls_ctsNo,
			ls_docCode,
			'R',
			'S',
			ldt_lasttxDate,
			f_cts_password(ls_docCode,ls_ctsNo),
			'SYSTEM',
			sysdate,
			NULL,
			NULL,
			(SELECT docadd1||' '||docadd2||' '||docadd3||' '||docadd4 FROM doctor@iweb WHERE doccode = ls_docCode),
			NULL,
      cts_doctor_seq.nextval)
			;

      DELETE FROM cts_doctor
      WHERE doccode = ls_docCode;

			INSERT INTO cts_doctor VALUE
			SELECT
			doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
			docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
			doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
			doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
			docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
			dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
			cpsdate,apldate,mpscdate,sldate,isotendoscopist,
			cts_doctor_seq.nextval
			FROM (
			SELECT
			doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
			docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
			doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
			doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
			docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
			dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
			cpsdate,apldate,mpscdate,sldate,isotendoscopist
			FROM doctor@iweb
			WHERE doccode = ls_docCode);

      INSERT INTO CTS_RECORD_LOG (
      CTS_NO,
      RECORD_STATUS,
      INSERT_BY,
      INSERT_DATE)
      VALUES (
      ls_ctsNo,
      'S',
      'SYSTEM',
      sysdate);

		END IF;
	END LOOP;

	COMMIT;

	CLOSE c_renewdoc;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;

create or replace
PROCEDURE PROC_GETRENEWDOCLISTMISS AS
	ls_docCode varchar(4);
	ls_ctsNo varchar(10);
	ldt_doctDate date;

	CURSOR c_renewdoc IS
	SELECT
	doc.doccode,trunc(doc.doctdate,'dd')
	FROM
	doctor@iweb doc
	WHERE trunc(sysdate,'dd') BETWEEN trunc(add_months(doctdate,-3),'dd') AND trunc(doc.doctdate, 'dd')
	AND doc.docsts = -1
	AND EXISTS (
	SELECT 1
	FROM
	sliptx@iweb sptx
	WHERE sptx.doccode = doc.doccode
	AND trunc(sptx.stntdate,'dd') = trunc(sysdate, 'dd'))
	AND NOT EXISTS (
	SELECT 1
	FROM
	cts_doctor ctsdoc
	WHERE doc.doccode = ctsdoc.doccode
	AND doc.doctdate = ctsdoc.doctdate)
	;

BEGIN
	OPEN c_renewdoc;
	LOOP
	FETCH c_renewdoc INTO ls_docCode,ldt_doctDate;
	EXIT WHEN c_renewdoc%NOTFOUND;

	SELECT
	'R'||substr('0000000000'||to_char(cts_record_seq.nextval),-9,9)
	INTO ls_ctsNo
	FROM dual;

	INSERT INTO cts_record (
	cts_no,
	doccode,
	record_type,
	record_status,
	last_stncdate,
	password,
	insert_by,
	insert_date,
	modified_date,
	init_contract_date,
	corr_addr,
	health_status,
	folder_id) VALUES (
	ls_ctsNo,
	ls_docCode,
	'R',
	'S',
	trunc(sysdate,'dd'),
	f_cts_password(ls_docCode,ls_ctsNo),
	'SYSTEM',
	sysdate,
	NULL,
	NULL,
	(SELECT docadd1||' '||docadd2||' '||docadd3||' '||docadd4 FROM doctor@iweb WHERE doccode = ls_docCode),
	NULL,
	cts_doctor_seq.nextval)
	;

	DELETE FROM cts_doctor
	WHERE doccode = ls_docCode;

	INSERT INTO cts_doctor VALUE
	SELECT
	doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
	docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
	doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
	doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
	docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
	dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
	cpsdate,apldate,mpscdate,sldate,isotendoscopist,
	cts_doctor_seq.nextval
	FROM (
	SELECT
	doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,
	docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,
	doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,
	doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,
	docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,
	dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,
	cpsdate,apldate,mpscdate,sldate,isotendoscopist
	FROM doctor@iweb
	WHERE doccode = ls_docCode);

	INSERT INTO CTS_RECORD_LOG (
	CTS_NO,
	RECORD_STATUS,
	INSERT_BY,
	INSERT_DATE)
	VALUES (
	ls_ctsNo,
	'S',
	'SYSTEM',
	sysdate);

	END LOOP;

	COMMIT;

	CLOSE c_renewdoc;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END PROC_GETRENEWDOCLISTMISS;


CREATE OR REPLACE PROCEDURE scheduled_job
AS
  ll_job NUMBER;
BEGIN
  dbms_job.submit(
    ll_job,
    'proc_get_renew_list();',
    SYSDATE,
    'TRUNC(SYSDATE,''DD'')  + 1 + 1/24'
  );
  dbms_output.put_line(TO_CHAR(ll_job)||' proc_get_renew_list');

  dbms_job.submit(
    ll_job,
    'proc_get_inactive_list();',
    SYSDATE,
    'TRUNC(SYSDATE,''DD'')  + 1 + 1/24 + 2/1440'
  );
  dbms_output.put_line(TO_CHAR(ll_job)||' proc_get_inactive_list');

  dbms_job.submit(
    ll_job,
    'proc_getrenewdoclistmiss();',
    SYSDATE,
    'TRUNC(SYSDATE,''DD'')  + 1 + 1/24 + 4/1440'
  );
  dbms_output.put_line(TO_CHAR(ll_job)||' proc_getrenewdoclistmiss');

END scheduled_job;






