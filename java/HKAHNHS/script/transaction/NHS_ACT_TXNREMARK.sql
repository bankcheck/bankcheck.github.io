CREATE OR REPLACE FUNCTION "NHS_ACT_TXNREMARK" (
	i_Action  IN VARCHAR2,
	i_SlpNo   IN VARCHAR2,
	i_Remark  IN VARCHAR2,
	i_UserID  IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
  RETURN NUMBER
AS
	o_errcode NUMBER;
	v_Count NUMBER;
	v_Remark1 VARCHAR2(1000);
	v_Remark2 VARCHAR2(1000);
	v_Remark3 VARCHAR2(3000);
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';
	v_Remark1 := NULL;
	v_Remark2 := NULL;
	v_Remark3 := NULL;

	IF LENGTH(i_Remark) > 5000 THEN
		o_errmsg := 'Additional Remark is too long. (' || LENGTH(i_Remark) || ' > 5000 characters)';
		RETURN o_errcode;
	END IF;

	IF LENGTH(i_Remark) > 1000 THEN
		v_Remark1 := SUBSTR(i_Remark, 1, 1000);
		IF LENGTH(i_Remark) > 2000 THEN
			v_Remark2 := SUBSTR(i_Remark, 1001, 1000);
			v_Remark3 := SUBSTR(i_Remark, 2001, 3000);
		ELSE
			v_Remark2 := SUBSTR(i_Remark, 1001);
		END IF;
	ELSE
		v_Remark1 := i_Remark;
	END IF;

	UPDATE Slip
	SET
		SlpAddRmk = v_Remark1,
		SlpAddRmk2 = v_Remark2,
		AddRmkModUsr = i_UserID,
		AddRmkModDt = SYSDATE
	WHERE  SlpNo = i_SlpNo;

	SELECT COUNT(1) INTO v_Count FROM SLIP_EXTRA WHERE SlpNo = i_SlpNo;
	IF v_Count > 0 THEN
		UPDATE SLIP_EXTRA
		SET    SlpAddRmk3 = v_Remark3
		WHERE  SlpNo = i_SlpNo;
	ELSE
		INSERT INTO SLIP_EXTRA (
			SlpNo,
			SlpAddRmk3
		) VALUES (
			i_SlpNo,
			v_Remark3
		);
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Additional Remark is too long.<br><font color=red>Error Code:' || SQLCODE || '</font>';

	RETURN -999;
END NHS_ACT_TXNREMARK;
/
