CREATE OR REPLACE FUNCTION "NHS_ACT_ITEMCHARGE" (
	v_action   IN VARCHAR2,
	v_itcid    IN varchar2,
	v_itemcode IN varchar2,
	v_pkgcode  IN varchar2,
	v_acmcode  IN varchar2,
	v_itctype  IN varchar2,
	v_glccode  IN varchar2,
	v_itcamt1  IN varchar2,
	v_itcamt2  IN varchar2,
	v_cpsid    IN varchar2,
	v_cpspct   IN varchar2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM ITEMCHG WHERE ITCID = v_itcid;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ITEMCHG (
				ITCID,
				ITMCODE,
				PKGCODE,
				ACMCODE,
				ITCTYPE,
				GLCCODE,
				ITCAMT1,
				ITCAMT2,
				STECODE,
				CPSID,
				CPSPCT
			) VALUES (
				seq_itemchg.NEXTVAL,
				v_itemcode,
				v_pkgcode,
				v_acmcode,
				v_itctype,
				v_glccode,
				to_number(v_itcamt1),
				to_number(v_itcamt2),
				GET_CURRENT_STECODE,
				v_cpsid,
				to_number(v_cpspct)
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE ITEMCHG
			SET
				 ITMCODE = v_itemcode,
				 PKGCODE = v_pkgcode,
				 ACMCODE = v_acmcode,
				 ITCTYPE = v_itctype,
				 GLCCODE = v_glccode,
				 ITCAMT1 = to_number(v_itcamt1),
				 ITCAMT2 = to_number(v_itcamt2),
				 CPSID = v_cpsid,
				 CPSPCT = to_number(v_cpspct)
			WHERE ITCID = v_itcid;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ITEMCHG WHERE ITCID = v_itcid;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ITEMCHARGE;
/
