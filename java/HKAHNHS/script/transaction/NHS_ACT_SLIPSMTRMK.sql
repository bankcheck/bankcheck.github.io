CREATE OR REPLACE FUNCTION "NHS_ACT_SLIPSMTRMK" (
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
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';

	IF LENGTH(i_Remark) > 2000 THEN
		o_errmsg := 'Remark is too long';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Slip_Extra WHERE slpno = i_SLPNO;
	IF v_Count = 1 THEN
		UPDATE Slip_Extra
		SET
			SMTRMK = i_Remark,
			SMTRMKUSER = i_UserID
		WHERE  SlpNo = i_SlpNo;
	ELSE
		INSERT INTO Slip_Extra(
			SLPNO,
			SMTRMK,
			SMTRMKUSER
		) VALUES (
			i_SlpNo,
			i_Remark,
			i_UserID
		);
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Remark is too long.<br><font color=red>Error Code:' || SQLCODE || '</font>';

	RETURN -999;
END NHS_ACT_SLIPSMTRMK;
/
