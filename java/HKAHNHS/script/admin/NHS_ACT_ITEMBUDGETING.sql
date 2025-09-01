CREATE OR REPLACE FUNCTION "NHS_ACT_ITEMBUDGETING" (
	v_action   IN VARCHAR2,
	v_CATEGORY IN VARCHAR2, -- D for debit, C for credit
	v_ITMCODE  IN BUDGET.ITMCODE%TYPE,
	v_ITCTYPE  IN BUDGET.ITCTYPE%TYPE,
	v_PKGCODE  IN BUDGET.PKGCODE%TYPE,
	v_ACMCODE  IN BUDGET.ACMCODE%TYPE,
	v_GLCCODE  IN BUDGET.GLCCODE%TYPE,
	v_ITCAMT1  IN VARCHAR2,
	v_ITCAMT2  IN VARCHAR2,
	v_ITCAMT3  IN VARCHAR2,
	v_ITCAMT4  IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_id NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_CATEGORY = 'D' THEN
		SELECT count(1) INTO v_noOfRec FROM BUDGET
		WHERE v_ITMCODE = ITMCODE
		AND v_ITCTYPE = ITCTYPE
		AND PKGCODE IS NULL -- v_PKGCODE = PKGCODE
		AND v_ACMCODE = ACMCODE
		AND v_GLCCODE = GLCCODE;
		SELECT MAX(ITCID) + 1 INTO v_id FROM BUDGET;
	ELSE
		SELECT count(1) INTO v_noOfRec FROM CREDITBGT
		WHERE v_ITMCODE = ITMCODE
		AND v_ITCTYPE = ITCTYPE
		AND PKGCODE IS NULL -- v_PKGCODE = PKGCODE
		AND v_ACMCODE = ACMCODE
		AND v_GLCCODE = GLCCODE;
		SELECT MAX(CICID) + 1 INTO v_id FROM CREDITBGT;
	END IF;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			IF v_CATEGORY = 'D' THEN
				INSERT INTO BUDGET (
					ITCID,
					ITMCODE,
					ITCTYPE,
					PKGCODE,
					ACMCODE,
					GLCCODE,
					ITCAMT1,
					ITCAMT2,
					ITCAMT3,
					ITCAMT4,
					STECODE
				) VALUES (
					v_id,
					v_ITMCODE,
					v_ITCTYPE,
					null, --v_PKGCODE,
					v_ACMCODE,
					v_GLCCODE,
					to_number(v_ITCAMT1),
					to_number(v_ITCAMT2),
					to_number(v_ITCAMT3),
					to_number(v_ITCAMT4),
					GET_CURRENT_STECODE
				);
		 	ELSE
				INSERT INTO CREDITBGT (
					CICID,
					ITMCODE,
					ITCTYPE,
					PKGCODE,
					ACMCODE,
					GLCCODE,
					ITCAMT1,
					ITCAMT2,
					ITCAMT3,
					ITCAMT4,
					STECODE
				) VALUES (
					v_id,
					v_ITMCODE,
					v_ITCTYPE,
					null, --v_PKGCODE,
					v_ACMCODE,
					v_GLCCODE,
					to_number(v_ITCAMT1),
					to_number(v_ITCAMT2),
					to_number(v_ITCAMT3),
					to_number(v_ITCAMT4),
					GET_CURRENT_STECODE
				);
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			IF v_category = 'D' THEN
				UPDATE BUDGET
				SET
				 	ITCAMT1 = to_number(v_ITCAMT1),
					ITCAMT2 = to_number(v_ITCAMT2),
					ITCAMT3 = to_number(v_ITCAMT3),
					ITCAMT4 = to_number(v_ITCAMT4)
				WHERE v_ITMCODE = ITMCODE
				AND v_ITCTYPE = ITCTYPE
				AND PKGCODE IS NULL --v_PKGCODE = PKGCODE
				AND v_ACMCODE = ACMCODE
				AND v_GLCCODE = GLCCODE;
			ELSE
				UPDATE CREDITBGT
				SET
					ITCAMT1 = to_number(v_ITCAMT1),
					ITCAMT2 = to_number(v_ITCAMT2),
					ITCAMT3 = to_number(v_ITCAMT3),
					ITCAMT4 = to_number(v_ITCAMT4)
				WHERE v_ITMCODE = ITMCODE
				AND v_ITCTYPE = ITCTYPE
				AND PKGCODE IS NULL -- v_PKGCODE = PKGCODE
				AND v_ACMCODE = ACMCODE
				AND v_GLCCODE = GLCCODE;
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			IF v_category = 'D' THEN
				DELETE BUDGET
				WHERE v_ITMCODE = ITMCODE
				AND v_ITCTYPE = ITCTYPE
				AND PKGCODE IS NULL-- v_PKGCODE = PKGCODE
				AND v_ACMCODE = ACMCODE
				AND v_GLCCODE = GLCCODE;
			ELSE
				DELETE CREDITBGT
				WHERE v_ITMCODE = ITMCODE
				AND v_ITCTYPE = ITCTYPE
				AND PKGCODE IS NULL-- v_PKGCODE = PKGCODE
				AND v_ACMCODE = ACMCODE
				AND v_GLCCODE = GLCCODE;
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ITEMBUDGETING;
/
