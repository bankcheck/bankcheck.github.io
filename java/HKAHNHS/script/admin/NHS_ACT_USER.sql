CREATE OR REPLACE FUNCTION "NHS_ACT_USER" (
	v_action  IN VARCHAR2,
	v_USRID   IN VARCHAR2,
	v_USRPWD  IN VARCHAR2,
	v_USRNAME IN VARCHAR2,
	v_USRSTS  IN VARCHAR2,
	v_USRINP  IN VARCHAR2,
	v_USROUT  IN VARCHAR2,
	v_USRDAY  IN VARCHAR2,
	v_USRPBO  IN VARCHAR2,
	v_DPTCODE IN VARCHAR2,
	v_stecode IN VARChAR2,
	v_ISUSING IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	seq_usersiteid NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	SELECT count(1) INTO v_noOfRec FROM USR WHERE USRID = v_USRID;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO Usr (
				USRID,
				USRPWD,
				USRNAME,
				USRSTS,
				USRINP,
				USROUT,
				USRDAY,
				USRPBO,
				DPTCODE,
				ISUSING
			) VALUES (
				v_USRID,
				v_USRPWD,
				v_USRNAME,
				DECODE(v_USRSTS, 'Y', -1, 0),
				DECODE(v_USRINP, 'Y', -1, 0),
				DECODE(v_USROUT, 'Y', -1, 0),
				DECODE(v_USRDAY, 'Y', -1, 0),
				DECODE(v_USRPBO, 'Y', -1, 0),
				v_DPTCODE,
				DECODE(v_ISUSING, 'Y', -1, 0)
			);

			SELECT seq_usersite.NEXTVAL INTO seq_usersiteid FROM dual;
			INSERT INTO UserSite (
				URSID,
				USRID,
				STECODE
			) VALUES (
				seq_usersiteid,
				v_USRID,
				v_stecode
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	USR
			SET
				USRPWD  = v_USRPWD,
				USRNAME = v_USRNAME,
				USRSTS  = DECODE(v_USRSTS, 'Y', -1, 0),
				USRINP  = DECODE(v_USRINP, 'Y', -1, 0),
				USROUT  = DECODE(v_USROUT, 'Y', -1, 0),
				USRDAY  = DECODE(v_USRDAY, 'Y', -1, 0),
				USRPBO  = DECODE(v_USRPBO, 'Y', -1, 0),
				DPTCODE = v_DPTCODE,
				ISUSING = DECODE(v_ISUSING, 'Y', -1, 0)
			WHERE  USRID = v_USRID;
			UPDATE usersite SET STECODE = v_stecode WHERE USRID = v_USRID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE USR WHERE USRID = v_USRID;
			DELETE usersite WHERE USRID = v_USRID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	return o_errcode;
END NHS_ACT_USER;
/
