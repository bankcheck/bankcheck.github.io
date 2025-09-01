CREATE OR REPLACE FUNCTION "NHS_ACT_ITEM" (
	v_action     IN VARCHAR2,
	v_ITMCODE    IN ITEM.ITMCODE%TYPE,
	v_ITMNAME    IN ITEM.ITMNAME%TYPE,
	v_ITMCNAME   IN ITEM.ITMCNAME%TYPE,
	v_ITMTYPE    IN ITEM.ITMTYPE%TYPE,
	v_ITMRLVL    IN ITEM.ITMRLVL%TYPE,
	v_ITMCAT     IN ITEM.ITMCAT%TYPE,
	v_DSCCODE    IN ITEM.DSCCODE%TYPE,
	v_DPTCODE    IN ITEM.DPTCODE%TYPE,
	v_ITMPOVERRD IN ITEM.ITMPOVERRD%TYPE,
	v_ITMDOCCR   IN ITEM.ITMDOCCR%TYPE,
	v_ITMGRP     IN	ITEM.ITMGRP%TYPE,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM ITEM WHERE ITMCODE = v_ITMCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ITEM (
				ITMCODE,
				ITMNAME,
				ITMCNAME,
				ITMTYPE,
				ITMRLVL,
				ITMCAT,
				DSCCODE,
				DPTCODE,
				STECODE,
				ITMPOVERRD,
				ITMDOCCR,
				ITMGRP,
				ITMSTS
			) VALUES (
				v_ITMCODE,
				v_ITMNAME,
				v_ITMCNAME,
				v_ITMTYPE,
				v_ITMRLVL,
				v_ITMCAT,
				v_DSCCODE,
				v_DPTCODE,
				GET_CURRENT_STECODE,
				v_ITMPOVERRD,
				v_ITMDOCCR,
				v_ITMGRP,
				-1
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	ITEM
			SET
					ITMCODE = v_ITMCODE,
					ITMNAME = v_ITMNAME,
					ITMCNAME = v_ITMCNAME,
					ITMTYPE = v_ITMTYPE,
					ITMRLVL = v_ITMRLVL,
					ITMCAT = v_ITMCAT,
					DSCCODE = v_DSCCODE,
					DPTCODE = v_DPTCODE,
					ITMPOVERRD = v_ITMPOVERRD,
					ITMDOCCR = v_ITMDOCCR,
					ITMGRP = v_ITMGRP
			WHERE	ITMCODE = v_ITMCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ITEM WHERE ITMCODE = v_ITMCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ITEM;
/
