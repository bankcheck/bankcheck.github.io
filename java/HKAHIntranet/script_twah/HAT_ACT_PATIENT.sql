/*
SET SERVEROUTPUT ON
DECLARE o_errmsg	VARCHAR2(20);
BEGIN
	dbms_output.put_line (HAT_ACT_PATIENT('ADD','','A1234567','','MRS','','','M','','CHINESE','31/07/2009','CTE','M','','CA','','I T DIRECTOR','','','','','','','','94322282','28906334','','','','','','','test test','','','WIFE','','','',o_errmsg));
END;
*/
CREATE OR REPLACE FUNCTION "HAT_ACT_PATIENT"
(
	v_action			IN VARCHAR2,
	v_PATNO				IN VARCHAR2,
	v_PATIDNO			IN VARCHAR2,
	v_PATFNAME		IN VARCHAR2,
	v_TITDESC			IN VARCHAR2,
	v_PATGNAME		IN VARCHAR2,
	v_PATCNAME		IN VARCHAR2,
	v_PATMSTS			IN VARCHAR2,
	v_PATMNAME		IN VARCHAR2,
	v_RACDESC			IN VARCHAR2,
	v_PATBDATE		IN VARCHAR2,
	v_MOTHCODE		IN VARCHAR2,
	v_PATSEX			IN VARCHAR2,
	v_EDULEVEL		IN VARCHAR2,
	v_RELIGIOUS		IN VARCHAR2,
	v_DEATH				IN VARCHAR2,
	v_OCCUPATION	IN VARCHAR2,
	v_PATMOTHER	 	IN VARCHAR2,
	v_PATNB				IN VARCHAR2,
	v_PATSTS			IN VARCHAR2,
	v_PATITP			IN VARCHAR2,
	v_PATSTAFF		IN VARCHAR2,
	v_PATEMAIL IN VARCHAR2,
	v_PATHTEL			IN VARCHAR2,
	v_PATOTEL			IN VARCHAR2,
	v_PATPAGER		IN VARCHAR2,
	v_PATFAXNO		IN VARCHAR2,
	v_PATADD1			IN VARCHAR2,
	v_PATADD2			IN VARCHAR2,
	v_PATADD3			IN VARCHAR2,
	v_LOCCODE			IN VARCHAR2,
	v_COUCODE			IN VARCHAR2,
	v_PATRMK			IN VARCHAR2,
	v_PATKNAME		IN VARCHAR2,
	v_PATKHTEL		IN VARCHAR2,
	v_PATKPTEL		IN VARCHAR2,
	v_PATKRELA		IN VARCHAR2,
	v_PATKOTEL		IN VARCHAR2,
	v_PATKMTEL		IN VARCHAR2,
	v_PATKADD			IN VARCHAR2,
	o_errmsg			OUT VARCHAR2
)
	 RETURN NUMBER
AS
	v_noOfRec		NUMBER;
