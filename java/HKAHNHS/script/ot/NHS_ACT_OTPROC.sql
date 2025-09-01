CREATE OR REPLACE FUNCTION "NHS_ACT_OTPROC" (
	v_action       IN VARCHAR2,
	v_OTPID        IN VARCHAR2,
	v_OTPCODE      IN VARCHAR2,
	v_OTPSFORM     IN VARCHAR2,
	v_OTPDESC      IN VARCHAR2,
	v_OTPTYPE      IN VARCHAR2,
	v_PKGCODE      IN VARCHAR2,
	v_OTPSURCHARGE IN VARCHAR2,
	v_OTPDUR       IN VARCHAR2,
	v_OTPINT       IN VARCHAR2,
	v_OTPSTS       IN VARCHAR2,
	v_STECODE      IN VARCHAR2,
	v_ISUPD        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode  NUMBER;
	v_noOfRec  NUMBER;
	v_newOtpid NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg  := 'OK';
	SELECT count(1) INTO v_noOfRec FROM OT_PROC WHERE OTPID = v_OTPID;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			select seq_ot_proc.NEXTVAL into v_newOtpid from dual;
			INSERT INTO OT_PROC (
				OTPID,
				OTPCODE,
				OTPSFORM,
				OTPDESC,
				OTPTYPE,
				OTPSTS,
				PKGCODE,
				ITMCODE,
				OTPDUR,
				OTPINT,
				STECODE,
				OTPSURCHARGE
			) VALUES (
				v_newOtpid,
				v_OTPCODE,
				v_OTPSFORM,
				v_OTPDESC,
				v_OTPTYPE,
				v_OTPSTS,
				v_PKGCODE,
				'',
				v_OTPDUR,
				v_OTPINT,
				v_STECODE,
				v_OTPSURCHARGE
			);
/*
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
*/
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE OT_PROC
			SET
				OTPCODE      = v_OTPCODE,
				OTPSFORM     = v_OTPSFORM,
				OTPDESC      = v_OTPDESC,
				OTPTYPE      = v_OTPTYPE,
				OTPSTS       = v_OTPSTS,
				PKGCODE      = v_PKGCODE,
				OTPDUR       = v_OTPDUR,
				OTPINT       = v_OTPINT,
				OTPSURCHARGE = v_OTPSURCHARGE
			WHERE OTPID = v_OTPID;
		ELSE
			o_errcode := -1;
			o_errmsg  := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE OT_PROC WHERE OTPID = v_OTPID;
		ELSE
			o_errcode := -1;
			o_errmsg  := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	RETURN o_errcode;

END NHS_ACT_OTPROC;
/
