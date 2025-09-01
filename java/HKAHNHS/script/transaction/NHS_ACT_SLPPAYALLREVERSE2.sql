CREATE OR REPLACE FUNCTION "NHS_ACT_SLPPAYALLREVERSE2" (
	i_Action     IN VARCHAR2,--ADD
	i_SpdID      IN VARCHAR2,
	i_CDate      IN VARCHAR2,
	i_UserCancel IN VARCHAR2, --1-yes,0-no
	i_UserID 	 IN VARCHAR2,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_CaptureDate DATE;
	v_UserCancel BOOLEAN;

BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF i_Action = 'ADD' THEN
		IF i_CDate IS NOT NULL AND TRIM(i_CDate) != '' THEN
			v_CaptureDate := TO_DATE(i_CDate,'dd/mm/yyyy');
		ELSE
			v_CaptureDate := NULL;
		END IF;

		IF i_UserCancel = '1' THEN
			v_UserCancel := TRUE;
		ELSE
			v_UserCancel := FALSE;
		END IF;

		o_errcode := NHS_UTL_SLPPAYALLREVERSE(i_SpdID, v_CaptureDate, v_UserCancel, i_UserID);
		IF o_errcode < 0 THEN
			o_errcode := -1;
			o_errmsg := 'Record not exists.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_SLPPAYALLREVERSE2;
/