--	v_noOfRec1	NUMBER;
	o_errcode		NUMBER;
	v_PATNO1		NUMBER;
	v_PATBDATE1 DATE;
	v_DEATH1		DATE;
	susrid			VARCHAR2(20);
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
--	susrid := get_current_usrid;
	susrid := 'IWEB';
	if trim(v_PATBDATE) = '' then
		v_PATBDATE1 := null;
	else
		v_PATBDATE1 := to_date(v_PATBDATE,'dd/MM/yyyy');
	end if;
	if trim(v_DEATH) = '' then
		v_DEATH1 := null;
	else
		v_DEATH1 := to_date(v_DEATH,'dd/MM/yyyy');
	end if;

	SELECT count(1) INTO v_noOfRec FROM PATIENT@IWEB WHERE PATNO = v_PATNO;
	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			v_PATNO1 := 0;
			WHILE v_PATNO1 = 0 loop
				v_PATNO1 := HAT_GET_NEXT_PATNO;
				SELECT COUNT(1) INTO v_noOfRec FROM PATIENT@IWEB WHERE PATNO = TO_CHAR(v_PATNO1);
				IF v_noOfRec > 0 THEN
					v_PATNO1 := 0;
				END IF;
			END LOOP;
			INSERT INTO PATIENT@IWEB(
				PATNO,
				PATIDNO,
				PATFNAME,
				PATGNAME,
				PATCNAME,
				PATMNAME,
				PATFNAMESDX,
				PATGNAMESDX,
				PATMNAMESDX,
				TITDESC,
				PATMSTS,
				PATBDATE,
				RACDESC,
				MOTHCODE,
				PATSEX,
				EDULEVEL,
				RELIGIOUS,
				DEATH,
				OCCUPATION,
				PATMOTHER,
				PATNB,
				PATSTS,
				PATITP,
				PATSTAFF,
				PATEMAIL,
				PATHTEL,
				PATOTEL,
				PATPAGER,
				PATFAXNO,
				PATADD1,
				PATADD2,
				PATADD3,
				LOCCODE,
				COUCODE,
				PATKNAME,
				PATKRELA,
				PATKHTEL,
				PATKOTEL,
				PATKPTEL,
				PATKMTEL,
				PATKADD,
				PATRMK,
				STECODE,
				LASTUPD,
				PATVCNT,
				PATRDATE,
				USRID
			) VALUES (
				v_PATNO1,
				v_PATIDNO,
				v_PATFNAME,
				v_PATGNAME,
				v_PATCNAME,
				v_PATMNAME,
				soundex(v_PATFNAME),
				soundex(v_PATGNAME),
				soundex(v_PATMNAME),
				v_TITDESC,
				v_PATMSTS,
				v_PATBDATE1,
				v_RACDESC,
				v_MOTHCODE,
				v_PATSEX,
				v_EDULEVEL,
				v_RELIGIOUS,
				v_DEATH1,
				v_OCCUPATION,
				v_PATMOTHER,
				to_number(v_PATNB),
				to_number(v_PATSTS),
				to_number(v_PATITP),
				to_number(v_PATSTAFF),
				v_PATEMAIL,
				v_PATHTEL,
				v_PATOTEL,
				v_PATPAGER,
				v_PATFAXNO,
				v_PATADD1,
				v_PATADD2,
				v_PATADD3,
				v_LOCCODE,
				v_COUCODE,
				v_PATKNAME,
				v_PATKRELA,
				v_PATKHTEL,
				v_PATKOTEL,
				v_PATKPTEL,
				v_PATKMTEL,
				v_PATKADD,
				v_PATRMK,
				'HKAH',
				sysdate,
				0,
				to_date(to_char(sysdate, 'dd/MM/yyyy'), 'dd/MM/yyyy'),
				susrid
			);
			o_errcode := v_PATNO1;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	PATIENT@IWEB
			SET
				PATIDNO = v_PATIDNO,
				PATFNAME = v_PATFNAME,
				PATGNAME = v_PATGNAME,
				PATCNAME = v_PATCNAME,
				PATMNAME = v_PATMNAME,
				PATFNAMESDX = soundex(v_PATFNAME),
				PATGNAMESDX = soundex(v_PATGNAME),
				PATMNAMESDX = soundex(v_PATMNAME),
				TITDESC = v_TITDESC,
				PATMSTS = v_PATMSTS,
				PATBDATE = v_PATBDATE1,
				RACDESC = v_RACDESC,
				MOTHCODE = v_MOTHCODE,
				PATSEX = v_PATSEX,
				EDULEVEL = v_EDULEVEL,
				RELIGIOUS = v_RELIGIOUS,
				DEATH = v_DEATH1,
				OCCUPATION = v_OCCUPATION,
				PATMOTHER = v_PATMOTHER,
				PATNB = to_number(v_PATNB),
				PATSTS = to_number(v_PATSTS),
				PATITP = to_number(v_PATITP),
				PATSTAFF = to_number(v_PATSTAFF),
				PATEMAIL = v_PATEMAIL,
				PATHTEL = v_PATHTEL,
				PATOTEL = v_PATOTEL,
				PATPAGER = v_PATPAGER,
				PATFAXNO = v_PATFAXNO,
				PATADD1 = v_PATADD1,
				PATADD2 = v_PATADD2,
				PATADD3 = v_PATADD3,
				LOCCODE = v_LOCCODE,
				COUCODE = v_COUCODE,
				PATKNAME = v_PATKNAME,
				PATKRELA = v_PATKRELA,
				PATKHTEL = v_PATKHTEL,
				PATKOTEL = v_PATKOTEL,
				PATKPTEL = v_PATKPTEL,
				PATKMTEL = v_PATKMTEL,
				PATKADD = v_PATKADD,
				PATRMK = v_PATRMK,
				STECODE = 'HKAH',
				LASTUPD = sysdate
			WHERE	PATNO = v_PATNO;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE PATIENT@IWEB WHERE PATNO = v_PATNO;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	COMMIT;
	RETURN o_errcode;
END HAT_ACT_PATIENT;

/