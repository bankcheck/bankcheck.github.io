CREATE OR REPLACE FUNCTION "NHS_ACT_CREDITCHG" (
	v_action  IN VARCHAR2,
	v_CICID   IN varchar2,
	v_ITMCODE IN varchar2,
	v_PKGCODE IN varchar2,
	v_ACMCODE IN varchar2,
	v_ITCTYPE IN varchar2,
	v_GLCCODE IN varchar2,
	v_ITCAMT1 IN varchar2,
	v_ITCAMT2 IN varchar2,
	v_CPSID   IN varchar2,
--	v_CICDOC  IN varchar2,
	v_CPSPCT  IN varchar2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM CREDITCHG	WHERE CICID = v_CICID;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO CREDITCHG (
				CICID,
				ITMCODE,
				PKGCODE,
				ACMCODE,
				ITCTYPE,
				GLCCODE,
				ITCAMT1,
				ITCAMT2,
				STECODE,
				CPSID,
				CICDOC,
				CPSPCT
			) VALUES (
				seq_creditchg.NEXTVAL,
				v_ITMCODE,
				v_PKGCODE,
				v_ACMCODE,
				v_ITCTYPE,
				v_GLCCODE,
				to_number(v_ITCAMT1),
				to_number(v_ITCAMT2),
				GET_CURRENT_STECODE,
				to_number(v_CPSID),
				null,
				to_number(v_CPSPCT)
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	CREDITCHG
			SET
				 PKGCODE = v_PKGCODE,
				 ACMCODE = v_ACMCODE,
				 ITCTYPE = v_ITCTYPE,
				 GLCCODE = v_GLCCODE,
				 ITCAMT1 = to_number(v_ITCAMT1),
				 ITCAMT2 = to_number(v_ITCAMT2),
				 CPSID = to_number(v_CPSID),
				 CPSPCT = to_number(v_CPSPCT)
			WHERE CICID = v_CICID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE CREDITCHG WHERE CICID=v_CICID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_CREDITCHG;
/
