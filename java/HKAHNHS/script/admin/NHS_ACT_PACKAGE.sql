CREATE OR REPLACE FUNCTION "NHS_ACT_PACKAGE" (
	v_action   IN VARCHAR2,
	v_PKGCODE  IN PACKAGE.PKGCODE%TYPE,
	v_PKGNAME  IN PACKAGE.PKGNAME%TYPE,
	v_PKGCNAME IN PACKAGE.PKGCNAME%TYPE,
	v_PKGRLVL  IN PACKAGE.PKGRLVL%TYPE,
	v_DPTCODE  IN PACKAGE.DPTCODE%TYPE,
	v_PKGTYPE  IN PACKAGE.PKGTYPE%TYPE,
	v_PKGALERT IN PACKAGE.PKGALERT%TYPE,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM PACKAGE WHERE PKGCODE = v_PKGCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO PACKAGE(
				PKGCODE,
				PKGNAME,
				PKGCNAME,
				PKGRLVL,
				DPTCODE,
				PKGTYPE,
				PKGALERT,
				STECODE
			) VALUES (
				v_PKGCODE,
				v_PKGNAME,
				v_PKGCNAME,
				v_PKGRLVL,
				v_DPTCODE,
				v_PKGTYPE,
				v_PKGALERT,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	PACKAGE
			SET
				PKGNAME = v_PKGNAME,
				PKGCNAME = v_PKGCNAME,
				PKGRLVL = v_PKGRLVL,
				DPTCODE = v_DPTCODE,
				PKGTYPE = v_PKGTYPE,
				PKGALERT = v_PKGALERT
			WHERE PKGCODE = v_PKGCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE PACKAGE WHERE PKGCODE = v_PKGCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_PACKAGE;
/
